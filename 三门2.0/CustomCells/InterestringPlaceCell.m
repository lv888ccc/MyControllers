//
//  InterestringPlaceCell.m
//  SanMen
//
//  Created by lcc on 13-12-23.
//  Copyright (c) 2013年 lcc. All rights reserved.
//

#import "InterestringPlaceCell.h"
#import "UIImageView+WebCache.h"
#import "LocalNewsObject.h"

#define HEADERIMGTAG 100
#define TITLETAG 110

@implementation InterestringPlaceCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        //背景
        UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 5, 296, 143)];
        [self.contentView addSubview:bgView];
        [bgView setImage:[[UIImage imageNamed:@"home_cell_bg"] stretchableImageWithLeftCapWidth:20 topCapHeight:35]];
        
        //新闻头像
        UIImageView *headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 296, 114)];
        headerImageView.tag = HEADERIMGTAG;
        [bgView addSubview:headerImageView];
        
        //标题
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(3, 114, 290, 30)];
        title.tag = TITLETAG;
        title.font = [UIFont systemFontOfSize:16];
        title.alpha = 0.7f;
        [bgView addSubview:title];
        
        [self setBackgroundColor:[UIColor clearColor]];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
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
    UIImageView *headerImageView = (UIImageView *)[self.contentView viewWithTag:HEADERIMGTAG];
    
    LocalNewsObject *tmpObj = [(NSMutableArray *)object objectAtIndex:indexPath.row];
    
    [headerImageView setImageWithURL:[NSURL URLWithString:tmpObj.l_imgUrl] placeholderImage:[UIImage imageNamed:@"activity_place"]];
    title.text = tmpObj.l_title;
    
}

@end

