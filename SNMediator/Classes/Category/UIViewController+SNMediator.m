//
//  UIViewController+SNMediator.m
//  Pods-SNMediator_Example
//
//  Created by 杨洁 on 2017/11/9.
//

#import "UIViewController+SNMediator.h"

@implementation UIViewController (SNMediator)
//获取当前VC
+ (UIViewController *)sn_currentViewController
{
    UIViewController *viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (viewController) {
        if ([viewController isKindOfClass:[UITabBarController class]]) {
            UITabBarController *tbvc = (UITabBarController*)viewController;
            viewController = tbvc.selectedViewController;
            continue;
        }
        if ([viewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *nvc = (UINavigationController*)viewController;
            viewController = nvc.topViewController;
            continue;
        }
        if (viewController.presentedViewController) {
            viewController = viewController.presentedViewController;
            continue;
        }
        if ([viewController isKindOfClass:[UISplitViewController class]] &&
            ((UISplitViewController *)viewController).viewControllers.count > 0) {
            UISplitViewController *svc = (UISplitViewController *)viewController;
            viewController = svc.viewControllers.lastObject;
            continue;
        }
        return viewController;
    }
    return viewController;
}

@end
