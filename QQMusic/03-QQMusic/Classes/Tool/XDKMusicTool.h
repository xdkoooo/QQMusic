//
//  XDKMusicTool.h
//  03-QQMusic
//
//  Created by 徐宽阔 on 15/9/9.
//  Copyright (c) 2015年 XDKOO. All rights reserved.
//

#import <Foundation/Foundation.h>
@class XDKMusic;
@interface XDKMusicTool : NSObject

+ (NSArray *)musics;

+ (void)setPlayingMusic:(XDKMusic *)playingMusic;

+ (XDKMusic *)playingMusic;

+ (XDKMusic *)nextMusic;

+ (XDKMusic *)previousMusic;
@end
