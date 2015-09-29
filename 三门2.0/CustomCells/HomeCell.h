//
//  HomeCell.h
//  SanMen
//
//  Created by lcc on 13-12-20.
//  Copyright (c) 2013年 lcc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TapImageView.h"

@protocol HomeCellDelegate <NSObject>

- (void) homeCellTapWithObject:(id) object;

@end

@interface HomeCell : UITableViewCell<TapImageViewDelegate>

@property (weak) id<HomeCellDelegate> h_delegate;

- (void) setContentWithObject:(id) object AtIndexPath: (NSIndexPath *) indexPath;
- (void) setCellDelegate:(id) object;

@end
