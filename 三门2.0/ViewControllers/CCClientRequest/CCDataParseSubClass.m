//
//  CCDataParseSubClass.m
//  WoZaiXianChang
//
//  Created by lcc on 13-9-17.
//  Copyright (c) 2013年 lcc. All rights reserved.
//

#import "CCDataParseSubClass.h"
#import "CCParseToObjectToDatabase.h"

@implementation CCDataParseSubClass

- (void)dealloc
{
    self.w_delegate = nil;
}

- (void) setWDelegateWithObject:(id)object
{
    self.w_delegate = object;
}

- (void) dataParseSuperRequestNetAccessLoadWithObject:(NSDictionary *)resultDic request:(ASIHTTPRequest *)request
{
    NSString *methodName = [[resultDic allKeys] objectAtIndex:0];
    NSString *jsonString = [resultDic objectForKey:methodName];
    
    //本地数据解析成对象或者数组
    NSMutableArray *infoArr = [CCParseToObjectToDatabase paraseDataFromJson:jsonString methodName:methodName saveDic:resultDic request:request];
    
    SEL selector = NSSelectorFromString(@"finishLoadDataCallBack:loadingData:");
    //代理回调
    if (self.w_delegate != nil && [self.w_delegate respondsToSelector:selector])
    {
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self.w_delegate performSelector:selector withObject:methodName withObject:infoArr];
        #pragma clang diagnostic pop
    }
}

- (void) dataParseSuperRequestNetAccessLoadFailedWithObject:(NSString *)errorString request:(ASIHTTPRequest *)request
{
    if (self.w_delegate != nil && [self.w_delegate respondsToSelector:@selector(failLoadData:)])
    {
        [self.w_delegate performSelector:@selector(failLoadData:) withObject:request.error];
    }
}

@end

