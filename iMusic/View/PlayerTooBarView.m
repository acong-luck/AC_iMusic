//
//  PlayerTooBarView.m
//  Music_for_Acong
//
//  Created by FM-13 on 16/1/13.
//  Copyright © 2016年 cong. All rights reserved.
//

#import "PlayerTooBarView.h"
#import "CircleProgressView.h"
#import "MusicPlayTool.h"

@interface PlayerTooBarView()

@property (strong, nonatomic) UIImageView *musicInc;
@property (strong, nonatomic) UILabel *musicName;
@property (strong, nonatomic) UILabel *songer;
@property (strong, nonatomic) UIButton *musicListButton;
@property (strong, nonatomic) UIButton *playButton;

@property (strong, nonatomic) CircleProgressView *circleView;

/**
 *  定时器
 */
@property (nonatomic, strong) CADisplayLink *link;
@end

@implementation PlayerTooBarView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)awakeFromNib
{
    [self initViews];
    
    [self.link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
        
        [self.link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    }
    return self;
}

-(void)dealloc
{
    [self.link invalidate];
    [self.link removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)startPlay
{
    self.link.paused = NO;
    self.playButton.selected = YES;
}

- (void)startPause
{
    self.link.paused = YES;
    self.playButton.selected = NO;
}

- (void)initViews
{
    self.backgroundColor = myColor(247, 247, 247, 1);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startPlay) name:@"ShouldPlay" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startPause) name:@"ShouldPause" object:nil];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self addGestureRecognizer:tap];
    
    self.musicInc = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.musicInc.backgroundColor = [UIColor clearColor];
    [self addSubview:self.musicInc];
    [self.musicInc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(10);
        make.top.equalTo(self).with.offset(10);
        make.bottom.equalTo(self).with.offset(-10);
        make.width.equalTo(self.musicInc.mas_height);
    }];
    self.musicInc.layer.cornerRadius = 40/2;
    self.musicInc.layer.masksToBounds = YES;
    
    
    self.musicName = [[UILabel alloc] initWithFrame:CGRectZero];
    self.musicName.backgroundColor = [UIColor clearColor];
    self.musicName.textColor = [UIColor darkTextColor];
    self.musicName.font = [UIFont systemFontOfSize:15];
    [self addSubview:self.musicName];
    
    self.songer = [[UILabel alloc] initWithFrame:CGRectZero];
    self.songer.backgroundColor = [UIColor clearColor];
    self.songer.textColor = [UIColor grayColor];
    self.songer.font = [UIFont systemFontOfSize:12];
    [self addSubview:self.songer];
    
    
    
    
    self.musicListButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.musicListButton setImage:[UIImage imageNamed:@"miniplayer_btn_playlist_highlight"] forState:UIControlStateNormal];
    [self.musicListButton setImage:[UIImage imageNamed:@"miniplayer_btn_playlist_normal"] forState:UIControlStateHighlighted];
    
    self.musicListButton.backgroundColor = [UIColor clearColor];
    [self.musicListButton addTarget:self action:@selector(listAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.musicListButton];
    
    
    [self.musicListButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(10);
        make.right.equalTo(self).with.offset(-10);
        make.bottom.equalTo(self).with.offset(-10);
        make.width.equalTo(self.musicListButton.mas_height);
    }];
    
    self.circleView = [[CircleProgressView alloc] initWithFrame:CGRectZero];
    self.circleView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.circleView];
    
    [self.circleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(10);
        make.height.equalTo(self.musicListButton.mas_height);
        make.width.equalTo(self.musicListButton.mas_width);
        make.right.equalTo(self.musicListButton.mas_left).with.offset(-10);
    }];
    
    
    self.playButton = [[UIButton alloc] initWithFrame:CGRectZero];
    self.playButton.backgroundColor = [UIColor clearColor];
    [self.playButton addTarget:self action:@selector(playAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.playButton setImage:[UIImage imageNamed:@"miniplayer_btn_play_normal"] forState:UIControlStateNormal];
    [self.playButton setImage:[UIImage imageNamed:@"miniplayer_btn_pause_normal"] forState:UIControlStateSelected];
    [self.circleView addSubview:self.playButton];
    [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.circleView).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self.musicName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.musicInc);
        make.left.equalTo(self.musicInc.mas_right).with.offset(10);
        make.right.equalTo(self.playButton.mas_left).with.offset(-10);
    }];
    
    [self.songer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.musicName.mas_bottom);
        make.left.equalTo(self.musicName);
        make.height.equalTo(self.musicName);
        make.bottom.equalTo(self.musicInc);
        make.width.equalTo(self.musicName);
    }];
}


- (void)tapAction
{
    [self sendActionBydelegate:BtnTypeTap];
}

- (void)playAction:(UIButton *)button
{
    button.selected = !button.selected;
    if (button.selected) {
        self.link.paused = NO;
        [self sendActionBydelegate:BtnTypePlay];
        
    }else{
        self.link.paused = YES;
        [self sendActionBydelegate:BtntypePause];
    }
    
}

- (void)listAction
{
    [self sendActionBydelegate:BtnTypeList];
}

- (CADisplayLink *)link
{
    if (_link == nil) {
        _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(upadte)];
    }
    return _link;
}

- (void)sendActionBydelegate:(BtnType)type
{
    if (_delegate && [_delegate respondsToSelector:@selector(playerTooBarBtnClickActionWithType:)]) {
        [_delegate playerTooBarBtnClickActionWithType:type];
    }
}

#pragma mark 定时器操作方法
-(void)upadte
{
    CGFloat angle = M_PI_4 / 60;
    self.musicInc.transform = CGAffineTransformRotate(self.musicInc.transform, angle);
    MusicPlayTool *playTool =[MusicPlayTool sharedMusicPlayTool];
    self.circleView.progressValue = (CGFloat)playTool.player.currentTime/(CGFloat)playTool.player.duration;
    [self.circleView setNeedsDisplay];
    
    self.playButton.selected = playTool.player.isPlaying;
}

- (void)setCurrentMusic:(MusicInfo *)currentMusic
{
    _currentMusic = currentMusic;
    
    self.musicName.text = _currentMusic.musicName;
    self.songer.text = _currentMusic.songer;
    self.musicInc.image = [UIImage imageNamed:@"89382494.jpg"];
}


@end
