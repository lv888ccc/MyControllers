//
//  CinemaObject.h
//  SanMen
//
//  Created by lcc on 14-2-20.
//  Copyright (c) 2014年 lcc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CinemaObject : NSObject

@property (nonatomic, strong) NSString *c_id;//影院id
@property (nonatomic, strong) NSString *c_name;//影院名称
@property (nonatomic, strong) NSString *c_address;//影院地址
@property (nonatomic, strong) NSString *c_phone;//电话
@property (nonatomic, strong) NSString *c_onTime;//营业时间
@property (nonatomic, strong) NSString *c_des;//影院介绍
@property (nonatomic, strong) NSString *c_imgUrl;//电影院

@end
