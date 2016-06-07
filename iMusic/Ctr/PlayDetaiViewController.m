//
//  PlayDetaiViewController.m
//  Music_for_Acong
//
//  Created by FM-13 on 16/1/14.
//  Copyright © 2016年 cong. All rights reserved.
//

#import "PlayDetaiViewController.h"
#import "MusicPlayTool.h"
#import "MusicManager.h"
#import "MusicInfo.h"

#import <MediaPlayer/MediaPlayer.h>

@interface PlayDetaiViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *currentTime;
@property (weak, nonatomic) IBOutlet UILabel *allTime;
@property (weak, nonatomic) IBOutlet UISlider *progressSlider;

@property (weak, nonatomic) IBOutlet UIView *baseView;
@property (strong, nonatomic) UITableView *lrcTableView;
@property (weak, nonatomic) IBOutlet UIButton *playButton;

@property (strong, nonatomic) NSTimer *timer;

@property (strong, nonatomic) NSMutableDictionary *lrcDic;
@property (strong, nonatomic) NSMutableArray *lrcTimeArr;
@property (assign, nonatomic) NSInteger currentIndex;


@end

@implementation PlayDetaiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initViews];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(upDateMusicInfo) name:@"ShouldPrepareToPlay" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startPlay) name:@"ShouldPlay" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startPause) name:@"ShouldPause" object:nil];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(upDateUI) userInfo:nil repeats:YES];
    
    self.lrcDic = [NSMutableDictionary dictionary];
    self.lrcTimeArr = [NSMutableArray array];
    self.currentIndex = 0;
}


- (void)startPlay
{
    self.playButton.selected = NO;
}

- (void)startPause
{
    self.playButton.selected = YES;
}

- (IBAction)backAction:(UIButton *)sender {
    [self hideCtr];
}

- (void)initViews
{
    self.view.backgroundColor = myColor(71, 71, 71, 1);
    [self.progressSlider setThumbImage:[UIImage imageNamed:@"mvplayer_progress_thumb_mini"] forState:UIControlStateNormal];
    [self.progressSlider setMaximumTrackImage:[UIImage imageNamed:@"mvplayer_progress_bg_mini"] forState:UIControlStateNormal];
    [self.progressSlider setMinimumTrackImage:[UIImage imageNamed:@"mvplayer_progress_played_mini"] forState:UIControlStateNormal];
    
    //歌词view
    self.lrcTableView = [[UITableView alloc] initWithFrame:CGRectZero];
    [self.baseView addSubview:self.lrcTableView];
    self.lrcTableView.backgroundColor = [UIColor clearColor];
    self.lrcTableView.separatorColor = [UIColor clearColor];
    self.lrcTableView.delegate = self;
    self.lrcTableView.dataSource = self;
    [self.lrcTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.baseView).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}


- (void)upDateUI
{
    MusicPlayTool *playTool = [MusicPlayTool sharedMusicPlayTool];
    self.currentTime.text = [NSString stringWithFormat:@"%02d:%02d",(int)playTool.player.currentTime/60,(int)playTool.player.currentTime%60];
    self.progressSlider.value = playTool.player.currentTime;

    for (int i = 0; i < self.lrcTimeArr.count; i++) {
        NSString *timeStr = self.lrcTimeArr[i];
        if ([timeStr integerValue] == (NSInteger)playTool.player.currentTime) {
            _currentIndex = i;
            [self resetLockInfo];
            [_lrcTableView reloadData];
            [_lrcTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
            return;
        }
    }
}

- (void)resetLockInfo
{
    MusicInfo *currentModel = [MusicManager sharedMusicManager].currentMusic;
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    //设置专辑名称
    info[MPMediaItemPropertyAlbumTitle] = @"网络热曲";
    //设置歌曲名
    info[MPMediaItemPropertyTitle] = currentModel.musicName;
    //设置歌手
    info[MPMediaItemPropertyArtist] = currentModel.songer;
    //设置专辑图片
    //UIImage *image = [UIImage imageNamed:music.icon];
    UIImage *image = [self createShareImage:[self.lrcDic objectForKey:self.lrcTimeArr[_currentIndex]] name:@"song_400" number:nil grade:nil];
    MPMediaItemArtwork *artwork = [[MPMediaItemArtwork alloc] initWithImage:image];
    info[MPMediaItemPropertyArtwork] = artwork;
    //设置歌曲时间
    info[MPMediaItemPropertyPlaybackDuration] = @([MusicPlayTool sharedMusicPlayTool].player.duration);
    info[MPNowPlayingInfoPropertyElapsedPlaybackTime] = @([MusicPlayTool sharedMusicPlayTool].player.currentTime);
    [MPNowPlayingInfoCenter defaultCenter].nowPlayingInfo = info;
    
}

- ( UIImage *)createShareImage:( NSString *)str name:( NSString *)name number:( NSString *)number grade:( NSString *)grade
{
    
    UIImage *image = [UIImage imageNamed:name];
    CGSize size= CGSizeMake (image.size.width, image.size.height); // 画布大小
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    [image drawAtPoint:CGPointMake(0, 0)];
    
    // 获得一个位图图形上下文
    CGContextRef context= UIGraphicsGetCurrentContext ();
    CGContextDrawPath(context, kCGPathStroke );
    CGSize needSize = CGSizeMake(1000,20);
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:16], NSForegroundColorAttributeName:[UIColor grayColor]};
    CGSize labelsize = [str boundingRectWithSize:needSize options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    CGFloat width = MIN(labelsize.width, image.size.width);
    [str drawInRect:CGRectMake((image.size.width-width)/2, image.size.height - 40, width, 20) withAttributes:attribute];
    
    // 返回绘制的新图形
    UIImage *newImage= UIGraphicsGetImageFromCurrentImageContext ();
    UIGraphicsEndImageContext ();
    
    return newImage;
}


