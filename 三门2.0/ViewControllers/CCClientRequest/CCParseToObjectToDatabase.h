//
//  ParseToObjectToDatabase.h
//  NetAccessShengji
//
//  Created by lcc on 13-11-1.
//  Copyright (c) 2013年 lcc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"

@interface CCParseToObjectToDatabase : NSObject

/*
 功能:数据解析
 date:2013-5-22
 params:jsonString待解析的json
 request:反问的返回
 */
+ (id) paraseDataFromJson:(NSString *) jsonString methodName:(NSString *)methodString saveDic:(NSDictionary *) saveDic request:(ASIHTTPRequest *) request;

@end
