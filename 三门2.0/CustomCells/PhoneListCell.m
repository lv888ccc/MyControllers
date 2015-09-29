//
//  PhoneListCell.m
//  SanMen
//
//  Created by lcc on 14-2-13.
//  Copyright (c) 2014年 lcc. All rights reserved.
//

#import "PhoneListCell.h"
#import "ConVinientObject.h"

#define HEADERIMGTAG 100
#define TITLETAG 110
#define SUBTAG 120

@implementation PhoneListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        //背景
        UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 5, 296, 55)];
        [self.contentView addSubview:bgView];
        [bgView setImage:[UIImage imageNamed:@"home_cell_bg"]];
        
        //热线标志
        UIImageView *headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(254, 16.5, 22, 22)];
        headerImageView.tag = HEADERIMGTAG;
        headerImageView.image = [UIImage imageNamed:@"convinient_phone_cell"];
        [bgView addSubview:headerImageView];
        
        //标题
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 230, 30)];
        title.tag = TITLETAG;
        title.font = [UIFont systemFontOfSize:17];
        title.alpha = 0.7f;
        [bgView addSubview:title];
        
        //副标题
        UILabel *subTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, 210, 20)];
        subTitle.tag = SUBTAG;
        subTitle.font = [UIFont systemFontOfSize:14];
        [bgView addSubview:subTitle];
        subTitle.alpha = 0.8f;
        subTitle.textColor = [UIColor grayColor];
        subTitle.backgroundColor = [UIColor clearColor];
        
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
    UILabel *subTitle = (UILabel *)[self.contentView viewWithTag:SUBTAG];

    ConVinientObject *tmpObj = [(NSMutableArray *)object objectAtIndex:indexPath.row];

    subTitle.text = tmpObj.c_phoneNo;
    title.text = tmpObj.c_title;
}

@end
