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
#import "SNServiceProtocol.h"

@interface SNServiceManger ()
@property (strong, nonatomic) NSDictionary<NSString *,SNModuleConfig *> *modulesConfigDict; //所有模块配置集合，以模块名为key，SNModuleConfig对象为value
@property (strong, nonatomic) NSMutableDictionary *serviceImplClassDict; //存放实现协议的类，"模块名/服务名"为key，实现服务的类的名字为value
@property (strong, nonatomic) NSMutableDictionary *serviceImplInstanceCacheDict; //缓存实现协议的类的实例 (获取服务时，创建对象，缓存在这里，下次用到直接查找，找不到再新建) implClass为key，implClass类的实例对象为value
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
    for (SNModuleConfig *config in moduleConfigArr) {
        BOOL sucess = [self registerModule:config.name serviceList:config.serviceList];
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
        //实现类如果是单例
        if ([[implClass class] respondsToSelector:@selector(singleton)]) {
            if ([[implClass class] singleton]) {
                if ([[implClass class] respondsToSelector:@selector(shareInstance)]) {
                    implInstance = [[implClass class] shareInstance];
                }else {
                    implInstance = [[implClass alloc] init];
                }
                [self.serviceImplInstanceCacheDict setValue:implInstance forKey:NSStringFromClass(implClass)];
                return implInstance;
            }
        }
        implInstance = [[implClass alloc] init];
        [self.serviceImplInstanceCacheDict setValue:implInstance forKey:NSStringFromClass(implClass)];
    }
    return implInstance;
}


#pragma mark - getter
- (NSMutableDictionary *)serviceImplClassDict
{
    if (!_serviceImplClassDict) {
        _serviceImplClassDict = [NSMutableDictionary dictionary];
    }
    return _serviceImplClassDict;
}

- (NSMutableDictionary *)serviceImplInstanceCacheDict
{
    if (!_serviceImplInstanceCacheDict) {
        _serviceImplInstanceCacheDict = [NSMutableDictionary dictionary];
    }
    return _serviceImplInstanceCacheDict;
}


#pragma mark - private
- (BOOL)registerModule:(NSString *)moduleName serviceList:(NSArray<SNServiceItem *> *)serviceList
{
    NSString *temp = [moduleName stringByAppendingString:@"/"];
    for (SNServiceItem *item in serviceList) {
        BOOL sucess = [self registerService:[temp stringByAppendingString:item.name] class:item.className protocol:item.protocol];
        if (!sucess) {
            return NO;
        }
    }
    return YES;
}

//serviceName 由 "模块名/服务名" 组成
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
        if ([self.serviceImplClassDict valueForKey:[serviceName lowercaseString]] != nil) {
            //注册的时候给予提醒，不允许相同服务名称进行注册，不区分大小写，有重复不予覆盖
            SNAssert(NO, @"service: %@ duplicate register service", serviceName);
            return NO;
        } else {
            [self.lock lock];
            [self.serviceImplClassDict setValue:serviceClass forKey:[serviceName lowercaseString]];
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
