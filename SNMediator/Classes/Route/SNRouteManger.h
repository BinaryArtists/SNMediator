//
//  SNRouteManger.h
//  Pods-SNMediator_Example
//
//  Created by 杨洁 on 2017/11/6.
//

#import <Foundation/Foundation.h>
@class UIViewController;
@class SNRouterItem;

//负责页面路由跳转
NS_ASSUME_NONNULL_BEGIN
@interface SNRouteManger : NSObject

+ (instancetype)shareInstance;
//注册所有模块的路由页面
- (BOOL)registerRouters:(NSDictionary *)modulesDict;

- (BOOL)canOpenURL:(NSURL *)URL;
- (BOOL)openURL:(NSURL *)URL withParams:(nullable NSDictionary *)params completion:(void (^_Nullable) (id _Nullable result))completion;
- (UIViewController *)viewControllerForURL:(NSURL *)URL params:(nullable NSDictionary *)params completion:(void (^_Nullable) (SNRouterItem  *routerItem))block;


@end
NS_ASSUME_NONNULL_END
