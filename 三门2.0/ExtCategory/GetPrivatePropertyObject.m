//
//  GetPrivatePropertyObject.m
//  SanMen
//
//  Created by lcc on 14-1-23.
//  Copyright (c) 2014年 lcc. All rights reserved.
//

#import "GetPrivatePropertyObject.h"
#import <objc/runtime.h>

@implementation GetPrivatePropertyObject

+ (NSInteger) getValueWithName:(NSString *) keyName object:(id) object containKey:(NSString *) keyString
{
    NSMutableArray *tmpArr = nil;
    object_getInstanceVariable(object, [keyName UTF8String], (void *)&tmpArr);
    
    NSInteger pageNo = 1;
    for (NSDictionary *tmpDic in tmpArr)
    {
        if ([[tmpDic objectForKey:@"key"] isEqualToString:keyString])
        {
            pageNo = [[tmpDic objectForKey:@"value"] integerValue];
        }
    }
    
    return pageNo;
}

@end
