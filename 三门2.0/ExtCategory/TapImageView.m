//
//  TapImageView.m
//  SanMen
//
//  Created by lcc on 14-1-11.
//  Copyright (c) 2014年 lcc. All rights reserved.
//

#import "TapImageView.h"

@implementation TapImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void) tapGesture:(UIGestureRecognizer *) gesture
{
    if (self.t_delegate && [self.t_delegate respondsToSelector:@selector(tapWithObject:)])
    {
        [self.t_delegate tapWithObject:self.identifier];
    }
}

@end
