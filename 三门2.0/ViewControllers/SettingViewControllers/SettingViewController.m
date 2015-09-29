//
//  SettingViewController.m
//  SanMen
//
//  Created by lcc on 13-12-18.
//  Copyright (c) 2013年 lcc. All rights reserved.
//

#import "SettingViewController.h"
#import "ContractSanMenViewController.h"
#import "AdviceViewController.h"
#import "ChangeNickNameViewController.h"
#import "SDImageCache.h"
#import "UserGuidViewController.h"
#import "MetaData.h"
#import "FMDBManage.h"
#import "UserObject.h"
#import "LoginViewController.h"
#import "UMSocial.h"
#import "StatusTipView.h"

@interface SettingViewController ()<UIAlertViewDelegate>
{
    BOOL isPressShare;
}

@property (strong, nonatomic) UserObject *userObject;
@property (strong, nonatomic) IBOutlet UIScrollView *ui_scrollView;
@property (strong, nonatomic) IBOutlet UILabel *ui_lengthLabel;
@property (strong, nonatomic) IBOutlet UILabel *ui_verLabel;
@property (strong, nonatomic) IBOutlet UILabel *ui_nicknameLabel;
@property (strong, nonatomic) IBOutlet UIButton *ui_cancelBtn;
@property (strong, nonatomic) IBOutlet UIButton *ui_markBtn;

@property (strong, nonatomic) StatusTipView *tipView;
@property (strong, nonatomic) IBOutlet UIView *ui_logoutTipView;

@end

@implementation SettingViewController

- (void)dealloc
{
    self.userObject = nil;
    self.ui_scrollView = nil;
    self.ui_lengthLabel = nil;
    self.ui_verLabel = nil;
    self.ui_nicknameLabel = nil;
    
    self.tipView = nil;

    self.ui_markBtn = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LOGINSUCCESSNOTIFICATION object:nil];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(msg_LOGINSUCCESSNOTIFICATION:) name:LOGINSUCCESSNOTIFICATION
                                                   object:nil];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tipView = [[StatusTipView alloc] initWithFrame:CGRectMake(320, 160, 120, 70)];
    [self.view addSubview:self.tipView];
    
    //控件属性设置
    CGSize size = self.ui_scrollView.contentSize;
    size.height = viewHeight - 64 + 5;
    self.ui_scrollView.contentSize = size;
    self.ui_scrollView.showsVerticalScrollIndicator = NO;
    self.ui_markBtn.alpha = 0;
    
    CGRect rect = self.ui_logoutTipView.frame;
    rect.origin.y = viewHeight;
    self.ui_logoutTipView.frame = rect;
    
    [self.view addSubview:self.ui_logoutTipView];

    [self performSelectorInBackground:@selector(getFileSize) withObject:nil];
    
    //读取用户信息
    NSMutableArray *tmpArr = [FMDBManage getDataFromTable:[UserObject class] WithString:@"1=1"];
    if ([tmpArr count] > 0)
    {
        self.userObject = [tmpArr objectAtIndex:0];
        self.ui_nicknameLabel.text = self.userObject.u_userName;
        self.ui_cancelBtn.hidden = NO;
    }
    else
    {
        self.ui_nicknameLabel.text = @"用户登录";
        self.ui_cancelBtn.hidden = YES;
    }
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
    
    SMApp.nav.view.userInteractionEnabled = YES;
    
    [StatusBarObject setStatusBarStyleWithIndex:1];
    
    if (!([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0))
    {
        if (isPressShare)
        {
            [self performSelector:@selector(freshViewFrame) withObject:nil afterDelay:0.1];
        }
    }
    
    isPressShare = NO;
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (isPressShare)
    {
        [StatusBarObject setStatusBarStyleWithIndex:0];
    }
    else
    {
        [StatusBarObject setStatusBarStyleWithIndex:1];
    }
}

