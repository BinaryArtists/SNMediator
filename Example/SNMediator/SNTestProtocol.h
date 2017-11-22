//
//  SNTestProtocol.h
//  SNMediator_Example
//
//  Created by 杨洁 on 2017/11/22.
//  Copyright © 2017年 yangjie2. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SNServiceProtocol.h"

@protocol SNTestProtocol <SNServiceProtocol>

- (void)sayHello;

@end
