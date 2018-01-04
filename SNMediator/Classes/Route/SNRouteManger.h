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

//根据URL跳转到某个新建界面
- (BOOL)canRouteURL:(NSURL *)URL;
- (BOOL)routeURL:(NSURL *)URL params:(nullable NSDictionary *)params completion:(void (^_Nullable) (id _Nullable result))block;
- (UIViewController *)viewControllerForURL:(NSURL *)URL params:(nullable NSDictionary *)params completion:(void (^_Nullable) (SNRouterItem  *routerItem))block;

//后退到(跳转到)popURL界面，该页面已经存在于视图栈中，并逆向传参params
- (void)routeBackToURL:(NSURL *)popURL params:(nullable NSDictionary *)params completion:(void (^_Nullable) (id _Nullable result))block;

@end
NS_ASSUME_NONNULL_END
