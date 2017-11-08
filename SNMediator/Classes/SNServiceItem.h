//
//  SNServiceItem.h
//  Pods-SNMediator_Example
//
//  Created by 杨洁 on 2017/11/4.
//

#import <Foundation/Foundation.h>

@interface SNServiceItem : NSObject<NSCopying>
@property (strong, nonatomic) NSString *name; //服务名
@property (strong, nonatomic) NSString *protocol; //协议
@property (strong, nonatomic) NSString *className; //实现protocol的类

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

+ (instancetype)newWithDict:(NSDictionary *)dict;

@end
