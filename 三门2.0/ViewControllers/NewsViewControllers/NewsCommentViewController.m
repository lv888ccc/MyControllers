//
//  NewsCommentViewController.m
//  SanMen
//
//  Created by lcc on 13-12-22.
//  Copyright (c) 2013年 lcc. All rights reserved.
//

#import "NewsCommentViewController.h"
#import "MyTableView.h"
#import "CCClientRequest.h"
#import "CommentObject.h"
#import "LoginViewController.h"
#import "StatusTipView.h"

@interface NewsCommentViewController ()<MyTableViewDelegate,UITextViewDelegate>
{
    NSInteger pageIndex;
}

@property (nonatomic, strong) MyTableView *myTable;
@property (nonatomic, strong) NSMutableArray *tableData;
@property (nonatomic, strong) CCClientRequest *myRequest;

@property (strong, nonatomic) IBOutlet UIView *ui_commentWriteView;
@property (strong, nonatomic) IBOutlet UITextView *ui_textView;
@property (strong, nonatomic) IBOutlet UIButton *ui_markView;
@property (strong, nonatomic) IBOutlet UIButton *ui_commitBtn;
@property (strong, nonatomic) StatusTipView *tipView;

@property (strong, nonatomic) IBOutlet UIView *ui_failTipView;
@property (strong, nonatomic) IBOutlet UIButton *ui_noTipImageView;


@end

@implementation NewsCommentViewController

- (void)dealloc
{
    self.myTable.myTable_delegate = nil;
    self.myTable = nil;
    
    self.myRequest.c_delegate = nil;
    self.myRequest = nil;
    
    self.tableData = nil;
    self.ui_commentWriteView = nil;
    self.ui_markView = nil;
    self.ui_textView = nil;
    
    self.newsId = nil;
    self.ui_commitBtn = nil;
    self.tipView = nil;
    
    self.ui_failTipView = nil;
    self.ui_noTipImageView = nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        self.myRequest = [[CCClientRequest alloc] init];
        self.myRequest.c_delegate = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tipView = [[StatusTipView alloc] initWithFrame:CGRectMake(320, 160, 120, 70)];
    [self.view addSubview:self.tipView];
    
    //表的初始化
    self.tableData = [[NSMutableArray alloc] init];
    self.myTable = [[MyTableView alloc] initWithFrame:(CGRect){0,64,320,viewHeight - 108} style:UITableViewStylePlain];
    self.myTable.cellNameString = @"CommentCell";
    self.myTable.tableData = self.tableData;
    [self.myTable setMyTable_delegate:self];
    [self.myTable setfreshHeaderView:YES];
    [self.myTable setFooterViewHidden:YES];
    [self.view addSubview:self.myTable];
    [self.myTable setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    //end
    
    //控件属性设置
    self.ui_commentWriteView.frame = CGRectMake(0, viewHeight, 320, 145);
    self.ui_textView.backgroundColor = [UIColor clearColor];
    self.ui_commitBtn.enabled = NO;
    self.ui_noTipImageView.hidden = YES;
    //end
    
    //网络数据请求
    [self.myTable dragAnimation];
    [self.myTable reloadTableViewDataSource];
    //end
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [StatusBarObject setStatusBarStyleWithIndex:0];
}

#pragma mark -
#pragma mark - custom method
//禁用发送按钮
- (void) setBtnEnable
{
    if ([self.ui_textView.text stringByReplacingOccurrencesOfString:@" " withString:@""].length > 0 && [self.ui_textView.text stringByReplacingOccurrencesOfString:@"\n" withString:@""].length > 0)
    {
        self.ui_commitBtn.enabled = YES;
    }
    else
    {
        self.ui_commitBtn.enabled = NO;
    }
}

#pragma mark -
#pragma mark - 控件事件
- (IBAction)backTapped:(id)sender
{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app.nav popViewController];
}

- (IBAction)commentTapped:(id)sender
{
    [self.ui_textView becomeFirstResponder];
}

- (IBAction)markTapped:(id)sender
{
    [self.ui_textView resignFirstResponder];
}

- (IBAction)commitTapped:(id)sender
{
    if (SMApp.userObject)
    {
        if (self.isNews)
        {
            [self.myRequest commitCommentWithContent:self.ui_textView.text newsId:self.newsId userId:SMApp.userObject.u_id];
        }
        else
        {
            [self.myRequest paikeCommitCommentWithContent:self.ui_textView.text pId:self.newsId userId:SMApp.userObject.u_id];
        }
        
        [self.tipView tipShowWithType:InfoCommittingTip tipString:Committing isHidden:NO];
    }
    else
    {
        LoginViewController *login = [[LoginViewController alloc] init];
        AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [app.nav pushViewController:login];
    }
    
}

- (IBAction)freshTapped:(id)sender
{
    self.ui_failTipView.hidden = YES;
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
    
    if (self.isNews)
    {
        [self.myRequest newsCommentWithId:self.newsId pageNo:pageIndex];
    }
    else
    {
        [self.myRequest paikeCommentDetailWithPageNo:pageIndex pid:self.newsId];
    }
}

