//
//  NSObject+SNTargetAction.h
//  Pods-SNMediator_Example
//
//  Created by 杨洁 on 2017/11/3.
//

#import <Foundation/Foundation.h>

#undef    AS_SINGLETON
#define AS_SINGLETON \
+ (nullable instancetype)sharedInstance;

#undef    DEF_SINGLETON
#define DEF_SINGLETON \
+ (nullable instancetype)sharedInstance \
{ \
static dispatch_once_t once; \
static id __singleton__; \
dispatch_once( &once, ^{ __singleton__ = [[self alloc] init]; } ); \
return __singleton__; \
}

NS_ASSUME_NONNULL_BEGIN
@interface NSObject (SNTargetAction)
- (id)performAction:(NSString *)actionName, ...;
+ (id)sn_getReturnFromInv:(NSInvocation *)inv withSig:(NSMethodSignature *)sig;
+ (void)sn_setInv:(NSInvocation *)inv withSig:(NSMethodSignature *)sig andArgs:(va_list)args;
- (void)sn_setParams:(NSDictionary*)params;

@end
NS_ASSUME_NONNULL_END
