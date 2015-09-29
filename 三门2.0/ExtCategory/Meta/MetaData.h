//
//  MetaData.h
//  zuiwuhan
//
//  Created by mmc on 12-10-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MetaData : NSObject

+ (NSString *) getPlatform;
+ (NSString *) getOSVersion;
+ (NSString *) getLongOSVersion;
+ (NSString *) getUid;

+ (NSString *) getCurrVer;
+ (NSString *) getSid;

+ (NSString *) getImei;
+ (NSString *) getImsi;

+ (NSString *) getVerCode;
+ (NSString *) getVerName;

+ (NSString *) getIsJail;

+ (NSString *) getToken;

//+ (NSString *)requestJSON;


@end
