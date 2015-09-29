//
//  CollectionObject.h
//  SanMen
//
//  Created by lcc on 14-1-6.
//  Copyright (c) 2014年 lcc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CollectionObject : NSObject

@property (nonatomic, strong) NSString *c_id;//数据 id
@property (nonatomic, strong) NSString *c_title;//数据 主标题
@property (nonatomic, strong) NSString *c_subTitle;//数据 子标题

@property (nonatomic, strong) NSString *c_modelType;//数据类型
@property (nonatomic, strong) NSString *c_imgUrl;//图片网络链接地址
@property (nonatomic, strong) NSString *c_videoUrl;//视频地址
@property (nonatomic, strong) NSString *c_newsTypeName;//新闻类型 是三门还是其他等等
@property (nonatomic, strong) NSString *c_collectionTime;//收藏时间
@property (nonatomic, strong) NSString *c_isEdit;

@end
