//
//  UIViewController+SNMediator.h
//  Pods-SNMediator_Example
//
//  Created by 杨洁 on 2017/11/9.
//

#import <UIKit/UIKit.h>

@interface UIViewController (SNMediator)
//获取当前VC
+ (UIViewController *)sn_currentViewController;

//控制器是否在视图栈中(可能没有显示出来，但是存在于视图栈中，存在于内存中)
- (BOOL)sn_inViewStack;

//dismiss所有模态viewController
+ (void)sn_dismissAllPresentedViewControllerWithCurrentVC:(UIViewController *)currentVC;

//获取该视图控制器的关系栈
- (NSArray *)getViewControllerRelationStack;

@end
