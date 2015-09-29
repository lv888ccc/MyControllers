//
//  ChangeNickNameViewController.m
//  SanMen
//
//  Created by lcc on 13-12-25.
//  Copyright (c) 2013年 lcc. All rights reserved.
//

#import "ChangeNickNameViewController.h"
#import "CCClientRequest.h"
#import "FMDBManage.h"
#import "StatusTipView.h"

@interface ChangeNickNameViewController ()<UITextFieldDelegate>

@property (strong, nonatomic) CCClientRequest *myRequest;

@property (strong, nonatomic) IBOutlet UITextField *ui_nicknameTxt;
@property (strong, nonatomic) StatusTipView *tipView;
@property (strong, nonatomic) IBOutlet UILabel *ui_errorLabel;
@property (strong, nonatomic) IBOutlet UIButton *ui_finishBtn;

@end

@implementation ChangeNickNameViewController

- (void)dealloc
{
    self.nickName = nil;
    self.ui_nicknameTxt = nil;
    
    self.tipView = nil;
    self.ui_errorLabel = nil;
    self.ui_finishBtn = nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
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
   
    self.ui_nicknameTxt.text = self.nickName;
    self.ui_finishBtn.enabled = NO;
    [self.ui_finishBtn setBackgroundColor:[UIColor lightGrayColor]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - custom method
- (void) popViewController
{
    [FMDBManage updateTable:SMApp.userObject setString:[NSString stringWithFormat:@"u_userName='%@'",self.ui_nicknameTxt.text] WithString:[NSString stringWithFormat:@"u_id='%@'",SMApp.userObject.u_id]];
    [SMApp.nav popViewController];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:LOGINSUCCESSNOTIFICATION object:nil];
}

#pragma mark -
#pragma mark - custom method
//禁用发送按钮
- (void) setBtnEnable
{
    if ([[self.ui_nicknameTxt.text stringByReplacingOccurrencesOfString:@" " withString:@""] isEqualToString:self.nickName])
    {
        self.ui_finishBtn.enabled = NO;
        [self.ui_finishBtn setBackgroundColor:[UIColor lightGrayColor]];
    }
    else
    {
        self.ui_finishBtn.enabled = YES;
        [self.ui_finishBtn setBackgroundColor:[UIColor colorWithRed:50.0f/255.0f green:137.0f/255.0f blue:217.0f/255.0f alpha:1.0f]];
    }
}

#pragma mark -
#pragma mark - 控件事件
- (IBAction)backTapped:(id)sender
{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app.nav popViewController];
}

- (IBAction)finishTapped:(id)sender
{
    if ([self.ui_nicknameTxt.text stringByReplacingOccurrencesOfString:@" " withString:@""].length == 0)
    {
        self.ui_errorLabel.text = @"您用户名是空哦";
        return;
    }
    
    [self.myRequest changeNicknameWithUid:SMApp.userObject.u_id nickname:self.ui_nicknameTxt.text];
    
    [self.view bringSubviewToFront:self.tipView];
    [self.tipView tipShowWithType:InfoCommittingTip tipString:Committing isHidden:NO];
}

#pragma mark -
#pragma mark - textField delegate
- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    [self performSelector:@selector(setBtnEnable) withObject:nil afterDelay:0.3];
    
    return YES;
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark -
#pragma mark - 网络数据回调
- (void) changeNicknameCallBack:(id) objectData
{
    if ([objectData count] > 0)
    {
        [self.tipView tipShowWithType:SuccessTipTypeTwo tipString:SuccessPsw isHidden:YES];
        [self performSelector:@selector(popViewController) withObject:nil afterDelay:1.4];
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
    if (reasonString)
    {
        [self.view bringSubviewToFront:self.tipView];
        [self.tipView tipShowWithType:SigleNetFailTip tipString:NetFailTip isHidden:YES];
    }
}


@end
