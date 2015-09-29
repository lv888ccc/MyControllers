//
//  RightViewController.m
//  SanMen
//
//  Created by lcc on 13-12-16.
//  Copyright (c) 2013年 lcc. All rights reserved.
//

#import "RightViewController.h"
#import "SettingViewController.h"
#import "WeatherViewController.h"
#import "ConllectionViewController.h"
#import "LoginViewController.h"
#import "MetaData.h"
#import "UserObject.h"
#import "FMDBManage.h"
#import "WeatherObject.h"

@interface RightViewController ()

@property (strong, nonatomic) UserObject *userObject;
@property (strong, nonatomic) IBOutlet UIButton *ui_verLabel;
@property (strong, nonatomic) IBOutlet UIButton *ui_nicknameBtn;
@property (strong, nonatomic) IBOutlet UIScrollView *ui_scrollView;
@property (strong, nonatomic) IBOutlet UIButton *ui_signBtn;
@property (strong, nonatomic) IBOutlet UIView *ui_weatherBgView;
@property (strong, nonatomic) IBOutlet UILabel *ui_weatherInfoLabel;
@property (strong, nonatomic) IBOutlet UIImageView *ui_weatherImgView;

@end

@implementation RightViewController

- (void)dealloc
{
    self.ui_verLabel = nil;
    self.userObject = nil;
    self.ui_nicknameBtn = nil;
    self.ui_scrollView = nil;
    self.ui_signBtn = nil;
    self.ui_weatherBgView = nil;
    self.ui_weatherInfoLabel = nil;
    self.ui_weatherImgView = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LOGINSUCCESSNOTIFICATION object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LOGOUTSUCCESSNOTIFICATION object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LOADDONEWEATHERINFO object:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(msg_LOGINSUCCESSNOTIFICATION:) name:LOGINSUCCESSNOTIFICATION
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(msg_LOGOUTSUCCESSNOTIFICATION:) name:LOGOUTSUCCESSNOTIFICATION
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(msg_LOADDONEWEATHERINFO:) name:LOADDONEWEATHERINFO
                                                   object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //版本读取
    NSDictionary *tmpDic = [[NSUserDefaults standardUserDefaults] objectForKey:VERINFO];
    [self.ui_verLabel setTitle:[NSString stringWithFormat:@"v%@",[tmpDic objectForKey:@"APP_VER"]] forState:UIControlStateNormal];
    
    if ([tmpDic objectForKey:@"APP_VER"] == nil)
    {
        self.ui_verLabel.hidden = YES;
    }
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0)
    {
        CGRect btnRect = self.ui_verLabel.frame;
        btnRect.origin.y = viewHeight - 54;
        self.ui_verLabel.frame = btnRect;
    }
    else
    {
        CGRect btnRect = self.ui_verLabel.frame;
        btnRect.origin.y = viewHeight - 34;
        self.ui_verLabel.frame = btnRect;
    }
    
    //读取用户信息
    NSMutableArray *tmpArr = [FMDBManage getDataFromTable:[UserObject class] WithString:@"1=1"];
    if ([tmpArr count] > 0)
    {
        self.userObject = [tmpArr objectAtIndex:0];
        SMApp.userObject = self.userObject;
        [self.ui_nicknameBtn setTitle:self.userObject.u_userName forState:UIControlStateNormal];
        [self.ui_signBtn setImage:[UIImage imageNamed:@"left_logo"] forState:UIControlStateNormal];
        [self.ui_signBtn setImage:[UIImage imageNamed:@"left_logo"] forState:UIControlStateHighlighted];
    }
    else
    {
        [self.ui_nicknameBtn setTitle:@"用户登录" forState:UIControlStateNormal];
    }
    
    CGRect rect = self.ui_scrollView.frame;
    rect.size.height = viewHeight;
    self.ui_scrollView.frame = rect;
    
    self.ui_scrollView.showsVerticalScrollIndicator = NO;
    
    CGSize size = self.ui_scrollView.contentSize;
    size.height = viewHeight + 5;
    self.ui_scrollView.contentSize = size;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - 自定义方法

#pragma mark -
#pragma mark - 控件事件
//天气
- (IBAction)weatherTapped:(id)sender
{
    WeatherViewController *weather = [[WeatherViewController alloc] init];
    [SMApp.nav pushViewController:weather];
}

//收藏
- (IBAction)collectionTapped:(id)sender
{
    ConllectionViewController *conllection = [[ConllectionViewController alloc] init];
    [SMApp.nav pushViewController:conllection];
}

//设置
- (IBAction)settingTapped:(id)sender
{
    SettingViewController *setting = [[SettingViewController alloc] init];
    [SMApp.nav pushViewController:setting];
}

//登陆
- (IBAction)loginTapped:(id)sender
{
    if (!self.userObject)
    {
        LoginViewController *login = [[LoginViewController alloc] init];
        [SMApp.nav pushViewController:login];
    }
    
}

#pragma mark -
#pragma mark - 消息处理函数
- (void) msg_LOGINSUCCESSNOTIFICATION:(NSNotification *) notification
{
    NSMutableArray *tmpArr = [FMDBManage getDataFromTable:[UserObject class] WithString:@"1=1"];
    if ([tmpArr count] > 0)
    {
        self.userObject = [tmpArr objectAtIndex:0];
        SMApp.userObject = self.userObject;
        [self.ui_nicknameBtn setTitle:self.userObject.u_userName forState:UIControlStateNormal];
        [self.ui_signBtn setImage:[UIImage imageNamed:@"left_logo"] forState:UIControlStateNormal];
        [self.ui_signBtn setImage:[UIImage imageNamed:@"left_logo"] forState:UIControlStateHighlighted];
    }
}

- (void)msg_LOGOUTSUCCESSNOTIFICATION:(NSNotification *) notification
{
    self.userObject = nil;
    SMApp.userObject = nil;
    [self.ui_nicknameBtn setTitle:@"用户登录" forState:UIControlStateNormal];
    [self.ui_signBtn setImage:[UIImage imageNamed:@"right_logo"] forState:UIControlStateNormal];
    [self.ui_signBtn setImage:[UIImage imageNamed:@"right_logo"] forState:UIControlStateHighlighted];
}

- (void)msg_LOADDONEWEATHERINFO:(NSNotification *) notification
{
    WeatherObject *tmpObj = notification.object;
    self.ui_weatherInfoLabel.text = [NSString stringWithFormat:@"三门 %@",tmpObj.w_temp];
    self.ui_weatherImgView.image = [UIImage imageNamed:tmpObj.w_img];
    self.ui_weatherBgView.hidden = NO;
}


@end
