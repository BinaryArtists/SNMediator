//
//  SNAppLifeManger.m
//  Pods-SNMediator_Example
//
//  Created by 杨洁 on 2017/11/9.
//

#import "SNAppLifeManger.h"
#import "SNModuleConfig.h"
#import "NSObject+SNTargetAction.h"

@interface SNAppLifeManger ()
@property (nonatomic, strong) NSMutableSet<id <SNAppDelegate>> *appDelegateInstanceSet;
@end

@implementation SNAppLifeManger
static SNAppLifeManger *instance = nil;
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
- (void)registerAppLife:(NSDictionary<NSString *,SNModuleConfig *> *)modulesDict
{
    NSArray<SNModuleConfig *> *moduleConfigArr = [modulesDict allValues];
    [moduleConfigArr enumerateObjectsUsingBlock:^(SNModuleConfig * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.delegateClass) {
            Class delegateClass = NSClassFromString(obj.delegateClass);
            if (delegateClass&&[delegateClass conformsToProtocol:@protocol(SNAppDelegate)]) {
                [self.appDelegateInstanceSet addObject:[[delegateClass alloc] init]];
            }
        }
    }];
}

- (void)performDelegateSelector:(SEL)selector, ...
{
    for (id<SNAppDelegate> appDelegateInstance in self.appDelegateInstanceSet) {
        if ([appDelegateInstance respondsToSelector:selector]&&[appDelegateInstance isKindOfClass:[NSObject class]]) {
            va_list args;
            va_start(args, selector);
            NSObject *moduleObj = (NSObject*)appDelegateInstance;
            NSMethodSignature * sig = [moduleObj methodSignatureForSelector:selector];
            if (!sig) { [moduleObj doesNotRecognizeSelector:selector]; continue; }
            NSInvocation *inv = [NSInvocation invocationWithMethodSignature:sig];
            if (!inv) { [moduleObj doesNotRecognizeSelector:selector]; continue; }
            [inv setTarget:moduleObj];
            [inv setSelector:selector];
            [NSObject sn_setInv:inv withSig:sig andArgs:args];
            [inv invoke];
        }
    }
}

- (void)performDelegateBlock:(void(^)(id<SNAppDelegate> appDelegateInstance, id result, BOOL *stop))block selector:(SEL)selector, ...
{
    BOOL stop = NO;
    for (id<SNAppDelegate> appDelegateInstance in self.appDelegateInstanceSet) {
        if ([appDelegateInstance respondsToSelector:selector]&&[appDelegateInstance isKindOfClass:[NSObject class]]) {
            va_list args;
            va_start(args, selector);
            NSObject *moduleObj = (NSObject*)appDelegateInstance;
            NSMethodSignature * sig = [moduleObj methodSignatureForSelector:selector];
            if (!sig) { [moduleObj doesNotRecognizeSelector:selector]; continue; }
            NSInvocation *inv = [NSInvocation invocationWithMethodSignature:sig];
            if (!inv) { [moduleObj doesNotRecognizeSelector:selector]; continue; }
            [inv setTarget:moduleObj];
            [inv setSelector:selector];
            [NSObject sn_setInv:inv withSig:sig andArgs:args];
            [inv invoke];
            block(appDelegateInstance, [NSObject sn_getReturnFromInv:inv withSig:sig], &stop);
            if (stop) {
                break;
            }
        }
    }
}

#pragma mark - setter
- (NSMutableSet<id<SNAppDelegate>> *)appDelegateInstanceSet
{
    if (!_appDelegateInstanceSet) {
        _appDelegateInstanceSet = [[NSMutableSet alloc] initWithCapacity:4];
    }
    return _appDelegateInstanceSet;
}




@end
