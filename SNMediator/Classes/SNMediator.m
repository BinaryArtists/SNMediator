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

@interface SNMediator()
@property (strong, nonatomic) NSMutableDictionary<NSString *,SNModuleConfig *> *modulesConfigDict;//所有模块配置集合，以模块名为key，SNModuleConfig对象为value
@property (strong, nonatomic) NSRecursiveLock *lock;

@end

@implementation SNMediator
static SNMediator *instance = nil;
+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[SNMediator alloc] init];
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
- (BOOL)registerAllModules
{
    BOOL flag1 = [self loadLocalModules];
    [[SNAppLifeManger shareInstance] registerAppLife:_modulesConfigDict];
    BOOL flag2 = [[SNRouteManger shareInstance] registerRouters:_modulesConfigDict];
    BOOL flag3 = [[SNServiceManger shareInstance] registerServices:_modulesConfigDict];
    return flag1&&flag2&&flag3;
}












#pragma mark - private
//加载本地 plist 文件中配置的所有模块，生成对应的模块配置数据并保存在 modulesConfigDict 中
- (BOOL)loadLocalModules
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"SNMediator.bundle/Modules" ofType:@"plist"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
        return NO;
    }
    NSArray *plistArr = [[NSArray alloc] initWithContentsOfFile:plistPath];
    if (plistArr&&[plistArr isKindOfClass:[NSArray class]]) {
        for (NSDictionary * configDict in plistArr) {
            SNModuleConfig *moduleConfig = [SNModuleConfig newWithDict:configDict];
            if (!moduleConfig.name) {
                return NO;
            }
            if (self.modulesConfigDict[moduleConfig.name]) {
                SNAssert(NO,@"注册错误, 已经存在模块: %@",moduleConfig.name);
            }
            [self.modulesConfigDict setValue:moduleConfig forKey:moduleConfig.name];
        }
        return YES;
    }
    return NO;
}











#pragma mark - getter
- (NSMutableDictionary<NSString *,SNModuleConfig *> *)modulesConfigDict
{
    if (!_modulesConfigDict) {
        _modulesConfigDict = [NSMutableDictionary dictionaryWithCapacity:4];
    }
    return _modulesConfigDict;
}


@end
