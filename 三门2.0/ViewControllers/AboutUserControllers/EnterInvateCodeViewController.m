//
//  EnterInvateCodeViewController.m
//  SanMen
//
//  Created by lcc on 13-12-25.
//  Copyright (c) 2013年 lcc. All rights reserved.
//

#import "EnterInvateCodeViewController.h"
#import "FinishRegistViewController.h"
#import "CCClientRequest.h"
#import "CommitPswViewController.h"
#import "StatusTipView.h"

@interface EnterInvateCodeViewController ()<UITextFieldDelegate>
{
    NSTimer *timer;
    NSInteger count;
}

@property (strong, nonatomic) CCClientRequest *myRequest;

@property (strong, nonatomic) IBOutlet UILabel *ui_phoneLabel;
@property (strong, nonatomic) IBOutlet UILabel *ui_timeTipLabel;
@property (strong, nonatomic) IBOutlet UIButton *ui_againBtn;
@property (strong, nonatomic) IBOutlet UITextField *ui_text;
@property (strong, nonatomic) IBOutlet UILabel *ui_errorLabel;

@property (strong, nonatomic) StatusTipView *tipView;
@property (strong, nonatomic) IBOutlet UILabel *ui_titleLabel;
@property (strong, nonatomic) IBOutlet UIView *ui_againview;

@end

@implementation EnterInvateCodeViewController

- (void)dealloc
{
    [timer invalidate];
    self.ui_phoneLabel = nil;
    self.ui_timeTipLabel = nil;
    self.ui_againBtn = nil;
    
    self.myRequest.c_delegate = nil;
    self.myRequest = nil;
    
    self.tipView = nil;
    self.ui_text = nil;
    self.ui_titleLabel = nil;
    self.ui_againview = nil;
    self.codeString = nil;
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
    
    count = 60;
    self.ui_againview.hidden = YES;
    
    if (self.isRegist == YES)
    {
        self.ui_titleLabel.text = @"注 册";
    }
    else
    {
        self.ui_titleLabel.text = @"忘记密码";
    }
    
    self.ui_phoneLabel.text = [NSString stringWithFormat:@"验证码已发送至 %@",self.phoneNo];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1
                                             target:self
                                           selector:@selector(countTime)
                                           userInfo:nil
                                            repeats:YES];
    
    self.tipView = [[StatusTipView alloc] initWithFrame:CGRectMake(320, 160, 120, 70)];
    [self.view addSubview:self.tipView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - custom method
//倒计时
- (void) countTime
{
    count --;
    if (count == 0)
    {
        [timer invalidate];
        count = 60;
        self.ui_timeTipLabel.hidden = YES;
        self.ui_againview.hidden = NO;
    }
    
    self.ui_timeTipLabel.text = [NSString stringWithFormat:@"重新发送验证码(%d)",count];
}

- (void) pushNextController
{
    if (self.isRegist)
    {
        FinishRegistViewController *finishRegist = [[FinishRegistViewController alloc] init];
        finishRegist.phoneNo = self.phoneNo;
        AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [app.nav pushViewController:finishRegist];
    }
    else
    {
        CommitPswViewController *commitPsw = [[CommitPswViewController alloc] init];
        commitPsw.phoneNo = self.phoneNo;
        [SMApp.nav pushViewController:commitPsw];
    }
    
}

#pragma mark -
#pragma mark - 控件事件
- (IBAction)backTapped:(id)sender
{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app.nav popViewController];
}

- (IBAction)nextTapped:(id)sender
{
    if ([self.ui_text.text stringByReplacingOccurrencesOfString:@" " withString:@""].length == 0)
    {
        
        self.ui_errorLabel.text = CodeNil;
        return;
    }
    else
    {
        self.ui_errorLabel.text = @"";
    }
    
    //是注册还是忘记密码
    if (self.isRegist)
    {
        [self.myRequest compareCodeWithPhoneNo:self.phoneNo type:REGISTER code:self.ui_text.text];
    }
    else
    {
        [self.myRequest compareCodeWithPhoneNo:self.phoneNo type:FORGETPSW code:self.ui_text.text];
    }
    
    [self.tipView tipShowWithType:InfoCommittingTip tipString:Committing isHidden:NO];
}

//再次发送验证码
- (IBAction)sendAgainTapped:(id)sender
{
    if (self.isRegist)
    {
        [self.myRequest noticeSendMsgWithPhoneNo:self.phoneNo type:REGISTER];
    }
    else
    {
        [self.myRequest noticeSendMsgWithPhoneNo:self.phoneNo type:FORGETPSW];
    }
    
    [self.tipView tipShowWithType:InfoCommittingTip tipString:Committing isHidden:NO];
    
    self.ui_againview.hidden = YES;
    self.ui_timeTipLabel.hidden = NO;
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1
                                             target:self
                                           selector:@selector(countTime)
                                           userInfo:nil
                                            repeats:YES];
}

#pragma mark -
#pragma mark - textfield delegate
- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark -
#pragma mark - 网络数据回调
- (void) noticeSendMsgCallBack:(id) objectData
{
    if ([objectData count] > 0)
    {
        [self.tipView tipShowWithType:SuccessTip tipString:AlreadySent isHidden:YES];
    }
    else
    {
        [self.tipView tipShowWithType:CommittingFailTip tipString:FailTip isHidden:YES];
    }
}

- (void) compareCodeCallBack:(id) objectData
{
    if ([objectData count] > 0)
    {
        NSString *tmpString = [objectData objectAtIndex:0];
        
        switch ([tmpString integerValue])
        {
            case Success:
                [self.tipView tipShowWithType:SuccessTipTypeTwo tipString:SuccessPassCode isHidden:YES];
                [self performSelector:@selector(pushNextController) withObject:nil afterDelay:1.4];
                break;
                
            case Failure:
                [self.tipView tipShowWithType:CommittingFailTip tipString:FailTip isHidden:YES];
                self.ui_errorLabel.text = CodeFailCompare;
                break;
                
            default:
                break;
        }
    }
    else
    {
        [self.tipView tipShowWithType:CommittingFailTip tipString:FailTip isHidden:YES];
        self.ui_errorLabel.text = CodeNil;
    }
}

#pragma mark -
#pragma mark - 网络回调失败
- (void) failLoadData:(id) reasonString
{
    if (reasonString)
    {
        self.ui_againview.hidden = NO;
        self.ui_timeTipLabel.hidden = YES;
        
        [self.view bringSubviewToFront:self.tipView];
        [self.tipView tipShowWithType:SigleNetFailTip tipString:NetFailTip isHidden:YES];
    }
}

@end
