//
//  SNRouteManger.h
//  Pods-SNMediator_Example
//
//  Created by 杨洁 on 2017/11/6.
//

#import <Foundation/Foundation.h>

//负责页面路由跳转
NS_ASSUME_NONNULL_BEGIN
@interface SNRouteManger : NSObject

+ (instancetype)shareInstance;
//注册所有模块的路由页面
- (BOOL)registerRouters:(NSDictionary *)modulesDict;

- (BOOL)canOpenURL:(NSURL *)URL;
- (BOOL)openURL:(NSURL *)RUL withParams:(NSDictionary *)params completion:(void (^_Nullable) (id _Nullable result))completion;

- (id)viewControllerForURL:(NSURL *)URL params:(nullable NSDictionary *)params;


@end
NS_ASSUME_NONNULL_END
