//
//  CollectionCell.m
//  SanMen
//
//  Created by lcc on 13-12-25.
//  Copyright (c) 2013年 lcc. All rights reserved.
//

#import "CollectionCell.h"
#import "UIImageView+WebCache.h"
#import "CollectionObject.h"
#import "TapImageView.h"

#define HEADERIMGTAG 100
#define TITLETAG 110
#define TIMEBGTAG 130
#define TYPETAG 140
#define COLLECTIONTIMETAG 150

#define SUBTAG 10000
#define THEMETITLETAG 1001

#define CELLTAG 200

#define THEMEVIEWTAG 300

@interface CollectionCell()<TapImageViewDelegate>

@end

@implementation CollectionCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        //新闻类型
        UIView *cellView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 380, 109)];
        [self.contentView addSubview:cellView];
        cellView.tag = CELLTAG;
        cellView.backgroundColor = [UIColor clearColor];
        
        //背景
        UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 5, 296, 70)];
        [cellView addSubview:bgView];
        [bgView setImage:[UIImage imageNamed:@"home_cell_bg"]];
        
        //新闻头像
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

        //时间类型背景
        UIImageView *timeBgView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 34, 296, 70)];
        timeBgView.tag = TIMEBGTAG;
        [self.contentView addSubview:timeBgView];
        [timeBgView setImage:[UIImage imageNamed:@"home_cell_bg"]];
        [self.contentView sendSubviewToBack:timeBgView];
        
        UILabel *type = [[UILabel alloc] initWithFrame:CGRectMake(12, 47, 40, 15)];
        type.tag = TYPETAG;
        type.font = [UIFont systemFontOfSize:12];
        type.textColor = [UIColor whiteColor];
        type.backgroundColor = [UIColor colorWithRed:50.0f/255.0f green:137.0f/255.0f blue:217.0f/255.0f alpha:1.0f];
        type.textAlignment = NSTextAlignmentCenter;
        [timeBgView addSubview:type];
        
        UIButton *delNewsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [delNewsBtn setImage:[UIImage imageNamed:@"collection_del"] forState:UIControlStateNormal];
        delNewsBtn.frame = CGRectMake(320, 0, 60, 109);
        [delNewsBtn addTarget:self action:@selector(delTapped:) forControlEvents:UIControlEventTouchUpInside];
        [cellView addSubview:delNewsBtn];
        
        //收藏时间
        UILabel *time = [[UILabel alloc] initWithFrame:CGRectMake(50, 47, 236, 15)];
        time.tag = COLLECTIONTIMETAG;
        time.font = [UIFont systemFontOfSize:12];
        time.textColor = [UIColor grayColor];
        time.textAlignment = NSTextAlignmentRight;
        [timeBgView addSubview:time];
        //end
        
        //主题类
        UIView *tmpThemeViewBg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 380, 109)];
        tmpThemeViewBg.tag = CELLTAG + 1;
        [self.contentView addSubview:tmpThemeViewBg];
        tmpThemeViewBg.backgroundColor = [UIColor clearColor];
        
        UIImageView *bgThemeView = [[UIImageView alloc] initWithFrame:(CGRect){12, 5, 296, 99}];
        [bgThemeView setImage:[UIImage imageNamed:@"home_cell_big_bg"]];
        [tmpThemeViewBg addSubview:bgThemeView];
        bgThemeView.tag = THEMEVIEWTAG;
        bgThemeView.userInteractionEnabled = YES;
        
        //标题
        UILabel *titleTheme = [[UILabel alloc] initWithFrame:CGRectMake(15, 8, 266, 20)];
        titleTheme.tag = THEMETITLETAG;
        titleTheme.font = [UIFont systemFontOfSize:15];
        [bgThemeView addSubview:titleTheme];
        titleTheme.backgroundColor = [UIColor clearColor];
        
        for (int m = 0; m < 3; m ++)
        {
            //新闻头像
            TapImageView *headerImageView = [[TapImageView alloc] initWithFrame:CGRectMake(18 + m*90, 36, 80, 50)];
            headerImageView.tag = SUBTAG + m;
            [bgThemeView addSubview:headerImageView];
            [headerImageView setT_delegate:self];
        }
        
        UIButton *delThemeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [delThemeBtn setImage:[UIImage imageNamed:@"collection_del"] forState:UIControlStateNormal];
        delThemeBtn.frame = CGRectMake(320, 0, 60, 138);
        [delThemeBtn addTarget:self action:@selector(delTapped:) forControlEvents:UIControlEventTouchUpInside];
        [tmpThemeViewBg addSubview:delThemeBtn];
        
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

