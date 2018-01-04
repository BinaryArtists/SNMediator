//
//  SNModuleConfig.h
//  Pods-SNMediator_Example
//
//  Created by 杨洁 on 2017/11/3.
//

#import <Foundation/Foundation.h>
@class SNRouterItem;
@class SNServiceItem;

@interface SNModuleConfig : NSObject
@property (copy, nonatomic) NSString *name; //模块名，用作 host
@property (copy, nonatomic) NSString *scheme; //通信协议,比如http、https等 暂时无用可空;apple用URL scheme进行app间的跳转
@property (copy, nonatomic) NSString *delegateClass; //用于管理module内部AppDeleate，必须遵循SNAppDelegate协议
@property (strong, nonatomic) NSArray<SNRouterItem *> *routerList;  //路由列表
@property (strong, nonatomic) NSArray<SNServiceItem *> *serviceList; //服务列表


- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

+ (instancetype)newWithDict:(NSDictionary *)dict;

@end
