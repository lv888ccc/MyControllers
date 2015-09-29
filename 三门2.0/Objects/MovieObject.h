//
//  MovieObject.h
//  SanMen
//
//  Created by lcc on 14-2-20.
//  Copyright (c) 2014年 lcc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MovieObject : NSObject

@property (nonatomic, strong) NSString *m_id;//电影的id
@property (nonatomic, strong) NSString *m_movieName;//电影名字
@property (nonatomic, strong) NSString *m_starCount;//星级
@property (nonatomic, strong) NSString *m_director;//导演
@property (nonatomic, strong) NSString *m_actors;//主演
@property (nonatomic, strong) NSString *m_place;//地区
@property (nonatomic, strong) NSString *m_type;//类型
@property (nonatomic, strong) NSString *m_timeLength;//时长
@property (nonatomic, strong) NSString *m_playTime;//上映
@property (nonatomic, strong) NSString *m_des;//简介
@property (nonatomic, strong) NSString *m_imgUrl;
@property (nonatomic, strong) NSString *m_videoId;
@property (nonatomic, strong) id m_orderObject;

//影院信息
@property (nonatomic, strong) NSString *m_cinemaName;
@property (nonatomic, strong) NSString *m_c_id;
@property (nonatomic, strong) NSString *m_mobile;
@property (nonatomic, strong) NSString *m_info;

@end