- (IBAction)playAction:(UIButton *)sender {

    if (sender.selected) {
        [[MusicPlayTool sharedMusicPlayTool] play];
    }else{
        [[MusicPlayTool sharedMusicPlayTool] pause];
    }
}

- (IBAction)playUpMusic:(UIButton *)sender {
    [[MusicPlayTool sharedMusicPlayTool] prepareForPlayWithMusic:[[MusicManager sharedMusicManager] upMusicInfo]];
    [[MusicPlayTool sharedMusicPlayTool] play];
}

- (IBAction)playNextMusic:(UIButton *)sender {
    [[MusicPlayTool sharedMusicPlayTool] prepareForPlayWithMusic:[[MusicManager sharedMusicManager] nextMusicInfo]];
    [[MusicPlayTool sharedMusicPlayTool] play];
}


- (IBAction)sliderTouchDown:(UISlider *)sender {
    [[MusicPlayTool sharedMusicPlayTool] pause];
}

- (IBAction)sliderTouchUpInside:(UISlider *)sender {
    //[[MusicPlayTool sharedMusicPlayTool] play];
}

- (IBAction)sliderTouchUpOutside:(UISlider *)sender {
    //[[MusicPlayTool sharedMusicPlayTool] play];
}

- (IBAction)sliderValueChanged:(UISlider *)sender {
    [MusicPlayTool sharedMusicPlayTool].player.currentTime = sender.value;
    [[MusicPlayTool sharedMusicPlayTool] play];
}


#pragma mark tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.lrcTimeArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    if (indexPath.row == _currentIndex) {
        cell.textLabel.textColor = [UIColor redColor];
    }else{
        cell.textLabel.textColor = [UIColor whiteColor];
        
    }
    cell.textLabel.text = [self.lrcDic objectForKey:self.lrcTimeArr[indexPath.row]];

    return cell;
}

- (void)upDateMusicInfo
{
    MusicPlayTool *playTool =[MusicPlayTool sharedMusicPlayTool];
    self.currentTime.text = [NSString stringWithFormat:@"%02d:%02d",(int)playTool.player.currentTime/60,(int)playTool.player.currentTime%60];
    self.allTime.text = [NSString stringWithFormat:@"%02d:%02d",(int)playTool.player.duration/60,(int)playTool.player.duration%60];
    self.progressSlider.minimumValue = 0;
    self.progressSlider.maximumValue = playTool.player.duration;
    self.progressSlider.value = playTool.player.currentTime;
    
    self.playButton.selected = !playTool.player.isPlaying;
    
    //解析歌词
    MusicInfo *currentModel = [MusicManager sharedMusicManager].currentMusic;
    [self.lrcTimeArr removeAllObjects];
    [self.lrcDic removeAllObjects];
    if (currentModel.lrc.length>0) {
        NSString *str = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:currentModel.lrc ofType:nil] encoding:NSUTF8StringEncoding error:nil];
        NSArray *allRowArr = [str componentsSeparatedByString:@"\n"];
        for (int i = 0; i < allRowArr.count; i++) {
            NSString *linStr = [allRowArr objectAtIndex:i];
            NSArray *lineArray = [linStr componentsSeparatedByString:@"]"];
            if ([lineArray[0] length] > 4) {
                NSString *str1 = [linStr substringWithRange:NSMakeRange(3, 1)];
                NSString *str2 = [linStr substringWithRange:NSMakeRange(6, 1)];
                NSString *str3 = [linStr substringWithRange:NSMakeRange(1, 1)];
                if (([str1 isEqualToString:@":"] && [str2 isEqualToString:@"." ]) || ([str1 isEqualToString:@":"]&&[str2 isEqualToString:@"]"]&&[str3 isEqualToString:@"0"])) {
                    NSString *lrcStr = [lineArray objectAtIndex:1];
                    
                    NSString *timeStr = [[lineArray objectAtIndex:0] substringWithRange:NSMakeRange(1, 5)];//分割区间求歌词时间
                    NSArray *array = [timeStr componentsSeparatedByString:@":"];//把时间转换成秒
                    NSUInteger currentTime = [array[0] intValue] * 60 + [array[1] intValue];
                    NSString *str = [NSString stringWithFormat:@"%ld",currentTime];
                    
                    //把时间 和 歌词 加入词典
                    [self.lrcDic setObject:lrcStr forKey:str];
                    [self.lrcTimeArr addObject:str];//timeArray的count就是行数
                }
                
            }
        }
    }
    
    [self.lrcTableView reloadData];
}


#pragma mark  showCtr
- (void)showCtr
{
    UIWindow *mainWindow = [UIApplication sharedApplication].keyWindow;
    mainWindow.userInteractionEnabled = NO;
    
    self.view.frame = mainWindow.bounds;
    
    self.view.hidden = NO;
    
    [mainWindow addSubview:self.view];
    
    self.view.top = self.view.height;
    
    [self upDateMusicInfo];
    
    [UIView animateWithDuration:.25 animations:^{
        self.view.top = 0;
    } completion:^(BOOL finished) {
        mainWindow.userInteractionEnabled = YES;
    }];
}


#pragma mark hideCtr
- (void)hideCtr
{
    UIWindow *mainWindow = [UIApplication sharedApplication].keyWindow;
    mainWindow.userInteractionEnabled = NO;
    
    self.view.frame = mainWindow.bounds;
    
    [mainWindow addSubview:self.view];
    
    
    [UIView animateWithDuration:.25 animations:^{
        self.view.top = self.view.height;
    } completion:^(BOOL finished) {
        self.view.hidden = YES;
        mainWindow.userInteractionEnabled = YES;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
