//
//  PaiKeContentDetailViewController.m
//  SanMen
//
//  Created by lcc on 13-12-25.
//  Copyright (c) 2013年 lcc. All rights reserved.
//

#import "PaiKeContentDetailViewController.h"
#import "ScrollImagesBrowseViewController.h"
#import "UIImageView+WebCache.h"
#import "MyTableView.h"
#import "CCClientRequest.h"
#import "PaiKeObject.h"
#import "LoginViewController.h"
#import "CommentObject.h"
#import "StatusTipView.h"

#define CONTENTLABELTAG 10000

@interface PaiKeContentDetailViewController ()<MyTableViewDelegate>
{
    NSInteger pageIndex;
}

@property (nonatomic, strong) MyTableView *myTable;
@property (nonatomic, strong) NSMutableArray *tableData;
@property (nonatomic, strong) CCClientRequest *myRequest;

@property (strong, nonatomic) IBOutlet UIView *ui_tableHeaderView;
@property (strong, nonatomic) IBOutlet UIView *ui_imgView;
@property (strong, nonatomic) IBOutlet UIImageView *ui_imgContentView;
@property (strong, nonatomic) IBOutlet UILabel *ui_nickName;
@property (strong, nonatomic) IBOutlet UILabel *ui_timeLabel;
@property (strong, nonatomic) IBOutlet UILabel *ui_commentSignLabel;

@property (strong, nonatomic) IBOutlet UIButton *ui_markView;
@property (strong, nonatomic) IBOutlet UIView *ui_commentWriteView;
@property (strong, nonatomic) IBOutlet UITextView *ui_textView;
@property (strong, nonatomic) IBOutlet UILabel *ui_titleLabel;

@property (strong, nonatomic) IBOutlet UILabel *ui_freshTipLabel;
@property (strong, nonatomic) StatusTipView *tipView;
@property (strong, nonatomic) IBOutlet UIButton *ui_imgsBtn;
@property (strong, nonatomic) IBOutlet UIButton *ui_commitBtn;
@property (strong, nonatomic) PaiKeObject *paiKeObject;

@end

@implementation PaiKeContentDetailViewController

