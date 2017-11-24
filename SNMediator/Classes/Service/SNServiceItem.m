//
//  SNServiceItem.m
//  Pods-SNMediator_Example
//
//  Created by 杨洁 on 2017/11/4.
//

#import "SNServiceItem.h"

@implementation SNServiceItem
+ (instancetype)newWithDict:(NSDictionary *)dict
{
    __block SNServiceItem *instance = [[self alloc] init];
    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [instance setValue:obj forKey:key];
    }];
    return instance;
}

#pragma mark - NSCopying
- (id)copyWithZone:(nullable NSZone *)zone
{
    SNServiceItem *item = [[[self class] allocWithZone:zone] init];
    item.name = self.name;
    item.protocol = self.protocol;
    item.className = self.className;
    return item;
}




@end
