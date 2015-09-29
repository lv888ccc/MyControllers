//
//  NumberLabel.h
//
//  Created by cc on 15/9/28.
//  Copyright (c) 2015年 cc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NumberLabel : UILabel
- (instancetype) initWithFrame:(CGRect)frame hideFraction:(BOOL) hideFraction;
- (void) setNumber:(double) num animated:(BOOL) animate;
- (void) animateFrom:(double) from to:(double) to;
- (void) stopAnimation;
@end
