//
//  NewsThemeListCell.m
//  SanMen
//
//  Created by lcc on 14-3-21.
//  Copyright (c) 2014年 lcc. All rights reserved.
//

#import "NewsThemeListCell.h"
#import "UIImageView+WebCache.h"
#import "ThemeObject.h"

#define HEADERIMGTAG 100
#define TITLETAG 110

@implementation NewsThemeListCell

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
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(99, 10, 179, 50)];
        title.tag = TITLETAG;
        title.font = [UIFont systemFontOfSize:16];
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
    UIImageView *headerImageView = (UIImageView *)[self.contentView viewWithTag:HEADERIMGTAG];
    
    ThemeObject *tmpObj = [(NSMutableArray *)object objectAtIndex:indexPath.row];
    
    [headerImageView setImageWithURL:[NSURL URLWithString:tmpObj.t_imgUrl] placeholderImage:[UIImage imageNamed:@"cell_place"]];
    title.text = tmpObj.t_title;
}

@end

