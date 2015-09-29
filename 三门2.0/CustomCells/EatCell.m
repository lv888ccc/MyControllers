//
//  EatCell.m
//  SanMen
//
//  Created by lcc on 13-12-22.
//  Copyright (c) 2013年 lcc. All rights reserved.
//

#import "EatCell.h"
#import "UIImageView+WebCache.h"
#import "FoodObject.h"

#define HEADERIMGTAG 100
#define TITLETAG 110
#define ADDRESSTAG 120

@implementation EatCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        //背景
        UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 5, 296, 70)];
        [self.contentView addSubview:bgView];
        [bgView setImage:[UIImage imageNamed:@"home_cell_bg"]];
        
        //新闻头像
        UIImageView *headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 80, 50)];
        headerImageView.tag = HEADERIMGTAG;
        [bgView addSubview:headerImageView];
        
        //标题
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(99, 10, 179, 30)];
        title.tag = TITLETAG;
        title.font = [UIFont systemFontOfSize:16];
        title.alpha = 0.7f;
        [bgView addSubview:title];
        
        //地址
        UILabel *address = [[UILabel alloc] initWithFrame:CGRectMake(99, 40, 179, 16)];
        address.tag = ADDRESSTAG;
        address.font = [UIFont systemFontOfSize:14];
        address.textColor = [UIColor grayColor];
        address.alpha = 0.7f;
        [bgView addSubview:address];
        
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

    // Configure the view for the selected state
}

- (void) setContentWithObject:(id) object AtIndexPath: (NSIndexPath *) indexPath
{
    UILabel *title = (UILabel *)[self.contentView viewWithTag:TITLETAG];
    UILabel *address = (UILabel *)[self.contentView viewWithTag:ADDRESSTAG];
    UIImageView *headerImageView = (UIImageView *)[self.contentView viewWithTag:HEADERIMGTAG];
    
    FoodObject *tmpObj = [object objectAtIndex:indexPath.row];
    
    [headerImageView setImageWithURL:[NSURL URLWithString:tmpObj.f_imgUrl] placeholderImage:[UIImage imageNamed:@"cell_place"]];
    address.text = tmpObj.f_subTitle;
    title.text = tmpObj.f_title;
}

@end
