//
//  SNRouteManger.m
//  Pods-SNMediator_Example
//
//  Created by 杨洁 on 2017/11/6.
//

#import "SNRouteManger.h"
#import "SNRouterItem.h"
#import "SNModuleConfig.h"

@interface SNRouteManger ()
@property (strong, nonatomic) NSMutableDictionary *moduleRouterDict;
@property (strong, nonatomic) NSMutableDictionary<NSString *,SNRouterItem *> *routerItemDict; //页面名(path)为key，SNRouterItem对象为value

@end
@implementation SNRouteManger
static SNRouteManger *instance = nil;
+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [super allocWithZone:zone];
    });
    return instance;
}

#pragma mark - public
- (BOOL)registerRouters:(NSDictionary *)modulesDict
{
    
}


@end
