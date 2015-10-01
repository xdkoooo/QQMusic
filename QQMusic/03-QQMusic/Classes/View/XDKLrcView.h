//
//  XDKLrcView.h
//  03-QQMusic
//
//  Created by 徐宽阔 on 15/9/11.
//  Copyright (c) 2015年 XDKOO. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XDKLrcLabel;

@interface XDKLrcView : UIScrollView

@property (nonatomic,copy)NSString * lrcName;

@property (nonatomic,assign)NSTimeInterval currentTime;

// 外面的label
@property (nonatomic,weak)XDKLrcLabel * lrcLabel;

@end
