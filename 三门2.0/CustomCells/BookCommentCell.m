//
//  BookCommentCell.m
//  SanMen
//
//  Created by lcc on 14-2-13.
//  Copyright (c) 2014年 lcc. All rights reserved.
//

#import "BookCommentCell.h"
#import "UIImageView+WebCache.h"
#import "BookObject.h"

#define IMGNEWSTAG 150
#define TITLETAG 151
#define BOOKTAG 152
#define SUBTAG 153

@implementation BookCommentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        //背景
        UIImageView *bgView = [[UIImageView alloc] initWithFrame:(CGRect){12, 5, 296, 97}];
        bgView.tag = IMGNEWSTAG;
        [bgView setImage:[UIImage imageNamed:@"home_cell_big_bg"]];
        [self.contentView addSubview:bgView];
        
        //图书封面
        UIImageView *bookView = [[UIImageView alloc] initWithFrame:(CGRect){8.5, 8.5, 60, 80}];
        bookView.tag = BOOKTAG;
        [bgView addSubview:bookView];
        
        //标题
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(80, 8.5, 210, 45)];
        title.tag = TITLETAG;
        title.font = [UIFont systemFontOfSize:17];
        [bgView addSubview:title];
        title.alpha = 0.8f;
        title.numberOfLines = 0;
        title.backgroundColor = [UIColor clearColor];
        
        //副标题
        UILabel *subTitle = [[UILabel alloc] initWithFrame:CGRectMake(80, 54, 210, 32)];
        subTitle.tag = SUBTAG;
        subTitle.font = [UIFont systemFontOfSize:13];
        [bgView addSubview:subTitle];
        subTitle.alpha = 0.8f;
        subTitle.textColor = [UIColor grayColor];
        subTitle.numberOfLines = 0;
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
    
    // Configure the view for the selected state
}


- (void) setContentWithObject:(id) object AtIndexPath: (NSIndexPath *) indexPath
{
    UIImageView *bgView = (UIImageView *)[self.contentView viewWithTag:IMGNEWSTAG];
    UIImageView *bookView = (UIImageView *)[bgView viewWithTag:BOOKTAG];
    UILabel *title = (UILabel *)[bgView viewWithTag:TITLETAG];
    UILabel *subTitle = (UILabel *)[bgView viewWithTag:SUBTAG];
    
    BookObject *tmpObj = [(NSMutableArray *)object objectAtIndex:indexPath.row];
    [bookView setImageWithURL:[NSURL URLWithString:tmpObj.b_imgUrl] placeholderImage:[UIImage imageNamed:@"book_cell_holder"]];
    title.text = tmpObj.b_title;
    subTitle.text = tmpObj.b_info;
}

@end
