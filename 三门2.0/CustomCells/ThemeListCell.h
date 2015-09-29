//
//  ThemeListCell.h
//  SanMen
//
//  Created by lcc on 14-2-13.
//  Copyright (c) 2014年 lcc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ThemeListCellDelegate <NSObject>

- (void) themeListCellTapWithObjec:(id) object;

@end

@interface ThemeListCell : UITableViewCell

@property (weak) id<ThemeListCellDelegate> t_delegate;

- (void) setCellDelegate:(id) object;

@end
