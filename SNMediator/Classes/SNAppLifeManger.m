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
@property (nonatomic, strong) NSMutableSet<id <SNApplicationDelegate>> *moduleDelegateInstanceSet; //存放moduleDelegate实例对象

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
            if (delegateClass&&[delegateClass conformsToProtocol:@protocol(SNApplicationDelegate)]) {
                [self.moduleDelegateInstanceSet addObject:[[delegateClass alloc] init]];
            }
        }
    }];
}

- (void)transmitAppDelegate:(SEL)selector, ...
{
    for (id<SNApplicationDelegate> moduleDelegateInstance in self.moduleDelegateInstanceSet) {
        if ([moduleDelegateInstance respondsToSelector:selector]&&[moduleDelegateInstance isKindOfClass:[NSObject class]]) {
            va_list args;
            va_start(args, selector);
            NSObject *moduleObj = (NSObject*)moduleDelegateInstance;
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

- (void)transmitAppDelegateBlock:(void(^)(id<SNApplicationDelegate> appDelegateInstance, id result, BOOL *stop))block selector:(SEL)selector, ...
{
    BOOL stop = NO;
    for (id<SNApplicationDelegate> moduleDelegateInstance in self.moduleDelegateInstanceSet) {
        if ([moduleDelegateInstance respondsToSelector:selector]&&[moduleDelegateInstance isKindOfClass:[NSObject class]]) {
            va_list args;
            va_start(args, selector);
            NSObject *moduleObj = (NSObject*)moduleDelegateInstance;
            NSMethodSignature * sig = [moduleObj methodSignatureForSelector:selector];
            if (!sig) { [moduleObj doesNotRecognizeSelector:selector]; continue; }
            NSInvocation *inv = [NSInvocation invocationWithMethodSignature:sig];
            if (!inv) { [moduleObj doesNotRecognizeSelector:selector]; continue; }
            [inv setTarget:moduleObj];
            [inv setSelector:selector];
            [NSObject sn_setInv:inv withSig:sig andArgs:args];
            [inv invoke];
            block(moduleDelegateInstance, [NSObject sn_getReturnFromInv:inv withSig:sig], &stop);
            if (stop) {
                break;
            }
        }
    }
}

#pragma mark - setter
- (NSMutableSet<id<SNApplicationDelegate>> *)moduleDelegateInstanceSet
{
    if (!_moduleDelegateInstanceSet) {
        _moduleDelegateInstanceSet = [[NSMutableSet alloc] initWithCapacity:4];
    }
    return (NSMutableSet<id<SNApplicationDelegate>> *)_moduleDelegateInstanceSet;
}




@end
