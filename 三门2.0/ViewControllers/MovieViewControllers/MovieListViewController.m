//
//  MovieListViewController.m
//  SanMen
//
//  Created by lcc on 14-2-11.
//  Copyright (c) 2014年 lcc. All rights reserved.
//

#import "MovieListViewController.h"
#import "MyTableView.h"
#import "MovieHomeViewController.h"
#import "CCClientRequest.h"
#import "StatusTipView.h"
#import "CinemaObject.h"
#import "FMDBManage.h"

@interface MovieListViewController ()<MyTableViewDelegate>

@property (nonatomic, strong) MyTableView *myTable;
@property (nonatomic, strong) NSMutableArray *tableData;
@property (nonatomic, strong) CCClientRequest *myRequest;
@property (strong, nonatomic) IBOutlet UILabel *ui_freshTipLabel;
@property (strong, nonatomic) StatusTipView *tipView;

@end

@implementation MovieListViewController

- (void)dealloc
{
    self.myRequest.c_delegate = nil;
    self.myRequest = nil;
    
    self.myTable.myTable_delegate = nil;
    self.myTable = nil;
    self.tableData = nil;
    
    self.ui_freshTipLabel = nil;
    self.tipView = nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.myRequest = [[CCClientRequest alloc] init];
        [self.myRequest setC_delegate:self];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.ui_freshTipLabel.hidden = YES;
    self.view.clipsToBounds = YES;
    self.tipView = [[StatusTipView alloc] initWithFrame:CGRectMake(320, 96, 120, 70)];
    [self.view addSubview:self.tipView];
    
    //表的初始化
    self.tableData = [[NSMutableArray alloc] init];
    
    [self readLocalDB];
    
    self.myTable = [[MyTableView alloc] initWithFrame:(CGRect){0,0,320,viewHeight - 64} style:UITableViewStylePlain];
    self.myTable.cellNameString = @"MovieListCell";
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

#pragma mark -
#pragma mark - custom method
- (void) readLocalDB
{
    NSArray *tmpArr = [FMDBManage getDataFromTable:[CinemaObject class] WithString:@"1=1"];
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
    [self.myRequest movieHomeList];
}

- (CGFloat) myTableRowHeightAtIndex:(NSIndexPath *)indexPath
{
    return 135;
}

- (void) myTabledidSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CinemaObject *tmpObject = [self.tableData objectAtIndex:indexPath.row];
    MovieHomeViewController *movie = [[MovieHomeViewController alloc] init];
    movie.cinemaId = tmpObject.c_id;
    [SMApp.nav pushViewController:movie];
}

#pragma mark -
#pragma mark - 网络数据返回
- (void) movieHomeListCallBack:(id) objectData
{
    NSMutableArray *tmpArr = objectData;
    
    [self.tableData removeAllObjects];
    
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
