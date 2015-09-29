//
//  HotSellBookCell.h
//  SanMen
//
//  Created by lcc on 14-2-13.
//  Copyright (c) 2014年 lcc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HotSellBookCellDelegate <NSObject>

- (void) hotSellBookTapWihtObject:(id) object;

@end

@interface HotSellBookCell : UITableViewCell

@property (weak) id<HotSellBookCellDelegate> h_delegate;

- (void) setCellDelegate:(id) object;

@end
