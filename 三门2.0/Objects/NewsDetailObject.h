//
//  NewsDetailObject.h
//  SanMen
//
//  Created by lcc on 14-1-6.
//  Copyright (c) 2014年 lcc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsDetailObject : NSObject

@property (nonatomic, strong) NSString *n_id;//标识
@property (nonatomic, strong) NSString *n_imgUrl;//网络图片
@property (nonatomic, strong) NSString *n_author;//小编
@property (nonatomic, strong) NSString *n_commentCount;//评论数
@property (nonatomic, strong) NSString *n_detailContent;//详情
@property (nonatomic, strong) NSString *n_modelType;//模块
@property (nonatomic, strong) NSString *n_subTitle;//子标题
@property (nonatomic, strong) NSString *n_title;//标题
@property (nonatomic, strong) NSString *n_keyWord;//关键字
@property (nonatomic, strong) NSString *n_des;//简介
@property (nonatomic, strong) NSString *n_datetime;//发布时间
@property (nonatomic, strong) NSString *n_source;

@property (nonatomic, strong) NSString *n_videoUrl;

@end
