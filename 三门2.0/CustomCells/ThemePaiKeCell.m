//
//  ThemePaiKeCell.m
//  SanMen
//
//  Created by lcc on 13-12-23.
//  Copyright (c) 2013年 lcc. All rights reserved.
//

#import "ThemePaiKeCell.h"
#import "UIImageView+WebCache.h"
#import "PaiKeObject.h"

#define HEADERIMGTAG 100
#define NAMETAG 110

@implementation ThemePaiKeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        //拍客
        UIImageView *headerImageView = [[UIImageView alloc] init];
        [headerImageView setFrame:(CGRect){12, 10, 296, 115}];
        headerImageView.tag = HEADERIMGTAG;
        [self.contentView addSubview:headerImageView];
        
        //标题背景
        UILabel *titleBg = [[UILabel alloc] initWithFrame:CGRectMake(0, 85, 296, 30)];
        titleBg.alpha = 0.4f;
        titleBg.backgroundColor = [UIColor blackColor];
        [headerImageView addSubview:titleBg];
        
        //标题
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 85, 296, 30)];
        title.tag = NAMETAG;
        title.font = [UIFont systemFontOfSize:15];
        title.backgroundColor = [UIColor clearColor];
        title.textColor = [UIColor whiteColor];
        title.numberOfLines = 0;
        [headerImageView addSubview:title];
        
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
    UILabel *title = (UILabel *)[self.contentView viewWithTag:NAMETAG];
    
    PaiKeObject *tmpObj = [(NSMutableArray *)object objectAtIndex:indexPath.row];
    
    [headerImageView setImageWithURL:[NSURL URLWithString:tmpObj.p_imgUrl] placeholderImage:[UIImage imageNamed:@"activity_place"]];
    title.text = [NSString stringWithFormat:@"  %@",tmpObj.p_title];
    
}

@end
