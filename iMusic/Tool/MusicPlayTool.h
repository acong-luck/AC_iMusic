//
//  MusicPlayTool.h
//  iMusic
//
//  Created by FM-13 on 16/6/6.
//  Copyright © 2016年 cong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "Single.h"
#import "MusicInfo.h"

@interface MusicPlayTool : NSObject <AVAudioPlayerDelegate>

singleton_interface(MusicPlayTool);

@property (nonatomic, strong) AVAudioPlayer *player;

- (void)prepareForPlayWithMusic:(MusicInfo *)music;

- (void)play;

- (void)pause;


@end
