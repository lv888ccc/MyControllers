//
//  ThemeListCell.m
//  SanMen
//
//  Created by lcc on 14-2-13.
//  Copyright (c) 2014年 lcc. All rights reserved.
//

#import "ThemeListCell.h"
#import "TapImageView.h"
#import "UIImageView+WebCache.h"
#import "ThemeObject.h"

#define IMGNEWSTAG 150
#define TITLETAG 151
#define SUBTAG 152

@interface ThemeListCell ()<TapImageViewDelegate>

@end

@implementation ThemeListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        
        UIImageView *bgView = [[UIImageView alloc] initWithFrame:(CGRect){12, 10, 296, 97}];
        bgView.tag = IMGNEWSTAG;
        [bgView setImage:[UIImage imageNamed:@"home_cell_big_bg"]];
        [self.contentView addSubview:bgView];
        bgView.userInteractionEnabled = YES;
        
        //标题
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(15, 8, 266, 20)];
        title.tag = TITLETAG;
        title.font = [UIFont systemFontOfSize:15];
        [bgView addSubview:title];
        title.backgroundColor = [UIColor clearColor];
        
        for (int m = 0; m < 3; m ++)
        {
            //新闻头像
            TapImageView *headerImageView = [[TapImageView alloc] initWithFrame:CGRectMake(18 + m*90, 36, 80, 50)];
            headerImageView.tag = SUBTAG + m;
            [bgView addSubview:headerImageView];
            [headerImageView setT_delegate:self];
        }
        
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

- (void) setCellDelegate:(id) object
{
    self.t_delegate = object;
}

- (void) setContentWithObject:(id) object AtIndexPath: (NSIndexPath *) indexPath
{
    ThemeObject *tmpObj = [(NSMutableArray *)object objectAtIndex:indexPath.row];
    NSArray *picArr = [tmpObj.t_imgUrl componentsSeparatedByString:@"^^"];
    
    UIImageView *bgView = (UIImageView *)[self.contentView viewWithTag:IMGNEWSTAG];
    UILabel *title = (UILabel *)[bgView viewWithTag:TITLETAG];
    
    for (UIView *tmpView in bgView.subviews)
    {
        if ([tmpView isKindOfClass:[UIImageView class]])
        {
            tmpView.hidden = YES;
        }
    }
    
    for (int i = 0; i < [picArr count]; i ++)
    {
        TapImageView *headerImageView = (TapImageView *)[bgView viewWithTag:SUBTAG + i];
        headerImageView.hidden = NO;
        NSDictionary *tmpDic = [NSDictionary dictionaryWithObjectsAndKeys:tmpObj,[NSString stringWithFormat:@"%d",i], nil];
        headerImageView.identifier = tmpDic;
        [headerImageView setImageWithURL:[NSURL URLWithString:[picArr objectAtIndex:i]] placeholderImage:[UIImage imageNamed:@"cell_place"]];
    }
    
    
    title.text = tmpObj.t_title;
}

#pragma mark -
#pragma mark - tapView delegate
- (void) tapWithObject:(id)sender
{
    if ([self.t_delegate respondsToSelector:@selector(themeListCellTapWithObjec:)] && self.t_delegate)
    {
        [self.t_delegate themeListCellTapWithObjec:sender];
    }
}

@end
