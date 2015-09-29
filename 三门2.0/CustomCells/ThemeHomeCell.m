//
//  ThemeHomeCell.m
//  SanMen
//
//  Created by lcc on 14-2-12.
//  Copyright (c) 2014年 lcc. All rights reserved.
//

#import "ThemeHomeCell.h"
#import "UIImageView+WebCache.h"
#import "ThemeObject.h"

#define HEADERIMGTAG 100
#define NAMETAG 110

@implementation ThemeHomeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        //专题
        UIImageView *headerImageView = [[UIImageView alloc] init];
        [headerImageView setFrame:(CGRect){12, 10, 296, 115}];
        headerImageView.tag = HEADERIMGTAG;
        [self.contentView addSubview:headerImageView];
        [headerImageView setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"activity_place"]];
        
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
    UIImageView *headerImageView = (UIImageView *)[self.contentView viewWithTag:HEADERIMGTAG];
    ThemeObject *tmpObj = [(NSMutableArray *)object objectAtIndex:indexPath.row];
    [headerImageView setImageWithURL:[NSURL URLWithString:tmpObj.t_imgUrl] placeholderImage:[UIImage imageNamed:@"activity_place"]];
}




@end

