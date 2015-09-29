//
//  BikeViewController.m
//  SanMen
//
//  Created by lcc on 14-2-13.
//  Copyright (c) 2014年 lcc. All rights reserved.
//

#import "BikeViewController.h"
#import "MyTableView.h"
#import "CCClientRequest.h"
#import "StatusTipView.h"
#import "ConVinientObject.h"
#import "NewsDetailViewController.h"
#import "FMDBManage.h"

@interface BikeViewController ()<MyTableViewDelegate>
{
    NSInteger pageIndex;
}

@property (nonatomic, strong) MyTableView *myTable;
@property (nonatomic, strong) NSMutableArray *tableData;
@property (nonatomic, strong) CCClientRequest *myRequest;

@property (strong, nonatomic) IBOutlet UILabel *ui_freshTipLabel;
@property (strong, nonatomic) StatusTipView *tipView;

@end

@implementation BikeViewController

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
    
    //表的初始化
    self.tableData = [[NSMutableArray alloc] init];
    
    [self readLocalDB];
    
    self.myTable = [[MyTableView alloc] initWithFrame:(CGRect){0,64,320,viewHeight - 64} style:UITableViewStylePlain];
    self.myTable.cellNameString = @"BikeListCell";
    self.myTable.tableData = self.tableData;
    [self.myTable setMyTable_delegate:self];
    [self.myTable setfreshHeaderView:YES];
    [self.myTable setFooterViewHidden:YES];
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
#pragma mark - custome method
- (void) readLocalDB
{
    NSArray *tmpArr = [FMDBManage getDataFromTable:[ConVinientObject class] WithString:[NSString stringWithFormat:@"c_type='%@'",CBIKEADDRESSNEWSMETHOD]];
    if (tmpArr)
    {
        [self.tableData addObjectsFromArray:tmpArr];
    }
}

#pragma mark -
#pragma mark - 控件事件
- (IBAction)backTapped:(id)sender
{
    [SMApp.nav popViewController];
}

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
    [self.myRequest cBikeAddressNews];
}

- (CGFloat) myTableRowHeightAtIndex:(NSIndexPath *)indexPath
{
    return 80;
}

- (void) myTabledidSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    ConVinientObject *tmpObject = [self.tableData objectAtIndex:indexPath.row];
//    NewsDetailViewController *newsDetail = [[NewsDetailViewController alloc] init];
//    newsDetail.newsId = tmpObject.c_id;
//    newsDetail.noCollection = YES;
//    newsDetail.isConvinient = YES;
//    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    [app.nav pushViewController:newsDetail];
}

#pragma mark -
#pragma mark - 网络数据返回
- (void) cBikeAddressNewsCallBack:(id) objectData
{
    NSMutableArray *tmpArr = objectData;

    self.tableData = tmpArr;
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