- (void)dealloc
{
    self.pId = nil;
    
    self.tableData = nil;
    self.myTable.myTable_delegate = nil;
    self.myTable = nil;
    
    self.ui_tableHeaderView = nil;
    self.ui_imgView = nil;
    self.ui_imgContentView = nil;
    self.ui_nickName = nil;
    self.ui_timeLabel = nil;
    self.ui_commentSignLabel = nil;
    
    self.ui_markView = nil;
    self.ui_commentWriteView = nil;
    self.ui_textView = nil;
    
    self.myRequest.c_delegate = nil;
    self.myTable = nil;
    self.ui_titleLabel = nil;
    
    self.ui_freshTipLabel = nil;
    self.tipView = nil;
    self.ui_imgsBtn = nil;
    self.ui_commitBtn = nil;
    self.paiKeObject = nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.myRequest = [[CCClientRequest alloc] init];
        self.myRequest.c_delegate = self;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
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
    
    //控件属性设置
    self.ui_commentWriteView.frame = CGRectMake(0, viewHeight, 320, 145);
    self.ui_textView.backgroundColor = [UIColor clearColor];
    self.ui_commitBtn.enabled = NO;
    //end
    
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
    if (self.isLight == YES)
    {
        [StatusBarObject setStatusBarStyleWithIndex:1];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
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

- (void) setHeader
{
    self.myTable.tableHeaderView = self.ui_tableHeaderView;
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

- (IBAction)imgTapped:(id)sender
{
    ScrollImagesBrowseViewController *browseImg = [[ScrollImagesBrowseViewController alloc] init];
    browseImg.pId = self.pId;
    
    if ([self.paiKeObject.p_count isEqualToString:@""] || [self.paiKeObject.p_count isEqualToString:@"0"])
    {
        browseImg.urlString = [[self.paiKeObject.p_imgUrl componentsSeparatedByString:@"@"] objectAtIndex:0];
    }
    
    [SMApp.nav pushViewController:browseImg];
}

#pragma mark -
#pragma mark - custom delegate
//表的代理
- (void) myTableViewLoadDataAgain
{
    pageIndex = 1;
    [self.myRequest paikeContentDetailWithPid:self.pId];
    [self.myRequest paikeCommentDetailWithPageNo:pageIndex pid:self.pId];
}

- (CGFloat) myTableRowHeightAtIndex:(NSIndexPath *)indexPath
{
    CommentObject *tmpObj = [self.tableData objectAtIndex:indexPath.row];
    CGSize size = [tmpObj.c_content sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(290, 1000) lineBreakMode:NSLineBreakByTruncatingTail];
    
    return size.height + 40;
}

- (void) myTableLoadMore
{
    pageIndex ++;
    [self.myRequest paikeCommentDetailWithPageNo:pageIndex pid:self.pId];
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
#pragma mark - 控件事件
- (IBAction)commitTapped:(id)sender
{
    if (SMApp.userObject)
    {
        [self.myRequest paikeCommitCommentWithContent:self.ui_textView.text pId:self.pId userId:SMApp.userObject.u_id];

        [self.view bringSubviewToFront:self.tipView];
        [self.tipView tipShowWithType:InfoCommittingTip tipString:Committing isHidden:NO];
    }
    else
    {
        LoginViewController *login = [[LoginViewController alloc] init];
        AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [app.nav pushViewController:login];
    }
    
}

#pragma mark -
#pragma mark - 网络数据放回
- (void) paikeContentDetailCallBack:(id) objectData
{
    NSMutableArray *tmpArr = (NSMutableArray *)objectData;
    if ([tmpArr count] > 0)
    {
        PaiKeObject *tmpObj = [tmpArr objectAtIndex:0];
        self.paiKeObject = tmpObj;
        [self.ui_imgContentView setImageWithURL:[NSURL URLWithString:tmpObj.p_imgUrl] placeholderImage:[UIImage imageNamed:@"home_cell_place"]];
        
        if ([self.tableData count] > 0)
        {
            self.ui_commentSignLabel.hidden = NO;
        }
        
        CGSize size = [tmpObj.p_subTitle sizeWithFont:[UIFont systemFontOfSize:15.0f] constrainedToSize:CGSizeMake(300, 1000) lineBreakMode:NSLineBreakByTruncatingTail];
        
        UILabel *contentLabel = (UILabel *)[self.ui_tableHeaderView viewWithTag:CONTENTLABELTAG];
        if (!contentLabel)
        {
            contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 250, 300, 0)];
            [self.ui_tableHeaderView addSubview:contentLabel];
        }
    
        contentLabel.textColor = [UIColor darkGrayColor];
        contentLabel.font = [UIFont systemFontOfSize:15];
        contentLabel.numberOfLines = 0;
        contentLabel.tag = CONTENTLABELTAG;
        
        CGRect lRect = contentLabel.frame;
        lRect.size.height = size.height;
        contentLabel.frame = lRect;
        
        CGRect sRect = self.ui_commentSignLabel.frame;
        sRect.origin.y = 265 + size.height;
        self.ui_commentSignLabel.frame = sRect;
        
        CGRect hRect = self.ui_tableHeaderView.frame;
        hRect.size.height = 285 + size.height;
        self.ui_tableHeaderView.frame = hRect;
        
        self.ui_titleLabel.text = tmpObj.p_title;
        contentLabel.text = tmpObj.p_subTitle;
        self.ui_timeLabel.text = tmpObj.p_time;
        self.ui_nickName.text = tmpObj.p_name;
        tmpObj.p_count = [NSString stringWithFormat:@"%@",tmpObj.p_count];
        
        if ([tmpObj.p_count isEqualToString:@""] || [tmpObj.p_count isEqualToString:@"0"])
        {
            self.ui_imgsBtn.hidden = YES;
        }
        
        [self.ui_imgsBtn setTitle:@"图 集" forState:UIControlStateNormal];
    }
    
    
}

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
        if ([tmpArr count] == 0)
        {
            self.ui_commentSignLabel.hidden = YES;
        }
        else
        {
            self.ui_commentSignLabel.hidden = NO;
        }
        
        [self.tableData removeAllObjects];
    }
    
    [self.tableData addObjectsFromArray:tmpArr];
    self.myTable.tableData = self.tableData;
    [self.myTable doneLoadingTableViewData];
    
    [self performSelector:@selector(setHeader) withObject:nil afterDelay:0.5];
}

//评论提交回调
- (void) paikeCommitCommentCallBack:(id) objectData
{
    [self.view bringSubviewToFront:self.tipView];
    if ([objectData count] > 0)
    {
        [self.tipView tipShowWithType:SuccessTipTypeTwo tipString:SucessComment isHidden:YES];
        self.ui_textView.text = @"";
        [self setBtnEnable];
        [self.ui_textView resignFirstResponder];
        
        [self.myTable dragAnimation];
        [self.myTable reloadTableViewDataSource];
    }
    else
    {
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
            self.ui_freshTipLabel.hidden = NO;
        }
        [self.view bringSubviewToFront:self.tipView];
        [self.tipView tipShowWithType:SigleNetFailTip tipString:NetFailTip isHidden:YES];
    }

}

@end
