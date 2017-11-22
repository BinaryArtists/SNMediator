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
#import "SNMediator.h"

@interface SNViewController ()

@end

@implementation SNViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)testRoute:(id)sender
{
    [[SNRouteManger shareInstance] openURL:SNURL(@"testModule/vcone") withParams:nil completion:NULL];
}

- (IBAction)testService:(id)sender
{
    [[[SNServiceManger shareInstance] getService:@"testModule/sayHello"] performAction:@"sayHello"];
}

@end
