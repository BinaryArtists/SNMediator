//
//  SNAppLifeManger.h
//  Pods-SNMediator_Example
//
//  Created by 杨洁 on 2017/11/9.
//

#import <Foundation/Foundation.h>
#import "NSObject+SNTargetAction.h"
#import "SNApplicationDelegate.h"
@class SNModuleConfig;

NS_ASSUME_NONNULL_BEGIN
@interface SNAppLifeManger : NSObject
+ (instancetype)shareInstance;

- (void)registerAppLife:(NSDictionary<NSString *,SNModuleConfig *> *)modulesDict;

- (void)forwardAppDelegate:(SEL)selector, ...;
- (void)forwardAppDelegateBlock:(void(^)(id<SNApplicationDelegate> appDelegateInstance, id result, BOOL *stop))block selector:(SEL)selector, ...;
@end
NS_ASSUME_NONNULL_END
