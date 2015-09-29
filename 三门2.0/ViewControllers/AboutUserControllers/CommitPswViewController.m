//
//  CommitPswViewController.m
//  SanMen
//
//  Created by lcc on 14-1-13.
//  Copyright (c) 2014年 lcc. All rights reserved.
//

#import "CommitPswViewController.h"
#import "CCClientRequest.h"
#import "StatusTipView.h"

@interface CommitPswViewController ()<UITextFieldDelegate>

@property (strong, nonatomic) CCClientRequest *myRequest;

@property (strong, nonatomic) StatusTipView *tipView;
@property (strong, nonatomic) IBOutlet UITextField *ui_pswTxt;
@property (strong, nonatomic) IBOutlet UILabel *ui_errorLabel;

@end

@implementation CommitPswViewController

- (void)dealloc
{
    self.myRequest.c_delegate = nil;
    self.myRequest = nil;
    
    self.tipView = nil;
    self.ui_errorLabel = nil;
    self.ui_pswTxt = nil;
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
}

#pragma mark -
#pragma mark - custom method
- (void) popToViewController
{
    [SMApp.nav popToDownViewController:@"RegisterViewController"];
}

- (BOOL)checkChinese:(NSString *)string
{
    /// 判断字符串nickName 是否含有汉字
    BOOL _haveChChar = NO;
    for(int i=0;i<[string length];i++)
    {
        unichar char_nick = [string characterAtIndex:i];
        
        ///Unicode --char 值处于区间[19968, 19968+20902]里的，都是汉字
        if(char_nick>=19968 && char_nick<= 19968+20902)
        {
            _haveChChar = YES;
        }
    }
    
    return _haveChChar;
}

#pragma mark -
#pragma mark - 控件事件
- (IBAction)backTapped:(id)sender
{
    [SMApp.nav popViewController];
}

- (IBAction)finishTapped:(id)sender
{
    if ([self.ui_pswTxt.text stringByReplacingOccurrencesOfString:@" " withString:@""].length == 0)
    {
        self.ui_errorLabel.text = PswNil;
        return;
    }
    
    if ([self.ui_pswTxt.text stringByReplacingOccurrencesOfString:@" " withString:@""].length < 6)
    {
        self.ui_errorLabel.text = PswLength;
        return;
    }
    
    if ([self checkChinese:self.ui_pswTxt.text])
    {
        self.ui_errorLabel.text = ChineseTip;
        return;
    }
    
    self.ui_errorLabel.text = @"";
    
    [self.myRequest commitPswWithPhoneNo:self.phoneNo psw:self.ui_pswTxt.text];
    [self.tipView tipShowWithType:InfoCommittingTip tipString:Committing  isHidden:NO];
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
- (void) commitPswCallBack:(id) objectData
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
        [self.tipView tipShowWithType:CommittingFailTip tipString:FailTip  isHidden:YES];
    }
    @finally
    {
        switch ([tmpReturnString intValue])
        {
            case Success:
                [self.tipView tipShowWithType:SuccessTipTypeTwo tipString:SuccessPsw  isHidden:YES];
                [self performSelector:@selector(popToViewController) withObject:nil afterDelay:1.4];
                break;
                
            default:
                [self.tipView tipShowWithType:CommittingFailTip  tipString:FailTip  isHidden:YES];
                self.ui_errorLabel.text = PswCantChange;
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
        [self.tipView tipShowWithType:SigleNetFailTip tipString:NetFailTip  isHidden:YES];
    }
}

@end
