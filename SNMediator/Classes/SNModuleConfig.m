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

@end
