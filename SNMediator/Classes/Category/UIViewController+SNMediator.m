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

//控制器是否在视图栈中(可能没有显示出来，但是存在于视图栈中，存在于内存中)
- (BOOL)sn_inViewStack
{
    return self.parentViewController || self.presentingViewController;
}

+ (void)sn_dismissAllPresentedViewControllerWithCurrentVC:(UIViewController *)currentVC
{
    UIViewController *tempVC = currentVC;
    if (tempVC.presentingViewController) {
        tempVC = tempVC.presentingViewController;
        [tempVC dismissViewControllerAnimated:NO completion:^{
            [[self class] sn_dismissAllPresentedViewControllerWithCurrentVC:tempVC];
        }];
    } else if (tempVC.presentedViewController) {
        [tempVC dismissViewControllerAnimated:NO completion:^{
            [[self class] sn_dismissAllPresentedViewControllerWithCurrentVC:tempVC];
        }];
    } else {
        return;
    }
}

- (NSArray *)getViewControllerRelationStack
{
    //获取关于 tempVC 的导航关系栈
    NSMutableArray *vcStack = [NSMutableArray array];
    UIViewController *tempVC = self;
    [vcStack addObject:tempVC];
    while (tempVC.parentViewController || tempVC.presentingViewController) {
        tempVC = tempVC.parentViewController?:tempVC.presentingViewController;
        [vcStack addObject:tempVC];
    }
    return vcStack;
}

@end