- (CGFloat) myTableRowHeightAtIndex:(NSIndexPath *)indexPath
{
    CommentObject *tmpObj = [self.tableData objectAtIndex:indexPath.row];
    CGSize size = [tmpObj.c_content sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(290, 1000) lineBreakMode:NSLineBreakByTruncatingTail];
    
    return size.height + 40;
}

- (void) myTabledidSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void) myTableLoadMore
{
    pageIndex ++;
    if (self.isNews)
    {
        [self.myRequest newsCommentWithId:self.newsId pageNo:pageIndex];
    }
    else
    {
        [self.myRequest paikeCommentDetailWithPageNo:pageIndex pid:self.newsId];
    }
}

#pragma mark -
#pragma mark - textView delegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    [self performSelector:@selector(setBtnEnable) withObject:nil afterDelay:0.3];
    return YES;
}

#pragma mark -
#pragma mark - 消息处理函数
- (void)keyboardWillShow:(NSNotification *)notification
{
    
    [self.view bringSubviewToFront:self.ui_markView];
    self.ui_markView.hidden = NO;
    [self.view bringSubviewToFront:self.ui_commentWriteView];
    
    /* Move the toolbar to above the keyboard */
    CGRect keyboardFrame;
	[[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrame];
	CGFloat keyboardHight = CGRectGetHeight(keyboardFrame);
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.4];
    
	CGRect newRect = self.ui_commentWriteView.frame;
	newRect.origin = CGPointMake(0, [[UIScreen mainScreen] bounds].size.height - keyboardHight - newRect.size.height);
    self.ui_commentWriteView.frame = newRect;
    self.ui_markView.alpha = 0.5;
    
	[UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.ui_commentWriteView.frame;
        if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation))
        {
            frame.origin.y = self.view.frame.size.height;
        }
        else
        {
            frame.origin.y = self.view.frame.size.width;
        }
        self.ui_commentWriteView.frame = frame;
        self.ui_markView.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.ui_markView.hidden = YES;
    }];
    
}

#pragma mark -
#pragma mark - 网络数据回调
//新闻评论列表
- (void) newsCommentCallBack:(id) objectData
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
    
    if ([self.tableData count] == 0)
    {
        self.myTable.hidden = YES;
        self.ui_noTipImageView.hidden = NO;
    }
    else
    {
        self.myTable.hidden = NO;
        self.ui_noTipImageView.hidden = YES;
    }
}

//评论提交回调
- (void) commitCommentCallBack:(id) objectData
{
    if ([objectData count] > 0)
    {
        [self.view bringSubviewToFront:self.tipView];
        [self.tipView tipShowWithType:SuccessTipTypeTwo tipString:SucessComment isHidden:YES];
        self.ui_textView.text = @"";
        [self setBtnEnable];
        [self.ui_textView resignFirstResponder];
        
        if (self.newsDelegate && [self.newsDelegate respondsToSelector:@selector(addCommentCount)])
        {
            [self.newsDelegate performSelector:@selector(addCommentCount) withObject:nil];
        }
        
        [self.myTable dragAnimation];
        [self.myTable reloadTableViewDataSource];
    }
    else
    {
        [self.view bringSubviewToFront:self.tipView];
        [self.tipView tipShowWithType:CommittingFailTip tipString:FailTip isHidden:YES];
    }
}

//图集
- (void) paikeCommentDetailCallBack:(id) objectData
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
    
    if ([self.tableData count] == 0)
    {
        self.myTable.hidden = YES;
        self.ui_noTipImageView.hidden = NO;
    }
    else
    {
        self.myTable.hidden = NO;
        self.ui_noTipImageView.hidden = YES;
    }
}

//图集评论提交回调
- (void) paikeCommitCommentCallBack:(id) objectData
{
    if ([objectData count] > 0)
    {
        [self.view bringSubviewToFront:self.tipView];
        [self.tipView tipShowWithType:SuccessTipTypeTwo tipString:SucessComment isHidden:YES];
        self.ui_textView.text = @"";
        [self setBtnEnable];
        [self.ui_textView resignFirstResponder];
        
        if (self.newsDelegate && [self.newsDelegate respondsToSelector:@selector(addCommentCount)])
        {
            [self.newsDelegate performSelector:@selector(addCommentCount) withObject:nil];
        }
        
        [self.myTable dragAnimation];
        [self.myTable reloadTableViewDataSource];
    }
    else
    {
        [self.view bringSubviewToFront:self.tipView];
        [self.tipView tipShowWithType:CommittingFailTip tipString:FailTip isHidden:YES];
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
        }
        
        if (self.ui_noTipImageView.hidden == YES)
        {
            self.ui_failTipView.hidden = NO;
        }
        
        [self.view bringSubviewToFront:self.tipView];
        [self.tipView tipShowWithType:SigleNetFailTip tipString:NetFailTip isHidden:YES];
    }
}



@end
