//
//  SNMediator.h
//  Pods-SNMediator_Example
//
//  Created by 杨洁 on 2017/11/3.
//

#import <Foundation/Foundation.h>
#import "NSURL+SNMediator.h"
#import "SNMediatorMacro.h"
#import "SNRouteManger.h"
#import "SNServiceManger.h"

@interface SNMediator : NSObject

+ (instancetype)shareInstance;

- (BOOL)registerAllModules;

@end
