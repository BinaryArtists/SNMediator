//
//  SNRouterItem.m
//  Pods-SNMediator_Example
//
//  Created by 杨洁 on 2017/11/4.
//

#import "SNRouterItem.h"

@implementation SNRouterItem
+ (instancetype)newWithDict:(NSDictionary *)dict
{
    __block SNRouterItem *instance = [[self alloc] init];
    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [instance setValue:obj forKey:key];
    }];
    return instance;
}

#pragma mark - NSCopying
- (id)copyWithZone:(nullable NSZone *)zone
{
    SNRouterItem *item = [[[self class] allocWithZone:zone] init];
    item.name = self.name;
    item.className = self.className;
    item.routeType = self.routeType;
    item.needLogin = self.needLogin;
    return item;
}


@end
