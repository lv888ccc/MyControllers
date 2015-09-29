//
//  RequestBegin.h
//  NetAccessShengji
//
//  Created by lcc on 13-10-31.
//  Copyright (c) 2013年 lcc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"

@protocol RequestBeginDelegate <NSObject>
/*
 功能:成功返回数据
 */
- (void) requestBeginLoadWithObject:(NSDictionary *) resultDic request:(ASIHTTPRequest *)request;

/*
 功能:数据请求失败
 */
- (void) requestBeginLoadFailedWithObject:(NSString *) errorString request:(ASIHTTPRequest *)request;

@end

@interface RequestBegin : NSObject<ASIHTTPRequestDelegate>

@property (weak) id<RequestBeginDelegate> r_delegate;

/*
 功能: 请求网络数据进行入队操作
 by : lcc
 datetime:2012-8-17
 参数:params 所有参数集合
 methodName 意思如名字
 */
- (void) beginRequestDataWithParam:(NSMutableDictionary *) params systemParams:(NSMutableDictionary *) sysParams  methodName:(NSString *)methodName  freshTime:(NSInteger) timerCount;

/*
 功能: 请求网络数据进行入队操作 post
 by : lcc
 datetime:2014 - 1 - 2
 参数:params 所有参数集合
 methodName 意思如名字
 */
- (void) beginPostRequestDataWithParam:(NSMutableDictionary *) params systemParams:(NSMutableDictionary *) sysParams methodName:(NSString *)methodName freshTime:(NSInteger) timerCount;

@end
