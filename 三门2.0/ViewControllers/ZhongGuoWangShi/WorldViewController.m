//
//  WorldViewController.m
//  SanMen
//
//  Created by lcc on 13-12-21.
//  Copyright (c) 2013年 lcc. All rights reserved.
//

#import "WorldViewController.h"
#import "MyTableView.h"
#import "WorldDetailViewController.h"
#import "CCClientRequest.h"
#import "NewsObject.h"
#import "AcitivityDetailViewController.h"
#import "StatusTipView.h"

@interface WorldViewController ()<MyTableViewDelegate>

@property (nonatomic, strong) MyTableView *myTable;
@property (nonatomic, strong) NSMutableArray *tableData;
@property (nonatomic, strong) CCClientRequest *myRequest;

@property (strong, nonatomic) IBOutlet UILabel *ui_freshTipLabel;
@property (strong, nonatomic) StatusTipView *tipView;
@property (strong, nonatomic) IBOutlet UIButton *ui_headerBtn;
@property (strong, nonatomic) IBOutlet UIView *ui_headerView;

@end

@implementation WorldViewController

- (void)dealloc
{
    self.myRequest.c_delegate = nil;
    self.myRequest = nil;
    self.tableData = nil;
    self.myTable.myTable_delegate = nil;
    self.myTable = nil;
    
    self.ui_freshTipLabel = nil;
    self.tipView = nil;
    
    self.ui_headerBtn = nil;
    self.ui_headerView = nil;
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
    self.myTable = [[MyTableView alloc] initWithFrame:(CGRect){0,0,320,viewHeight - 64} style:UITableViewStylePlain];
    self.myTable.cellNameString = @"WorldCell";
    self.myTable.tableData = self.tableData;
    [self.myTable setMyTable_delegate:self];
    [self.myTable setfreshHeaderView:YES];
    [self.myTable setFooterViewHidden:YES];
    [self.view addSubview:self.myTable];
    [self.myTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.myTable.tableHeaderView = self.ui_headerView;
    //end
    
    //网络请求
    [self.myTable dragAnimation];
    [self.myTable reloadTableViewDataSource];
    //end
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark - custom method
- (IBAction)downLoadTapped:(id)sender
{
    AcitivityDetailViewController  *activity = [[AcitivityDetailViewController alloc] init];
    activity.webUrl = ZHONGGUOWANGSHI;
    [SMApp.nav pushViewController:activity];
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

#pragma mark -
#pragma mark - custom delegate
//表的代理
- (void) myTableViewLoadDataAgain
{
    [self.myRequest newsWorld];
}

- (CGFloat) myTableRowHeightAtIndex:(NSIndexPath *)indexPath
{
    return 80;
}

- (void) myTabledidSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsObject *tmpObj = [self.tableData objectAtIndex:indexPath.row];
    WorldDetailViewController *newsDetail = [[WorldDetailViewController alloc] init];
    newsDetail.newsId = tmpObj.n_id;
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app.nav pushViewController:newsDetail];
}

#pragma mark -
#pragma mark - 网络数据放回
//三门-新闻
- (void) newsWorldCallBack:(id) objectData
{
    NSMutableArray *tmpArr = objectData;
    self.tableData = tmpArr ;
    self.myTable.tableData = self.tableData;
    [self.myTable doneLoadingTableViewData];
}

#pragma mark -
#pragma mark - 网络回调失败
- (void) failLoadData:(id) reasonString
{
    if (reasonString)
    {
        [self.myTable doneLoadingTableViewData];
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
