//
//  RequestBegin.m
//  NetAccessShengji
//
//  Created by lcc on 13-10-31.
//  Copyright (c) 2013年 lcc. All rights reserved.
//

#import "RequestBegin.h"
#import "HttpRequest.h"

@implementation RequestBegin

- (void)dealloc
{
    self.r_delegate = nil;
}

#pragma mark -
#pragma mark - ASIHttp delegate 完成数据加载

/*
 功能: 请求数据成功
 by : lcc
 datetime:2012-8-17
 */
- (void)requestFinished:(ASIHTTPRequest *)request
{
    if (self.r_delegate && [self.r_delegate respondsToSelector:@selector(requestBeginLoadWithObject:request:)])
    {
        NSMutableDictionary *resultDic = [[NSMutableDictionary alloc] init];
        [resultDic setValue:request.responseString forKey:request.username];
        
        [self.r_delegate requestBeginLoadWithObject:resultDic request:request];
    }
}

/*
 功能: 请求数据失败
 by : lcc
 datetime:2012-8-17
 */
- (void)requestFailed:(ASIHTTPRequest *)request
{
    if (self.r_delegate && [self.r_delegate respondsToSelector:@selector(requestBeginLoadFailedWithObject:request:)])
    {
        [[HttpRequest shareTimeArr] removeObjectForKey:request.username];
        
        [self.r_delegate requestBeginLoadFailedWithObject:[NSString stringWithFormat:@"%@",request.error] request:request];
    }
}

#pragma mark -
#pragma mark - 发出网络请求
/*
 功能: 请求网络数据进行入队操作
 by : lcc
 datetime:2012-8-17
 参数:params 所有参数集合
 methodName 意思如名字
 */
- (void) beginRequestDataWithParam:(NSMutableDictionary *) params systemParams:(NSMutableDictionary *) sysParams  methodName:(NSString *)methodName  freshTime:(NSInteger) timerCount
{
    ASIHTTPRequest *request = [HttpRequest createRequestWithParams:params systemParams:sysParams httpMethod:methodName freshTime:timerCount];
    if (request)
    {
        //返回结果需要有对象接受数据
        [request setDelegate:self];
        [request startAsynchronous];
    }
    else
    {
        if (self.r_delegate && [self.r_delegate respondsToSelector:@selector(requestBeginLoadFailedWithObject:request:)])
        {
            [self.r_delegate requestBeginLoadFailedWithObject:nil request:request];
        }
    }
}

/*
 功能: 请求网络数据进行入队操作 post
 by : lcc
 datetime:2014 - 1 - 2
 参数:params 所有参数集合
 methodName 意思如名字
 */
- (void) beginPostRequestDataWithParam:(NSMutableDictionary *) params systemParams:(NSMutableDictionary *) sysParams methodName:(NSString *)methodName freshTime:(NSInteger) timerCount
{
    ASIFormDataRequest *request = [HttpRequest createFormRequestWithParams:params systemParams:sysParams httpMethod:methodName freshTime:timerCount];
    if (request)
    {
        //返回结果需要有对象接受数据
        [request setDelegate:self];
        [request startAsynchronous];
    }
    else
    {
        if (self.r_delegate && [self.r_delegate respondsToSelector:@selector(requestBeginLoadFailedWithObject:request:)])
        {
            [self.r_delegate requestBeginLoadFailedWithObject:nil request:request];
        }
    }
}

@end
