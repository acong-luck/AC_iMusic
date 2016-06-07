//
//  MusicPlayTool.m
//  iMusic
//
//  Created by FM-13 on 16/6/6.
//  Copyright © 2016年 cong. All rights reserved.
//

#import "MusicPlayTool.h"
#import "MusicManager.h"

#import <MediaPlayer/MediaPlayer.h>

@implementation MusicPlayTool

singleton_implementation(MusicPlayTool)


- (void)prepareForPlayWithMusic:(MusicInfo *)music
{
    NSURL *musicUrl = [[NSBundle mainBundle] URLForResource:music.musicPath withExtension:nil];
    
    NSError *error = nil;
    
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:musicUrl error:&error];
    if (error) {
        NSLog(@"%s %@", __func__, error);
    }
    self.player.delegate = self;
    
    [self.player prepareToPlay];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShouldPrepareToPlay" object:nil];
    //歌词更新   toobar更新
    
    
    
    //由于有的歌曲没有歌词  所以这边需要设置一次 可以加个判断只有进入后台后才设置
    //设置锁屏音乐信息
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    //设置专辑名称
    info[MPMediaItemPropertyAlbumTitle] = @"网络热曲";
    //设置歌曲名
    info[MPMediaItemPropertyTitle] = music.musicName;
    //设置歌手
    info[MPMediaItemPropertyArtist] = music.songer;
    //设置专辑图片
    MPMediaItemArtwork *artwork = [[MPMediaItemArtwork alloc] initWithImage:[UIImage imageNamed:@"song_400"]];
    info[MPMediaItemPropertyArtwork] = artwork;
    //设置歌曲时间
    info[MPMediaItemPropertyPlaybackDuration] = @(self.player.duration);
    [MPNowPlayingInfoCenter defaultCenter].nowPlayingInfo = info;
    
}

- (void)play
{
    [self.player play];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShouldPlay" object:nil];
}

- (void)pause
{
    [self.player pause];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShouldPause" object:nil];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [self prepareForPlayWithMusic:[[MusicManager sharedMusicManager] nextMusicInfo]];
    [self play];
}

@end
