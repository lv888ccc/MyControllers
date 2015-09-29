//
//  CollectionCell.h
//  SanMen
//
//  Created by lcc on 13-12-25.
//  Copyright (c) 2013年 lcc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CollectionCellDelegate <NSObject>

@optional
- (void) collectionCellTapWithIndex:(NSIndexPath *) index;
- (void) collectionCellTapWithObject:(id) object;

@end

@interface CollectionCell : UITableViewCell

@property (weak) id<CollectionCellDelegate> c_delegate;
@property (nonatomic, strong) NSIndexPath *cellIndexPath;

- (void) setContentWithObject:(id) object AtIndexPath: (NSIndexPath *) indexPath;

- (void) setCellDelegate:(id) object;



@end
