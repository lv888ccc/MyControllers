//
//  HomeViewController.m
//  SanMen
//
//  Created by lcc on 13-12-16.
//  Copyright (c) 2013年 lcc. All rights reserved.
//

#import "HomeViewController.h"
#import "CCClientRequest.h"
#import "MyTableView.h"
#import "NewsDetailViewController.h"
#import "HomeObject.h"
#import <MediaPlayer/MediaPlayer.h>
#import "FMDBManage.h"
#import "AcitivityDetailViewController.h"
#import "FMDBManage.h"
#import "SettingObject.h"
#import "MetaData.h"
#import "ThemeDetailViewController.h"

#define GUIDTAG 100123

@interface HomeViewController ()<MyTableViewDelegate>

@property (nonatomic, strong) NSMutableArray *tableData;
@property (nonatomic, strong) MyTableView *myTable;
@property (strong, nonatomic) IBOutlet UIView *ui_guidView;
@property (strong, nonatomic)  CCClientRequest *myRequest;

@property (strong, nonatomic) IBOutlet UILabel *ui_freshTipLabel;
@property (strong, nonatomic) IBOutlet UIView *ui_tipView;
@property (strong, nonatomic) SettingObject *settingObject;

@end

@implementation HomeViewController

- (void)dealloc
{
    self.myRequest.c_delegate = nil;
    self.myRequest = nil;
    
    self.tableData = nil;
    self.ui_guidView = nil;
    self.myTable.myTable_delegate = nil;
    self.myTable = nil;
    
    self.ui_freshTipLabel = nil;
    self.ui_tipView = nil;
    self.settingObject = nil;
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
    
    [self initViewController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - custom method
//让提示语消失
- (void) tipDispear
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect = self.ui_tipView.frame;
        rect.origin.x = 320;
        self.ui_tipView.frame = rect;
    }];
}

- (void) initViewController
{
    //表的初始化
    self.tableData = [[NSMutableArray alloc] init];
    //本度数据读取
    [self readLocalDB];
    
    self.view.clipsToBounds = YES;
    self.ui_freshTipLabel.hidden = YES;
    
    self.myTable = [[MyTableView alloc] initWithFrame:(CGRect){0,0,320,viewHeight - 64} style:UITableViewStylePlain];
    self.myTable.cellNameString = @"HomeCell";
    self.myTable.tableData = self.tableData;
    [self.myTable setMyTable_delegate:self];
    [self.myTable setCellDelegateObject:self];
    [self.myTable setfreshHeaderView:YES];
    [self.myTable setFooterViewHidden:YES];
    self.myTable.scrollsToTop = YES;
    [self.myTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    //尾部
    self.myTable.tableFooterView = [self tableViewFooter];
    [self.view addSubview:self.myTable];
    //end
    
    //推送
    if (SMApp.pushInfo)
    {
        [self performSelector:@selector(pushDetailViewController) withObject:nil afterDelay:0.5];
    }
    //end
    
    //第一次新手引导页面
    NSMutableArray * tmpArr = [FMDBManage getDataFromTable:[SettingObject class] WithString:@"1=1"];
    
    if ([tmpArr count] > 0)
    {
        self.settingObject = [tmpArr objectAtIndex:0];
    }
    
    if ([self.settingObject.s_home isEqualToString:@"-1"] || self.settingObject == nil)
    {
        //添加左边引导图
        UIButton *guidBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [guidBtn setImage:[UIImage imageNamed:@"left_guid"] forState:UIControlStateNormal];
        [guidBtn setImage:[UIImage imageNamed:@"left_guid"] forState:UIControlStateHighlighted];
        [SMApp.nav.view addSubview:guidBtn];
        guidBtn.tag = GUIDTAG;
        guidBtn.alpha = 0;
        guidBtn.frame = CGRectMake(0, viewHeight - 568, 320, 568);
        [guidBtn addTarget:self action:@selector(guidTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        //首页引导图
        CGRect rect = self.ui_guidView.frame;
        rect.size.height = viewHeight;
        self.ui_guidView.frame = rect;
        [SMApp.nav.view addSubview:self.ui_guidView];
        [SMApp.nav.view bringSubviewToFront:SMApp.userGuid.view];
        [self performSelector:@selector(markViewAppear) withObject:nil afterDelay:0.5];
    }
    //end
    
    [self performSelector:@selector(requestBegin) withObject:nil afterDelay:0.3];
}

//网络开始请求
- (void) requestBegin
{
    //动画
    [self.myTable dragAnimation];
    [self.myTable reloadTableViewDataSource];
}

//返回表尾巴
- (UIView *) tableViewFooter
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 55)];
    
    UIImageView *moreImg = [[UIImageView alloc] initWithFrame:CGRectMake(12, 6, 296, 40)];
    moreImg.image = [UIImage imageNamed:@"center_more_bg"];
    [footerView addSubview:moreImg];
    
    UITapGestureRecognizer *tapAction = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(moreTapped:)];
    UIImageView *bgImg = [[UIImageView alloc] initWithFrame:CGRectMake(12, 6, 296, 40)];
    bgImg.image = [UIImage imageNamed:@"center_more"];
    bgImg.contentMode = UIViewContentModeCenter;
    [footerView addSubview:bgImg];
    bgImg.userInteractionEnabled = YES;
    [bgImg addGestureRecognizer:tapAction];

    return footerView;
}

