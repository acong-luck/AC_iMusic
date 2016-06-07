//
//  MusicManager.h
//  iMusic
//
//  Created by FM-13 on 16/6/6.
//  Copyright © 2016年 cong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MusicInfo.h"
#import "Single.h"

typedef enum{
    SingleCycle,//单曲循环
    RandomPlay,//随机播放
    OrderPlay//顺序播放
}CycleType;


@interface MusicManager : NSObject

singleton_interface(MusicManager)

@property (strong, nonatomic) MusicInfo *currentMusic;
@property (strong, nonatomic) NSMutableArray *allMusicArr;
@property (assign, nonatomic) CycleType cycleType;

- (MusicInfo *)nextMusicInfo;

- (MusicInfo *)upMusicInfo;

@end
