//
//  EatPhoneNoCell.m
//  SanMen
//
//  Created by lcc on 13-12-22.
//  Copyright (c) 2013年 lcc. All rights reserved.
//

#import "EatPhoneNoCell.h"
#import "UIImageView+WebCache.h"
#import "FoodObject.h"

#define HEADERIMGTAG 100
#define TITLETAG 110
#define PHONENOTAG 120

@implementation EatPhoneNoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        //背景
        UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 5, 296, 70)];
        [self.contentView addSubview:bgView];
        [bgView setImage:[UIImage imageNamed:@"home_cell_bg"]];
        
        //头像
        UIImageView *headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 80, 50)];
        headerImageView.tag = HEADERIMGTAG;
        [bgView addSubview:headerImageView];
        
        //标题
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(99, 10, 179, 30)];
        title.tag = TITLETAG;
        title.font = [UIFont systemFontOfSize:16];
        title.alpha = 0.7f;
        [bgView addSubview:title];
        
        //电话
        UILabel *phone = [[UILabel alloc] initWithFrame:CGRectMake(99, 40, 179, 16)];
        phone.tag = PHONENOTAG;
        phone.font = [UIFont systemFontOfSize:14];
        phone.textColor = [UIColor grayColor];
        phone.alpha = 0.7f;
        [bgView addSubview:phone];
        
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
    UILabel *phone = (UILabel *)[self.contentView viewWithTag:PHONENOTAG];
    UIImageView *headerImageView = (UIImageView *)[self.contentView viewWithTag:HEADERIMGTAG];
    
    FoodObject *tmpObj = [object objectAtIndex:indexPath.row];
    
    [headerImageView setImageWithURL:[NSURL URLWithString:tmpObj.f_imgUrl] placeholderImage:[UIImage imageNamed:@"cell_place"]];
    phone.text = tmpObj.f_subTitle;
    title.text = tmpObj.f_title;
}

@end

