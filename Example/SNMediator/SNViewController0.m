//
//  SNViewController.m
//  SNMediator
//
//  Created by yangjie2 on 11/01/2017.
//  Copyright (c) 2017 yangjie2. All rights reserved.
//

#import "SNViewController0.h"
#import "NSObject+SNTargetAction.h"
#import "NSURL+SNMediator.h"
#import "SNMediator.h"

@interface SNLog : NSObject

@property (nonatomic, strong) NSString *logText;
@property (nonatomic, strong) NSString *timestamp;

@end

@implementation SNLog

+ (instancetype)logWithText:(NSString *)text
{
    SNLog *log = [[SNLog alloc] init];
    log.logText = text;
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
    log.timestamp = [formatter stringFromDate:date];
    return log;
}


@end

@interface SNViewController0 ()

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) NSMutableArray *logsArr;

@end

@implementation SNViewController0

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"首页"];
    _logsArr = [NSMutableArray arrayWithCapacity:10];

}

- (IBAction)testRoute:(id)sender
{
    [[SNRouteManger shareInstance] routeURL:SNURL(@"testModule/vcone") params:nil completion:NULL];
}

- (IBAction)testService:(id)sender
{
   NSString *str = [[[SNServiceManger shareInstance] getService:@"testModule/sayHello"] performAction:@"sayHello"];
    if (!self.textView.superview) {
        [self.view addSubview:self.textView];
    }
    [self printLog:str];
}

#pragma mark - private
- (void)printLog:(NSString*)newText
{
    if (newText.length == 0) {
        return;
    }
    @synchronized (self) {
        SNLog *newLog = [SNLog logWithText:newText];
        [self.logsArr addObject:newLog];
        if (self.logsArr.count > 20) {
            [self.logsArr removeObjectAtIndex:0];
        }
        // view
        [self refreshLogDisplay];
    }
}

- (void)refreshLogDisplay
{
    NSMutableString *mutableStr = [NSMutableString new];
    for (SNLog *log in self.logsArr) {
        if (log.logText.length == 0) {
            return;
        }
        [mutableStr appendString:log.timestamp];
        [mutableStr appendString:[NSString stringWithFormat:@"  %@",log.logText]];
        [mutableStr appendString:@"\n"];
    }
    self.textView.text = mutableStr;
    [self.textView scrollRangeToVisible:NSMakeRange(self.textView.text.length, 1)];
}


#pragma mark - getter
- (UITextView *)textView
{
    if (!_textView) {
        CGRect rect = self.view.bounds;
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, rect.size.height-150, rect.size.width, 120)];
        _textView.font = [UIFont systemFontOfSize:12.0f];
        _textView.backgroundColor = [UIColor blackColor];
        _textView.textColor = [UIColor whiteColor];
        _textView.scrollsToTop = NO;
        _textView.editable = NO;
        _textView.selectable = NO;
        _textView.layoutManager.allowsNonContiguousLayout = NO;
        _textView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    }
    return _textView;
}

@end