//推送到详情页面
- (void) pushDetailViewController
{
    //取出push的消息
    NewsDetailViewController *newsDetail = [[NewsDetailViewController alloc] init];
    newsDetail.newsId = [SMApp.pushInfo objectForKey:@"id"];
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app.nav pushViewController:newsDetail];
    
    SMApp.pushInfo = nil;
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (void) markViewAppear
{
    [UIView animateWithDuration:0.3 animations:^{
        self.ui_guidView.alpha = 1.0f;
    }];
}

//首页缓存读取
- (void) readLocalDB
{
    NSMutableArray *tmpArr = [FMDBManage getDataFromTable:[HomeObject class] WithString:@"1=1"];
    
    NSInteger key = 0;
    NSMutableArray *typeArr = nil;
    
    for (int i = 0; i < [tmpArr count] ; i ++)
    {
        HomeObject *tmpObj = [tmpArr objectAtIndex:i];
        
        if (key == 0)
        {
            typeArr = [[NSMutableArray alloc] init];
            key = [tmpObj.h_type integerValue];
        }
        
        if (key != 0 && key != [tmpObj.h_type integerValue])
        {
            [self.tableData addObject:typeArr];
            key = [tmpObj.h_type integerValue];
            typeArr = nil;
            typeArr = [[NSMutableArray alloc] init];
        }
        
        [typeArr addObject:tmpObj];
        
        //最后一行
        if (i == [tmpArr count] - 1)
        {
            [self.tableData addObject:typeArr];
        }
    }
}

- (void) addLeftGuid
{
    UIButton *tmpBtn = (UIButton *)[SMApp.nav.view viewWithTag:GUIDTAG];
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         tmpBtn.alpha = 1.0f;
                     }];
}

#pragma mark -
#pragma mark - 控件事件
- (IBAction)freshTapped:(id)sender
{
    self.ui_freshTipLabel.hidden = YES;
    self.myTable.hidden = NO;
    
    [self requestBegin];
}

- (void) moreTapped:(UIButton *) sender
{
    [SMApp.home leftMenuTapped:nil];
}

- (IBAction)markTapped:(id)sender
{
    __block UIView *tmpView = [(UIView *)sender superview];
    [UIView animateWithDuration:0.5 animations:^{
        tmpView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [tmpView removeFromSuperview];
        tmpView = nil;
        
        [SMApp.home leftMenuTapped:nil];
        [self performSelector:@selector(addLeftGuid) withObject:nil afterDelay:0.5];
    }];
}

- (void) guidTapped:(UIButton *) sender
{
    [UIView animateWithDuration:0.3 animations:^{
        sender.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [sender removeFromSuperview];
        
        SettingObject *tmpObj = [[SettingObject alloc] init];
        tmpObj.s_crrVer = [MetaData getCurrVer];
        tmpObj.s_left = @"0";
        tmpObj.s_home = @"0";
        
        //入库
        [FMDBManage updateTable:tmpObj setString:[NSString stringWithFormat:@"s_home='0',s_left='0',s_camara='-1',s_crrVer='%@'",tmpObj.s_crrVer] WithString:@"1=1"];
    }];
}

#pragma mark -
#pragma mark - custom delegate
//表的代理
- (void) myTableViewLoadDataAgain
{
    [self.myRequest homeNewsType];
}