#pragma mark - 
#pragma mark -  custom method
- (long long) fileSizeAtPath:(NSString*) filePath
{
    
    NSFileManager* manager = [NSFileManager defaultManager];
    
    if ([manager fileExistsAtPath:filePath])
    {
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

- (float ) folderSizeAtPath:(NSString*) folderPath
{
    
    NSFileManager* manager = [NSFileManager defaultManager];
    
    if (![manager fileExistsAtPath:folderPath]) return 0;
    
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;

    long long folderSize = 0;
    
    while ((fileName = [childFilesEnumerator nextObject]) != nil)
    {
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    
    return folderSize/(1024.0*1024.0);
    
}

//因为分享刷新页面
- (void) freshViewFrame
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect = self.view.frame;
        rect.origin.y = -20;
        rect.size.height = viewHeight;
        self.view.frame = rect;
    }];
}

//让提示语消失
- (void) tipDispear
{
    [self.view bringSubviewToFront:self.tipView];

    [self.tipView tipShowWithType:InfoCommittingTip tipString:ClearDone isHidden:YES];
    
    //重新计算大小
    CGFloat sizeLength = (CGFloat)[[SDImageCache sharedImageCache] getSize]/1024/1024;
//    self.ui_lengthLabel.text = [NSString stringWithFormat:@"%.2f M",[self folderSizeAtPath:PicPath] + sizeLength];
    self.ui_lengthLabel.text = [NSString stringWithFormat:@"%.2f M",sizeLength];
}

//文件大小读取
- (void) getFileSize
{
    //缓存大小读取
    CGFloat sizeLength = (CGFloat)[[SDImageCache sharedImageCache] getSize]/1024/1024;
    self.ui_lengthLabel.text = [NSString stringWithFormat:@"%.2f M",[self folderSizeAtPath:PicPath] + sizeLength];

    //版本读取
    NSDictionary *tmpDic = [[NSUserDefaults standardUserDefaults] objectForKey:VERINFO];
    
    self.ui_verLabel.text = [NSString stringWithFormat:@"v%@",[tmpDic objectForKey:@"APP_VER"]];
    
    if ([tmpDic objectForKey:@"APP_VER"] == nil)
    {
        self.ui_verLabel.hidden = YES;
    }
}

#pragma mark -
#pragma mark - 控件事件
- (IBAction)backTapped:(id)sender
{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app.nav popViewController];
}

//关于三门
- (IBAction)aboutTapped:(id)sender
{
    ContractSanMenViewController *contractor = [[ContractSanMenViewController alloc] init];
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app.nav pushViewController:contractor];
}

//意见反馈
- (IBAction)adviceTapped:(id)sender
{
    AdviceViewController *advice = [[AdviceViewController alloc] init];
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app.nav pushViewController:advice];
}

//更改昵称
- (IBAction)changeTapped:(id)sender
{
    if (self.userObject)
    {
        ChangeNickNameViewController *change = [[ChangeNickNameViewController alloc] init];
        change.nickName = self.ui_nicknameLabel.text;
        AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [app.nav pushViewController:change];
    }
    else
    {
        LoginViewController *login = [[LoginViewController alloc] init];
        AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [app.nav pushViewController:login];
    }
}

//缓存清理
- (IBAction)clearTapped:(id)sender
{
    [self.tipView tipShowWithType:InfoCommittingTip tipString:CacheClearing isHidden:NO];
    [self performSelector:@selector(tipDispear) withObject:nil afterDelay:rand()%4];
    
    [[SDImageCache sharedImageCache] clearDisk];
    
    NSString *extension = @"jpg";
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:PicPath error:NULL];
    NSEnumerator *e = [contents objectEnumerator];
    NSString *filename;
    while ((filename = [e nextObject]))
    {
        
        if ([[filename pathExtension] isEqualToString:extension]) {
            
            [fileManager removeItemAtPath:[PicPath stringByAppendingPathComponent:filename] error:NULL];
        }
    }
}

