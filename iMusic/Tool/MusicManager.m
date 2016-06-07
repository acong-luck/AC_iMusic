//
//  MusicManager.m
//  iMusic
//
//  Created by FM-13 on 16/6/6.
//  Copyright © 2016年 cong. All rights reserved.
//

#import "MusicManager.h"

@implementation MusicManager

singleton_implementation(MusicManager);

-(instancetype)init
{
    self = [super init];
    if (self) {
        self.allMusicArr = [NSMutableArray array];
        self.cycleType = OrderPlay;
        NSArray *tempArr = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"songsInfo" ofType:@"plist"]];
        for (int i = 0; i<tempArr.count; i++) {
            NSDictionary *dic = tempArr[i];
            MusicInfo *model = [[MusicInfo alloc] init];
            model.musicName = dic[@"name"];
            model.musicPath = dic[@"filename"];
            model.songer = dic[@"songer"];
            model.icon = dic[@"icon"];
            model.lrc = dic[@"lrc"];
            [self.allMusicArr addObject:model];
        }
        if (self.allMusicArr.count>0) {
            self.currentMusic = self.allMusicArr[0];
        }
    }
    
    return self;
}

- (MusicInfo *)upMusicInfo
{
    switch (self.cycleType) {
        case SingleCycle:
            return self.currentMusic;
            break;
        case RandomPlay:
            self.currentMusic = self.allMusicArr[arc4random()%self.allMusicArr.count];
            break;
        case OrderPlay:{
            NSInteger index = [self.allMusicArr indexOfObject:self.currentMusic];
            if (index == 0) {
                index = self.allMusicArr.count - 1;
            }else{
                index--;
            }
            self.currentMusic = self.allMusicArr[index];
        }
            break;
            
        default:
            break;
    }
    return self.currentMusic;
}

- (MusicInfo *)nextMusicInfo
{
    switch (self.cycleType) {
        case SingleCycle:
            return self.currentMusic;
            break;
        case RandomPlay:
            self.currentMusic = self.allMusicArr[arc4random()%self.allMusicArr.count];
            break;
        case OrderPlay:{
            NSInteger index = [self.allMusicArr indexOfObject:self.currentMusic];
            if (index == self.allMusicArr.count - 1) {
                index = 0;
            }else{
                index++;
            }
            self.currentMusic = self.allMusicArr[index];
        }
            break;
            
        default:
            break;
    }
    return self.currentMusic;
}


@end
