//
//  DataParse.m
//  NetAccessShengji
//
//  Created by lcc on 13-10-31.
//  Copyright (c) 2013年 lcc. All rights reserved.
//

#import "DataParseSuper.h"
#import "RequestBegin.h"
#import "CCParseToObjectToDatabase.h"

@interface DataParseSuper()<RequestBeginDelegate>

@property (nonatomic, strong) RequestBegin *myRequest;

@end

@implementation DataParseSuper

- (id) init
{
    self = [super init];
    
    if (self)
    {
        self.myRequest = [[RequestBegin alloc] init];
        [self.myRequest setR_delegate:self];
    }
    
    return self;
    
}

/*
 功能: 请求网络数据进行入队操作 get
 by : lcc
 datetime:2012-8-17
 
 参数:params 所有参数集合
 methodName 意思如名字
 */
- (void) beginRequestDataWithParam:(NSMutableDictionary *) params systemParams:(NSMutableDictionary *) sysParams methodName:(NSString *)methodName freshTime:(NSInteger)timerCount
{
    [self.myRequest beginRequestDataWithParam:params systemParams:sysParams methodName:methodName freshTime:timerCount];
}

/*
 功能: 请求网络数据进行入队操作 post
 by : lcc
 datetime:2014 - 1 - 2
 参数:params 所有参数集合
 methodName 意思如名字
 */
- (void) beginPostRequestDataWithParam:(NSMutableDictionary *) params systemParams:(NSMutableDictionary *) sysParams methodName:(NSString *)methodName freshTime:(NSInteger)timerCount
{
    [self.myRequest beginPostRequestDataWithParam:params systemParams:sysParams methodName:methodName freshTime:timerCount];
}

#pragma mark -
#pragma mark - 网络访问代理
//数据返回成功
- (void) requestBeginLoadWithObject:(NSDictionary *)resultDic request:(ASIHTTPRequest *)request
{
    [self dataParseSuperRequestNetAccessLoadWithObject:resultDic request:request];
}

//数据放回失败
- (void) requestBeginLoadFailedWithObject:(NSString *)errorString request:(ASIHTTPRequest *)request
{
    [self dataParseSuperRequestNetAccessLoadFailedWithObject:errorString request:request];
}

- (void) dataParseSuperRequestNetAccessLoadWithObject:(NSDictionary *)resultDic request:(ASIHTTPRequest *)request;
{
    //do something
}

- (void) dataParseSuperRequestNetAccessLoadFailedWithObject:(NSString *)errorString request:(ASIHTTPRequest *)request
{
    //do error
}

/*
 功能: 设置子类的代理回调具体对象
 by : cc
 param:object 实现与回调的对象
 */
- (void) setWDelegateWithObject:(id) object
{
    //
}

@end
