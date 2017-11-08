//
//  SNRouter.m
//  Pods-SNMediator_Example
//
//  Created by 杨洁 on 2017/11/6.
//

#import "SNRouter.h"
#import "SNRouterItem.h"

@interface SNRouter ()
@property (strong, nonatomic) NSMutableDictionary<NSString *,SNRouter *> *moduleRouterDict;
@property (strong, nonatomic) NSMutableDictionary<NSString *,SNRouterItem *> *routerItemDict; //页面名(path)为key，SNRouterItem对象为value

@end
@implementation SNRouter 


@end
