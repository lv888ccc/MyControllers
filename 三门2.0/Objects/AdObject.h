//
//  AdObject.h
//  SanMen
//
//  Created by lcc on 14-1-6.
//  Copyright (c) 2014年 lcc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AdObject : NSObject

@property (nonatomic, strong) NSString *a_id;//数据 id
@property (nonatomic, strong) NSString *a_title;//数据 主标题
@property (nonatomic, strong) NSString *a_subTitle;//数据 子标题

@property (nonatomic, strong) NSString *a_modelType;//数据类型
@property (nonatomic, strong) NSString *a_imgUrl;//图片网络链接地址
@property (nonatomic, strong) NSString *a_videoUrl;//视频地址

@property (nonatomic, strong) NSString *a_isOut;//是否是外部链接
@property (nonatomic, strong) NSString *a_linkerId;
@property (nonatomic, strong) NSString *a_webUrl;

@end
