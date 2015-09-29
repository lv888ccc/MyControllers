//
//  StatusBarObject.m
//  SanMen
//
//  Created by lcc on 14-1-1.
//  Copyright (c) 2014年 lcc. All rights reserved.
//

#import "StatusBarObject.h"

@implementation StatusBarObject

+ (void) setStatusBarStyleWithIndex:(NSInteger) index
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        switch (index)
        {
            case 0://default
                [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
                break;
                
            case 1://light ios 7.0
                [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
                break;
                
            case 2://
                
                break;
                
            default:
                break;
        }
    }
    else
    {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleBlackOpaque;
    }
}

@end
