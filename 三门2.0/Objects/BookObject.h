//
//  BookObject.h
//  SanMen
//
//  Created by lcc on 14-2-21.
//  Copyright (c) 2014年 lcc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BookObject : NSObject

@property (nonatomic, strong) NSString *b_id;
@property (nonatomic, strong) NSString *b_title;
@property (nonatomic, strong) NSString *b_subTitle;
@property (nonatomic, strong) NSString *b_commentCount;
@property (nonatomic, strong) NSString *b_imgUrl;
@property (nonatomic, strong) NSString *b_info;

@end
