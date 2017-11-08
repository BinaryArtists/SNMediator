//
//  SNRouter.h
//  Pods-SNMediator_Example
//
//  Created by 杨洁 on 2017/11/6.
//

#import <Foundation/Foundation.h>

//负责页面路由跳转
@interface SNRouter : NSObject

- (BOOL)canOpenURL:(nonnull NSURL *)URL;
- (BOOL)openURL:(nonnull NSURL *)RUL withParams:(NSDictionary *)params completion:(void (^_Nullable) (id _Nullable result))completion;

- (id)getInstanceForURL:(nonnull NSURL *)URL params:(nullable NSDictionary *)params;


@end
