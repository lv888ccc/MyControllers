//
//  AdviceViewController.m
//  SanMen
//
//  Created by lcc on 13-12-25.
//  Copyright (c) 2013年 lcc. All rights reserved.
//

#import "AdviceViewController.h"
#import "PlaceHolderTextView.h"
#import "MetaData.h"
#import "CCClientRequest.h"
#import "StatusTipView.h"

@interface AdviceViewController ()

@property (strong, nonatomic) IBOutlet PlaceHolderTextView *ui_textView;
@property (strong, nonatomic) IBOutlet UILabel *ui_sysLabel;
@property (strong, nonatomic) CCClientRequest *myRequest;
@property (strong, nonatomic) IBOutlet UIButton *ui_sendBtn;
@property (strong, nonatomic) StatusTipView *tipView;

@end

@implementation AdviceViewController

- (void)dealloc
{
    self.ui_sysLabel = nil;
    self.ui_textView = nil;
    self.myRequest.c_delegate = nil;
    self.myRequest = nil;
    self.ui_sendBtn = nil;
    
    self.tipView = nil;
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
    
    self.ui_textView.placeholder = @"请输入您的反馈，我们将为您不断改进";
    self.ui_textView.backgroundColor = [UIColor clearColor];
    self.ui_sysLabel.text = [NSString stringWithFormat:@"设备:%@ 系统:%@ 版本:%@",[MetaData getPlatform],[MetaData getOSVersion],[MetaData getCurrVer]];
    self.ui_sendBtn.enabled = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - custom method
//禁用发送按钮
- (void) setBtnEnable
{
    if ([self.ui_textView.text stringByReplacingOccurrencesOfString:@" " withString:@""].length > 0)
    {
        self.ui_sendBtn.enabled = YES;
    }
    else
    {
        self.ui_sendBtn.enabled = NO;
    }
}

#pragma mark -
#pragma mark - 控件事件
- (IBAction)backTapped:(id)sender
{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app.nav popViewController];
}

- (IBAction)sendTapped:(id)sender
{
    [self.tipView tipShowWithType:InfoCommittingTip tipString:Committing isHidden:NO];
    
    [self.myRequest goodAdviceWithDeviceNum:[MetaData getPlatform] sysVer:[MetaData getOSVersion] curVer:[MetaData getCurrVer] content:self.ui_textView.text linkMethod:(SMApp.userObject.u_phoneNo == nil?@"":SMApp.userObject.u_phoneNo) userId:(SMApp.userObject.u_id == nil?@"":SMApp.userObject.u_id)];
}

#pragma mark -
#pragma mark - textView delegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    [self performSelector:@selector(setBtnEnable) withObject:nil afterDelay:0.3];
    return YES;
}

#pragma mark -
#pragma mark - 网络回调
- (void) goodAdviceCallBack:(id) objectData
{
    if ([objectData count] > 0)
    {
        [self.tipView tipShowWithType:SuccessTipTypeTwo tipString:SuccessAdvice isHidden:YES];
        self.ui_textView.text = @"";
        [self setBtnEnable];
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
