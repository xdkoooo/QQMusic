//
//  XDKLrc.h
//  03-QQMusic
//
//  Created by 徐宽阔 on 15/9/11.
//  Copyright (c) 2015年 XDKOO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XDKLrc : NSObject

@property (nonatomic,assign)NSTimeInterval time;

@property (nonatomic,copy)NSString * text;

- (instancetype)initWithLrcName:(NSString *)lrcName;

+ (instancetype)lrcWithLrcName:(NSString *)lrcName;

@end
