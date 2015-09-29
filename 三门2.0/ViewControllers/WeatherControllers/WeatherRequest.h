//
//  WeatherRequest.h
//  SanMen
//
//  Created by lcc on 14-2-22.
//  Copyright (c) 2014年 lcc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherRequest : NSObject<NSURLConnectionDelegate>

@property(nonatomic,retain) NSMutableData *webData;//最终保存的值

- (void) getWeather;

@end
