//
//  SNServiceManger.h
//  Pods-SNMediator_Example
//
//  Created by 杨洁 on 2017/11/6.
//

#import <Foundation/Foundation.h>
#import "NSObject+SNTargetAction.h"
#import "SNServiceProtocol.h"

//负责方法(服务)调用
NS_ASSUME_NONNULL_BEGIN
@interface SNServiceManger : NSObject
+ (instancetype)shareInstance;
//注册所有模块的服务
- (BOOL)registerServices:(NSDictionary *)modulesDict;

/**
 *  从所有注册的服务中获取某个服务
 *
 */
- (id)getService:(NSString *)serviceName;

@end
NS_ASSUME_NONNULL_END
