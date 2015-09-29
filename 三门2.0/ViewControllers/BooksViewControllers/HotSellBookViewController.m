//
//  HotSellBookViewController.m
//  SanMen
//
//  Created by lcc on 14-2-13.
//  Copyright (c) 2014年 lcc. All rights reserved.
//

#import "HotSellBookViewController.h"
#import "MyTableView.h"
#import "NewsDetailViewController.h"
#import "StatusTipView.h"
#import "BookObject.h"

@interface HotSellBookViewController ()<MyTableViewDelegate>
{
    NSInteger pageIndex;
}

@property (nonatomic, strong) MyTableView *myTable;
@property (nonatomic, strong) NSMutableArray *tableData;

@property (nonatomic, strong) CCClientRequest *myRequest;

@property (strong, nonatomic) IBOutlet UILabel *ui_freshTipLabel;
@property (strong, nonatomic) StatusTipView *tipView;

@end

@implementation HotSellBookViewController

- (void)dealloc
{
    self.myRequest.c_delegate = nil;
    self.myRequest = nil;
    self.tableData = nil;
    self.myTable = nil;
    
    self.ui_freshTipLabel = nil;
    self.tipView = nil;
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
    self.myTable = [[MyTableView alloc] initWithFrame:(CGRect){0,0,320,viewHeight - 109} style:UITableViewStylePlain];
    self.myTable.cellNameString = @"HotSellBookCell";
    self.myTable.tableData = self.tableData;
    [self.myTable setMyTable_delegate:self];
    [self.myTable setfreshHeaderView:YES];
    self.myTable.isImage = YES;
    self.myTable.clumnCount = 3;
    [self.myTable setFooterViewHidden:YES];
    self.myTable.cellDelegateObject = self;
    [self.view addSubview:self.myTable];
    [self.myTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    //end
    
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
    [self.myRequest hotSellBookNewsWithPageNo:pageIndex];
}

- (CGFloat) myTableRowHeightAtIndex:(NSIndexPath *)indexPath
{
    return 150;
}

- (void) myTableLoadMore
{
    pageIndex ++;
    
    [self.myRequest hotSellBookNewsWithPageNo:pageIndex];
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
#pragma mark - cell delegate
- (void) hotSellBookTapWihtObject:(id) object
{
    BookObject *tmpObject = object;
    NewsDetailViewController *newsDetail = [[NewsDetailViewController alloc] init];
    newsDetail.newsId = tmpObject.b_id;
    newsDetail.noCollection = YES;
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app.nav pushViewController:newsDetail];
}


#pragma mark -
#pragma mark - 网络数据返回
- (void) hotSellBookNewsCallBack:(id) objectData
{
    NSMutableArray *tmpArr = objectData;

    if ([tmpArr count] < 15)
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

