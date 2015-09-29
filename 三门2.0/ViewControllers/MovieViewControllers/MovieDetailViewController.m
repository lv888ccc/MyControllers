//
//  MovieDetailViewController.m
//  SanMen
//
//  Created by lcc on 14-2-11.
//  Copyright (c) 2014年 lcc. All rights reserved.
//

#import "MovieDetailViewController.h"
#import "DJQRateView.h"
#import "UIImageView+WebCache.h"
#import "DataCompareObject.h"
#import <MediaPlayer/MediaPlayer.h>
#import "CCClientRequest.h"
#import "RTLabel.h"

@interface MovieDetailViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet DJQRateView *ui_starView;
@property (strong, nonatomic) IBOutlet UIImageView *ui_movieImgView;
@property (strong, nonatomic) IBOutlet UIScrollView *ui_scrollView;
@property (strong, nonatomic) IBOutlet UIView *ui_detailView;
@property (strong, nonatomic) IBOutlet UIButton *ui_markBtn;
@property (strong, nonatomic) IBOutlet UIScrollView *ui_tableScrollView;
@property (strong, nonatomic) IBOutlet UILabel *ui_movieNameLabel;
@property (strong, nonatomic) NSMutableDictionary *tableData;
@property (strong, nonatomic) IBOutlet UILabel *ui_sliderLabel;
@property (strong, nonatomic) IBOutlet UILabel *ui_starLabel;
@property (strong, nonatomic) IBOutlet UILabel *ui_directorLabel;
@property (strong, nonatomic) IBOutlet UILabel *ui_actorLabel;
@property (strong, nonatomic) IBOutlet UILabel *ui_timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *ui_dataLabel;
@property (strong, nonatomic) IBOutlet UILabel *ui_bMovieNameLabel;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *ui_activity;
@property (strong, nonatomic) IBOutlet UIScrollView *ui_buttomScrollView;
@property (strong, nonatomic) IBOutlet UIButton *ui_playBtn;

@property (strong, nonatomic) IBOutlet UILabel *ui_b_directorLabel;
@property (strong, nonatomic) IBOutlet UILabel *ui_b_actorsLabel;
@property (strong, nonatomic) IBOutlet UILabel *ui_b_placeLabel;
@property (strong, nonatomic) IBOutlet UILabel *ui_b_typeLabel;
@property (strong, nonatomic) IBOutlet UILabel *ui_b_timeLengthLabel;
@property (strong, nonatomic) IBOutlet UILabel *ui_b_showTimeLabel;


@property (strong, nonatomic) RTLabel *ui_contentLabel;
@property (strong, nonatomic) CCClientRequest *myRequest;

@property (strong, nonatomic) NSString *videoId;

@end

@implementation MovieDetailViewController

