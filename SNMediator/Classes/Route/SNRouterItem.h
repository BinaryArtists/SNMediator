//
//  SNRouterItem.h
//  Pods-SNMediator_Example
//
//  Created by 杨洁 on 2017/11/4.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, SNRouteType) {
    SNRouteType_push = 0,
    SNRouteType_modal,
};

@interface SNRouterItem : NSObject<NSCopying>
@property (strong, nonatomic) NSString *name; //页面名,对应url中的 path，并且每个页面名对应一个页面，这个页面对应一个 routerItem 对象
@property (strong, nonatomic) NSString *className; //页面名对应的页面类
@property (nonatomic) SNRouteType routeType; //路由跳转形式: 0:push/ 1:modal
@property (nonatomic) BOOL needLogin;  //是否需要登录

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

+ (instancetype)newWithDict:(NSDictionary *)dict;

@end
