//
//  SanmenViewController.m
//  SanMen
//
//  Created by lcc on 13-12-21.
//  Copyright (c) 2013年 lcc. All rights reserved.
//

#import "SanmenViewController.h"
#import "MyTableView.h"
#import "NewsDetailViewController.h"
#import "UIButton+WebCache.h"
#import "CCClientRequest.h"
#import "NewsObject.h"
#import "AdObject.h"
#import "StatusTipView.h"
#import "FMDBManage.h"

@interface SanmenViewController ()<MyTableViewDelegate,UIScrollViewDelegate>
{
    NSInteger pageIndex;
    NSTimer *timer;
    NSInteger imgIndex;
    BOOL isBigger;
    NSInteger picsCount;
}

@property (nonatomic, strong) MyTableView *myTable;
@property (nonatomic, strong) NSMutableArray *tableData;
@property (nonatomic, strong) CCClientRequest *myRequest;
@property (nonatomic, strong) NSMutableArray *adData;

@property (strong, nonatomic) IBOutlet UILabel *ui_indexLabel;
@property (strong, nonatomic) IBOutlet UILabel *ui_titleLabel;
@property (strong, nonatomic) IBOutlet UIScrollView *ui_scrollView;
@property (strong, nonatomic) IBOutlet UIView *ui_tableHeaderView;

@property (strong, nonatomic) IBOutlet UILabel *ui_freshTipLabel;
@property (strong, nonatomic) StatusTipView *tipView;


@end

@implementation SanmenViewController

- (void)dealloc
{
    self.myRequest.c_delegate = nil;
    self.myRequest = nil;
    self.tableData = nil;
    self.myTable.myTable_delegate = nil;
    self.myTable = nil;
    self.adData = nil;
    
    self.ui_indexLabel = nil;
    self.ui_scrollView = nil;
    self.ui_tableHeaderView = nil;
    self.ui_titleLabel = nil;
    
    self.ui_freshTipLabel = nil;
    self.tipView = nil;
    timer = nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        //网络请求
        self.myRequest = [[CCClientRequest alloc] init];
        self.myRequest.c_delegate = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.clipsToBounds = YES;
    self.ui_freshTipLabel.hidden = YES;
    self.tipView = [[StatusTipView alloc] initWithFrame:CGRectMake(320, 96, 120, 70)];
    [self.view addSubview:self.tipView];
    
    //表的初始化
    self.tableData = [[NSMutableArray alloc] init];
    
    [self readLocalDB];
    
    self.myTable = [[MyTableView alloc] initWithFrame:(CGRect){0,0,320,viewHeight - 109} style:UITableViewStylePlain];
    self.myTable.cellNameString = @"SanMenCell";
    self.myTable.tableData = self.tableData;
    [self.myTable setMyTable_delegate:self];
    [self.myTable setfreshHeaderView:YES];
    [self.myTable setFooterViewHidden:YES];
    [self.view addSubview:self.myTable];
    [self.myTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    //end

    self.adData = [[NSMutableArray alloc] init];
    
    imgIndex = 0;
    isBigger = YES;
    
    //网络请求
    [self.myTable dragAnimation];
    [self.myTable reloadTableViewDataSource];
    //end
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    if ([self.adData count] > 1)
    {
        [timer invalidate];
    }
    
}

#pragma mark -
#pragma mark - custom method
//获取view所在的viewcontroller
- (UIViewController*) viewController
{
    for (UIView* next = [[self.view superview] superview]; next; next = next.superview)
    {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]])
        {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

- (void) scrollUpDown
{
    [UIView animateWithDuration:0.2 animations:^{
        CGRect rect = self.myTable.frame;
        rect.size.height = self.view.frame.size.height;
        self.myTable.frame = rect;
    }];
}

- (void) adTapped:(UIButton *) sender
{
    AdObject *tmpObj = [self.adData objectAtIndex:sender.tag - 1000];
    NewsDetailViewController *newsDetail = [[NewsDetailViewController alloc] init];
    newsDetail.newsId = tmpObj.a_id;
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app.nav pushViewController:newsDetail];
}

- (void) changeImg
{
    imgIndex ++;
    
    if (imgIndex >= picsCount)
    {
        imgIndex = 0;
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        CGPoint point = self.ui_scrollView.contentOffset;
        point.x = imgIndex*320;
        self.ui_scrollView.contentOffset = point;
    } completion:^(BOOL finished) {
        self.ui_indexLabel.text = [NSString stringWithFormat:@"%d/%d",imgIndex + 1,picsCount];
        AdObject *tmpObj = [self.adData objectAtIndex:imgIndex];
        self.ui_titleLabel.text = tmpObj.a_title;
    }];

}

- (void) readLocalDB
{
    NSArray *tmpArr = [FMDBManage getDataFromTable:[NewsObject class] WithString:[NSString stringWithFormat:@"n_newsType='%@'",NEWSSAMENMETHOD]];
    if (tmpArr)
    {
        [self.tableData addObjectsFromArray:tmpArr];
    }
}

