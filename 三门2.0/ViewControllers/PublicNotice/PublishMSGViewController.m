//
//  PublishMSGViewController.m
//  SanMen
//
//  Created by lcc on 13-12-28.
//  Copyright (c) 2013年 lcc. All rights reserved.
//

#import "PublishMSGViewController.h"
#import "MyTableView.h"
#import "NewsDetailViewController.h"
#import "CCClientRequest.h"
#import "PublishObject.h"
#import "StatusTipView.h"

@interface PublishMSGViewController ()<MyTableViewDelegate>
{
    NSInteger pageIndex;
}

@property (nonatomic, strong) MyTableView *myTable;
@property (nonatomic, strong) NSMutableArray *tableData;
@property (nonatomic, strong) CCClientRequest *myRequest;
@property (strong, nonatomic) IBOutlet UILabel *ui_freshTipLabel;
@property (strong, nonatomic) StatusTipView *tipView;

@end

@implementation PublishMSGViewController

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
    self.myTable = [[MyTableView alloc] initWithFrame:(CGRect){0,0,320,viewHeight - 64} style:UITableViewStylePlain];
    self.myTable.cellNameString = @"PublishCell";
    self.myTable.tableData = self.tableData;
    [self.myTable setMyTable_delegate:self];
    [self.myTable setfreshHeaderView:YES];
    [self.myTable setFooterViewHidden:YES];
    [self.view addSubview:self.myTable];
    [self.myTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    //end
    
    [self.myTable dragAnimation];
    [self.myTable reloadTableViewDataSource];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
    [self.myRequest publishWithPageNo:pageIndex];
}

- (CGFloat) myTableRowHeightAtIndex:(NSIndexPath *)indexPath
{
    return 80;
}

- (void) myTabledidSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PublishObject *tmpObject = [self.tableData objectAtIndex:indexPath.row];
    NewsDetailViewController *newsDetail = [[NewsDetailViewController alloc] init];
    newsDetail.newsId = tmpObject.p_id;
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app.nav pushViewController:newsDetail];
}

- (void) myTableLoadMore
{
    pageIndex ++;
    [self.myRequest publishWithPageNo:pageIndex];
}

#pragma mark -
#pragma mark - 网络数据放回
- (void) publishCallBack:(id) objectData
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

