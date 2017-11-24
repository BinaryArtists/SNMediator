//
//  SNServiceProtocol.h
//  Pods-SNMediator_Example
//
//  Created by 杨洁 on 2017/11/4.
//

#import <Foundation/Foundation.h>

@protocol SNServiceProtocol <NSObject>

@optional
+ (BOOL)singleton;
+ (id)shareInstance;

@end
