//
//  FMDBManage.h
//  WoZaiXianChang
//
//  Created by lcc on 13-9-16.
//  Copyright (c) 2013年 lcc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FMDBManage : NSObject

+ (void) insertProgramWithObject:(id) object;

+ (NSMutableArray *)getDataFromTable:(id)table WithString:(NSString *) string;

+ (void) deleteFromTable:(id)table WithString:(NSString *) string;

+ (void) updateTable:(id)table setString:(NSString *) setString WithString:(NSString *) string;

@end