//版本检测
- (IBAction)checkTapped:(id)sender
{
    NSDictionary *tmpDic = [[NSUserDefaults standardUserDefaults] objectForKey:VERINFO];
    //更新状态
    NSString *updateStatus = [tmpDic objectForKey:@"APP_UPDATE"];
    
    //选择更新
    if ([updateStatus isEqualToString:@"1"])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[tmpDic objectForKey:@"APP_VER_TITLE"]
                                                            message:[tmpDic objectForKey:@"APP_VER_INTRO"]
                                                           delegate:self
                                                  cancelButtonTitle:@"稍后再说"
                                                  otherButtonTitles:@"立即更新", nil];
        alertView.tag = 2;
        [alertView show];
    }
    
    //强制更新
    if ([updateStatus isEqualToString:@"2"])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[tmpDic objectForKey:@"APP_VER_TITLE"]
                                                            message:[tmpDic objectForKey:@"APP_VER_INTRO"]
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil, nil];
        alertView.tag = 1;
        [alertView show];
    }
}

//新手引导
- (IBAction)guidTapped:(id)sender
{
    //新手引导页面
    SMApp.userGuid = nil;
    SMApp.userGuid = [[UserGuidViewController alloc] init];
    CGRect rect = SMApp.userGuid.view.frame;
    rect.size.height = viewHeight;
    SMApp.userGuid.view.frame = rect;
    [SMApp.window addSubview:SMApp.userGuid.view];
    //end
}

- (IBAction)cancelTapped:(id)sender
{
    self.ui_cancelBtn.hidden = YES;
    
    [FMDBManage deleteFromTable:[UserObject class] WithString:@"1=1"];
    self.userObject = nil;
    self.ui_nicknameLabel.text = @"用户登录";
    [[NSNotificationCenter defaultCenter] postNotificationName:LOGOUTSUCCESSNOTIFICATION object:nil];
    
    [self markTapped:nil];
}

//分享
- (IBAction)shareTapped:(id)sender
{
    //设置微信分享应用类型，用户点击消息将跳转到应用，或者到下载页面
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeApp;
    //分享图文样式到微信朋友圈显示字数比较少，只显示分享标题
    [UMSocialData defaultData].extConfig.title = ShareText;
    //设置微信好友或者朋友圈的分享url,下面是微信好友，微信朋友圈对应wechatTimelineData
    [UMSocialData defaultData].extConfig.wechatSessionData.url = SAMDOWNURL;
    
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:YouMengKey
                                      shareText:SettingShareText
                                     shareImage:nil
                                shareToSnsNames:nil
                                       delegate:nil];
    isPressShare = YES;
}

//退出提示
- (IBAction)logoutTipTapped:(id)sender
{
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         CGRect rect = self.ui_logoutTipView.frame;
                         rect.origin.y = viewHeight - rect.size.height;
                         self.ui_logoutTipView.frame = rect;
                         self.ui_markBtn.alpha = 0.4;
                     }];
}

- (IBAction)markTapped:(id)sender
{
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         
                         CGRect rect = self.ui_logoutTipView.frame;
                         rect.origin.y = viewHeight;
                         self.ui_logoutTipView.frame = rect;
                         
                         self.ui_markBtn.alpha = 0;
                     }];
}

#pragma mark -
#pragma mark - 消息处理函数
- (void) msg_LOGINSUCCESSNOTIFICATION:(NSNotification *) notification
{
    NSMutableArray *tmpArr = [FMDBManage getDataFromTable:[UserObject class] WithString:@"1=1"];
    if ([tmpArr count] > 0)
    {
        self.userObject = [tmpArr objectAtIndex:0];
        self.ui_nicknameLabel.text = self.userObject.u_userName;
        self.ui_cancelBtn.hidden = NO;
    }
}

#pragma mark -
#pragma mark - alertView delegate
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *infoDic = (NSDictionary *)[userDefaults objectForKey:VERINFO];
    
    if (alertView.tag == 1)
    {
        //强制更新
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[infoDic objectForKey:@"APP_VER_URL"]]];
        _exit(0);
    }
    else if(alertView.tag == 2)
    {
        if (buttonIndex == 1)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[infoDic objectForKey:@"APP_VER_URL"]]];
        }
    }
    
}

@end
