//
//  NSURL+SNMediator.h
//  Pods-SNMediator_Example
//
//  Created by 杨洁 on 2017/11/9.
//

#import <Foundation/Foundation.h>

@interface NSURL (SNMediator)
+ (instancetype)sn_URLWithString:(NSString *)urlString;
- (NSString *)sn_scheme;
- (NSString *)sn_host;
- (NSString *)sn_path;
- (NSMutableDictionary*)sn_query;
- (BOOL)sn_matchHostSet:(NSSet*)hostSet;

@end
