//
//  ThemeDetailViewController.h
//  SanMen
//
//  Created by lcc on 14-2-14.
//  Copyright (c) 2014年 lcc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThemeObject.h"

@interface ThemeDetailViewController : UIViewController

@property (nonatomic, strong) ThemeObject *themeObject;
@property (nonatomic) BOOL isLight;

@end
