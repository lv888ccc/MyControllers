//
//  ThemeObject.h
//  SanMen
//
//  Created by lcc on 14-2-18.
//  Copyright (c) 2014年 lcc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ThemeObject : NSObject

@property (nonatomic, strong) NSString *t_id;//数据 id
@property (nonatomic, strong) NSString *t_title;//数据 主标题
@property (nonatomic, strong) NSString *t_imgUrl;//图片网络链接地址
@property (nonatomic, strong) NSString *t_index;

@end
