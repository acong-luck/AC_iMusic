//
//  PlayerTooBarView.h
//  Music_for_Acong
//
//  Created by FM-13 on 16/1/13.
//  Copyright © 2016年 cong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MusicInfo.h"

typedef enum{
    BtnTypeTap,
    BtnTypePlay,
    BtntypePause,
    BtnTypeList
}BtnType;

@protocol PlayerTooBarViewDelegate <NSObject>

- (void)playerTooBarBtnClickActionWithType:(BtnType)btnType;

@end

@interface PlayerTooBarView : UIView

@property (strong, nonatomic) MusicInfo *currentMusic;

@property (nonatomic, weak) id<PlayerTooBarViewDelegate> delegate;

@end
