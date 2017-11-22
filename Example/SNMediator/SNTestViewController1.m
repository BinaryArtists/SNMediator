//
//  SNTestViewController1.m
//  SNMediator_Example
//
//  Created by 杨洁 on 2017/11/22.
//  Copyright © 2017年 yangjie2. All rights reserved.
//

#import "SNTestViewController1.h"
#import "SNMediator.h"


@interface SNTestViewController1 ()

@end

@implementation SNTestViewController1

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

- (IBAction)buttonClicked:(id)sender
{
    [[SNRouteManger shareInstance] openURL:SNURL(@"testModule/vctwo") withParams:nil completion:NULL];
}

@end
