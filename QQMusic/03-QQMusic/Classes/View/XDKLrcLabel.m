//
//  XDKLrcLabel.m
//  03-QQMusic
//
//  Created by 徐宽阔 on 15/9/11.
//  Copyright (c) 2015年 XDKOO. All rights reserved.
//

#import "XDKLrcLabel.h"

@implementation XDKLrcLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.textAlignment = NSTextAlignmentCenter;
        self.font = [UIFont systemFontOfSize:13];
        self.textColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setProgress:(CGFloat)progress
{
    _progress = progress;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    [[UIColor greenColor] set];
    
    CGRect drawRect = CGRectMake(0, 0, self.bounds.size.width * self.progress, self.bounds.size.height);
    
//    UIRectFill(drawRect);
    UIRectFillUsingBlendMode(drawRect, kCGBlendModeSourceIn);
}

@end
