//
//  SNTestViewController2.m
//  SNMediator_Example
//
//  Created by 杨洁 on 2017/11/22.
//  Copyright © 2017年 yangjie2. All rights reserved.
//

#import "SNTestViewController2.h"
#import "SNMediator.h"

@interface SNTestViewController2 ()
- (IBAction)pushToVC4:(id)sender;

@end

@implementation SNTestViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"vcTwo";
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
    [SNMediator routeURL:SNURL(@"testModule/vcthree") params:nil];
}

- (IBAction)pushNonexistentVC:(id)sender
{
    [SNMediator routeURL:SNURL(@"testModule/nonexistent") params:nil];
}

- (IBAction)pushToVC4:(id)sender
{
    [SNMediator routeURL:SNURL(@"testModule/vcfour")];
}


@end
