//
//  CamaraObject.h
//  SanMen
//
//  Created by lcc on 13-12-27.
//  Copyright (c) 2013年 lcc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CamaraObject : NSObject

@property (strong, nonatomic) id c_delegate;

- (void) openPicOrVideoWithSign:(NSInteger) sign;

@end
