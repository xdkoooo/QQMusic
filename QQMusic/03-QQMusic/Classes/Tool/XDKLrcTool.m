//
//  XDKLrcTool.m
//  03-QQMusic
//
//  Created by 徐宽阔 on 15/9/11.
//  Copyright (c) 2015年 XDKOO. All rights reserved.
//

#import "XDKLrcTool.h"
#import "XDKLrc.h"

@implementation XDKLrcTool

+ (NSArray *)currentLrcArray:(NSString *)lrcName
{
    // 歌词路径
    NSString *path = [[NSBundle mainBundle] pathForResource:lrcName ofType:nil];
    NSString *lrcString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    NSArray *lrcArray = [lrcString componentsSeparatedByString:@"\n"];
    NSInteger count = lrcArray.count;
    NSMutableArray *templrc = [NSMutableArray array];
    for (int i = 0; i < count ; i++) {
        NSString *subLrc = lrcArray[i];
        if ([subLrc hasPrefix:@"[ti:"] || [subLrc hasPrefix:@"[ar:"] || [subLrc hasPrefix:@"[al:"] || ![subLrc hasPrefix:@"["]) {
            continue;
        }
        
        XDKLrc *lrc = [[XDKLrc alloc] initWithLrcName:subLrc];
        [templrc addObject:lrc];
    }
    return templrc;
}

@end
