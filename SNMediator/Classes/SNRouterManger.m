//
//  SNRouter.m
//  Pods-SNMediator_Example
//
//  Created by 杨洁 on 2017/11/6.
//

#import "SNRouterManger.h"
#import "SNRouterItem.h"

@interface SNRouterManger ()
@property (strong, nonatomic) NSMutableDictionary *moduleRouterDict;
@property (strong, nonatomic) NSMutableDictionary<NSString *,SNRouterItem *> *routerItemDict; //页面名(path)为key，SNRouterItem对象为value

@end
@implementation SNRouterManger


@end
