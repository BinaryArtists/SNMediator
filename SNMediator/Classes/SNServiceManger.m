//
//  SNServiceManger.m
//  Pods-SNMediator_Example
//
//  Created by 杨洁 on 2017/11/6.
//

#import "SNServiceManger.h"
#import "SNMediatorMacro.h"
#import "SNModuleConfig.h"
#import "SNServiceItem.h"

@interface SNServiceManger ()
@property (strong, nonatomic) NSDictionary<NSString *,SNModuleConfig *> *modulesConfigDict; //所有模块配置集合，以模块名为key，SNModuleConfig对象为value
@property (strong, nonatomic) NSMutableDictionary *serviceImplClassDict; //存放实现协议的类，name为key，serviceClass为value
@property (strong, nonatomic) NSMutableDictionary *serviceImplInstanceCacheDict; //缓存实现协议的类的实例 (获取服务时，创建对象，缓存在这里，下次用到直接查找，找不到再新建) serviceClass为key，serviceClass的实例对象为value
@property (strong, nonatomic) NSRecursiveLock *lock;

@end


@implementation SNServiceManger
static SNServiceManger *instance = nil;
+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [super allocWithZone:zone];
    });
    return instance;
}


#pragma mark - public
- (BOOL)registerServices:(NSDictionary *)modulesDict
{
    if (!modulesDict) {
        return NO;
    }
    _modulesConfigDict = (NSDictionary<NSString *,SNModuleConfig *> *)modulesDict;
    NSArray<SNModuleConfig *> *moduleConfigArr = _modulesConfigDict.allValues;
    NSMutableArray *tempArr = [NSMutableArray array];
    [self.lock lock];
    for (SNModuleConfig *config in moduleConfigArr) {
        [tempArr addObjectsFromArray:config.serviceList];
    }
    [self.lock unlock];
    for (SNServiceItem *item in tempArr) {
        BOOL sucess = [self registerService:item.name class:item.className protocol:item.protocol];
        if (!sucess) {
            return NO;
        }
    }
    return YES;
}

- (id)getService:(NSString *)serviceName
{
    Class implClass = [self.serviceImplClassDict objectForKey:[serviceName lowercaseString]];
    //如果服务的class不存在直接返回Nil
    if (!implClass) {
        SNAssert(NO,@"service: serviceName-%@ invalid, reason is can't find serviceClass",serviceName);
        return nil;
    }
    id implInstance = [self.serviceImplInstanceCacheDict objectForKey:NSStringFromClass(implClass)];
    //如果服务存在，检查服务是否启动，如果未启动，马上启动，并返回service实例
    if (!implInstance) {
        implInstance = [[implClass alloc] init];
        [self.serviceImplInstanceCacheDict setValue:implInstance forKey:NSStringFromClass(implClass)];
    }
    return implInstance;
}


#pragma mark - private
- (BOOL)registerService:(NSString *)serviceName class:(NSString *)serviceClassStr protocol:(NSString *)serviceProtocolStr
{
    Class serviceClass = nil;
    if (serviceClassStr && ![serviceClassStr isEqualToString:@""]) {
        serviceClass = NSClassFromString(serviceClassStr);
    }else {
        SNAssert(NO, @"invaild service impl class for service name: %@",serviceName);
        return NO;
    }
    Protocol *serviceProtocol = nil;
    if (serviceProtocolStr && ![serviceProtocolStr isEqualToString:@""]) {
        serviceProtocol = NSProtocolFromString(serviceProtocolStr);
    }else {
        SNAssert(NO, @"invaild service protocol for service name: %@",serviceName);
        return NO;
    }
    //如果 class 在bundle中不存在，不注册该服务
    if (serviceClass && serviceProtocol && [serviceClass conformsToProtocol:serviceProtocol]) {
        if ([self.serviceImplClassDict objectForKey:[serviceName lowercaseString]] != nil) {
            //注册的时候给予提醒，不允许相同服务名称进行注册，不区分大小写，有重复不予覆盖
            SNAssert(NO, @"service: %@ duplicate register service", serviceName);
            return NO;
        } else {
            [self.lock lock];
            [self.serviceImplClassDict setObject:serviceClass forKey:[serviceName lowercaseString]];
            [self.lock unlock];
        }
    }
    // debug阶段给予提示
    else {
        SNAssert(NO, @"service: %@ invalid, reason is serviceImpl(%@) is not impleamted or not "
                 @"conform to protocol (%@)",
                 serviceName, serviceClassStr, serviceProtocolStr);
        return NO;
    }
    return YES;
}



@end
