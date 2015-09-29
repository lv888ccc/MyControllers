//
//  MetaData.m
//  zuiwuhan
//
//  Created by mmc on 12-10-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MetaData.h"

//change

//#import "JSON.h"
#import "UIDeviceHardware.h"
#import "UIDevice+IdentifierAddition.h"
#import "AppDelegate.h"
#import "NSString+URLEncoding.h"


@implementation MetaData


+ (NSString*) getPlatform
{
    NSString* platform = [UIDeviceHardware platformString];
    
    return [platform copy];
}

+ (NSString*) getOSVersion
{
    NSString* osVersion = [NSString stringWithFormat:@"%@",
                           [[UIDevice currentDevice] systemVersion]];
    NSArray *arr = [osVersion componentsSeparatedByString:@"."];
    osVersion = [arr objectAtIndex:0];
    return [osVersion copy];
}

+ (NSString*) getLongOSVersion
{
    NSString* osVersion = [NSString stringWithFormat:@"%@",
                           [[UIDevice currentDevice] systemVersion]];
    return [osVersion copy];
}

+ (NSString*) getUid
{
    if ([[MetaData getOSVersion] floatValue] >= 7.0)
    {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        if ([userDefaults objectForKey:@"uuid"] == nil)
        {
            CFUUIDRef puuid = CFUUIDCreate( nil );
            CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
            NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
            CFRelease(puuid);
            CFRelease(uuidString);
            
            [userDefaults setObject:result forKey:@"uuid"];//保存UUID
            [userDefaults synchronize];
            
            return [NSString stringWithFormat:@"%@",[userDefaults objectForKey:@"uuid"]];
        }
        else
        {
            return [NSString stringWithFormat:@"%@",[userDefaults objectForKey:@"uuid"]];
        }
        
        return nil;
    }
    NSString* uid = [NSString stringWithFormat:@"%@",[[UIDevice currentDevice] uniqueGlobalDeviceIdentifier]];
    
    return [uid copy];
}

+ (NSString*) getCurrVer
{
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    
    NSString *currVer = [infoDict objectForKey:@"CFBundleShortVersionString"];
    
    return [currVer copy];
}

+ (NSString*) getSid
{
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    
    NSString *sid = [infoDict objectForKey:@"CFBundleIdentifier"];
    
    return [sid copy];
}

+ (NSString*) getImei
{
    return @"";
}

+ (NSString*) getImsi
{
    return @"";
}

+ (NSString*) getVerCode
{
    return [self getCurrVer];
}

+ (NSString*) getVerName
{
    return [self getCurrVer];
}

BOOL isJailBreak()
{
    BOOL jailbroken = NO;
    NSString *cydiaPath = @"/Applications/Cydia.app";
    NSString *aptPath = @"/private/var/lib/apt/";
    if ([[NSFileManager defaultManager] fileExistsAtPath:cydiaPath])
    {
        jailbroken = YES;
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:aptPath])
    {
        jailbroken = YES;
    }  
    return jailbroken;
}

+ (NSString *) getIsJail
{
    return [NSString stringWithFormat:@"%d",isJailBreak()];
}

+ (NSString *) getToken
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [NSString stringWithFormat:@"%@",[userDefaults objectForKey:@"token"]];
    token = [token stringByReplacingOccurrencesOfString:@"<" withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@">" withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (token == nil || [token isEqualToString:@"(null)"] || [token isEqualToString:@""])
    {
        token = @"";
    }
    
    return token;
}

@end
