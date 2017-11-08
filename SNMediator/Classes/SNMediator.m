//
//  SNMediator.m
//  Pods-SNMediator_Example
//
//  Created by 杨洁 on 2017/11/3.
//

#import "SNMediator.h"
#import "SNModuleConfig.h"

@interface SNMediator()

@property (nonatomic, strong) NSRecursiveLock *lock;

@end

@implementation SNMediator
static SNMediator *instance = nil;
+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[SNMediator alloc] init];
    });
    return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [super allocWithZone:zone];
    });
    return instance;
}

- (BOOL)loadLocalModules
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"SNMediator.bundle/Modules" ofType:@"plist"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
        return NO;
    }
    NSArray *plistArr = [[NSArray alloc] initWithContentsOfFile:plistPath];
    if (plistArr&&[plistArr isKindOfClass:[NSArray class]]) {
        for (id obj in plistArr) {
            if ([obj isKindOfClass:[NSDictionary class]]) {
                SNModuleConfig *moduleConfig = [SNModuleConfig newWithDict:obj];
                if (!moduleConfig.name) {
                    return NO;
                }
            }
        }
        
    }
}
















@end
