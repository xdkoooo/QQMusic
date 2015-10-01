//
//  XDKAudioTool.m
//  01-音效播放
//
//  Created by 徐宽阔 on 15/9/9.
//  Copyright (c) 2015年 XDKOO. All rights reserved.
//

#import "XDKAudioTool.h"
#import <AVFoundation/AVFoundation.h>

@implementation XDKAudioTool

static NSMutableDictionary *_soundDict;

static NSMutableDictionary *_musicDict;

+ (void)initialize
{
    _soundDict = [NSMutableDictionary dictionary];
    _musicDict = [NSMutableDictionary dictionary];
}

+ (void)playSoundWithSoundName:(NSString *)soundName
{
    SystemSoundID soundID = [_soundDict[soundName] unsignedIntValue];
    
    if (soundID == 0) {
        NSURL *url = [[NSBundle mainBundle] URLForResource:soundName withExtension:nil];
        
        CFURLRef urlRef = (__bridge CFURLRef)url;
        
        AudioServicesCreateSystemSoundID(urlRef, &soundID);
        
        [_soundDict setObject:@(soundID) forKey:soundName];
    }
    
    AudioServicesPlaySystemSound(soundID);
}



+ (AVAudioPlayer *)playMusicWithMusicName:(NSString *)musicName
{
    assert(musicName);
    
    AVAudioPlayer *player = _musicDict[musicName];
    
    if (player == nil) {
        NSURL *url = [[NSBundle mainBundle] URLForResource:musicName withExtension:nil];
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:url  error:nil];
        
        [_musicDict setObject:player forKey:musicName];
    }
    [player prepareToPlay];
    [player play];
    return player;
}

+ (void)pauseMusicWithMusicName:(NSString *)musicName
{
    assert(musicName);
    AVAudioPlayer *player = _musicDict[musicName];
    if (player) {
        [player pause];
    }
}

+ (void)stopMusicWithMusicName:(NSString *)musicName
{
    assert(musicName);
    AVAudioPlayer *player = _musicDict[musicName];
    if (player) {
        [player stop];
        [_musicDict removeObjectForKey:musicName];
        player = nil;
    }
}

@end
