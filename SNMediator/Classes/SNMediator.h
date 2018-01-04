//
//  SNMediator.h
//  Pods-SNMediator_Example
//
//  Created by 杨洁 on 2017/11/3.
//

#import <Foundation/Foundation.h>
#import "NSURL+SNMediator.h"
#import "SNMediatorMacro.h"
#import "SNRouteManger.h"
#import "SNServiceManger.h"
#import "SNAppLifeManger.h"

NS_ASSUME_NONNULL_BEGIN
@interface SNMediator : NSObject

+ (BOOL)registerAllModules;

+ (BOOL)routeURL:(NSURL *)URL;

+ (BOOL)routeURL:(NSURL *)URL params:(nullable NSDictionary *)params;

+ (BOOL)routeURL:(NSURL *)URL params:(nullable NSDictionary *)params completion:(void(^ _Nullable)(id _Nullable result))completion;

+ (void)routeBackToURL:(NSURL *)URL params:(nullable NSDictionary *)params completion:(void (^_Nullable) (id _Nullable result))block;

+ (nullable id)getService:(NSString *)serviceName;

@end
NS_ASSUME_NONNULL_END