#pragma mark -
#pragma mark - custome method
- (void) setContentWithObject:(id) object AtIndexPath: (NSIndexPath *) indexPath
{
    CollectionObject *tmpObj = [(NSMutableArray *)object objectAtIndex:indexPath.row];
    
    UIImageView *cellNewsView = (UIImageView *)[self.contentView viewWithTag:CELLTAG];
    UIImageView *bgThemeView = (UIImageView *)[self.contentView viewWithTag:CELLTAG + 1];
    
    UIImageView *timeBgView = (UIImageView *)[self.contentView viewWithTag:TIMEBGTAG];
    UILabel *time = (UILabel *)[timeBgView viewWithTag:COLLECTIONTIMETAG];
    UILabel *type =  (UILabel *)[timeBgView viewWithTag:TYPETAG];
    
    CGRect timeRect = timeBgView.frame;
    time.text = tmpObj.c_collectionTime;
    type.text = tmpObj.c_newsTypeName;
    
    cellNewsView.hidden = YES;
    bgThemeView.hidden = YES;
    
    if ([tmpObj.c_modelType integerValue] == THEMEPRO)
    {
        timeRect.origin.y = 64;
        timeBgView.frame = timeRect;
        
        //非新闻类型
        bgThemeView.hidden = NO;
        CGRect rectTheme = bgThemeView.frame;
        if ([tmpObj.c_isEdit isEqualToString:@"1"])
        {
            rectTheme.origin.x = -60;
            timeRect.origin.x = -48;
        }
        else
        {
            rectTheme.origin.x = 0;
            timeRect.origin.x = 12;
        }
        bgThemeView.frame = rectTheme;
        timeBgView.frame = timeRect;

        NSArray *picArr = [tmpObj.c_imgUrl componentsSeparatedByString:@"^^"];
        
        UIView *tmpThemeViewBg = [self.contentView viewWithTag:CELLTAG + 1];
        UIImageView *bgThemeView = (UIImageView *)[tmpThemeViewBg viewWithTag:THEMEVIEWTAG];
        UILabel *titleTheme = (UILabel *)[bgThemeView viewWithTag:THEMETITLETAG];
        
        for (UIView *tmpView in bgThemeView.subviews)
        {
            if ([tmpView isKindOfClass:[UIImageView class]])
            {
                tmpView.hidden = YES;
            }
        }
        
        for (int i = 0; i < [picArr count]; i ++)
        {
            TapImageView *headerImageView = (TapImageView *)[bgThemeView viewWithTag:SUBTAG + i];
            headerImageView.hidden = NO;
            NSDictionary *tmpDic = [NSDictionary dictionaryWithObjectsAndKeys:tmpObj,[NSString stringWithFormat:@"%d",i], nil];
            headerImageView.identifier = tmpDic;
            [headerImageView setImageWithURL:[NSURL URLWithString:[picArr objectAtIndex:i]] placeholderImage:[UIImage imageNamed:@"cell_place"]];
        }
        
        titleTheme.text = tmpObj.c_title;
    }
    else
    {
        cellNewsView.hidden = NO;
        
        timeRect.origin.y = 34;
        timeBgView.frame = timeRect;
        
        //新闻类型
        UIView *cellView = [self.contentView viewWithTag:CELLTAG];
        UILabel *title = (UILabel *)[cellView viewWithTag:TITLETAG];
        UIImageView *headerImageView = (UIImageView *)[cellView viewWithTag:HEADERIMGTAG];
        
        [headerImageView setImageWithURL:[NSURL URLWithString:tmpObj.c_imgUrl] placeholderImage:[UIImage imageNamed:@"cell_place"]];
        title.text = tmpObj.c_title;

        CGRect rectNews = cellNewsView.frame;
        if ([tmpObj.c_isEdit isEqualToString:@"1"])
        {
            rectNews.origin.x = -60;
            timeRect.origin.x = -48;
        }
        else
        {
            rectNews.origin.x = 0;
            timeRect.origin.x = 12;
        }
        
        cellNewsView.frame = rectNews;
        timeBgView.frame = timeRect;
    }
    
     self.cellIndexPath = indexPath;
    
}

- (void) setCellDelegate:(id) object
{
    self.c_delegate = object;
}

- (void) delTapped:(UIButton *) sender
{
    if (self.c_delegate && [self.c_delegate respondsToSelector:@selector(collectionCellTapWithIndex:)])
    {
        [self.c_delegate collectionCellTapWithIndex:self.cellIndexPath];
    }
}

#pragma mark -
#pragma mark - tapView delegate
- (void) tapWithObject:(id)sender
{
    if ([self.c_delegate respondsToSelector:@selector(collectionCellTapWithObject:)] && self.c_delegate)
    {
        [self.c_delegate collectionCellTapWithObject:sender];
    }
}

@end

