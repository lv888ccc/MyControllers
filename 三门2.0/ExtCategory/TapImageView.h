//
//  TapImageView.h
//  SanMen
//
//  Created by lcc on 14-1-11.
//  Copyright (c) 2014年 lcc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TapImageViewDelegate <NSObject>

- (void) tapWithObject:(id) sender;

@end

@interface TapImageView : UIImageView

@property (nonatomic, strong) id identifier;
@property (weak) id<TapImageViewDelegate> t_delegate;

@end
