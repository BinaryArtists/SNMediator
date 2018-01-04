//
//  SNTestViewController4.m
//  SNMediator_Example
//
//  Created by 杨洁 on 2018/1/3.
//  Copyright © 2018年 yangjie2. All rights reserved.
//

#import "SNTestViewController4.h"
#import "SNMediator.h"

@interface SNTestViewController4 ()

@end

@implementation SNTestViewController4

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backToVCOne:(id)sender
{
    [SNMediator routeBackToURL:SNURL(@"testModule/vcone") params:@{@"bgColor":[UIColor yellowColor]} completion:NULL];
}

- (IBAction)backToVCthree:(id)sender
{
    [SNMediator routeBackToURL:SNURL(@"testModule/vcthree") params:nil completion:NULL];
}

- (IBAction)backToVCTwo:(id)sender
{
    [SNMediator routeBackToURL:SNURL(@"testModule/vctwo") params:nil completion:NULL];
}

- (IBAction)backToRootTabBarSecondIndex:(id)sender
{
    [SNMediator routeBackToURL:SNURL(@"homeModule/rootVC1") params:nil completion:NULL];
}


@end
