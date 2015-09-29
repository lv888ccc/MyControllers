//
//  HttpRequest.m
//  NetAccess
//
//  Created by lcc on 13-6-10.
//  Copyright (c) 2013年 lcc. All rights reserved.
//

#import "HttpRequest.h"
#import "CommonUrl.h"

static NSMutableDictionary *timeDictionary = nil;

@implementation HttpRequest

//获取上次刷新的时间
+ (NSMutableDictionary *) shareTimeArr
{
    @synchronized (self)
    {
        if (timeDictionary == nil)
        {
            timeDictionary = [[NSMutableDictionary alloc] init];
        }
    }
    
    return timeDictionary;
}

/*
 功 能: 每次生产出一个新的请求 get
 date: 2013 - 5 - 12
 param: httpMethod 具体某一个方法的名字
 params 参数如 id，name 等
 by:lcc
 egg:http://172.16.3.111:8080/unite_interface/CheckAppVer?appId=1&appType=1&appVer=1.1
 */
+ (ASIHTTPRequest *)createRequestWithParams:(NSMutableDictionary *) params systemParams:(NSMutableDictionary *) sysParams  httpMethod:(NSString *) methodName freshTime:(NSInteger) timerCount
{
    if ([self continueFreshWithMethodName:methodName freshTime:timerCount])
    {
        NSInteger paramsCount = [[params allKeys] count];
        NSMutableString *parameterList=[NSMutableString stringWithCapacity:64];
        
        //获取参数用于传递
        for (int i = 0; i < paramsCount; i++)
        {
            //获取键值
            NSString *tmpKey = [[params allKeys] objectAtIndex:i];
            NSString *tmpKeyValue = [NSString stringWithFormat:@"%@",[params objectForKey:tmpKey]];
            
            /*这里应该对键值进行编码
             *编码原因是因为在用到汉字，会报错 -- bad url
             */
            if (i == 0)
            {
                [parameterList appendFormat:@"%@=%@",tmpKey,[self URLEncodedString:tmpKeyValue]];
            }
            else
            {
                [parameterList appendFormat:@"&%@=%@",tmpKey,[self URLEncodedString:tmpKeyValue]];
            }
        }
        
        //请求的地址
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?%@",HTTPURL,parameterList]];
        
        NSLog(@"请求链接地址:%@",url);

        //创建请求
        ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:url];
        request.shouldAttemptPersistentConnection = NO;
        request.numberOfTimesToRetryOnTimeout = 40;
        request.username = methodName;
        
        return request;
    }
    else
    {
        return nil;
    }
}

/*
 功 能: 每次生产出一个新的请求 post
 date: 2014 - 1 - 2
 param: httpMethod 具体某一个方法的名字
 params 参数如 id，name 等
 */
+ (ASIFormDataRequest *)createFormRequestWithParams:(NSMutableDictionary *) params systemParams:(NSMutableDictionary *) sysParams httpMethod:(NSString *) methodName freshTime:(NSInteger) timerCount
{
    if ([self continueFreshWithMethodName:methodName freshTime:timerCount])
    {
        //请求的地址
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",HTTPURL]];
        
        NSLog(@"请求链接地址:%@",url);
        
        //创建请求
        ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:url];
        
        //手机等系统信息添加到header中
        for (NSString *enumKey in sysParams.keyEnumerator)
        {
            [request addRequestHeader:[sysParams valueForKey:enumKey] value:enumKey];
        }
        
        //参数添加到post中
        for (NSString *enumKey in params.keyEnumerator)
        {
            [request addPostValue:[params valueForKey:enumKey] forKey:enumKey];
        }
        [request setRequestMethod:@"POST"];
        request.shouldAttemptPersistentConnection = NO;
        request.username = methodName;
        return request;
    }
    else
    {
        return nil;
    }
}


/*
 功 能: 主要对汉字以及特殊符号进行编码处理
 date: 2013 - 6 - 10
 param: myString:要编码的字符串
 by:lcc
 */
+ (NSString *)URLEncodedString:(NSString *) myString
{
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                           (CFStringRef)myString,
                                                                           NULL,
																		   CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                           kCFStringEncodingUTF8));
	return result;
}

#pragma mark -
#pragma mark - 请求入"对"
/*
 功能: 防止用户不断请求刷新
 date:2013 - 6 - 11
 methodName 意思如名字
 */
+ (BOOL) continueFreshWithMethodName:(NSString *)methodName freshTime:(NSInteger) timerCount
{
    BOOL isFresh = NO;
    
    NSMutableDictionary *tmpDic = [HttpRequest shareTimeArr];
    
    //计算时间
    NSDate *date = [NSDate date];
    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
    [formate setDateFormat:@"yyyy-MM-dd HH-mm-ss"];
    NSTimeInterval nowTime=[date timeIntervalSince1970]*1;
    
    if ([tmpDic.allKeys containsObject:methodName])
    {
        //取出上次刷新的时间进行比对
        double oldTime = [[tmpDic objectForKey:methodName] doubleValue];
        ;
        
        if (nowTime - oldTime > timerCount)
        {
            isFresh = YES;
            
            [tmpDic setObject:[NSString stringWithFormat:@"%f",nowTime] forKey:methodName];
        }
        else
        {
            isFresh = NO;
        }
    }
    else
    {
        isFresh = YES;
        
        [tmpDic setObject:[NSString stringWithFormat:@"%f",nowTime] forKey:methodName];
    }
    
    return isFresh;
}

@end