- (void)dealloc
{
    self.ui_detailView = nil;
    self.ui_movieImgView = nil;
    self.ui_scrollView = nil;
    self.ui_detailView = nil;
    self.ui_markBtn = nil;
    self.ui_tableScrollView = nil;
    self.tableData = nil;
    self.ui_sliderLabel = nil;
    self.movieObj = nil;
    self.ui_movieNameLabel = nil;
    self.ui_starLabel = nil;
    self.ui_directorLabel = nil;
    self.ui_actorLabel = nil;
    self.ui_timeLabel = nil;
    self.ui_dataLabel = nil;
    
    self.ui_b_directorLabel = nil;
    self.ui_b_actorsLabel = nil;
    self.ui_b_placeLabel = nil;
    self.ui_b_typeLabel = nil;
    self.ui_b_timeLengthLabel = nil;
    self.ui_b_showTimeLabel = nil;
    
    self.myRequest.c_delegate = nil;
    self.myRequest = nil;
    self.ui_buttomScrollView = nil;
    self.ui_contentLabel = nil;
    self.ui_playBtn = nil;
    
    self.videoId = nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.myRequest = [[CCClientRequest alloc] init];
        self.myRequest.c_delegate = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //网络请求
    [self.myRequest movieDetailListDetailInfoWithMId:self.movieObj.m_id];
    [self.ui_activity startAnimating];
    //end
    
    [self initControllers];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [StatusBarObject setStatusBarStyleWithIndex:0];
    
    if (!([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0))
    {
        [self performSelector:@selector(freshViewFrame) withObject:nil afterDelay:0.1];
    }
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [StatusBarObject setStatusBarStyleWithIndex:1];
}

#pragma mark -
#pragma mark - custom method
- (void) initControllers
{
    CGSize cSize = self.ui_buttomScrollView.contentSize;
    cSize.height = 301;
    self.ui_buttomScrollView.contentSize = cSize;
    self.ui_buttomScrollView.showsVerticalScrollIndicator = NO;
    
    self.ui_movieNameLabel.text = self.movieObj.m_movieName;
    self.ui_bMovieNameLabel.text = self.movieObj.m_movieName;
    self.ui_starView.rate = [self.movieObj.m_starCount floatValue];
    self.ui_starLabel.text = [NSString stringWithFormat:@"%@",self.movieObj.m_starCount];
    self.ui_dataLabel.text = [NSString stringWithFormat:@"今天%@",[DataCompareObject getCurrentTimeWithFormate:@"MM月dd日"]];
    [self.ui_movieImgView setImageWithURL:[NSURL URLWithString:self.movieObj.m_imgUrl] placeholderImage:[UIImage imageNamed:@"movie_detail_default"]];
    
    CGSize contentSize = self.ui_scrollView.contentSize;
    contentSize.height = 578;
    self.ui_scrollView.contentSize = contentSize;
    self.ui_scrollView.showsVerticalScrollIndicator = NO;
    
    self.ui_tableScrollView.pagingEnabled = YES;
    self.ui_tableScrollView.contentSize = CGSizeMake(288*3, 182);
    self.ui_tableScrollView.showsHorizontalScrollIndicator = NO;
    
    //详情
    CGRect detailRect = self.ui_detailView.frame;
    detailRect.origin.y = viewHeight;
    self.ui_detailView.frame = detailRect;
    [self.view addSubview:self.ui_detailView];
    //end
    
    //遮罩层
    [self.view addSubview:self.ui_markBtn];
    //end
    
    //初始化表数据
    self.tableData = [[NSMutableDictionary alloc] init];
    //end
    
    //日期
    UILabel *timeLabel1 = (UILabel *)[self.ui_scrollView viewWithTag:100];
    timeLabel1.text = [NSString stringWithFormat:@"今天%@",[DataCompareObject getCurrentTimeWithFormate:@"MM月dd日"]];
    //end
    
    self.ui_contentLabel = [[RTLabel alloc] initWithFrame:CGRectMake(9, 244, 303, 56)];
    [self.ui_buttomScrollView addSubview:self.ui_contentLabel];
    self.ui_contentLabel.font = [UIFont systemFontOfSize:15];
    self.ui_contentLabel.alpha = 0.7;
    self.ui_contentLabel.backgroundColor = [UIColor clearColor];
    self.ui_contentLabel.textColor = [UIColor blackColor];
}

- (void) addTable
{
    CGRect rect = self.ui_tableScrollView.frame;
    
    if (viewHeight > 480)
    {
        rect.size.height = rect.size.height + 88;
        self.ui_tableScrollView.frame = rect;
        CGRect tmpRect = self.ui_activity.frame;
        tmpRect.size.height = tmpRect.size.height + 44;
        self.ui_activity.frame = tmpRect;
    }
    
    for (int i = 0; i < 3; i ++)
    {
        UITableView *tmpTable = [[UITableView alloc] init];
        tmpTable.backgroundColor = [UIColor clearColor];
        [tmpTable setDelegate:self];
        [tmpTable setDataSource:self];
        tmpTable.tag = i + 10;
        tmpTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        tmpTable.frame = (CGRect){i*288,0,rect.size};
        [self.ui_tableScrollView addSubview:tmpTable];
        tmpTable.showsVerticalScrollIndicator = NO;
        
        UIImageView *tmpImgView = [[UIImageView alloc] initWithFrame:CGRectMake(99 + 288*i, 30, 90, 102)];
        tmpImgView.image = [UIImage imageNamed:@"movie_order_no"];
        [self.ui_tableScrollView addSubview:tmpImgView];
        tmpImgView.tag = 20 + i;
        tmpImgView.hidden = YES;
    }
}

//因为分享刷新页面
- (void) freshViewFrame
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect = self.view.frame;
        rect.origin.y = -20;
        rect.size.height = viewHeight;
        self.view.frame = rect;
    }];
}

