//
//  ThemeListViewController.m
//  SanMen
//
//  Created by lcc on 14-2-12.
//  Copyright (c) 2014年 lcc. All rights reserved.
//

#import "ThemeListViewController.h"
#import "MyTableView.h"
#import "ThemeDetailViewController.h"
#import "StatusTipView.h"
#import "CCClientRequest.h"

@interface ThemeListViewController ()<MyTableViewDelegate>
{
    NSInteger pageIndex;
}

@property (nonatomic, strong) MyTableView *myTable;
@property (nonatomic, strong) NSMutableArray *tableData;
@property (nonatomic, strong) CCClientRequest *myRequest;

@property (strong, nonatomic) IBOutlet UILabel *ui_freshTipLabel;
@property (strong, nonatomic) IBOutlet UILabel *ui_titleLabel;
@property (strong, nonatomic) StatusTipView *tipView;
@end

@implementation ThemeListViewController

- (void)dealloc
{
    self.myRequest.c_delegate = nil;
    self.myRequest = nil;
    self.tableData = nil;
    self.myTable = nil;
    
    self.ui_freshTipLabel = nil;
    self.tipView = nil;
    
    self.themeObject = nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
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
    self.tipView = [[StatusTipView alloc] initWithFrame:CGRectMake(320, 160, 120, 70)];
    [self.view addSubview:self.tipView];
    
    self.ui_titleLabel.text = self.themeObject.t_title;
    
    //表的初始化
    self.tableData = [[NSMutableArray alloc] init];
    self.myTable = [[MyTableView alloc] initWithFrame:(CGRect){0,64,320,viewHeight - 64} style:UITableViewStylePlain];
    self.myTable.cellNameString = @"ThemeListCell";
    self.myTable.tableData = self.tableData;
    [self.myTable setMyTable_delegate:self];
    [self.myTable setfreshHeaderView:YES];
    [self.myTable setFooterViewHidden:YES];
    [self.myTable setCellDelegateObject:self];
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

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [StatusBarObject setStatusBarStyleWithIndex:0];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [StatusBarObject setStatusBarStyleWithIndex:1];
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

- (IBAction)backTapped:(id)sender
{
    [SMApp.nav popViewController];
}

#pragma mark -
#pragma mark - custom delegate
//表的代理
- (void) myTableViewLoadDataAgain
{
    pageIndex = 1;
    [self.myRequest themeHomeListWithPageNo:pageIndex tId:self.themeObject.t_id];
}

- (CGFloat) myTableRowHeightAtIndex:(NSIndexPath *)indexPath
{
    if (indexPath.row == [self.tableData count] - 1)
    {
        return 117;
    }
    return 107;
}

- (void) myTableLoadMore
{
    pageIndex ++;
    [self.myRequest themeHomeListWithPageNo:pageIndex tId:self.themeObject.t_id];
}

#pragma mark -
#pragma mark - cell delegate
- (void) themeListCellTapWithObjec:(id) object
{
    NSString *tmpString = [((NSDictionary *)object).allKeys objectAtIndex:0];
    ThemeObject *tmpObj = [object objectForKey:tmpString];
    tmpObj.t_index = tmpString;
    ThemeDetailViewController *browse = [[ThemeDetailViewController alloc] init];
    browse.themeObject = tmpObj;
    [SMApp.nav pushViewController:browse];
}

#pragma mark -
#pragma mark - 网络数据放回
- (void) themeHomeListCallBack:(id) objectData
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
