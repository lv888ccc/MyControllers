//
//  GetPrivatePropertyObject.h
//  SanMen
//
//  Created by lcc on 14-1-23.
//  Copyright (c) 2014年 lcc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetPrivatePropertyObject : NSObject

+ (NSInteger) getValueWithName:(NSString *) keyName object:(id) object containKey:(NSString *) keyString;

@end
