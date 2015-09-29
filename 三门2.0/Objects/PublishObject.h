//
//  PublishObject.h
//  SanMen
//
//  Created by lcc on 14-1-3.
//  Copyright (c) 2014年 lcc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PublishObject : NSObject

@property (nonatomic, strong) NSString *p_id;//数据 id
@property (nonatomic, strong) NSString *p_title;//数据 主标题
@property (nonatomic, strong) NSString *p_subTitle;//数据 子标题

@property (nonatomic, strong) NSString *p_modelType;//数据类型
@property (nonatomic, strong) NSString *p_imgUrl;//图片网络链接地址
@property (nonatomic, strong) NSString *p_videoUrl;//视频地址

@end
