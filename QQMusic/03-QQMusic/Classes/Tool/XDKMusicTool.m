//
//  XDKMusicTool.m
//  03-QQMusic
//
//  Created by 徐宽阔 on 15/9/9.
//  Copyright (c) 2015年 XDKOO. All rights reserved.
//

#import "XDKMusicTool.h"
#import "MJExtension.h"
#import "XDKMusic.h"

@implementation XDKMusicTool

static NSArray *_musics;

static XDKMusic *_playingMusic;

+ (void)initialize
{
    _musics = [XDKMusic objectArrayWithFilename:@"Musics.plist"];
    _playingMusic = _musics[2];
}

+ (NSArray *)musics
{
    return _musics;
}

+ (void)setPlayingMusic:(XDKMusic *)playingMusic
{
    _playingMusic = playingMusic;
}

+ (XDKMusic *)playingMusic
{
    return _playingMusic;
}

+ (XDKMusic *)nextMusic
{
    NSInteger currentIndex = [_musics indexOfObject:_playingMusic];
    NSInteger nextIndex = currentIndex + 1;
    if (nextIndex > _musics.count - 1) {
        nextIndex = 0;
    }
    XDKMusic *nextMusic = _musics[nextIndex];
    return nextMusic;
}

+ (XDKMusic *)previousMusic
{
    NSInteger currentIndex = [_musics indexOfObject:_playingMusic];
    NSInteger previousIndex = currentIndex - 1;
    if (previousIndex < 0) {
        previousIndex = _musics.count - 1;
    }
    XDKMusic *previousMusic = _musics[previousIndex];
    return previousMusic;
}


@end
