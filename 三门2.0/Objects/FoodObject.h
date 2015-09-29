//
//  FoodObject.h
//  SanMen
//
//  Created by lcc on 14-1-3.
//  Copyright (c) 2014年 lcc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FoodObject : NSObject


@property (nonatomic, strong) NSString *f_id;//数据 id
@property (nonatomic, strong) NSString *f_title;//数据 主标题
@property (nonatomic, strong) NSString *f_subTitle;//数据 子标题

@property (nonatomic, strong) NSString *f_modelType;//数据类型
@property (nonatomic, strong) NSString *f_imgUrl;//图片网络链接地址
@property (nonatomic, strong) NSString *f_contractType;//联系方式 地址或者电话

@end
