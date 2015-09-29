//
//  WeatherObject.h
//  SanMen
//
//  Created by lcc on 14-2-22.
//  Copyright (c) 2014年 lcc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherObject : NSObject

@property (nonatomic, strong) NSString *w_weekDay;//周
@property (nonatomic, strong) NSString *w_weatherInfo;//天气状况
@property (nonatomic, strong) NSString *w_temp;//温度
@property (nonatomic, strong) NSString *w_img;//图片
@property (nonatomic, strong) NSString *w_wind;//风级
@property (nonatomic, strong) NSString *w_datetime;//时间

@end
