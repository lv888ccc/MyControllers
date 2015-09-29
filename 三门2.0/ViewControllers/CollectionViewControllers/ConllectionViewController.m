//
//  ConllectionViewController.m
//  SanMen
//
//  Created by lcc on 13-12-21.
//  Copyright (c) 2013年 lcc. All rights reserved.
//

#import "ConllectionViewController.h"
#import "MyTableView.h"
#import "NewsDetailViewController.h"
#import "FMDBManage.h"
#import "CollectionObject.h"
#import "ThemeDetailViewController.h"

@interface ConllectionViewController ()<MyTableViewDelegate>
{
    BOOL isEdited;
}

@property (nonatomic, strong) MyTableView *myTable;
@property (nonatomic, strong) NSMutableArray *tableData;
@property (strong, nonatomic) IBOutlet UIImageView *ui_tipImgView;
@property (strong, nonatomic) IBOutlet UIView *ui_bgView;
@property (strong, nonatomic) IBOutlet UIButton *ui_editBtn;


@end

@implementation ConllectionViewController

- (void)dealloc
{
    self.myTable.myTable_delegate = nil;
    self.myTable = nil;
    self.tableData = nil;
    self.ui_tipImgView = nil;
    self.ui_bgView = nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    isEdited = NO;
    
    //表的初始化
    self.tableData = [[NSMutableArray alloc] init];
    self.myTable = [[MyTableView alloc] initWithFrame:(CGRect){0,64,320,viewHeight - 64} style:UITableViewStylePlain];
    self.myTable.cellNameString = @"CollectionCell";
    self.myTable.tableData = self.tableData;
    [self.myTable setMyTable_delegate:self];
    [self.myTable setCellDelegateObject:self];
    [self.myTable setfreshHeaderView:NO];
    [self.myTable setFooterViewHidden:YES];
    [self.view addSubview:self.myTable];
    [self.myTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
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
    
    //数据库读取
    NSArray *tmpArr = [FMDBManage getDataFromTable:[CollectionObject class] WithString:@"1=1 order by c_collectionTime desc"];
    if ([tmpArr count] > 0)
    {
        [self.tableData removeAllObjects];
        [self.tableData addObjectsFromArray:tmpArr];
        self.myTable.tableData = self.tableData;
        [self.myTable doneLoadingTableViewData];
        self.ui_editBtn.hidden = NO;
    }
    else
    {
        [self.view bringSubviewToFront:self.ui_bgView];
        self.ui_editBtn.hidden = YES;
    }
}

#pragma mark -
#pragma mark - custom method
- (void) freshTable
{
    [self.myTable doneLoadingTableViewData];
}

#pragma mark -
#pragma mark - 控件事件
- (IBAction)backTapped:(id)sender
{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app.nav popViewController];
}

- (IBAction)editTapped:(id)sender
{
    CGFloat x = 0;
    if (isEdited == NO)
    {
        x = -60;
        [self.ui_editBtn setTitle:@"完成" forState:UIControlStateNormal];
    }
    else
    {
        x = 0;
        [self.ui_editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    }
    
    [UIView beginAnimations:@"" context:nil];
    [UIView setAnimationDuration:0.3];
    
    for (int i = 0; i < [self.tableData count]; i ++)
    {
        UITableViewCell *tmpCell = [self.myTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        UIView *tmpThemeView = [tmpCell viewWithTag:201];
        UIView *tmpNewsView = [tmpCell viewWithTag:200];
        UIImageView *timeBgView = (UIImageView *)[tmpCell viewWithTag:130];
        
        CGRect rectTheme = tmpThemeView.frame;
        rectTheme.origin.x = x;
        tmpThemeView.frame = rectTheme;
        
        CGRect rectNews = tmpNewsView.frame;
        rectNews.origin.x = x;
        tmpNewsView.frame = rectNews;
        
        CGRect rectTime = timeBgView.frame;
        rectTime.origin.x = x + 12;
        timeBgView.frame = rectTime;
        
        CollectionObject *tmpObj = [self.tableData objectAtIndex:i];
        if (isEdited == NO)
        {
            tmpObj.c_isEdit = @"1";
        }
        else
        {
            tmpObj.c_isEdit = @"0";
        }
    }
    
    [UIView commitAnimations];
    
    isEdited = !isEdited;
}

#pragma mark -
#pragma mark - custom delegate
//表的代理
- (void) myTableViewLoadDataAgain
{
    
}

- (CGFloat) myTableRowHeightAtIndex:(NSIndexPath *)indexPath
{
    CollectionObject *tmpObj = [self.tableData objectAtIndex:indexPath.row];
    if ([tmpObj.c_modelType integerValue] == THEMEPRO)
    {
        return 109 + 29;
    }
    return 109;
}

- (void) myTabledidSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!isEdited)
    {
        CollectionObject *tmpObj = [self.tableData objectAtIndex:indexPath.row];
        
        if ([tmpObj.c_modelType integerValue] != THEMEPRO)
        {
            NewsDetailViewController *newsDetail = [[NewsDetailViewController alloc] init];
            newsDetail.newsId = tmpObj.c_id;
            AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [app.nav pushViewController:newsDetail];
        }
    }
}

#pragma mark -
#pragma mark - cell delegate
- (void) collectionCellTapWithIndex:(NSIndexPath *) index
{
    CollectionObject *tmpObj = [self.tableData objectAtIndex:index.row];
    NSString *newsId = tmpObj.c_id;
    
    [self.tableData removeObjectAtIndex:index.row];
    [self.myTable deleteRowsAtIndexPaths:[NSArray arrayWithObjects:index, nil] withRowAnimation:UITableViewRowAnimationLeft];
    self.myTable.tableData = self.tableData;
    [self performSelector:@selector(freshTable) withObject:nil afterDelay:0.3];
    
    if ([self.tableData count] == 0)
    {
        [self.view bringSubviewToFront:self.ui_bgView];
        self.ui_editBtn.hidden = YES;
    }
    
    [FMDBManage deleteFromTable:[CollectionObject class] WithString:[NSString stringWithFormat:@"c_id='%@' and c_modelType='%@'",newsId,tmpObj.c_modelType]];
}

- (void) collectionCellTapWithObject:(id) object
{
    NSString *tmpString = [((NSDictionary *)object).allKeys objectAtIndex:0];
    CollectionObject *tmpObj = [object objectForKey:tmpString];
    
    ThemeObject *tmpTObj = [[ThemeObject alloc] init];
    tmpTObj.t_id = tmpObj.c_id;
    tmpTObj.t_imgUrl = tmpObj.c_imgUrl;
    tmpTObj.t_title = tmpObj.c_title;
    tmpTObj.t_index = tmpString;
    
    ThemeDetailViewController *browse = [[ThemeDetailViewController alloc] init];
    browse.themeObject = tmpTObj;
    browse.isLight = YES;
    [SMApp.nav pushViewController:browse];
}

@end
