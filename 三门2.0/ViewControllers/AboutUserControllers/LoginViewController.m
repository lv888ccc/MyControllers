//
//  LoginViewController.m
//  SanMen
//
//  Created by lcc on 13-12-24.
//  Copyright (c) 2013年 lcc. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "CCClientRequest.h"
#import "StatusTipView.h"

@interface LoginViewController ()<UITextFieldDelegate>

@property (strong, nonatomic) CCClientRequest *myRequest;

@property (strong, nonatomic) IBOutlet StatusTipView *tipView;
@property (strong, nonatomic) IBOutlet UITextField *ui_phoneTxt;
@property (strong, nonatomic) IBOutlet UITextField *ui_pswTxt;
@property (strong, nonatomic) IBOutlet UILabel *ui_errorLabel;

@end

@implementation LoginViewController

- (void)dealloc
{
    self.tipView = nil;
    
    self.myRequest.c_delegate = nil;
    self.myRequest = nil;
    self.ui_phoneTxt = nil;
    self.ui_pswTxt = nil;
    self.ui_errorLabel = nil;
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [StatusBarObject setStatusBarStyleWithIndex:1];
}

#pragma mark -
#pragma mark - custom method
- (void) popToViewController
{
    [[NSNotificationCenter defaultCenter] postNotificationName:LOGINSUCCESSNOTIFICATION object:nil];
    [SMApp.nav popViewController];
}

#pragma mark -
#pragma mark - 控件事件
- (IBAction)backTapped:(id)sender
{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app.nav popViewController];
}

//忘记密码
- (IBAction)forgetPswTapped:(id)sender
{
    RegisterViewController *regist = [[RegisterViewController alloc] init];
    regist.isRegist = NO;
    [SMApp.nav pushViewController:regist];
}

//注册
- (IBAction)registTapped:(id)sender
{
    RegisterViewController *regist = [[RegisterViewController alloc] init];
    regist.isRegist = YES;
    [SMApp.nav pushViewController:regist];
}

//登陆
- (IBAction)loginTapped:(id)sender
{
    if ([self.ui_phoneTxt.text stringByReplacingOccurrencesOfString:@" " withString:@""].length == 0)
    {
        self.ui_errorLabel.text = NicknameNil;
        [self.ui_phoneTxt becomeFirstResponder];
        return;
    }
    
    if ([self.ui_pswTxt.text stringByReplacingOccurrencesOfString:@" " withString:@""].length == 0)
    {
        self.ui_errorLabel.text = PswNil;
        [self.ui_pswTxt becomeFirstResponder];
        return;
    }
    
    [self.myRequest userLoginWithPhoneNo:self.ui_phoneTxt.text psw:self.ui_pswTxt.text];
    
    [self.tipView tipShowWithType:InfoCommittingTip tipString:Loginning isHidden:NO];
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
- (void) userLoginCallBack:(id) objectData
{
    NSString *tmpReturnString = [NSString stringWithFormat:@"%d",DataIsNull];
    @try
    {
        tmpReturnString = [objectData objectAtIndex:0];
    }
    @catch (NSException *exception)
    {
        tmpReturnString = [NSString stringWithFormat:@"%d",DataIsNull];
        self.ui_errorLabel.text = Erroring;
    }
    @finally
    {
        
    }
    
    switch ([tmpReturnString intValue])
    {
        case Success:
            [self.tipView tipShowWithType:SuccessTip tipString:SuccessLogin isHidden:YES];
            [self performSelector:@selector(popToViewController) withObject:nil afterDelay:1.4];
            break;
            
        case DataIsNull:
            [self.tipView tipShowWithType:CommittingFailTip tipString:FailTip  isHidden:YES];
            self.ui_errorLabel.text = NoInfo;
            break;
            
        default:
            
            break;
    }
}

#pragma mark -
#pragma mark - 网络回调失败
- (void) failLoadData:(id) reasonString
{
    if (reasonString)
    {
        [self.view bringSubviewToFront:self.tipView];
        [self.tipView tipShowWithType:SigleNetFailTip tipString:NetFailTip  isHidden:YES];
    }
}


@end
