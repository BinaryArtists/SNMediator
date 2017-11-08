//
//  SNModuleConfig.m
//  Pods-SNMediator_Example
//
//  Created by 杨洁 on 2017/11/3.
//

#import "SNModuleConfig.h"
#import "SNRouterItem.h"
#import "SNServiceItem.h"

@implementation SNModuleConfig

+ (instancetype)newWithDict:(NSDictionary *)dict
{
    __block SNModuleConfig *instance = [[self alloc] init];
    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [instance setValue:obj forKey:key];
    }];
    return instance;
}

#pragma mark - setter
- (void)setRouterList:(NSArray<SNRouterItem *> *)routerList
{
    NSArray *list;
    if ([routerList isKindOfClass:[NSDictionary class]]) {
        list = [(NSDictionary*)routerList allValues];
    } else if ([routerList isKindOfClass:[NSArray class]]) {
        list = routerList;
    }
    NSMutableArray *tempRouterList = [NSMutableArray array];
    [list enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            [tempRouterList addObject:[SNRouterItem newWithDict:obj]];
        }
    }];
    _routerList = tempRouterList;
}

- (void)setServiceList:(NSArray<SNServiceItem *> *)serviceList
{
    NSArray *list;
    if ([serviceList isKindOfClass:[NSDictionary class]]) {
        list = [(NSDictionary*)serviceList allValues];
    } else if ([serviceList isKindOfClass:[NSArray class]]) {
        list = serviceList;
    }
    NSMutableArray *tempServiceList = [NSMutableArray array];
    [list enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            [tempServiceList addObject:[SNServiceItem newWithDict:obj]];
        }
    }];
    _routerList = tempServiceList;
}

@end