#pragma mark -
#pragma mark - 控件事件
- (IBAction)backTapped:(id)sender
{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app.nav popViewController];
}

- (IBAction)playTapped:(id)sender
{
    MPMoviePlayerViewController *player = [[MPMoviePlayerViewController alloc] init];
    NSURL *tmpUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",VIDEOPLAYERHTTPURL,self.videoId]];
    player.moviePlayer.contentURL = tmpUrl;
    [player.moviePlayer play];
    [SMApp.nav presentMoviePlayerViewControllerAnimated:player];
}

- (IBAction)detailTapped:(id)sender
{
    [self.view bringSubviewToFront:self.ui_markBtn];
    [self.view bringSubviewToFront:self.ui_detailView];
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect detailRect = self.ui_detailView.frame;
        detailRect.origin.y = viewHeight - detailRect.size.height;
        self.ui_detailView.frame = detailRect;
        self.ui_markBtn.alpha = 0.7;
    }];
}

- (IBAction)cancelTapped:(id)sender
{
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect detailRect = self.ui_detailView.frame;
        detailRect.origin.y = viewHeight;
        self.ui_detailView.frame = detailRect;
        self.ui_markBtn.alpha = 0.0;
    }];
}

- (IBAction)dataTapped:(id)sender
{
    UILabel *timeLabel1 = (UILabel *)[self.ui_scrollView viewWithTag:100];
    timeLabel1.textColor = [UIColor blackColor];
    timeLabel1.text = @"今天";
    UILabel *timeLabel2 = (UILabel *)[self.ui_scrollView viewWithTag:101];
    timeLabel2.textColor = [UIColor blackColor];
    timeLabel2.text = @"明天";
    UILabel *timeLabel3 = (UILabel *)[self.ui_scrollView viewWithTag:102];
    timeLabel3.textColor = [UIColor blackColor];
    timeLabel3.text = @"后天";
    
    UIButton *tmpBtn = (UIButton *)sender;
    UILabel *timeLabel4 = (UILabel *)[self.ui_scrollView viewWithTag:tmpBtn.tag - 100];
    timeLabel4.textColor = [UIColor redColor];
    
    NSDate *tmpDate = [NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"MM月dd日"];
    
    switch (tmpBtn.tag - 100)
    {
        case 100:
            timeLabel4.text = [NSString stringWithFormat:@"今天%@",[DataCompareObject getCurrentTimeWithFormate:@"MM月dd日"]];
            break;
            
        case 101:
            tmpDate = [tmpDate dateByAddingTimeInterval:24 * 60 * 60 *1];
            timeLabel4.text = [NSString stringWithFormat:@"明天%@",[dateformatter stringFromDate:tmpDate]];
            break;

        case 102:
            tmpDate = [tmpDate dateByAddingTimeInterval:24 * 60 * 60 *2];
            timeLabel4.text = [NSString stringWithFormat:@"后天%@",[dateformatter stringFromDate:tmpDate]];
            break;

            
        default:
            break;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        self.ui_sliderLabel.frame = (CGRect){16 + (tmpBtn.tag - 200)*96,self.ui_sliderLabel.frame.origin.y,self.ui_sliderLabel.frame.size};
        self.ui_tableScrollView.contentOffset = (CGPoint){288*(tmpBtn.tag - 200),self.ui_tableScrollView.contentOffset.y};
    }];
}


