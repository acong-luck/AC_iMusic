//
//  HomeViewController.m
//  iMusic
//
//  Created by FM-13 on 16/6/6.
//  Copyright © 2016年 cong. All rights reserved.
//

#import "HomeViewController.h"
#import "PlayDetaiViewController.h"

#import "MusicInfo.h"
#import "MusicManager.h"
#import "MusicPlayTool.h"
#import "PlayerTooBarView.h"

@interface HomeViewController ()<UITableViewDataSource, UITableViewDelegate, PlayerTooBarViewDelegate>

@property (strong, nonatomic) UITableView *listTableView;
@property (strong, nonatomic) PlayerTooBarView *playTooBar;
@property (strong, nonatomic) PlayDetaiViewController *playingCtr;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(upDateUI) name:@"ShouldPrepareToPlay" object:nil];
    
    [self initViews];
}

- (void)upDateUI
{
    self.playTooBar.currentMusic = [MusicManager sharedMusicManager].currentMusic;

    NSInteger index = [[MusicManager sharedMusicManager].allMusicArr indexOfObject:[MusicManager sharedMusicManager].currentMusic];
    [self.listTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
}

- (void)initViews
{
    //歌曲列表
    self.listTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.listTableView.delegate = self;
    self.listTableView.dataSource = self;
    [self.view addSubview:self.listTableView];
    
    [self.listTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 60, 0));
    }];
    
    //底部播放
    self.playTooBar = [[PlayerTooBarView alloc] initWithFrame:CGRectZero];
    self.playTooBar.delegate = self;
    [self.view addSubview:self.playTooBar];
    
    [self.playTooBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.height.mas_equalTo(60);
    }];
    
    
    self.playingCtr = [[PlayDetaiViewController alloc] init];

    //锁屏后 事件
    myAppDel.myRemoteEventBlock = ^(UIEvent *event)
    {
        switch (event.subtype) {
            case UIEventSubtypeRemoteControlPlay:
                [[MusicPlayTool sharedMusicPlayTool] play];
                break;
            case UIEventSubtypeRemoteControlPause:
                [[MusicPlayTool sharedMusicPlayTool] pause];
                break;
            case UIEventSubtypeRemoteControlPreviousTrack:
                [[MusicPlayTool sharedMusicPlayTool] prepareForPlayWithMusic:[[MusicManager sharedMusicManager] upMusicInfo]];
                [[MusicPlayTool sharedMusicPlayTool] play];
                break;
            case UIEventSubtypeRemoteControlNextTrack:
                [[MusicPlayTool sharedMusicPlayTool] prepareForPlayWithMusic:[[MusicManager sharedMusicManager] nextMusicInfo]];
                [[MusicPlayTool sharedMusicPlayTool] play];
                break;
                
            default:
                break;
        }
    };
}

#pragma UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[MusicManager sharedMusicManager] allMusicArr].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    MusicInfo *mode = [[MusicManager sharedMusicManager] allMusicArr][indexPath.row];
    cell.textLabel.text = mode.musicName;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MusicInfo *mode = [[MusicManager sharedMusicManager] allMusicArr][indexPath.row];
    [MusicManager sharedMusicManager].currentMusic = mode;
    MusicPlayTool *playTool =[MusicPlayTool sharedMusicPlayTool];
    [playTool prepareForPlayWithMusic:[MusicManager sharedMusicManager].currentMusic];
    [playTool play];
}

#pragma playTooBar delegate
- (void)playerTooBarBtnClickActionWithType:(BtnType)btnType
{
    switch (btnType) {
        case BtnTypeTap:
            [self.playingCtr showCtr];
            break;
        case BtnTypePlay:
            [[MusicPlayTool sharedMusicPlayTool] play];
            break;
        case BtntypePause:
            [[MusicPlayTool sharedMusicPlayTool] pause];
            break;
        case BtnTypeList:
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
