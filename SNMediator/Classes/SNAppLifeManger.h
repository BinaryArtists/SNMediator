//
//  SNAppLifeManger.h
//  Pods-SNMediator_Example
//
//  Created by 杨洁 on 2017/11/9.
//

#import <Foundation/Foundation.h>
#import "SNAppDelegate.h"
#import "NSObject+SNTargetAction.h"
@class SNModuleConfig;

NS_ASSUME_NONNULL_BEGIN
@interface SNAppLifeManger : NSObject
+ (instancetype)shareInstance;

- (void)registerAppLife:(NSDictionary<NSString *,SNModuleConfig *> *)modulesDict;

- (void)performDelegateSelector:(SEL)selector, ...;
- (void)performDelegateBlock:(void(^)(id<SNAppDelegate> appDelegateInstance, id result, BOOL *stop))block selector:(SEL)selector, ...;
@end
NS_ASSUME_NONNULL_END