#pragma mark -
#pragma mark - scroll delegate
- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.tag == 0)
    {
        CGRect rect = self.ui_sliderLabel.frame;
        rect.origin.x = scrollView.contentOffset.x/3.0f + 16;
        self.ui_sliderLabel.frame = rect;
    }
}

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.tag == 0)
    {
        UILabel *timeLabel1 = (UILabel *)[self.ui_scrollView viewWithTag:100];
        timeLabel1.textColor = [UIColor blackColor];
        timeLabel1.text = @"今天";
        UILabel *timeLabel2 = (UILabel *)[self.ui_scrollView viewWithTag:101];
        timeLabel2.textColor = [UIColor blackColor];
        timeLabel2.text = @"明天";
        UILabel *timeLabel3 = (UILabel *)[self.ui_scrollView viewWithTag:102];
        timeLabel3.textColor = [UIColor blackColor];
        timeLabel3.text = @"后天";
        
        //每页宽度
        CGFloat pageWidth = scrollView.frame.size.width;
        //根据当前的坐标与页宽计算当前页码
        int currentPage = floor((scrollView.contentOffset.x - pageWidth/2)/pageWidth)+1;
        UILabel *timeLabel4 = (UILabel *)[self.ui_scrollView viewWithTag:100 + currentPage];
        timeLabel4.textColor = [UIColor redColor];
        
        NSDate *tmpDate = [NSDate date];
        NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"MM月dd日"];
        
        switch (100 + currentPage)
        {
            case 100:
                timeLabel4.text = [NSString stringWithFormat:@"今天%@",[DataCompareObject getCurrentTimeWithFormate:@"MM月dd日"]];
                break;
                
            case 101:
                tmpDate = [tmpDate dateByAddingTimeInterval:24 * 60 * 60 *1];
                timeLabel4.text = [NSString stringWithFormat:@"明天%@",[dateformatter stringFromDate:tmpDate]];
                break;
                
            case 102:
                tmpDate = [tmpDate dateByAddingTimeInterval:24 * 60 * 60 *2];
                timeLabel4.text = [NSString stringWithFormat:@"后天%@",[dateformatter stringFromDate:tmpDate]];
                break;
                
                
            default:
                break;
        }
    }
}

#pragma mark -
#pragma mark - table delegate
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //获取表的具体数据
    NSMutableArray *tmpTableData = [self.tableData objectForKey:[NSString stringWithFormat:@"table%d",tableView.tag]];
    UIImageView *tmpImgView = (UIImageView *)[self.ui_tableScrollView viewWithTag:tableView.tag + 10];
    NSInteger count = [tmpTableData count];
    if (count == 0)
    {
        tmpImgView.hidden = NO;
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    NSMutableArray *tmpTableData = [self.tableData objectForKey:[NSString stringWithFormat:@"table%d",tableView.tag]];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.backgroundColor = [UIColor clearColor];
        
        //时间
        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 0, 80, 35)];
        timeLabel.tag = 10;
        timeLabel.font = [UIFont systemFontOfSize:14];
        [cell.contentView addSubview:timeLabel];
        
        UIImageView *sImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 288, 1)];
        sImgView.backgroundColor = [UIColor grayColor];
        sImgView.alpha = 0.2f;
        [cell.contentView addSubview:sImgView];
        sImgView.hidden = YES;
        sImgView.tag = 11;
        
        UIImageView *dateImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, 15, 15)];
        [cell.contentView addSubview:dateImgView];
        dateImgView.tag = 12;
        
        //视频类型
        UILabel *priviteLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, 88, 35)];
        priviteLabel.tag = 13;
        priviteLabel.textColor = [UIColor lightGrayColor];
        priviteLabel.font = [UIFont systemFontOfSize:15];
        priviteLabel.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:priviteLabel];
        
        //票价
        UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(188, 0, 100, 35)];
        priceLabel.tag = 14;
        priceLabel.textColor = [UIColor redColor];
        priceLabel.font = [UIFont systemFontOfSize:14];
        [cell.contentView addSubview:priceLabel];
        priceLabel.textAlignment = NSTextAlignmentCenter;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    NSDictionary *tmpDic = [tmpTableData objectAtIndex:indexPath.row];
    
    UILabel *timeLabel = (UILabel *)[cell.contentView viewWithTag:10];
    timeLabel.text = [tmpDic objectForKey:@"time"];
    
    UILabel *priviteLabel = (UILabel *)[cell.contentView viewWithTag:13];
    priviteLabel.text = [tmpDic objectForKey:@"type"];
    
    UILabel *priceLabel = (UILabel *)[cell.contentView viewWithTag:14];
    priceLabel.text = [tmpDic objectForKey:@"money"];
    
    UIImageView *sImgView = (UIImageView *)[cell.contentView viewWithTag:11];
    UIImageView *dateImgView = (UIImageView *)[cell.contentView viewWithTag:12];
    
    if (indexPath.row == 0)
    {
        [dateImgView setImage:[UIImage imageNamed:@"movie_daytime"]];
    }
    else
    {
        [dateImgView setImage:[UIImage imageNamed:@""]];
    }
    
    if (indexPath.row > 0)
    {
        if (([DataCompareObject compareOneDay:timeLabel.text withAnotherDay:@"18:00"] == 1 || [DataCompareObject compareOneDay:timeLabel.text withAnotherDay:@"18:00"] == 0) && [DataCompareObject compareOneDay:[[tmpTableData objectAtIndex:indexPath.row - 1] objectForKey:@"time"] withAnotherDay:@"18:00"] == -1)
        {
            sImgView.hidden = NO;
            [dateImgView setImage:[UIImage imageNamed:@"movie_night"]];
        }
        else
        {
            sImgView.hidden = YES;
            [dateImgView setImage:[UIImage imageNamed:@""]];
        }
    }
    
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}