#pragma mark -
#pragma mark - 控件事件
- (IBAction)freshTapped:(id)sender
{
    self.ui_freshTipLabel.hidden = YES;
    self.myTable.hidden = NO;
    
    [self.myTable dragAnimation];
    [self.myTable reloadTableViewDataSource];
}

#pragma mark -
#pragma mark - custom delegate
//表的代理
- (void) myTableViewLoadDataAgain
{
    pageIndex = 1;
    [self.myRequest newsSanMenWithPageNo:pageIndex];
    [self.myRequest sanMenTopAd];
}

- (CGFloat) myTableRowHeightAtIndex:(NSIndexPath *)indexPath
{
    return 80;
}

- (void) myTabledidSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsObject *tmpObject = [self.tableData objectAtIndex:indexPath.row];
    NewsDetailViewController *newsDetail = [[NewsDetailViewController alloc] init];
    newsDetail.newsId = tmpObject.n_id;
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app.nav pushViewController:newsDetail];
}

- (void) myTableLoadMore
{
    pageIndex ++;
    [self.myRequest newsSanMenWithPageNo:pageIndex];
}

//上滚动
- (void) scrollUp
{
    UIViewController *tmpView = [self viewController];
    if (tmpView)
    {
        [tmpView performSelector:@selector(scrollUp) withObject:nil];
    }
}

//下滚动
- (void) scrollDown
{
    UIViewController *tmpView = [self viewController];
    if (tmpView)
    {
        [tmpView performSelector:@selector(scrollDown) withObject:nil];
    }
}

#pragma mark -
#pragma mark - 控件代理
- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    imgIndex = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    self.ui_indexLabel.text = [NSString stringWithFormat:@"%d/%d",imgIndex + 1,picsCount];
    AdObject *tmpObj = [self.adData objectAtIndex:imgIndex];
    self.ui_titleLabel.text = tmpObj.a_title;
}

#pragma mark -
#pragma mark - 网络数据放回
//三门-新闻
- (void) newsSanMenCallBack:(id) objectData
{
    NSMutableArray *tmpArr = objectData;
    
    if ([tmpArr count] < PAGESIZE)
    {
        [self.myTable setFooterViewHidden:YES];
    }
    else
    {
        [self.myTable setFooterViewHidden:NO];
    }
    
    if (pageIndex == 1)
    {
        [self.tableData removeAllObjects];
    }
    
    [self.tableData addObjectsFromArray:tmpArr];
    self.myTable.tableData = self.tableData;
    [self.myTable doneLoadingTableViewData];
}

//广告图
- (void) sanMenTopAdCallBack:(id) objectData
{
    
    NSMutableArray *tmpArr = objectData;
    if ([tmpArr count] > 0)
    {
        [self.adData removeAllObjects];
        [self.adData addObjectsFromArray:tmpArr];
        
        picsCount = [self.adData count];
        
        NSInteger i = 0;
        //设置 表头
        for (AdObject *tmpObj in tmpArr)
        {
            if (i == 0)
            {
                self.ui_titleLabel.text = tmpObj.a_title;
            }
            UIButton *tmpView = [UIButton buttonWithType:UIButtonTypeCustom];
            tmpView.frame = CGRectMake(i*320, 0, 320, 180);
            tmpView.tag = 1000 + i;
            [tmpView addTarget:self action:@selector(adTapped:) forControlEvents:UIControlEventTouchUpInside];
            [tmpView setImageWithURL:[NSURL URLWithString:tmpObj.a_imgUrl] placeholderImage:[UIImage imageNamed:@"ad_place"]];
            [self.ui_scrollView addSubview:tmpView];
            i ++;
        }
        
        CGSize size = self.ui_scrollView.contentSize;
        size.width = 320*[tmpArr count];
        self.ui_scrollView.contentSize = size;
        self.ui_scrollView.pagingEnabled = YES;
        self.ui_scrollView.showsHorizontalScrollIndicator = NO;
        
        self.ui_indexLabel.text = [NSString stringWithFormat:@"1/%d",[tmpArr count]];
        self.myTable.tableHeaderView = self.ui_tableHeaderView;
        //end
        
        if (timer){
            [timer invalidate];
            timer = nil;
        }
        
        if (picsCount > 1)
        {
            timer = [NSTimer scheduledTimerWithTimeInterval:4
                                                     target:self
                                                   selector:@selector(changeImg)
                                                   userInfo:nil
                                                    repeats:YES];
        }
    }
}

#pragma mark -
#pragma mark - 网络回调失败
- (void) failLoadData:(id) reasonString
{
    [self.myTable doneLoadingTableViewData];
    if (reasonString)
    {
        if ([self.tableData count] == 0)
        {
            self.myTable.hidden = YES;
            self.ui_freshTipLabel.hidden = NO;
        }
        [self.view bringSubviewToFront:self.tipView];
        [self.tipView tipShowWithType:SigleNetFailTip tipString:NetFailTip isHidden:YES];
    }
}

@end
