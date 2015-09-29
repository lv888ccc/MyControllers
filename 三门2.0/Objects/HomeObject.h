//
//  HomeObject.h
//  SanMen
//
//  Created by lcc on 14-1-10.
//  Copyright (c) 2014年 lcc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeObject : NSObject

@property (nonatomic, strong) NSString *h_id;//首页标识
@property (nonatomic, strong) NSString *h_title;//标题
@property (nonatomic, strong) NSString *h_imgUrl;//图片链接
@property (nonatomic, strong) NSString *h_type;//大类型
@property (nonatomic, strong) NSString *h_outUrl;//外部链接
@property (nonatomic, strong) NSString *h_modelType;//小类型链接

@end