#pragma mark -
#pragma mark - 网络数据返回
- (void) movieDetailListDetailInfoCallBack:(id) objectData
{
    [self.ui_activity stopAnimating];
    
    NSMutableArray *tmpArr = (NSMutableArray *)objectData;
    if ([tmpArr count] > 0)
    {
        
        MovieObject *tmpObj =  [tmpArr objectAtIndex:0];

        self.ui_directorLabel.text = [NSString stringWithFormat:@"导演:  %@",tmpObj.m_director];
        self.ui_actorLabel.text = [NSString stringWithFormat:@"主演:  %@",tmpObj.m_actors];
        self.ui_timeLabel.text = [NSString stringWithFormat:@"时长:  %@",tmpObj.m_timeLength];
        
        self.ui_b_directorLabel.text = tmpObj.m_director;
        self.ui_b_actorsLabel.text = tmpObj.m_actors;
        self.ui_b_typeLabel.text = tmpObj.m_type;
        self.ui_b_timeLengthLabel.text = tmpObj.m_timeLength;
        self.ui_b_placeLabel.text = tmpObj.m_place;
        self.ui_b_showTimeLabel.text = tmpObj.m_playTime;
        
        //电影单
        NSArray *tmpOArr = tmpObj.m_orderObject;
        for (int i = 0; i < [tmpOArr count]; i ++)
        {
            NSDictionary *tmpDic = [tmpOArr objectAtIndex:i];
            //表的数据
            id tmpClass = [tmpDic objectForKey:@"bill"];
            NSMutableArray *tmpDetailOrderArr = [NSMutableArray array];
            if ([tmpClass isKindOfClass:[NSArray class]])
            {
                tmpDetailOrderArr = tmpClass;
            }
           
            [self.tableData setObject:tmpDetailOrderArr forKey:[NSString stringWithFormat:@"table%d",i+10]];
            
            if (i == 0)
            {
                CGSize contentSize = [tmpObj.m_info sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(303, 1000) lineBreakMode:NSLineBreakByTruncatingTail];
                CGRect contentRect = self.ui_contentLabel.frame;
                contentRect.size.height = contentSize.height;
                
                self.ui_contentLabel.text = tmpObj.m_info;
                
                if (contentSize.height > 56)
                {
                    CGSize tmpSize = self.ui_buttomScrollView.contentSize;
                    tmpSize.height = tmpSize.height + contentSize.height - 56;
                    self.ui_buttomScrollView.contentSize = tmpSize;
                    
                    self.ui_contentLabel.frame = contentRect;
                }
                
                if ([tmpObj.m_videoId integerValue] == 0 || [tmpObj.m_videoId integerValue] == -1)
                {
                    self.ui_playBtn.enabled = NO;
                    [self.ui_playBtn setImage:[UIImage imageNamed:@"movie_no_play"] forState:UIControlStateNormal];
                }
                
                self.videoId = tmpObj.m_videoId;
            }
            
        }
        //end
        
        //产次添加
        [self addTable];
        //end
    }
}

#pragma mark -
#pragma mark - 网络回调失败
- (void) failLoadData:(id) reasonString
{
    
}

@end
