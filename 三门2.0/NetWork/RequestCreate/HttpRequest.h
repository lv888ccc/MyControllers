//
//  HttpRequest.h
//  NetAccess
//
//  Created by lcc on 13-6-10.
//  Copyright (c) 2013年 lcc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

@interface HttpRequest : NSObject

/*
 功 能: 每次生产出一个新的请求链接
 date: 2013 - 5 - 12
 param: httpMethod 具体某一个方法的名字
 params 参数如 id，name 等
 
 egg:http://172.16.3.111:8080/unite_interface/CheckAppVer?appId=1&appType=1&appVer=1.1
 */
+ (ASIHTTPRequest *)createRequestWithParams:(NSMutableDictionary *) params systemParams:(NSMutableDictionary *) sysParams  httpMethod:(NSString *) methodName freshTime:(NSInteger) timerCount;

/*
 功 能: 每次生产出一个新的请求 post
 date: 2014 - 1 - 2
 param: httpMethod 具体某一个方法的名字
 params 参数如 id，name 等
 */
+ (ASIFormDataRequest *)createFormRequestWithParams:(NSMutableDictionary *) params systemParams:(NSMutableDictionary *) sysParams httpMethod:(NSString *) methodName freshTime:(NSInteger) timerCount;

//获取上次刷新的时间
+ (NSMutableDictionary *) shareTimeArr;

@end
