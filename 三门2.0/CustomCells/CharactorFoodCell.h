//
//  CharactorFoodCell.h
//  SanMen
//
//  Created by lcc on 13-12-23.
//  Copyright (c) 2013年 lcc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CharactorFoodCellDelegate <NSObject>

- (void) charactorFoodCellTapWithIndex:(NSInteger) indexPath;

@end

@interface CharactorFoodCell : UITableViewCell
{
    NSInteger sendingIndex;
}

@property (nonatomic, strong) NSIndexPath *cellIndexPath;
@property (weak) id<CharactorFoodCellDelegate> c_delegate;

- (void) setContentWithObject:(id) object AtIndexPath: (NSIndexPath *) indexPath;
- (void) setCellDelegate:(id) object;

@end
