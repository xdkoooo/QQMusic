//
//  XDKLrc.m
//  03-QQMusic
//
//  Created by 徐宽阔 on 15/9/11.
//  Copyright (c) 2015年 XDKOO. All rights reserved.
//

#import "XDKLrc.h"

@implementation XDKLrc



- (instancetype)initWithLrcName:(NSString *)lrcName
{
    if (self = [super init]) {
        //        [01:20.74]想这样没担忧 唱着歌 一直走
        NSArray *lrcArray = [lrcName componentsSeparatedByString:@"]"];
        self.text = [lrcArray lastObject];

        self.time = [self time:lrcArray.firstObject];
    }
    return self;
}

+ (instancetype)lrcWithLrcName:(NSString *)lrcName
{
    return [[self alloc] initWithLrcName:lrcName];
}

- (NSTimeInterval)time:(NSString *)str
{
    NSString *newLrc = [str substringFromIndex:1];
    NSArray *lrcArray = [newLrc componentsSeparatedByString:@":"];
    NSInteger min = [[lrcArray firstObject] integerValue];
    NSArray * remianArray = [[lrcArray lastObject] componentsSeparatedByString:@"."];
    NSInteger sec = [[remianArray firstObject] integerValue];
    NSInteger haomiao = [[remianArray lastObject] integerValue];
    return min * 60 + sec + haomiao * 0.01;
}

@end
