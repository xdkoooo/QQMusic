//
//  XDKPlayingViewController.m
//  03-QQMusic
//
//  Created by 徐宽阔 on 15/9/9.
//  Copyright (c) 2015年 XDKOO. All rights reserved.
//

#import "XDKPlayingViewController.h"
#import "XDKMusicTool.h"
#import "XDKAudioTool.h"
#import "XDKMusic.h"
#import "Masonry.h"
#import "NSString+XDKTime.h"
#import "CALayer+PauseAimate.h"
#import "XDKLrcView.h"
#import "XDKLrcTool.h"
#import "XDKLrcLabel.h"
#import <MediaPlayer/MediaPlayer.h>

@interface XDKPlayingViewController () <AVAudioPlayerDelegate,UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *singerLabel;
@property (weak, nonatomic) IBOutlet UIImageView *singerIconView;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UISlider *progressView;
@property (weak, nonatomic) IBOutlet UIButton *playORpauseBtn;

@property (weak, nonatomic) IBOutlet UILabel *playedTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;
@property (weak, nonatomic) IBOutlet XDKLrcView *lrcView;

@property (weak, nonatomic) IBOutlet XDKLrcLabel *lrcLabel;


@property (nonatomic,weak)AVAudioPlayer *player;

@property (nonatomic,strong)NSTimer *timer;
@property (nonatomic,strong)CADisplayLink *link;

- (IBAction)sliderTouchDown:(id)sender;
- (IBAction)sliderTouchUpInside:(id)sender;
- (IBAction)sliderValueChanged:(id)sender;

- (IBAction)previousMusic:(id)sender;
- (IBAction)nextMusic:(id)sender;
- (IBAction)playORpauseBtnClick:(id)sender;
- (IBAction)sliderTap:(UITapGestureRecognizer *)sender;

@end

@implementation XDKPlayingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupBlurGlassView];
    
    [self startPlayingMusic];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    // 设置中间图片的圆圈
    self.singerIconView.layer.cornerRadius = self.singerIconView.bounds.size.width * 0.5;
    self.singerIconView.layer.masksToBounds = YES;
    self.singerIconView.layer.borderWidth = 5;
    self.singerIconView.layer.borderColor = [UIColor colorWithRed:36/255.0 green:36/255.0 blue:36/255.0 alpha:1.0].CGColor;
}

- (void)setupBlurGlassView
{
    // 设置毛玻璃效果
    UIToolbar *toolBar = [[UIToolbar alloc] init];
    toolBar.barStyle = UIBarStyleBlack;
    toolBar.translatesAutoresizingMaskIntoConstraints = NO;
    [self.iconView addSubview:toolBar];
    [toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.iconView);
    }];
    
    // 设置进度条图片
    [self.progressView setThumbImage:[UIImage imageNamed:@"player_slider_playback_thumb"] forState:UIControlStateNormal];
}

- (void)startPlayingMusic
{
    // 1.当前正在播放的音乐
    XDKMusic *music = [XDKMusicTool playingMusic];
    
    // 2.更改界面
    self.nameLabel.text = music.name;
    self.singerLabel.text = music.singer;
    self.iconView.image = [UIImage imageNamed:music.icon];
    self.singerIconView.image = [UIImage imageNamed:music.icon];
    
    // 3.获取当前播放器
    self.player = [XDKAudioTool playMusicWithMusicName:music.filename];
    self.player.delegate = self;
    self.playedTimeLabel.text = [NSString stringWithTime:self.player.currentTime];
    self.totalTimeLabel.text = [NSString stringWithTime:self.player.duration];
    
    // 4.添加定时器
    [self addMusicPlayingTimer];
    
    // 5.开始动画
    [self startSingerIconViewAnimation];
    
    // 6.传递歌词名
    self.lrcView.contentSize = CGSizeMake(self.view.bounds.size.width * 2, 0);
    self.lrcView.delegate = self;
    self.lrcView.lrcName = music.lrcname;
    self.lrcView.lrcLabel = self.lrcLabel;
    
    // 7.添加歌词切换的定时器
    [self addLrcTimer];
    
    // 8.设置锁屏界面
    [self setupLockScreenInfoWithPlayingMusic:music];
}

