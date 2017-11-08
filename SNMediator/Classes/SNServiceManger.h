//
//  SNServiceManger.h
//  Pods-SNMediator_Example
//
//  Created by 杨洁 on 2017/11/6.
//

#import <Foundation/Foundation.h>

//负责方法(服务)调用
NS_ASSUME_NONNULL_BEGIN
@interface SNServiceManger : NSObject
+ (instancetype)shareInstance;
//注册所有模块的服务
- (BOOL)registerServices:(NSDictionary *)modulesDict;


@end
NS_ASSUME_NONNULL_END
