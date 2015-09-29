//
//  OrderObject.h
//  SanMen
//
//  Created by lcc on 14-1-5.
//  Copyright (c) 2014年 lcc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderObject : NSObject

@property (strong, nonatomic) NSString *o_id;   //标识
@property (strong, nonatomic) NSString *o_title;//标题
@property (strong, nonatomic) NSString *o_beginTime;//开始时间
@property (strong, nonatomic) NSString *o_endTime;//结束时间
@property (strong, nonatomic) NSString *o_pTitle;
@property (strong, nonatomic) NSString *o_videoUrl;

@end