- (void)setupLockScreenInfoWithPlayingMusic:(XDKMusic *)music
{
    MPNowPlayingInfoCenter *info = [MPNowPlayingInfoCenter defaultCenter];
    
    NSMutableDictionary *playingInfo = [NSMutableDictionary dictionary];
    
    playingInfo[MPMediaItemPropertyAlbumTitle] = music.name;
    playingInfo[MPMediaItemPropertyArtist] = music.singer;
    playingInfo[MPMediaItemPropertyArtwork] = [[MPMediaItemArtwork alloc] initWithImage:[UIImage imageNamed:music.icon]];
    playingInfo[MPMediaItemPropertyPlaybackDuration] = @(self.player.duration);
    
    
    info.nowPlayingInfo = playingInfo;
    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    switch (event.subtype) {
        case UIEventSubtypeRemoteControlPlay:
        case UIEventSubtypeRemoteControlPause:
              [self playORpauseBtnClick:nil];
            break;
        
        case UIEventSubtypeRemoteControlNextTrack:
            [self nextMusic:nil];
            break;
        
        case UIEventSubtypeRemoteControlPreviousTrack:
            [self previousMusic:nil];
            break;
            
        default:
            break;
    }
}

#pragma mark -<UIScrollViewDelegate>

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat ratio = self.lrcView.contentOffset.x / self.view.bounds.size.width;
    
    self.singerIconView.alpha = 1 - ratio;
    self.lrcLabel.alpha = 1 - ratio;
}

- (void)addLrcTimer
{
    self.link = [CADisplayLink displayLinkWithTarget:self selector:@selector(currentTimeDidChange)];
    [self.link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)removeLrcTimer
{
    [self.link invalidate];
    self.link = nil;
}

- (void)currentTimeDidChange
{
    self.lrcView.currentTime = self.player.currentTime;
}

- (void)addMusicPlayingTimer
{
    [self updateTimeLabelInfo];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateTimeLabelInfo) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)removeMusicPlayingTimer
{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)updateTimeLabelInfo
{
    self.progressView.value = self.player.currentTime / self.player.duration;
    self.playedTimeLabel.text = [NSString stringWithTime:self.player.currentTime];
}

- (IBAction)sliderTouchDown:(id)sender {
    [self removeMusicPlayingTimer];
}

- (IBAction)sliderTouchUpInside:(id)sender {
    self.player.currentTime = self.player.duration * self.progressView.value;
    [self addMusicPlayingTimer];
}

- (IBAction)sliderValueChanged:(id)sender {
    [self removeMusicPlayingTimer];
    NSTimeInterval currentTime = self.player.duration * self.progressView.value;
    self.playedTimeLabel.text = [NSString stringWithTime:currentTime];
}

- (void)startSingerIconViewAnimation
{
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    anim.fromValue = @(0);
    anim.toValue = @(M_PI * 2);
    anim.duration = 30;
    anim.repeatCount = NSIntegerMax;
    
    [self.singerIconView.layer addAnimation:anim forKey:nil];
}

- (IBAction)previousMusic:(id)sender {
    XDKMusic *music = [XDKMusicTool previousMusic];
    [self changePlayingMusic:music];
}
- (IBAction)nextMusic:(id)sender {
    
    XDKMusic *music = [XDKMusicTool nextMusic];
    
    [self changePlayingMusic:music];
}

- (void)changePlayingMusic:(XDKMusic *)music
{
    self.playORpauseBtn.selected = NO;
    
    XDKMusic *playingMusic = [XDKMusicTool playingMusic];
    
    [XDKAudioTool stopMusicWithMusicName:playingMusic.filename];
    
    [XDKMusicTool setPlayingMusic:music];
    
    [self startPlayingMusic];
}

- (IBAction)playORpauseBtnClick:(UIButton *)sender {
    self.playORpauseBtn.selected = !sender.selected;
    if (self.player.isPlaying) {
        [self.player pause];
        [self.singerIconView.layer pauseAnimate];
        [self removeMusicPlayingTimer];
    }else{
        [self.player play];
        [self.singerIconView.layer resumeAnimate];
        [self addMusicPlayingTimer];
    }
}

- (IBAction)sliderTap:(UITapGestureRecognizer *)sender {
    CGPoint point = [sender locationInView:self.progressView];
    CGFloat ratio = point.x / self.progressView.bounds.size.width;
    self.player.currentTime = self.player.duration * ratio;
    [self updateTimeLabelInfo];
}

#pragma mark - <AVAudioPlayerDelegate>

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if (flag) {
        [self nextMusic:nil];
    }
}

@end
