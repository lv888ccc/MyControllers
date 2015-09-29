//
//  CommentCell.m
//  SanMen
//
//  Created by lcc on 13-12-23.
//  Copyright (c) 2013年 lcc. All rights reserved.
//

#import "CommentCell.h"
#import "CommentObject.h"

#define NameLabelTag 10
#define TimeLabelTag 11
#define ContentLabelTag 12
#define STag 13

@implementation CommentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        //昵称
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 155, 15)];
        nameLabel.tag = NameLabelTag;
        nameLabel.textColor = [UIColor colorWithRed:50.0f/255.0f green:137.0f/255.0f blue:217.0f/255.0f alpha:1.0];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:nameLabel];
        
        //时间
        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(170, 10, 130, 15)];
        timeLabel.tag = TimeLabelTag;
        timeLabel.textColor = [UIColor grayColor];
        timeLabel.backgroundColor = [UIColor clearColor];
        timeLabel.font = [UIFont systemFontOfSize:13];
        timeLabel.alpha = 0.7f;
        [self.contentView addSubview:timeLabel];
        timeLabel.textAlignment = NSTextAlignmentRight;
        
        //内容
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 30, 290, 40)];
        contentLabel.tag = ContentLabelTag;
        contentLabel.backgroundColor = [UIColor clearColor];
        contentLabel.font = [UIFont systemFontOfSize:15];
        contentLabel.alpha = 0.7f;
        contentLabel.numberOfLines = 0;
        [self.contentView addSubview:contentLabel];
        
        //分割线
        UIImageView *tmpSImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, 305, 1)];
        [self.contentView addSubview:tmpSImg];
        [tmpSImg setImage:[UIImage imageNamed:@"comment_s"]];
        tmpSImg.tag = STag;
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
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
    UILabel *nameLabel = (UILabel *)[self.contentView viewWithTag:NameLabelTag];
    UILabel *timeLabel = (UILabel *)[self.contentView viewWithTag:TimeLabelTag];
    UILabel *contentLabel = (UILabel *)[self.contentView viewWithTag:ContentLabelTag];
    UIImageView *tmpSImg = (UIImageView *)[self.contentView viewWithTag:STag];
    
    CommentObject *tmpObj = [object objectAtIndex:indexPath.row];
    
    nameLabel.text = tmpObj.c_userName;
    timeLabel.text = tmpObj.c_datetime;

    CGSize size = [tmpObj.c_content sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(290, 1000) lineBreakMode:NSLineBreakByTruncatingTail];
    CGRect rect = contentLabel.frame;
    rect.size.height = size.height;
    contentLabel.frame = rect;
    contentLabel.text = tmpObj.c_content;
    
    CGRect sRect = tmpSImg.frame;
    sRect.origin.y = 39 + size.height;
    tmpSImg.frame = sRect;
    
}

@end
