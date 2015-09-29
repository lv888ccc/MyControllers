//
//  AppDelegate.h
//  SanMen
//
//  Created by lcc on 13-12-16.
//  Copyright (c) 2013年 lcc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLNavigationController.h"
#import "UserGuidViewController.h"
#import "CheckUpdateObject.h"
#import "UserObject.h"
#import "BMapKit.h"
#import "WeatherRequest.h"
#import "HomeCenterViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate,BMKGeneralDelegate>

@property (strong, nonatomic) NSDictionary *pushInfo;
@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) MLNavigationController *nav;
@property (strong, nonatomic) UserGuidViewController *userGuid;
@property (strong, nonatomic) CheckUpdateObject *check;
@property (strong, nonatomic) UserObject *userObject;
@property (strong, nonatomic) HomeCenterViewController *home;

//全局收藏用到
@property (strong, nonatomic) NSString *newsType;
@property (strong, nonatomic) NSString *newsTypeName;

//天气
@property (strong, nonatomic) WeatherRequest *weatherObj;
@property (strong, nonatomic) NSMutableArray *weatherArr;
@end
