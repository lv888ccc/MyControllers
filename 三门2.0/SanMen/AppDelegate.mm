//
//  AppDelegate.m
//  SanMen
//
//  Created by lcc on 13-12-16.
//  Copyright (c) 2013年 lcc. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"
#import "LeftViewController.h"
#import "RightViewController.h"
#import "StartImageView.h"
#import "NewsDetailViewController.h"
#import "UMSocial.h"
#import "MetaData.h"
#import "FMDBManage.h"
#import "SettingObject.h"
#import "ProgramObject.h"

BMKMapManager* _mapManager;

@implementation AppDelegate

- (void)dealloc
{
    self.pushInfo = nil;
    self.window = nil;
    self.nav = nil;
    self.userGuid = nil;
    self.check = nil;
    self.userObject = nil;
    _mapManager = nil;
    self.weatherArr = nil;
    self.weatherObj = nil;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    //推送信息
    [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound];
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    if (launchOptions)
    {
        self.pushInfo = [[launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"] objectForKey:@"aps"];
    }
    //end
    
    //百度地图
    _mapManager = [[BMKMapManager alloc]init];
	BOOL ret = [_mapManager start:@"3zDOSYb3sWL3An5vVLr5PCFj" generalDelegate:self];
	if (!ret) {
		NSLog(@"manager start failed!");
	}
    //end
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    //设置状态栏 ios7.0以上
    [UIApplication sharedApplication].statusBarHidden = NO;
    [StatusBarObject setStatusBarStyleWithIndex:1];
    
    //初始化root
    RootViewController *root = [[RootViewController alloc] init];
    
    //初始化menu
    self.home = [[HomeCenterViewController alloc] init];

    LeftViewController       *left = [[LeftViewController alloc] init];
    RightViewController      *right = [[RightViewController alloc] init];
    self.home.leftVC = left;
    self.home.rightVC = right;
    self.home.centerVCString = @"HomeViewController";
    
    //初始化导航栏
    self.nav = [[MLNavigationController alloc] initWithRootViewController:root];
    self.window.rootViewController = self.nav;
    root.rootController = self.home;
    
    //新手引导页面
    [self setUserInfoWithLaunchOptions:launchOptions];
    //end
    
    //版本更新
    self.check = [[CheckUpdateObject alloc] init];
    //end
    
    //友盟社会化组件
    [UMSocialData setAppKey:YouMengKey];
    [UMSocialConfig setWXAppId:WeiChatKey url:SAMDOWNURL];
    [UMSocialConfig setSnsPlatformNames:@[UMShareToSina,UMShareToTencent,UMShareToWechatTimeline,UMShareToQzone]];
    //end
    
    self.nav.navigationBarHidden = YES;
    self.window.backgroundColor = [UIColor blackColor];
    [self.window makeKeyAndVisible];
    
    //天气
    self.weatherObj = [[WeatherRequest alloc] init];
    [self.weatherObj getWeather];
    //end
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{}

- (void)applicationDidEnterBackground:(UIApplication *)application
{}

- (void)applicationWillEnterForeground:(UIApplication *)application
{}

- (void)applicationWillTerminate:(UIApplication *)application
{}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

//消息推送
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)newDeviceToken
{
    NSLog(@"%@",newDeviceToken);
    [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%@",newDeviceToken] forKey:TOKENKEY];
}

//接受消息推送
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    self.pushInfo = [userInfo objectForKey:@"aps"];
    if (SMApp.pushInfo)
    {
        [self performSelector:@selector(pushDetailViewController) withObject:nil afterDelay:0.5];
    }
}

#pragma mark -
#pragma mark - custom method
//推送到详情页面
- (void) pushDetailViewController
{
    //取出push的消息
    NewsDetailViewController *newsDetail = [[NewsDetailViewController alloc] init];
    newsDetail.newsId = [self.pushInfo objectForKey:@"id"];
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app.nav pushViewController:newsDetail];
    
    SMApp.pushInfo = nil;
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

//引导图和启动图
- (void) setUserInfoWithLaunchOptions:(NSDictionary *)launchOptions
{
    NSMutableArray *settingArr = [FMDBManage getDataFromTable:[SettingObject class] WithString:@"1=1"];
    if ([settingArr count] == 0)
    {
        UIView *tmpView = (UIView *)[[UIApplication sharedApplication] valueForKey:@"statusBar"];
        tmpView.alpha = 0.0f;
        
        self.userGuid = [[UserGuidViewController alloc] init];
        self.userGuid.view.frame = CGRectMake(0, 0, 320, viewHeight);
        [self.nav.view  addSubview:self.userGuid.view];
    }
    else
    {
        SettingObject *tmpObj = [settingArr objectAtIndex:0];
        NSString *oldVer = tmpObj.s_crrVer;
        NSString *newVer = [MetaData getCurrVer];
        
         NSInteger result = [oldVer compare:newVer];
        if (result == -1)
        {
            UIView *tmpView = (UIView *)[[UIApplication sharedApplication] valueForKey:@"statusBar"];
            tmpView.alpha = 0.0f;
            
            tmpObj.s_crrVer = [MetaData getCurrVer];
            
            //小于
            self.userGuid = [[UserGuidViewController alloc] init];
            self.userGuid.view.frame = CGRectMake(0, 0, 320, viewHeight);
            [self.nav.view  addSubview:self.userGuid.view];
            
            //入库
            [FMDBManage updateTable:tmpObj setString:[NSString stringWithFormat:@"s_home='-1',s_left='-1',s_camara='-1',s_crrVer='%@'",tmpObj.s_crrVer] WithString:@"1=1"];
            
//            //删除一期保存的
//            [FMDBManage deleteFromTable:[ProgramObject class] WithString:@"1=1"];
        }
        else
        {
            //启动图片 如果有推送消息启动广告图片不显示
            if (!launchOptions)
            {
                StartImageView *startView = [[StartImageView alloc] initWithFrame:CGRectMake(0, 0, 320, viewHeight)];
                [self.nav.view addSubview:startView];
            }
            //end
        }
        
    }
}

@end
