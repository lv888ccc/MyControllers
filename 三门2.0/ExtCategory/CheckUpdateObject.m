//
//  CheckUpdateObject.m
//  SanMen
//
//  Created by lcc on 14-1-7.
//  Copyright (c) 2014年 lcc. All rights reserved.
//

#import "CheckUpdateObject.h"

@implementation CheckUpdateObject

- (id)init
{
    self = [super init];
    if (self) {
        self.myRequest = [[CCClientRequest alloc] init];
        self.myRequest.c_delegate = self;
        
        [self performSelector:@selector(check) withObject:nil afterDelay:8];
    }
    return self;
}

#pragma mark -
#pragma mark - custom method
- (void) check
{
    [self.myRequest checkUpdate];
}

#pragma mark -
#pragma mark - 网络数据放回
//版本更新
- (void) checkUpdateCallBack:(id) objectData
{
    if ([objectData count] > 0)
    {
        NSDictionary *tmpDic = [objectData objectAtIndex:0];
        NSUserDefaults *tmpUser = [NSUserDefaults standardUserDefaults];
        [tmpUser setValue:tmpDic forKey:VERINFO];
        
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
