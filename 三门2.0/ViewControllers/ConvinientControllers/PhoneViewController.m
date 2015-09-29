//
//  PhoneViewController.m
//  SanMen
//
//  Created by lcc on 14-2-13.
//  Copyright (c) 2014年 lcc. All rights reserved.
//

#import "PhoneViewController.h"
#import "MyTableView.h"
#import "CCClientRequest.h"
#import "StatusTipView.h"
#import "ConVinientObject.h"
#import "FMDBManage.h"

@interface PhoneViewController ()<MyTableViewDelegate>
{
    UIWebView *webView;
    NSInteger pageIndex;
}

@property (nonatomic, strong) MyTableView *myTable;
@property (nonatomic, strong) NSMutableArray *tableData;
@property (nonatomic, strong) CCClientRequest *myRequest;

@property (strong, nonatomic) IBOutlet UILabel *ui_freshTipLabel;
@property (strong, nonatomic) StatusTipView *tipView;

@end

@implementation PhoneViewController

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
    
    webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:webView];
    
    self.view.clipsToBounds = YES;
    self.ui_freshTipLabel.hidden = YES;
    self.tipView = [[StatusTipView alloc] initWithFrame:CGRectMake(320, 160, 120, 70)];
    [self.view addSubview:self.tipView];
    
    //表的初始化
    self.tableData = [[NSMutableArray alloc] init];
    
    [self readLocalDB];
    
    self.myTable = [[MyTableView alloc] initWithFrame:(CGRect){0,64,320,viewHeight - 64} style:UITableViewStylePlain];
    self.myTable.cellNameString = @"PhoneListCell";
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
    NSArray *tmpArr = [FMDBManage getDataFromTable:[ConVinientObject class] WithString:[NSString stringWithFormat:@"c_type='%@'",PHONENOLISTMETHOD]];
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
    [self.myRequest phoneNOList];
}

- (CGFloat) myTableRowHeightAtIndex:(NSIndexPath *)indexPath
{
    return 65;
}

- (void) myTabledidSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ConVinientObject *tmpObj = [self.tableData objectAtIndex:indexPath.row];
    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",tmpObj.c_phoneNo]];
    [webView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
}

#pragma mark -
#pragma mark - 网络数据返回
- (void) phoneNOListCallBack:(id) objectData
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
