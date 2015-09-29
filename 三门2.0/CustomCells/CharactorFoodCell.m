//
//  CharactorFoodCell.m
//  SanMen
//
//  Created by lcc on 13-12-23.
//  Copyright (c) 2013年 lcc. All rights reserved.
//

#import "CharactorFoodCell.h"
#import "UIButton+WebCache.h"
#import "LocalNewsObject.h"

#define BG1TAG 99
#define HEADERIMG1TAG 1000
#define TITLE1TAG 110

#define BG2TAG 199
#define HEADERIMG2TAG 1001
#define TITLE2TAG 110

@implementation CharactorFoodCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        //背景1
        UIImageView *bgView1 = [[UIImageView alloc] initWithFrame:CGRectMake(20, 5, 131, 171)];
        [self.contentView addSubview:bgView1];
        bgView1.tag = BG1TAG;
        [bgView1 setImage:[[UIImage imageNamed:@"home_cell_bg"] stretchableImageWithLeftCapWidth:20 topCapHeight:35]];
        bgView1.userInteractionEnabled = YES;
        
        //新闻头像1
        UIButton *headerImageView1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [headerImageView1 setFrame:(CGRect){0, 0, 131, 141}];
        headerImageView1.tag = HEADERIMG1TAG;
        [bgView1 addSubview:headerImageView1];
        [headerImageView1 addTarget:self action:@selector(imgTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        //标题1
        UILabel *title1 = [[UILabel alloc] initWithFrame:CGRectMake(3, 141, 125, 30)];
        title1.tag = TITLE1TAG;
        title1.font = [UIFont systemFontOfSize:16];
        title1.alpha = 0.7f;
        [bgView1 addSubview:title1];
        
        //背景2
        UIImageView *bgView2 = [[UIImageView alloc] initWithFrame:CGRectMake(169, 5, 131, 171)];
        [self.contentView addSubview:bgView2];
        bgView2.tag = BG2TAG;
        [bgView2 setImage:[[UIImage imageNamed:@"home_cell_bg"] stretchableImageWithLeftCapWidth:20 topCapHeight:35]];
        bgView2.userInteractionEnabled = YES;
        
        //新闻头像2
        UIButton *headerImageView2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [headerImageView2 setFrame:(CGRect){0, 0, 131, 141}];
        headerImageView2.tag = HEADERIMG2TAG;
        [bgView2 addSubview:headerImageView2];
        [headerImageView2 addTarget:self action:@selector(imgTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        //标题2
        UILabel *title2 = [[UILabel alloc] initWithFrame:CGRectMake(3, 141, 125, 30)];
        title2.tag = TITLE2TAG;
        title2.font = [UIFont systemFontOfSize:16];
        title2.alpha = 0.7f;
        [bgView2 addSubview:title2];
        
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
    self.cellIndexPath = indexPath;
    
    UIImageView *bgView1 = (UIImageView *)[self.contentView viewWithTag:BG1TAG];
    UILabel *title1 = (UILabel *)[bgView1 viewWithTag:TITLE1TAG];
    UIButton *headerImageView1 = (UIButton *)[bgView1 viewWithTag:HEADERIMG1TAG];
    
    UIImageView *bgView2 = (UIImageView *)[self.contentView viewWithTag:BG2TAG];
    UILabel *title2 = (UILabel *)[bgView2 viewWithTag:TITLE2TAG];
    UIButton *headerImageView2 = (UIButton *)[bgView2 viewWithTag:HEADERIMG2TAG];
    
    bgView1.hidden = YES;
    bgView2.hidden = YES;
    
    NSMutableArray *dataArr = (NSMutableArray *)object;
    
    NSInteger rowIndex = indexPath.row;
    NSInteger arrIndex = rowIndex*2;
    sendingIndex = arrIndex;
    
    if (arrIndex >= [dataArr count])
    {
        return;
    }
    
    bgView1.hidden = NO;
    LocalNewsObject *tmpObj1 = [dataArr objectAtIndex:arrIndex];
    title1.text = tmpObj1.l_title;
    [headerImageView1 setImageWithURL:[NSURL URLWithString:tmpObj1.l_imgUrl] placeholderImage:[UIImage imageNamed:@"charactor_place"]];
    
    if (arrIndex + 1 >= [dataArr count])
    {
        return;
    }
    
    bgView2.hidden = NO;
    LocalNewsObject *tmpObj2 = [dataArr objectAtIndex:arrIndex + 1];
    title2.text = tmpObj2.l_title;
    [headerImageView2 setImageWithURL:[NSURL URLWithString:tmpObj2.l_imgUrl] placeholderImage:[UIImage imageNamed:@"charactor_place"]];
    
}

- (void) setCellDelegate:(id) object
{
    self.c_delegate = object;
}

- (void) imgTapped:(UIButton *) sender
{
    if (self.c_delegate && [self.c_delegate respondsToSelector:@selector(charactorFoodCellTapWithIndex:)])
    {
        [self.c_delegate charactorFoodCellTapWithIndex:self.cellIndexPath.row*2+(sender.tag - 1000)];
    }
}

@end