- (CGFloat) myTableRowHeightAtIndex:(NSIndexPath *)indexPath
{
    NSMutableArray *tmpArr = [self.tableData objectAtIndex:indexPath.row];
    HomeObject *tmpObj = [tmpArr objectAtIndex:0];
    NSString *typeString = tmpObj.h_type;
    
    switch ([typeString integerValue])
    {
        case NEWSADTYPE:
            return 182;//广告
            
        case NEWSTYPE:
        case VIDEOTYPE:
            
            switch ([tmpArr count])
            {
                case 1:
                    return 182;
                    
                case 2:
                    return 252;
                    
                default:
                    return 322;//视频 //图文新闻
            }
            
            
        case PUBLISHTYPE:
            
            switch ([tmpArr count])
            {
                case 1:
                    return 85;

                case 2:
                    return 155;
        
                default:
                    return 225;//三门新闻
            }
            
        default:
            switch ([tmpArr count])
            {
                case 1:
                    return 186;
                    
                case 2:
                    return 273;
                    
                default:
                    return 380;//专栏
            }
            
    }
}

#pragma mark -
#pragma mark - cell delegate
- (void) homeCellTapWithObject:(id) object
{
    if ([object isKindOfClass:[NSDictionary class]])
    {
        NSString *tmpString = [((NSDictionary *)object).allKeys objectAtIndex:0];
        HomeObject *tmpObj = [object objectForKey:tmpString];
        
        ThemeObject *tmpTObj = [[ThemeObject alloc] init];
        tmpTObj.t_id = tmpObj.h_id;
        tmpTObj.t_imgUrl = tmpObj.h_imgUrl;
        tmpTObj.t_title = tmpObj.h_title;
        tmpTObj.t_index = tmpString;
        
        ThemeDetailViewController *browse = [[ThemeDetailViewController alloc] init];
        browse.themeObject = tmpTObj;
        browse.isLight = YES;
        [SMApp.nav pushViewController:browse];
    }
    else
    {
        HomeObject *tmpObj = object;
        NewsDetailViewController *newsDetail = [[NewsDetailViewController alloc] init];
        newsDetail.newsId = tmpObj.h_id;
        SMApp.newsTypeName = TOPNEWS;
        
        switch ([tmpObj.h_type integerValue])
        {
            case NEWSADTYPE:
            {
                if ([tmpObj.h_modelType isEqualToString:@"700021"])
                {
                    AcitivityDetailViewController  *activity = [[AcitivityDetailViewController alloc] init];
                    activity.webUrl = tmpObj.h_outUrl;
                    [SMApp.nav pushViewController:activity];
                }
                else if ([tmpObj.h_modelType isEqualToString:@"700020"])
                {
                    [SMApp.nav pushViewController:newsDetail];
                }
            }
                break;
                
            case NEWSTYPE:
                
                [SMApp.nav pushViewController:newsDetail];
                
                break;
                
            case VIDEOTYPE:
            {
                MPMoviePlayerViewController *player = [[MPMoviePlayerViewController alloc] init];
                player.moviePlayer.contentURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",VIDEOHTTPURL,tmpObj.h_id]];
                [player.moviePlayer play];
                [SMApp.nav presentMoviePlayerViewControllerAnimated:player];
            }
                
                break;
                
            case PUBLISHTYPE:
                
                [SMApp.nav pushViewController:newsDetail];
                
                break;
                
            default:
                break;
        }
    }
}

#pragma mark -
#pragma mark - 网络数据放回
- (void) homeNewsTypeCallBack:(id) objectData
{
    self.tableData = objectData;
    self.myTable.tableData = self.tableData;
    [self.myTable doneLoadingTableViewData];
    self.myTable.tableFooterView = [self tableViewFooter];
}

#pragma mark -
#pragma mark - 网络回调失败
- (void) failLoadData:(id) reasonString
{
    [self.myTable doneLoadingTableViewData];
    if (reasonString)
    {
        [self.view bringSubviewToFront:self.ui_tipView];
        
        if (reasonString)
        {
            [UIView animateWithDuration:0.3 animations:^{
                CGRect rect = self.ui_tipView.frame;
                rect.origin.x = 200;
                self.ui_tipView.frame = rect;
            } completion:^(BOOL finished) {
                if ([self.tableData count] == 0)
                {
                    self.myTable.hidden = YES;
                    self.ui_freshTipLabel.hidden = NO;
                }
                
                [self performSelector:@selector(tipDispear) withObject:nil afterDelay:1];
            }];
        }
    }
}

@end
