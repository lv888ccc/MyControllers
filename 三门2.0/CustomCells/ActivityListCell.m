//
//  ActivityListCell.m
//  SanMen
//
//  Created by lcc on 13-12-25.
//  Copyright (c) 2013年 lcc. All rights reserved.
//

#import "ActivityListCell.h"
#import "UIImageView+WebCache.h"
#import "ActivityObject.h"

#define HEADERIMGTAG 100
#define NAMETAG 110

@implementation ActivityListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        //活动图片
        UIImageView *headerImageView = [[UIImageView alloc] init];
        [headerImageView setFrame:(CGRect){12, 10, 296, 115}];
        headerImageView.tag = HEADERIMGTAG;
        [self.contentView addSubview:headerImageView];
        
        //标题
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(-7, 15, 80, 25)];
        title.tag = NAMETAG;
        title.font = [UIFont systemFontOfSize:16];
        title.backgroundColor = [UIColor colorWithRed:50.0f/255.0f green:137.0f/255.0f blue:217.0f/255.0f alpha:1.0f];
        title.textColor = [UIColor whiteColor];
        [headerImageView addSubview:title];
        title.textAlignment = NSTextAlignmentCenter;
        
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
    UILabel *title = (UILabel *)[self.contentView viewWithTag:NAMETAG];
    UIImageView *headerImageView = (UIImageView *)[self.contentView viewWithTag:HEADERIMGTAG];
    
    ActivityObject *tmpObj = [(NSMutableArray *)object objectAtIndex:indexPath.row];
    
    [headerImageView setImageWithURL:[NSURL URLWithString:tmpObj.a_imgUrl] placeholderImage:[UIImage imageNamed:@"activity_place"]];
    title.text = tmpObj.a_subTitle;
}

@end

