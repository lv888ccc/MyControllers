//
//  RegisterViewController.m
//  SanMen
//
//  Created by lcc on 13-12-24.
//  Copyright (c) 2013年 lcc. All rights reserved.
//

#import "RegisterViewController.h"
#import "EnterInvateCodeViewController.h"
#import "Validate.h"
#import "CCClientRequest.h"
#import "StatusTipView.h"

@interface RegisterViewController ()<UITextFieldDelegate>

@property (strong, nonatomic) CCClientRequest *myRequest;

@property (strong, nonatomic) IBOutlet UILabel *ui_redTipLabel;
@property (strong, nonatomic) IBOutlet UITextField *ui_text;

@property (strong, nonatomic) StatusTipView *tipView;
@property (strong, nonatomic) IBOutlet UILabel *ui_titleLabel;

@end

@implementation RegisterViewController

- (void)dealloc
{
    self.ui_redTipLabel = nil;
    self.ui_text = nil;
    
    self.myRequest.c_delegate = nil;
    self.myRequest = nil;
    
    self.tipView = nil;
    self.ui_titleLabel = nil;

    self.ui_redTipLabel = nil;
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
    
    if (self.isRegist == YES)
    {
        self.ui_titleLabel.text = @"注 册";
    }
    else
    {
        self.ui_titleLabel.text = @"忘记密码";
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - custom method
- (void) pushNextController:(NSString *)codeString
{
    EnterInvateCodeViewController *enterInvate = [[EnterInvateCodeViewController alloc] init];
    enterInvate.phoneNo = self.ui_text.text;
    enterInvate.isRegist = self.isRegist;
    enterInvate.codeString = codeString;
    [SMApp.nav pushViewController:enterInvate];
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
     if (![Validate isMobileNumber:self.ui_text.text])
     {
         self.ui_redTipLabel.text = ErrorNo;
         return;
     }
    else
    {
        self.ui_redTipLabel.text = @"";
    }
    
    if (self.isRegist)
    {
        [self.myRequest noticeSendMsgWithPhoneNo:self.ui_text.text type:REGISTER];
    }
    else
    {
        [self.myRequest noticeSendMsgWithPhoneNo:self.ui_text.text type:FORGETPSW];
    }
    
    [self.tipView tipShowWithType:InfoCommittingTip tipString:Committing isHidden:NO];
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
    NSString *tmpReturnString = [NSString stringWithFormat:@"%d",DataIsNull];
    //最终删掉
    NSString *codeString = @"";
    
    @try
    {
        tmpReturnString = [objectData objectAtIndex:0];
        if ([objectData count] > 1)
        {
            codeString = [[objectData objectAtIndex:1] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        }
    }
    @catch (NSException *exception)
    {
        tmpReturnString = [NSString stringWithFormat:@"%d",DataIsNull];
        self.ui_redTipLabel.text = Erroring;
    }
    @finally
    {
        switch ([tmpReturnString intValue])
        {
            case Success:
                [self.tipView tipShowWithType:SuccessTip tipString:SendingCode isHidden:YES];
                [self performSelector:@selector(pushNextController:) withObject:codeString afterDelay:1.4];
                break;
            case RegExistAccount:
                [self.tipView tipShowWithType:CommittingFailTip tipString:FailTip isHidden:YES];
                self.ui_redTipLabel.text = RegistAlready;
                break;
            case DataIsNotExist:
                [self.tipView tipShowWithType:CommittingFailTip tipString:FailTip isHidden:YES];
                self.ui_redTipLabel.text = NoPhoneNo;
                break;
                
            default:
            [self.tipView tipShowWithType:CommittingFailTip tipString:FailTip isHidden:YES];
                break;
        }
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
