//
//  MovieListCell.m
//  SanMen
//
//  Created by lcc on 14-2-11.
//  Copyright (c) 2014年 lcc. All rights reserved.
//

#import "MovieListCell.h"
#import "UIImageView+WebCache.h"
#import "CinemaObject.h"

#define HEADERIMGTAG 100

@implementation MovieListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        UIImageView *headerImageView = [[UIImageView alloc] init];
        [headerImageView setFrame:(CGRect){12, 10, 296, 115}];
        headerImageView.tag = HEADERIMGTAG;
        [self.contentView addSubview:headerImageView];
        
        [self setBackgroundColor:[UIColor clearColor]];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void) setContentWithObject:(id) object AtIndexPath: (NSIndexPath *) indexPath
{
    UIImageView *headerImageView = (UIImageView *)[self.contentView viewWithTag:HEADERIMGTAG];
    CinemaObject *tmpObj = [(NSMutableArray *)object objectAtIndex:indexPath.row];
    [headerImageView setImageWithURL:[NSURL URLWithString:tmpObj.c_imgUrl] placeholderImage:[UIImage imageNamed:@"activity_place"]];
}


@end
