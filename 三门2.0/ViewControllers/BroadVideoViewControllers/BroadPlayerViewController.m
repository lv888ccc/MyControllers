//
//  BroadPlayerViewController.m
//  SanMen
//
//  Created by lcc on 13-12-23.
//  Copyright (c) 2013年 lcc. All rights reserved.
//

#import "BroadPlayerViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AudioToolbox/AudioToolbox.h>
#import "CCClientRequest.h"
#import "OrderObject.h"
#import "DataCompareObject.h"

#define SelectedViewTag 10
#define TimeLabelTag 11
#define NameLabelTag 12

#define VlumeNotification @"vlumeNotification"

@interface BroadPlayerViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    MPMoviePlayerController *broadPlayer;
    MPMusicPlayerController *mpc;//用于控制系统音量
    BOOL isPlaying;
    
    NSTimer *timer;
}

@property (strong, nonatomic) IBOutlet UITableView *ui_myTableView;
@property (strong, nonatomic) IBOutlet UIButton *ui_playBtn;
@property (strong, nonatomic) NSMutableArray *tableData;
@property (strong, nonatomic) IBOutlet UISlider *ui_volumnSliderView;
@property (strong, nonatomic) CCClientRequest *myRequest;
@property (strong, nonatomic) IBOutlet UILabel *ui_timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *ui_broNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *ui_pNameLabel;

@end

@implementation BroadPlayerViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:VlumeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackStateDidChangeNotification object:nil];
    
    self.myRequest.c_delegate = nil;
    self.myRequest = nil;
    
    self.ui_myTableView.delegate = nil;
    self.ui_myTableView.dataSource = nil;
    self.ui_myTableView = nil;
    
    self.tableData = nil;
    
    self.ui_volumnSliderView = nil;
    self.ui_playBtn = nil;
    
    broadPlayer = nil;
    mpc = nil;
    
    self.ui_pNameLabel = nil;
    self.ui_broNameLabel = nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        AudioSessionInitialize(NULL, NULL, NULL, NULL);
        AudioSessionSetActive(true);
        AudioSessionAddPropertyListener(kAudioSessionProperty_CurrentHardwareOutputVolume ,
                                        volumeListenerCallback,
                                        (__bridge void *)(self));
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(msg_MPMoviePlayerPlaybackStateDidChangeNotification:)
                                                     name:MPMoviePlayerPlaybackStateDidChangeNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(msg_moviePlayerLoadStateChanged:)
                                                     name:MPMoviePlayerLoadStateDidChangeNotification
                                                   object:nil];
        
        self.myRequest = [[CCClientRequest alloc] init];
        self.myRequest.c_delegate = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(msg_vlumeNotification:)
                                                 name:VlumeNotification
                                               object:nil];
    
    //音量
    [self.ui_volumnSliderView setMinimumTrackImage:[[UIImage imageNamed:@"volume_blue"] stretchableImageWithLeftCapWidth:5 topCapHeight:0] forState:UIControlStateNormal];
    [self.ui_volumnSliderView setMaximumTrackImage:[UIImage imageNamed:@"volume_gray"] forState:UIControlStateNormal];
    
    mpc = [MPMusicPlayerController applicationMusicPlayer];
    self.ui_volumnSliderView.value = mpc.volume;
    //end
    
    //节目单
    self.tableData = [[NSMutableArray alloc] init];
    self.ui_myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.ui_myTableView.backgroundColor = [UIColor clearColor];
    //end
    
    //播放器
    broadPlayer = [[MPMoviePlayerController alloc] init];
    //end
    
    //网络数据请求
    [self.myRequest broadOrder];
    //end
    
    timer = [NSTimer scheduledTimerWithTimeInterval:60
                                             target:self
                                           selector:@selector(compareTime)
                                           userInfo:nil
                                            repeats:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [broadPlayer pause];
    [broadPlayer stop];
    broadPlayer = nil;
    [timer invalidate];
    timer = nil;
    
}

#pragma mark -
#pragma mark - custom method
//声音回调
void volumeListenerCallback (void *inClientData,AudioSessionPropertyID inID, UInt32 inDataSize,const void *inData)
{
    const float *volumePointer = inData;
    float volume = *volumePointer;
    [[NSNotificationCenter defaultCenter] postNotificationName:VlumeNotification object:[NSNumber numberWithFloat:volume]];
}

- (void) compareTime
{
    self.ui_timeLabel.text = [DataCompareObject getCurrentTimeWithFormate:@"HH:mm"];
    
    for (int i = 0; i < [self.tableData count]; i ++)
    {
        OrderObject *tmpObj = [self.tableData objectAtIndex:i];
        
        NSInteger result = [DataCompareObject compareOneDay:[DataCompareObject getCurrentTimeWithFormate:@"HH:mm"] withAnotherDay:tmpObj.o_endTime];
        
        if (result == -1)
        {
            [self.tableData removeObjectsInRange:NSMakeRange(0, i)];
            [self.ui_myTableView reloadData];
            
            OrderObject *tmpObj = [self.tableData objectAtIndex:0];
            self.ui_broNameLabel.text = tmpObj.o_pTitle;
            self.ui_pNameLabel.text = tmpObj.o_title;
            
            break;
        }
    }
}

