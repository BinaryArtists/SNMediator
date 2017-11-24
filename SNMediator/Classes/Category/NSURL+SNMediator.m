//
//  NSURL+SNMediator.m
//  Pods-SNMediator_Example
//
//  Created by 杨洁 on 2017/11/9.
//

#import "NSURL+SNMediator.h"
#import "NSString+URLEncode.h"

@implementation NSURL (SNMediator)

+ (instancetype)sn_URLWithString:(NSString *)urlString
{
    if (!urlString||[urlString isEqualToString:@""]) {
        return nil;
    }
    if ([urlString rangeOfString:@"://"].location == NSNotFound) {
        NSString *ignorePrefix = @"/";
        if ([urlString hasPrefix:ignorePrefix]) {
            urlString = [urlString substringFromIndex:ignorePrefix.length];
        }
        urlString = [NSString stringWithFormat:@"snow://%@", urlString];
    }
    return [NSURL URLWithString:urlString];
}

- (NSString *)sn_scheme
{
    return [self.scheme lowercaseString];
}

- (NSString *)sn_host
{
    return [self.host lowercaseString];
}

- (NSString *)sn_path
{
    NSString *path = self.path;
    NSString *ignorePrefix = @"/";
    if ([path hasPrefix:ignorePrefix]) {
        path = [path substringFromIndex:ignorePrefix.length];
    }
    if ([path hasSuffix:ignorePrefix]) {
        path = [path substringToIndex:path.length-ignorePrefix.length];
    }
    return [path lowercaseString];
}

- (NSMutableDictionary*)sn_query
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSArray *paramsArr = [self.query componentsSeparatedByString:@"&"];
    for (NSString *paramString in paramsArr) {
        NSArray *paramsArr = [paramString componentsSeparatedByString:@"="];
        [params setValue:[[paramsArr lastObject] sn_URLDecode] forKey:[paramsArr firstObject]];
    }
    return params;
}

- (BOOL)sn_matchHostSet:(NSSet*)hostSet
{
    NSString *urlHost = self.sn_host;
    for (NSString *host in hostSet.allObjects) {
        if ([urlHost isEqualToString:[host lowercaseString]]) {//完全匹配域名
            return YES;
        }
        if ([urlHost hasSuffix:[[@"." stringByAppendingString:host] lowercaseString]]) {//匹配多级域名
            return YES;
        }
    }
    return NO;
}

@end
