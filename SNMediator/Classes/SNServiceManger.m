//
//  SNServiceManger.m
//  Pods-SNMediator_Example
//
//  Created by 杨洁 on 2017/11/6.
//

#import "SNServiceManger.h"

@interface SNServiceManger ()
@property (strong, nonatomic) NSMutableDictionary *serviceImplClassDict; //存放实现协议的类，name为key，serviceClass为value
@property (strong, nonatomic) NSMutableDictionary *serviceImplInstanceCacheDict; //缓存实现协议的类的实例 (获取服务时，创建对象，缓存在这里，下次用到直接查找，找不到再新建) serviceClass为key，serviceClass的实例对象为value



@end
@implementation SNServiceManger

@end
