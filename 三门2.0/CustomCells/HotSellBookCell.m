//
//  HotSellBookCell.m
//  SanMen
//
//  Created by lcc on 14-2-13.
//  Copyright (c) 2014年 lcc. All rights reserved.
//

#import "HotSellBookCell.h"
#import "UIImageView+WebCache.h"
#import "TapImageView.h"
#import "BookObject.h"

#define IMGTAG 160
#define BGIMGTAG 170

@interface HotSellBookCell()<TapImageViewDelegate>

@end

@implementation HotSellBookCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        for (int m = 0; m < 3; m ++)
        {
            UIImageView *shadowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15 + m*100, 10, 90, 130)];
            [self.contentView addSubview:shadowImageView];
            [shadowImageView setImage:[UIImage imageNamed:@"book_hot_shadow"]];
            shadowImageView.tag = BGIMGTAG + m;
            
            //新闻头像
            TapImageView *headerImageView = [[TapImageView alloc] initWithFrame:CGRectMake(20 + m*100, 15, 80, 120)];
            headerImageView.tag = IMGTAG + m;
            headerImageView.t_delegate = self;
            [self.contentView addSubview:headerImageView];
        }
        
        [self setBackgroundColor:[UIColor clearColor]];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        UIImageView *pressView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"book_cell_back"]];
        [self setBackgroundView:pressView];
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
    NSMutableArray *tmpArr = object;
    
    for (int i = 0; i < 3; i ++)
    {
        TapImageView *headerImageView = (TapImageView *)[self.contentView viewWithTag:IMGTAG + i];
        headerImageView.hidden = YES;
        
        UIImageView *shadowImageView = (UIImageView *)[self.contentView viewWithTag:BGIMGTAG + i];
        shadowImageView.hidden = YES;
    }
    
    @try
    {
        for (int i = 0; i < 3; i ++)
        {
            TapImageView *headerImageView = (TapImageView *)[self.contentView viewWithTag:IMGTAG + i];
            UIImageView *shadowImageView = (UIImageView *)[self.contentView viewWithTag:BGIMGTAG + i];
            NSInteger index = indexPath.row * 3 + i;
            
            if (index <= [tmpArr count] - 1)
            {
                headerImageView.hidden = NO;
                shadowImageView.hidden = NO;
                BookObject *tmpObj = [tmpArr objectAtIndex:index];
                [headerImageView setImageWithURL:[NSURL URLWithString:tmpObj.b_imgUrl] placeholderImage:[UIImage imageNamed:@"book_cell_holder"]];
                headerImageView.identifier = tmpObj;
            }
            else
            {
                return;
            }
        }
    }
    @catch (NSException *exception)
    {
        
    }
}

- (void) setCellDelegate:(id) object
{
    self.h_delegate = object;
}

#pragma mark -
#pragma mark - tapView delegate
- (void) tapWithObject:(id)sender
{
    if ([self.h_delegate respondsToSelector:@selector(hotSellBookTapWihtObject:)] && self.h_delegate)
    {
        [self.h_delegate hotSellBookTapWihtObject:sender];
    }
}

@end
