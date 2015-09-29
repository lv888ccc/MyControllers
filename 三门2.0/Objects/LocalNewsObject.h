//
//  LocalNewsObject.h
//  SanMen
//
//  Created by lcc on 14-1-4.
//  Copyright (c) 2014年 lcc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalNewsObject : NSObject

@property (nonatomic, strong) NSString *l_id;//数据 id
@property (nonatomic, strong) NSString *l_title;//数据 主标题
@property (nonatomic, strong) NSString *l_subTitle;//数据 子标题

@property (nonatomic, strong) NSString *l_modelType;//数据类型
@property (nonatomic, strong) NSString *l_imgUrl;//图片网络链接地址
@property (nonatomic, strong) NSString *l_videoUrl;//视频地址

@property (nonatomic, strong) NSString *l_newsType;

@end
