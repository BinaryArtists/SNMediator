//
//  SNViewController.m
//  SNMediator
//
//  Created by yangjie2 on 11/01/2017.
//  Copyright (c) 2017 yangjie2. All rights reserved.
//

#import "SNViewController.h"
#import "NSObject+SNTargetAction.h"
#import "SNTestModel.h"
#import "NSURL+SNMediator.h"

@interface SNViewController ()

@end

@implementation SNViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSMutableDictionary *params = @{}.mutableCopy;
    [params setValue:@(12) forKey:@"age"];
    [params setValue:@"杨洁" forKey:@"name"];
    id testModel = [[SNTestModel alloc] init];
    [testModel sn_setParams:params];
    
    NSURL *URL = [NSURL URLWithString:@"snow://videoModule/sponsor//?roomid=1002&sid=10000&patient=yangjie"];
    NSString *path = URL.path;
    if ([path hasSuffix:@"/"]) {
        path = [path substringToIndex:path.length-1];
    }
    if ([path hasPrefix:@"/"]) {
        path = [path substringFromIndex:1];
    }
    NSLog(@"%@",URL);
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
