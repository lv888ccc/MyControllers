//
//  BikeListCell.m
//  SanMen
//
//  Created by lcc on 14-2-13.
//  Copyright (c) 2014年 lcc. All rights reserved.
//

#import "BikeListCell.h"
#import "ConVinientObject.h"

#define HEADERIMGTAG 100
#define TITLETAG 110


@implementation BikeListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        //背景
        UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 5, 296, 70)];
        [self.contentView addSubview:bgView];
        [bgView setImage:[UIImage imageNamed:@"home_cell_bg"]];
        
        //自行车
        UIImageView *headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 80, 50)];
        headerImageView.tag = HEADERIMGTAG;
        headerImageView.image = [UIImage imageNamed:@"convinient_bike_cell"];
        [bgView addSubview:headerImageView];
        
        //标题
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(99, 10, 185, 50)];
        title.tag = TITLETAG;
        title.font = [UIFont systemFontOfSize:15];
        title.alpha = 0.7f;
        title.numberOfLines = 0;
        [bgView addSubview:title];
        
        [self setBackgroundColor:[UIColor clearColor]];
        UIImageView *pressView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cell_press"]];
        self.selectedBackgroundView = pressView;
        [self bringSubviewToFront:pressView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void) setContentWithObject:(id) object AtIndexPath: (NSIndexPath *) indexPath
{
    UILabel *title = (UILabel *)[self.contentView viewWithTag:TITLETAG];
    ConVinientObject *tmpObj = [(NSMutableArray *)object objectAtIndex:indexPath.row];
    title.text = tmpObj.c_title;
}

@end
