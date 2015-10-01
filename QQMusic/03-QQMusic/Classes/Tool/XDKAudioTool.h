//
//  XDKAudioTool.h
//  01-音效播放
//
//  Created by 徐宽阔 on 15/9/9.
//  Copyright (c) 2015年 XDKOO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface XDKAudioTool : NSObject


+ (void)playSoundWithSoundName:(NSString *)soundName;

+ (AVAudioPlayer *)playMusicWithMusicName:(NSString *)musicName;

+ (void)pauseMusicWithMusicName:(NSString *)musicName;

+ (void)stopMusicWithMusicName:(NSString *)musicName;
@end
