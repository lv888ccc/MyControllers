//
//  FtpObject.h
//  SanMen
//
//  Created by lcc on 14-1-14.
//  Copyright (c) 2014年 lcc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FtpObject : NSObject

@property (nonatomic, strong) NSString *f_id;
@property (nonatomic, strong) NSString *f_ip;
@property (nonatomic, strong) NSString *f_path;
@property (nonatomic, strong) NSString *f_userName;
@property (nonatomic, strong) NSString *f_psw;
@property (nonatomic, strong) NSString *f_port;

@end
