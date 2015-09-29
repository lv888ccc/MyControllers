//
//  PaiKeObject.h
//  SanMen
//
//  Created by lcc on 14-1-9.
//  Copyright (c) 2014年 lcc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PaiKeObject : NSObject

@property (nonatomic, strong) NSString *p_id;//数据 id
@property (nonatomic, strong) NSString *p_title;//数据 主标题
@property (nonatomic, strong) NSString *p_subTitle;//数据 子标题

@property (nonatomic, strong) NSString *p_modelType;//数据类型
@property (nonatomic, strong) NSString *p_imgUrl;//图片网络链接地址

@property (nonatomic, strong) NSString *p_height;
@property (nonatomic, strong) NSString *p_width;

@property (nonatomic, strong) NSString *p_name;
@property (nonatomic, strong) NSString *p_time;

@property (nonatomic, strong) NSString *p_count;

@end
