//
//  DataParse.h
//  NetAccessShengji
//
//  Created by lcc on 13-10-31.
//  Copyright (c) 2013年 lcc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"

@interface DataParseSuper : NSObject

/*
 功能: 请求网络数据进行入队操作 get
 by : lcc
 datetime:2012-8-17
 
 参数:params 所有参数集合
 methodName 意思如名字
 */
- (void) beginRequestDataWithParam:(NSMutableDictionary *) params systemParams:(NSMutableDictionary *) sysParams methodName:(NSString *)methodName freshTime:(NSInteger)timerCount;

/*
 功能: 请求网络数据进行入队操作 post
 by : lcc
 datetime:2014 - 1 - 2
 参数:params 所有参数集合
 methodName 意思如名字
 */
- (void) beginPostRequestDataWithParam:(NSMutableDictionary *) params systemParams:(NSMutableDictionary *) sysParams methodName:(NSString *)methodName freshTime:(NSInteger)timerCount;

/*
 功能: 网络数据返回成功回调 成功与失败
 by : cc
 param:resultDic成功的结果集合 request是具体哪一个请求返回的  errorString:失败的错误信息
 */
- (void) dataParseSuperRequestNetAccessLoadWithObject:(NSDictionary *)resultDic request:(ASIHTTPRequest *)request;
- (void) dataParseSuperRequestNetAccessLoadFailedWithObject:(NSString *)errorString request:(ASIHTTPRequest *)request;

/*
 功能: 设置子类的代理回调具体对象
 by : cc
 param:object 实现与回调的对象
 */
- (void) setWDelegateWithObject:(id) object;

@end
