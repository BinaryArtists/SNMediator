//
//  SNMediator.m
//  Pods-SNMediator_Example
//
//  Created by 杨洁 on 2017/11/3.
//

#import "SNMediator.h"
#import "SNModuleConfig.h"
#import "SNMediatorMacro.h"
#import "SNRouteManger.h"
#import "SNServiceManger.h"
#import "SNAppLifeManger.h"

@implementation SNMediator

#pragma mark - public
+ (BOOL)registerAllModules
{
   return [[self class] loadLocalModules];
}

+ (BOOL)routeURL:(NSURL *)URL
{
    return [[SNRouteManger shareInstance] openURL:URL withParams:nil completion:NULL];
}

+ (BOOL)routeURL:(NSURL *)URL params:(nullable NSDictionary *)params
{
    return [[SNRouteManger shareInstance] openURL:URL withParams:params completion:NULL];
}

+ (BOOL)routeURL:(NSURL *)URL params:(nullable NSDictionary *)params completion:(void(^ _Nullable)(id _Nullable result))completion
{
    return [[SNRouteManger shareInstance] openURL:URL withParams:params completion:completion];
}

+ (nullable id)getService:(NSString *)serviceName
{
    return [[SNServiceManger shareInstance] getService:serviceName];
}


#pragma mark - private
//加载本地 plist 文件中配置的所有模块，生成对应的模块配置数据并保存在 modulesConfigDict 中
+ (BOOL)loadLocalModules
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"SNMediator.bundle/Modules" ofType:@"plist"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
        return NO;
    }
    NSArray *plistArr = [[NSArray alloc] initWithContentsOfFile:plistPath];
    NSMutableDictionary *tempModulesConfigDict = [NSMutableDictionary dictionary];
    if (plistArr&&[plistArr isKindOfClass:[NSArray class]]) {
        for (NSDictionary * configDict in plistArr) {
            SNModuleConfig *moduleConfig = [SNModuleConfig newWithDict:configDict];
            if (!moduleConfig.name) {
                SNAssert(NO,@"注册错误, 模块名为空");
            }
            if (tempModulesConfigDict[moduleConfig.name]) {
                SNAssert(NO,@"注册错误, 已经存在模块: %@",moduleConfig.name);
            }
            [tempModulesConfigDict setValue:moduleConfig forKey:[moduleConfig.name lowercaseString]];
        }
        [[SNAppLifeManger shareInstance] registerAppLife:tempModulesConfigDict];
        BOOL flag1 = [[SNRouteManger shareInstance] registerRouters:tempModulesConfigDict];
        BOOL flag2 = [[SNServiceManger shareInstance] registerServices:tempModulesConfigDict];
        return flag1&&flag2;
    }
    return NO;
}



@end
