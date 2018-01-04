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

- (BOOL)canRouteURL:(NSURL *)URL
{
    SNRouterItem * routerItem = nil;
    routerItem = [self routerItemWithURL:URL];
    return routerItem?YES:NO;
}

- (BOOL)routeURL:(NSURL *)URL params:(nullable NSDictionary *)params completion:(void (^_Nullable) (id _Nullable result))block
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
        viewController.hidesBottomBarWhenPushed = YES;
        if ([currentVC isKindOfClass:[UINavigationController class]]) {
            [(UINavigationController *)currentVC pushViewController:viewController animated:YES];
        }else if (currentVC.navigationController) {
            [currentVC.navigationController pushViewController:viewController animated:YES];
        }else {
            if (currentVC.presentedViewController) {
                [currentVC dismissViewControllerAnimated:NO completion:NULL];
            }
            UINavigationController *Nav = [[UINavigationController alloc] initWithRootViewController:viewController];
            Nav.modalPresentationStyle = UIModalPresentationCustom;
            [currentVC presentViewController:Nav animated:NO completion:NULL];
        }
    }else if (item.routeType == SNRouteType_modal) {
        if (currentVC.presentedViewController) {
            [currentVC dismissViewControllerAnimated:NO completion:NULL];
        }
        UINavigationController *NaVC = [[UINavigationController alloc] initWithRootViewController:viewController];
        NaVC.modalPresentationStyle = UIModalPresentationCustom;
        [currentVC presentViewController:NaVC animated:YES completion:NULL];
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
    
    //local URL
    routerItem = [self routerItemWithURL:URL];
    viewController = [self viewControllerWithItem:routerItem params:params];
    if (viewController) {
        //解析 URL 中的传参
        NSDictionary *URLParam = [URL sn_query];
        [viewController sn_setParams:URLParam];
    }
    if (block) {
        block(routerItem);
    }
    return viewController;
}

//根据URL后退到(跳转到)某个已经存在于视图栈中的VC界面
- (void)routeBackToURL:(NSURL *)popURL params:(nullable NSDictionary *)params completion:(void (^_Nullable) (id _Nullable result))block
{
    SNRouterItem *targetItem = [self routerItemWithURL:popURL];
    if (!targetItem) {
        if (block) {
            block(nil);
        }
        return;
    }
    UIViewController *currentVC = [UIViewController sn_currentViewController];
    if ([NSStringFromClass(currentVC.class) isEqualToString:targetItem.className] ) {
        [currentVC sn_setParams:params];
        if (block) {
            block(currentVC);
        }
        return;
    }
    //获取关于 tempVC 的导航关系栈
    NSMutableArray *vcStack = [[currentVC getViewControllerRelationStack] mutableCopy];
    [vcStack removeObjectAtIndex:0];
    //获取需要返回到的目标VC，然后显示，更新界面
    for (UIViewController *obj in vcStack) {
        if ([obj isKindOfClass:[UITabBarController class]]) {
            UITabBarController *tabBarVC = (UITabBarController *)obj;
            if ([tabBarVC.selectedViewController isKindOfClass:[UINavigationController class]]) {
                UINavigationController *selectedNavigaVC = tabBarVC.selectedViewController;
                for (UIViewController *obj in selectedNavigaVC.viewControllers) {
                    if ([NSStringFromClass(obj.class) isEqualToString:targetItem.className]) {
                        [obj sn_setParams:params];
                        if (block) {
                            block(obj);
                        }
                        [selectedNavigaVC dismissViewControllerAnimated:NO completion:NULL];
                        [selectedNavigaVC popToViewController:obj animated:YES];
                        return;
                    }
                }
            }else if ([tabBarVC.selectedViewController isKindOfClass:[UIViewController class]]) {
                UIViewController *selectedVC = tabBarVC.selectedViewController;
                if ([NSStringFromClass(selectedVC.class) isEqualToString:targetItem.className]) {
                    [selectedVC sn_setParams:params];
                    if (block) {
                        block(selectedVC);
                    }
                    [selectedVC dismissViewControllerAnimated:NO completion:NULL];
                    return;
                }
            }
            for (UIViewController *obj in tabBarVC.viewControllers) {
                if ([obj isKindOfClass:[UINavigationController class]]) {
                    UINavigationController *navigaVC = (UINavigationController *)obj;
                    UIViewController *rootVC = [navigaVC.viewControllers firstObject];
                    if ([NSStringFromClass(rootVC.class) isEqualToString:targetItem.className]) {
                        [rootVC sn_setParams:params];
                        if (block) {
                            block(rootVC);
                        }
                        [navigaVC dismissViewControllerAnimated:NO completion:NULL];
                        [navigaVC popToViewController:rootVC animated:YES];
                        return;
                    }
                }else if ([obj isKindOfClass:[UIViewController class]]) {
                    if ([NSStringFromClass(obj.class) isEqualToString:targetItem.className]) {
                        [obj sn_setParams:params];
                        if (block) {
                            block(obj);
                        }
                        [obj dismissViewControllerAnimated:NO completion:NULL];
                        [tabBarVC setSelectedViewController:obj];
                        return;
                    }
                }
            }
        }else if ([obj isKindOfClass:[UINavigationController class]]) {
            UINavigationController *navigaVC = (UINavigationController *)obj;
            for (UIViewController *objVC in navigaVC.viewControllers) {
                if ([NSStringFromClass(objVC.class) isEqualToString:targetItem.className]) {
                    [objVC sn_setParams:params];
                    if (block) {
                        block(objVC);
                    }
                    [navigaVC dismissViewControllerAnimated:NO completion:NULL];
                    [navigaVC popToViewController:objVC animated:YES];
                    return;
                }
            }
            continue;
        }else if ([obj isKindOfClass:[UIViewController class]]) {
            if ([NSStringFromClass([obj class]) isEqualToString:targetItem.className]) {
                [obj sn_setParams:params];
                if (block) {
                    block(obj);
                }
                [obj dismissViewControllerAnimated:NO completion:NULL];
                return;
            } else continue;

        }
    }
    if (block) {
        block(nil);
    }
}


#pragma mark - setter/getter
- (NSCache<NSString *,SNRouterItem *> *)routerItemCache
{
    if (!_routerItemCache) {
        _routerItemCache = [[NSCache alloc] init];
        _routerItemCache.countLimit = 200;
    }
    return _routerItemCache;
}


#pragma mark - private
- (SNRouterItem *)routerItemWithURL:(NSURL *)URL
{
    SNRouterItem * routerItem = nil;
    //优先匹配host与模块名相同的情况
    NSString *host = URL.sn_host;
    NSString *path = URL.sn_path;
    SNModuleConfig *moduleConfig = [self.modulesConfigDict objectForKey:host];
    routerItem = [self routerItemWithURLPath:path moduleConfig:moduleConfig];
    if (!routerItem) {
        //host与模块名不相同，匹配全路径
        NSString *fullPath = [host stringByAppendingPathComponent:path]; //路径拼接，会在字符串前自动添加“/”
        routerItem = [self routerItemWithURLPath:fullPath moduleConfig:moduleConfig];
    }
    return routerItem;
}

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
    UIViewController *viewController = nil;
    if (!item) {
        //页面不存在，生成错误页面
        viewController = [[SNErrorViewController alloc] init];
        return viewController;
    }
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
        //页面不存在，生成错误页面
        viewController = [[SNErrorViewController alloc] init];
        return viewController;
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
