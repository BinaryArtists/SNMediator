//
//  SNRouteManger.m
//  Pods-SNMediator_Example
//
//  Created by 杨洁 on 2017/11/6.
//

#import "SNRouteManger.h"
#import "SNRouterItem.h"
#import "SNModuleConfig.h"
#import "NSURL+SNMediator.h"
#import "SNErrorViewController.h"
#import "NSObject+SNTargetAction.h"
#import "SNMediatorMacro.h"
#import "UIViewController+SNMediator.h"

@interface SNRouteManger ()
@property (strong, nonatomic) NSDictionary<NSString *,SNModuleConfig *> *modulesConfigDict; //所有模块配置集合，以模块名为key，SNModuleConfig对象为value
@property (strong, nonatomic) NSCache<NSString *,SNRouterItem *> *routerItemCache; //跳转过的页面item缓存起来，下次用到直接从这里获取

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
    if (!modulesDict) {
        return NO;
    }
    _modulesConfigDict = (NSDictionary<NSString *,SNModuleConfig *> *)modulesDict;
    return YES;
}

- (BOOL)canOpenURL:(NSURL *)URL
{
    SNRouterItem * routerItem = nil;
    //优先匹配host与模块名相同的情况
    NSString *host = URL.sn_host;
    NSString *path = URL.sn_path;
    SNModuleConfig *moduleConfig = [self.modulesConfigDict objectForKey:host];
    routerItem = [self routerItemWithURLPath:path moduleConfig:moduleConfig];
    if (routerItem) {
        return YES;
    }else {
        //host与模块名不相同，匹配全路径
        NSString *fullPath = [host stringByAppendingPathComponent:path]; //路径拼接，会在字符串前自动添加“/”
        routerItem = [self routerItemWithURLPath:fullPath moduleConfig:moduleConfig];
    }
    return routerItem?YES:NO;
}

- (BOOL)openURL:(NSURL *)URL withParams:(NSDictionary *)params completion:(void (^_Nullable) (id _Nullable result))block
{
    UIViewController *viewController = nil;
    __block SNRouterItem *item = nil;
    viewController = [self viewControllerForURL:URL params:params completion:^(SNRouterItem * _Nonnull routerItem) {
        item = routerItem;
    }];
    //判断是否需要登录
    if (item.needLogin) {
        //调出登录界面
    }
    //显示
    UIViewController *currentVC = [UIViewController sn_currentViewController];
    if (item.routeType == SNRouteType_push) {
        if ([currentVC isKindOfClass:[UINavigationController class]]) {
            [(UINavigationController *)currentVC pushViewController:viewController animated:YES];
        }else if (currentVC.navigationController) {
            [currentVC.navigationController pushViewController:viewController animated:YES];
        }else {
            UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:viewController];
            [currentVC presentViewController:Nav animated:NO completion:NULL];
        }
    }else if (item.routeType == SNRouteType_modal) {
        if (currentVC.presentedViewController) {
            [currentVC dismissViewControllerAnimated:NO completion:NULL];
        }
        [currentVC presentViewController:viewController animated:YES completion:NULL];
    }
    if (block) {
        block(viewController);
    }
    return viewController?YES:NO;
}

- (UIViewController *)viewControllerForURL:(NSURL *)URL params:(nullable NSDictionary *)params completion:(void (^_Nullable) (SNRouterItem  *routerItem))block
{
    UIViewController *viewController = nil;
    SNRouterItem * routerItem = nil;
    
    //Web URL
    if ([URL.scheme.lowercaseString isEqualToString:@"http"]||[URL.scheme.lowercaseString isEqualToString:@"https"]) {
        NSMutableDictionary *mParams = params?[params mutableCopy]:[NSMutableDictionary dictionary];
        mParams[@"webURL"] = [URL absoluteString];
        return [self viewControllerForURL:SNURL(@"appbase/webbrowser") params:mParams completion:block];
    }
    
    //优先匹配host与模块名相同的情况
    NSString *host = URL.sn_host;
    NSString *path = URL.sn_path;
    SNModuleConfig *moduleConfig = [self.modulesConfigDict objectForKey:host];
    routerItem = [self routerItemWithURLPath:path moduleConfig:moduleConfig];
    if (!routerItem) {     //host与模块名不相同，匹配全路径
        NSString *fullPath = [host stringByAppendingPathComponent:path]; //路径拼接，会在字符串前自动添加“/”
        routerItem = [self routerItemWithURLPath:fullPath moduleConfig:moduleConfig];
    }
    viewController = [self viewControllerWithItem:routerItem params:params];
    if (viewController) {
        //解析 URL 中的传参
        NSDictionary *URLParam = [URL sn_query];
        [viewController sn_setParams:URLParam];
        
        //夸界面传参  待实现
        
    }
    if (block) {
        block(routerItem);
    }
    return viewController;
}


#pragma mark - setter/getter
- (NSCache<NSString *,SNRouterItem *> *)routerItemCache
{
    if (!_routerItemCache) {
        _routerItemCache = [[NSCache alloc] init];
        _routerItemCache.countLimit = 400;
    }
    return _routerItemCache;
}


#pragma mark - private
//根据path(页面名)获取routeritem 确保path字符串前后都没有@"/"符号
- (SNRouterItem *)routerItemWithURLPath:(NSString *)path moduleConfig:(SNModuleConfig *)config
{
    SNRouterItem *routerItem = nil;
    routerItem = [self.routerItemCache objectForKey:path];
    if (routerItem) {
        return routerItem;
    }
    for (SNRouterItem *item in config.routerList) {
        if ([path caseInsensitiveCompare:item.name] == NSOrderedSame) { //不区分大小写
            [self.routerItemCache setObject:item forKey:path];
            routerItem = item;
            break;
        }
    }
    return routerItem;
}

- (UIViewController *)viewControllerWithItem:(SNRouterItem *)item params:(NSDictionary *)params
{
    if (!item) {
        return nil;
    }
    UIViewController *viewController = nil;
    Class class = NSClassFromString(item.className);
    if (!class||![class isSubclassOfClass:[UIViewController class]]) {
        //页面不存在，生成错误页面
        viewController = [[SNErrorViewController alloc] init];
        return viewController;
    }
    NSString *nibName = [self nibFileWithClass:class];
    if (nibName) {
        viewController = [[class alloc] initWithNibName:nibName bundle:nil];
    }else {
        viewController = [[class alloc] init];
    }
    if (viewController) {
        if (params) {
            [viewController sn_setParams:params];
        }
        return viewController;
    }else {
        return nil;
    }
}

- (NSString*)nibFileWithClass:(Class)class
{
    BOOL nibFileExist = ([[NSBundle mainBundle] pathForResource:NSStringFromClass(class) ofType:@"nib"] != nil);
    //如果没有对应的nib，但是父类不是UIViewController，则继续查找替用父类的nib
    if (nibFileExist == NO
        &&[NSStringFromClass([class superclass]) isEqualToString:NSStringFromClass([UIViewController class])] == NO) {
        return [self nibFileWithClass:[class superclass]];
    }
    return nibFileExist?NSStringFromClass(class):nil;
}





@end
