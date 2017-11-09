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
    __block BOOL sucess = YES;
    [moduleConfigArr enumerateObjectsUsingBlock:^(SNModuleConfig * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        for (SNServiceItem *serviceItem in obj.serviceList) {
            sucess = [self registerService:serviceItem.name class:serviceItem.className protocol:serviceItem.protocol];
            if (!sucess) {
                return;
            }
        }
    }];
    return sucess;
}

- (id)getService:(NSString *)serviceName
{
    Class serviceClass = [self.serviceImplClassDict objectForKey:[serviceName lowercaseString]];
    //如果服务的class不存在直接返回Nil
    if (!serviceClass) {
        SNAssert(NO,@"service: serviceName-%@ invalid, reason is can't find serviceClass",serviceName);
        return nil;
    }
    id serviceImplInstance = [self.serviceImplInstanceCacheDict objectForKey:NSStringFromClass(serviceClass)];
    //如果服务存在，检查服务是否启动，如果未启动，马上启动，并返回service实例
    if (!serviceImplInstance) {
        serviceImplInstance = [[serviceClass alloc] init];
        [self.serviceImplInstanceCacheDict setValue:serviceImplInstance forKey:NSStringFromClass(serviceClass)];
    }
    return serviceImplInstance;
}

#pragma mark - private
- (BOOL)registerService:(NSString *)serviceName class:(NSString *)serviceClassStr protocol:(NSString *)serviceProtocolStr
{
    BOOL success = NO;
    Class serviceClass = nil;
    if (serviceClassStr && ![serviceClassStr isEqualToString:@""]) {
        serviceClass = NSClassFromString(serviceClassStr);
    }
    Protocol *serviceProtocol = nil;
    if (serviceProtocolStr && ![serviceProtocolStr isEqualToString:@""]) {
        serviceProtocol = NSProtocolFromString(serviceProtocolStr);
    }
    //如果 class 在bundle中不存在，不注册该服务
    if (serviceClass && serviceProtocol && [serviceClass conformsToProtocol:serviceProtocol]) {
        if ([self.serviceImplClassDict objectForKey:[serviceName lowercaseString]] != nil) {
            //注册的时候给予提醒，不允许相同服务名称进行注册，不区分大小写，有重复不予覆盖
            SNAssert(NO, @"service: %@ duplicate register service", serviceName);
        } else {
            [self.serviceImplClassDict setObject:serviceClass forKey:[serviceName lowercaseString]];
            success = YES;
        }
    }
    // debug阶段给予提示
    else {
        SNAssert(NO, @"service: %@ invalid, reason is serviceImpl(%@) is not impleamted or not "
                 @"conform to protocol (%@)",
                 serviceName, serviceClassStr, serviceProtocolStr);
    }
    return success;
}



@end
