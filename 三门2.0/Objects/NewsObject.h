//
//  NewsObject.h
//  SanMen
//
//  Created by lcc on 14-1-3.
//  Copyright (c) 2014年 lcc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsObject : NSObject

@property (nonatomic, strong) NSString *n_id;//数据 id
@property (nonatomic, strong) NSString *n_title;//数据 主标题
@property (nonatomic, strong) NSString *n_subTitle;//数据 子标题

@property (nonatomic, strong) NSString *n_modelType;//数据类型
@property (nonatomic, strong) NSString *n_imgUrl;//图片网络链接地址
@property (nonatomic, strong) NSString *n_videoUrl;//视频地址

@property (nonatomic, strong) NSString *n_newsType;

@end
