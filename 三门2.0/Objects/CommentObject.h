//
//  CommentObject.h
//  SanMen
//
//  Created by lcc on 14-1-7.
//  Copyright (c) 2014年 lcc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentObject : NSObject

@property (nonatomic, strong) NSString *c_id;//评论id
@property (nonatomic, strong) NSString *c_content;//评论的内容
@property (nonatomic, strong) NSString *c_datetime;//时间
@property (nonatomic, strong) NSString *c_userId;//用户id
@property (nonatomic, strong) NSString *c_newsId;//新闻id
@property (nonatomic, strong) NSString *c_userName;//用户昵称

@end