#pragma mark -
#pragma mark - 控件事件
- (IBAction)backTapped:(id)sender
{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app.nav popViewController];
}

- (IBAction)changeTapped:(id)sender
{
    mpc.volume = self.ui_volumnSliderView.value;
}

- (IBAction)playTapped:(id)sender
{
    if (isPlaying == YES)
    {
        [self.ui_playBtn setImage:[UIImage imageNamed:@"broad_play.png"] forState:UIControlStateNormal];
        [broadPlayer pause];
    }
    else
    {
        [self.ui_playBtn setImage:[UIImage imageNamed:@"broad_pause.png"] forState:UIControlStateNormal];
        [broadPlayer play];
    }
    
    isPlaying = !isPlaying;
}

#pragma mark -
#pragma mark - system delegate tableView
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count = [self.tableData count];
    return count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        //选中
        UIImageView *selectedView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"program_selected_bg"]];
        [cell.contentView addSubview:selectedView];
        selectedView.tag = SelectedViewTag;
        selectedView.frame = (CGRect){0,0,248,30};
        
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //时间
        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(34, 0, 80, 30)];
        timeLabel.tag = TimeLabelTag;
        timeLabel.backgroundColor = [UIColor clearColor];
        timeLabel.font = [UIFont systemFontOfSize:13];
        [cell.contentView addSubview:timeLabel];
        
        //节目名称
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(152, 0, 100, 30)];
        nameLabel.tag = NameLabelTag;
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.font = [UIFont systemFontOfSize:14];
        [cell.contentView addSubview:nameLabel];
    }
    
    UIImageView *selectedView = (UIImageView *)[cell.contentView viewWithTag:SelectedViewTag];
    UILabel *timeLabel = (UILabel *)[cell.contentView viewWithTag:TimeLabelTag];
    UILabel *nameLabel = (UILabel *)[cell.contentView viewWithTag:NameLabelTag];
    
    if (indexPath.row == 0)
    {
        timeLabel.textColor = [UIColor colorWithRed:151.0f/255.0f green:202.0f/255.0f blue:247.0f/255.0f alpha:1.0];
        nameLabel.textColor = [UIColor whiteColor];
        selectedView.hidden = NO;
    }
    else
    {
        timeLabel.textColor = [UIColor grayColor];
        nameLabel.textColor = [UIColor grayColor];
        selectedView.hidden = YES;
    }
    
    OrderObject *tmpObj = [self.tableData objectAtIndex: indexPath.row];
    
    timeLabel.text = [NSString stringWithFormat:@"%@-%@",tmpObj.o_beginTime,tmpObj.o_endTime];
    nameLabel.text = tmpObj.o_title;
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}

//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
//{
//    return YES;
//}

#pragma mark -
#pragma mark - 消息处理函数
- (void) msg_vlumeNotification:(NSNotification *)notification
{
    if (self.ui_volumnSliderView.state == 0)
    {
        self.ui_volumnSliderView.value = [notification.object floatValue];
    }
}

- (void) msg_MPMoviePlayerPlaybackStateDidChangeNotification:(NSNotification*)notification
{
    if (broadPlayer.playbackState == MPMoviePlaybackStatePlaying|broadPlayer.playbackState == MPMoviePlaybackStateSeekingForward|broadPlayer.playbackState == MPMoviePlaybackStateSeekingBackward)
    {
        
        [self.ui_playBtn setImage:[UIImage imageNamed:@"broad_pause"] forState:UIControlStateNormal];
    }
    else
    {
        [self.ui_playBtn setImage:[UIImage imageNamed:@"broad_play"] forState:UIControlStateNormal];
    }
}

- (void) msg_moviePlayerLoadStateChanged:(NSNotification*)notification
{
    if (broadPlayer.playbackState == MPMoviePlaybackStatePlaying|broadPlayer.playbackState == MPMoviePlaybackStateSeekingForward|broadPlayer.playbackState == MPMoviePlaybackStateSeekingBackward)
    {
        
        [self.ui_playBtn setImage:[UIImage imageNamed:@"broad_pause"] forState:UIControlStateNormal];
    }
    else
    {
        [self.ui_playBtn setImage:[UIImage imageNamed:@"broad_play"] forState:UIControlStateNormal];
    }
}

#pragma mark -
#pragma mark - 网络数据返回
//节目清单数据返回
- (void) broadOrderCallBack:(id) objectData
{
    self.tableData = objectData;
    [self compareTime];
    [self.ui_myTableView reloadData];
    
    if ([self.tableData count] > 0)
    {
        OrderObject *tmpObj = [self.tableData objectAtIndex:0];
        broadPlayer.contentURL = [NSURL URLWithString:tmpObj.o_videoUrl];
        [broadPlayer prepareToPlay];
        [broadPlayer play];
        isPlaying = YES;
    }
}

@end
