//
//  SettingObject.h
//  SanMen
//
//  Created by lcc on 14-1-18.
//  Copyright (c) 2014年 lcc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettingObject : NSObject

@property (nonatomic, strong) NSString *s_crrVer;//当前版本
@property (nonatomic, strong) NSString *s_home; //-1没有出现过
@property (nonatomic, strong) NSString *s_left;//-1没有出现过
@property (nonatomic, strong) NSString *s_camara;//-1没有出现过
@property (nonatomic, strong) NSString *s_token;//token
@property (nonatomic, strong) NSString *s_id;

@end
