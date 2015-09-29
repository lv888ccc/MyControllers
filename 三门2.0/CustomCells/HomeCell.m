//
//  HomeCell.m
//  SanMen
//
//  Created by lcc on 13-12-20.
//  Copyright (c) 2013年 lcc. All rights reserved.
//

#import "HomeCell.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"
#import "HomeObject.h"

#define TOPIMGTAG 100
#define TOPIMGTITLETAG 110
#define NEWSVIEWTAG 120
#define VIDEONEWSTAG 130
#define SANMENNEWSTAG 140
#define IMGNEWSTAG 150
#define ACTIVITYTAG 160

@implementation HomeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        //不同类型的表格展现形式
        //类型一 新闻
        UIView *newsView = [[UIView alloc] initWithFrame:CGRectMake(12, 12, 296, 307)];
        
        //一个大图片 和 文字说明
        TapImageView *nTopImage = [[TapImageView alloc] initWithFrame:(CGRect){0,0,296,167}];
        nTopImage.tag = TOPIMGTAG;
        [newsView addSubview:nTopImage];
        [nTopImage setT_delegate:self];
        
        //大图片描述性文字
        UILabel *nTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 142, 296, 25)];
        nTitle.tag = TOPIMGTITLETAG;
        nTitle.backgroundColor = [UIColor blackColor];
        nTitle.textColor = [UIColor whiteColor];
        nTitle.font = [UIFont systemFontOfSize:15];
        nTitle.alpha = 0.7f;
        [nTopImage addSubview:nTitle];
        
        newsView.tag = NEWSVIEWTAG;
        for (int i = 0; i < 2; i ++)
        {
            //背景
            TapImageView *bgView = [[TapImageView alloc] initWithFrame:(CGRect){0, 70*i + 167, 296, 70}];
            bgView.tag = NEWSVIEWTAG*10 + i;
            [bgView setImage:[UIImage imageNamed:@"home_cell_bg"]];
            [newsView addSubview:bgView];
            [bgView setT_delegate:self];
            
            //新闻头像
            UIImageView *headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 80, 50)];
            headerImageView.tag = NEWSVIEWTAG*20 + i;
            [bgView addSubview:headerImageView];
            
            //标题
            UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(99, 10, 179, 50)];
            title.tag = NEWSVIEWTAG*30 + i;
            title.font = [UIFont systemFontOfSize:16];
            title.alpha = 0.7f;
            title.backgroundColor = [UIColor clearColor];
            title.numberOfLines = 0;
            [bgView addSubview:title];
        }
        [self.contentView addSubview:newsView];
        //end
        
        //类型二 视频新闻
        UIView *videoNewsView = [[UIView alloc] initWithFrame:CGRectMake(12, 12, 296, 307)];
        videoNewsView.tag = VIDEONEWSTAG;
        
        //一个大图片 和 文字说明
        TapImageView *vTopImage = [[TapImageView alloc] initWithFrame:(CGRect){0,0,296,167}];
        vTopImage.tag = TOPIMGTAG;
        [videoNewsView addSubview:vTopImage];
        [vTopImage setT_delegate:self];
        
        UIImageView *vPlaySign = [[UIImageView alloc] initWithFrame:CGRectMake(126, 55, 43, 43)];
        vPlaySign.image = [UIImage imageNamed:@"home_top_play"];
        [vTopImage addSubview:vPlaySign];
        
        //大图片描述性文字
        UILabel *vTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 142, 296, 25)];
        vTitle.tag = TOPIMGTITLETAG;
        vTitle.backgroundColor = [UIColor blackColor];
        vTitle.textColor = [UIColor whiteColor];
        vTitle.font = [UIFont systemFontOfSize:15];
        vTitle.alpha = 0.7f;
        [vTopImage addSubview:vTitle];
        
        for (int i = 0; i < 2; i ++)
        {
            //背景
            TapImageView *bgView = [[TapImageView alloc] initWithFrame:(CGRect){0, 70*i + 167, 296, 70}];
            bgView.tag = VIDEONEWSTAG*10 + i;
            [bgView setImage:[UIImage imageNamed:@"home_cell_bg"]];
            [videoNewsView addSubview:bgView];
            [bgView setT_delegate:self];
            
            //标题
            UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 179, 50)];
            title.tag = VIDEONEWSTAG*30 + i;
            title.font = [UIFont systemFontOfSize:16];
            title.alpha = 0.7f;
            title.backgroundColor = [UIColor clearColor];
            title.numberOfLines = 0;
            [bgView addSubview:title];
            
            //头像
            UIImageView *headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(206, 10, 80, 50)];
            headerImageView.tag = VIDEONEWSTAG*20 + i;
            [bgView addSubview:headerImageView];
            
            UIImageView *playSign = [[UIImageView alloc] initWithFrame:CGRectMake(25, 10, 30, 30)];
            playSign.image = [UIImage imageNamed:@"home_top_play"];
            [headerImageView addSubview:playSign];
        }
        
        [self.contentView addSubview:videoNewsView];
        //end
        
        //类型三 三门早报
        UIView *sanmenNewsView = [[UIView alloc] initWithFrame:CGRectMake(12, 12, 296, 210)];
        sanmenNewsView.tag = SANMENNEWSTAG;

        for (int i = 0; i < 3; i ++)
        {
            //背景
            TapImageView *bgView = [[TapImageView alloc] initWithFrame:(CGRect){0, 70*i, 296, 70}];
            bgView.tag = SANMENNEWSTAG*10 + i;
            [bgView setImage:[UIImage imageNamed:@"home_cell_bg"]];
            [sanmenNewsView addSubview:bgView];
            [bgView setT_delegate:self];
            
            //新闻头像
            UIImageView *headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 80, 50)];
            headerImageView.tag = SANMENNEWSTAG*20 + i;
            [bgView addSubview:headerImageView];

            //标题
            UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(99, 10, 179, 50)];
            title.tag = SANMENNEWSTAG*30 + i;
            title.font = [UIFont systemFontOfSize:16];
            title.alpha = 0.7f;
            title.backgroundColor = [UIColor clearColor];
            title.numberOfLines = 0;
            [bgView addSubview:title];
        }
        
        [self.contentView addSubview:sanmenNewsView];
        //end
        
        //类型四 - 图集
        UIView *imgNewsView = [[UIView alloc] initWithFrame:CGRectMake(12, 12, 296, 367)];
        imgNewsView.tag = IMGNEWSTAG;

        //一个大图片 和 文字说明
        TapImageView *iTopImage = [[TapImageView alloc] initWithFrame:(CGRect){0,0,296,167}];
        iTopImage.tag = TOPIMGTAG;
        [imgNewsView addSubview:iTopImage];
        [iTopImage setT_delegate:self];

        //大图片描述性文字
        UILabel *iTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 142, 296, 25)];
        iTitle.tag = TOPIMGTITLETAG;
        iTitle.backgroundColor = [UIColor blackColor];
        iTitle.textColor = [UIColor whiteColor];
        iTitle.font = [UIFont systemFontOfSize:15];
        iTitle.alpha = 0.7f;
        [iTopImage addSubview:iTitle];

        for (int i = 0; i < 2; i ++)
        {
            //背景
            UIImageView *bgView = [[UIImageView alloc] initWithFrame:(CGRect){0, 97*i + 167, 296, 97}];
            bgView.tag = IMGNEWSTAG*10 + i;
            [bgView setImage:[UIImage imageNamed:@"home_cell_big_bg"]];
            [imgNewsView addSubview:bgView];
            bgView.userInteractionEnabled = YES;
            
            //标题
            UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(15, 8, 266, 20)];
            title.tag = IMGNEWSTAG*30 + i;
            title.font = [UIFont systemFontOfSize:15];
            [bgView addSubview:title];
            title.backgroundColor = [UIColor clearColor];

            for (int m = 0; m < 3; m ++)
            {
                //新闻头像
                TapImageView *headerImageView = [[TapImageView alloc] initWithFrame:CGRectMake(18 + m*90, 36, 80, 50)];
                headerImageView.tag = IMGNEWSTAG*20 + m;
                [bgView addSubview:headerImageView];
                headerImageView.t_delegate = self;
            }
            
        }
        [self.contentView addSubview:imgNewsView];
        //end
        
        //不同类型的表格展现形式
        //类型五 活动
        UIView *activityView = [[UIView alloc] initWithFrame:CGRectMake(12, 12, 296, 167)];
        activityView.tag = ACTIVITYTAG;
        
        //一个大图片
        TapImageView *aTopImage = [[TapImageView alloc] initWithFrame:CGRectMake(0, 0, 296, 167)];
        aTopImage.tag = TOPIMGTAG;
        [activityView addSubview:aTopImage];
        [self.contentView addSubview:activityView];
        [aTopImage setT_delegate:self];
        //end
        
        [self setBackgroundColor:[UIColor clearColor]];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

#pragma mark -
#pragma mark - custom method
- (void) setContentWithObject:(id) object AtIndexPath: (NSIndexPath *) indexPath
{
    UIView *newsView = [self.contentView viewWithTag:NEWSVIEWTAG];
    UIView *videoNewsView = [self.contentView viewWithTag:VIDEONEWSTAG];
    UIView *sanmenNewsView = [self.contentView viewWithTag:SANMENNEWSTAG];
    UIView *imgNewsView = [self.contentView viewWithTag:IMGNEWSTAG];
    UIView *activityView = [self.contentView viewWithTag:ACTIVITYTAG];
    
    newsView.hidden = YES;
    videoNewsView.hidden = YES;
    sanmenNewsView.hidden = YES;
    imgNewsView.hidden = YES;
    activityView.hidden = YES;

    NSMutableArray *tmpArr = [object objectAtIndex:indexPath.row];
    HomeObject *tmpObj = [tmpArr objectAtIndex:0];
    NSString *typeString = tmpObj.h_type;
    
    switch ([typeString integerValue])
    {
        case NEWSADTYPE: //广告 活动 通知
        {
            activityView.hidden = NO;
            TapImageView *aTopImage = (TapImageView *)[activityView viewWithTag:TOPIMGTAG];
            
            @try
            {
                HomeObject *aTmpObj = [tmpArr objectAtIndex:0];
                aTopImage.identifier = aTmpObj;
                
                [aTopImage setImageWithURL:[NSURL URLWithString:aTmpObj.h_imgUrl] placeholderImage:[UIImage imageNamed:@"home_cell_place"]];
            }
            @catch (NSException *exception)
            {
                [aTopImage setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"home_cell_place"]];
            }
            
        }
            break;
            
        case NEWSTYPE://新闻类型
        {
            newsView.hidden = NO;
            
            //大图
            TapImageView *nTopImage = (TapImageView *)[newsView viewWithTag:TOPIMGTAG];
            //大图标题
            UILabel *nTitle = (UILabel *)[newsView viewWithTag:TOPIMGTITLETAG];
            
            //第一条数据
            TapImageView *bgView1 = (TapImageView *)[newsView viewWithTag:NEWSVIEWTAG*10];
            UIImageView *headerImageView1 = (UIImageView *)[bgView1 viewWithTag:NEWSVIEWTAG*20];
            UILabel *title1 = (UILabel *)[bgView1 viewWithTag:NEWSVIEWTAG*30];
            bgView1.hidden = YES;
            
            //第二条数据
            TapImageView *bgView2 = (TapImageView *)[newsView viewWithTag:NEWSVIEWTAG*10 + 1];
            UIImageView *headerImageView2 = (UIImageView *)[bgView2 viewWithTag:NEWSVIEWTAG*20 + 1];
            UILabel *title2 = (UILabel *)[bgView2 viewWithTag:NEWSVIEWTAG*30 + 1];
            bgView2.hidden = YES;
            
            @try
            {
                HomeObject *nTmpObj1 = [tmpArr objectAtIndex:0];
                [nTopImage setImageWithURL:[NSURL URLWithString:nTmpObj1.h_imgUrl] placeholderImage:[UIImage imageNamed:@"home_cell_place"]];
                nTitle.text = [NSString stringWithFormat:@"  %@",nTmpObj1.h_title];
                nTopImage.identifier = nTmpObj1;
                
                
                [headerImageView1 setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@""]];
                title1.text = @"";
                
                HomeObject *nTmpObj2 = [tmpArr objectAtIndex:1];
                bgView1.identifier = nTmpObj2;
                bgView1.hidden = NO;
                [headerImageView1 setImageWithURL:[NSURL URLWithString:nTmpObj2.h_imgUrl] placeholderImage:[UIImage imageNamed:@"cell_place"]];
                title1.text = nTmpObj2.h_title;
                
                [headerImageView2 setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@""]];
                title2.text = @"";
                HomeObject *nTmpObj3 = [tmpArr objectAtIndex:2];
                bgView2.identifier = nTmpObj3;
                bgView2.hidden = NO;
                [headerImageView2 setImageWithURL:[NSURL URLWithString:nTmpObj3.h_imgUrl] placeholderImage:[UIImage imageNamed:@"cell_place"]];
                title2.text = nTmpObj3.h_title;
            }
            @catch (NSException *exception)
            {
                
            }
        }
            
            break;
            
        case VIDEOTYPE:
        {
            videoNewsView.hidden = NO;
            
            //大图
            TapImageView *vTopImage = (TapImageView *)[videoNewsView viewWithTag:TOPIMGTAG];
            //大图标题
            UILabel *vTitle = (UILabel *)[videoNewsView viewWithTag:TOPIMGTITLETAG];
            
            //第一条数据
            TapImageView *bgView1 = (TapImageView *)[videoNewsView viewWithTag:VIDEONEWSTAG*10];
            UIImageView *headerImageView1 = (UIImageView *)[bgView1 viewWithTag:VIDEONEWSTAG*20];
            UILabel *title1 = (UILabel *)[bgView1 viewWithTag:VIDEONEWSTAG*30];
            bgView1.hidden = YES;
            
            //第二条数据
            TapImageView *bgView2 = (TapImageView *)[videoNewsView viewWithTag:VIDEONEWSTAG*10 + 1];
            UIImageView *headerImageView2 = (UIImageView *)[bgView2 viewWithTag:VIDEONEWSTAG*20 + 1];
            UILabel *title2 = (UILabel *)[bgView2 viewWithTag:VIDEONEWSTAG*30 + 1];
            bgView2.hidden = YES;
            
            @try
            {
                HomeObject *vTmpObj1 = [tmpArr objectAtIndex:0];
                [vTopImage setImageWithURL:[NSURL URLWithString:vTmpObj1.h_imgUrl] placeholderImage:[UIImage imageNamed:@"home_cell_place"]];
                vTitle.text = [NSString stringWithFormat:@"  %@",vTmpObj1.h_title];
                vTopImage.identifier = vTmpObj1;
                
                
                [headerImageView1 setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@""]];
                title1.text = @"";
                HomeObject *vTmpObj2 = [tmpArr objectAtIndex:1];
                bgView1.hidden = NO;
                [headerImageView1 setImageWithURL:[NSURL URLWithString:vTmpObj2.h_imgUrl] placeholderImage:[UIImage imageNamed:@"cell_place"]];
                title1.text = vTmpObj2.h_title;
                bgView1.identifier = vTmpObj2;
                
                [headerImageView2 setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@""]];
                title2.text = @"";
                HomeObject *nTmpObj3 = [tmpArr objectAtIndex:2];
                bgView2.hidden = NO;
                [headerImageView2 setImageWithURL:[NSURL URLWithString:nTmpObj3.h_imgUrl] placeholderImage:[UIImage imageNamed:@"cell_place"]];
                title2.text = nTmpObj3.h_title;
                bgView2.identifier = nTmpObj3;
            }
            @catch (NSException *exception)
            {
                
            }
        }
            break;
            
        case PUBLISHTYPE:
        {
            sanmenNewsView.hidden = NO;
            
            //第一条数据
            TapImageView *bgView1 = (TapImageView *)[sanmenNewsView viewWithTag:SANMENNEWSTAG*10];
            bgView1.hidden = YES;
            UIImageView *headerImageView1 = (UIImageView *)[bgView1 viewWithTag:SANMENNEWSTAG*20];
            UILabel *title1 = (UILabel *)[bgView1 viewWithTag:SANMENNEWSTAG*30];
            
            //第二条数据
            TapImageView *bgView2 = (TapImageView *)[sanmenNewsView viewWithTag:SANMENNEWSTAG*10 + 1];
            bgView2.hidden = YES;
            UIImageView *headerImageView2 = (UIImageView *)[bgView2 viewWithTag:SANMENNEWSTAG*20 + 1];
            UILabel *title2 = (UILabel *)[bgView2 viewWithTag:SANMENNEWSTAG*30 + 1];
            
            //第三条数据
            TapImageView *bgView3 = (TapImageView *)[sanmenNewsView viewWithTag:SANMENNEWSTAG*10 + 2];
            bgView3.hidden = YES;
            UIImageView *headerImageView3 = (UIImageView *)[bgView3 viewWithTag:SANMENNEWSTAG*20 + 2];
            UILabel *title3 = (UILabel *)[bgView3 viewWithTag:SANMENNEWSTAG*30 + 2];
            
            @try
            {
                
                [headerImageView1 setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@""]];
                title1.text = @"";
                HomeObject *sTmpObj1 = [tmpArr objectAtIndex:0];
                bgView1.hidden = NO;
                [headerImageView1 setImageWithURL:[NSURL URLWithString:sTmpObj1.h_imgUrl] placeholderImage:[UIImage imageNamed:@"cell_place"]];
                title1.text = sTmpObj1.h_title;
                bgView1.identifier = sTmpObj1;
                
                
                [headerImageView2 setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@""]];
                title2.text = @"";
                HomeObject *sTmpObj2 = [tmpArr objectAtIndex:1];
                bgView2.hidden = NO;
                [headerImageView2 setImageWithURL:[NSURL URLWithString:sTmpObj2.h_imgUrl] placeholderImage:[UIImage imageNamed:@"cell_place"]];
                title2.text = sTmpObj2.h_title;
                bgView2.identifier = sTmpObj2;
                
                
                [headerImageView3 setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@""]];
                title3.text = @"";
                HomeObject *sTmpObj3 = [tmpArr objectAtIndex:2];
                bgView3.hidden = NO;
                [headerImageView3 setImageWithURL:[NSURL URLWithString:sTmpObj3.h_imgUrl] placeholderImage:[UIImage imageNamed:@"cell_place"]];
                title3.text = sTmpObj3.h_title;
                bgView3.identifier = sTmpObj3;
            }
            @catch (NSException *exception)
            {
                
            }
        }
            
            break;
            
        default:
        {
            imgNewsView.hidden = NO;
            HomeObject *tmpObj1 = [tmpArr objectAtIndex:0];
            NSArray *picArr1 = [tmpObj1.h_imgUrl componentsSeparatedByString:@"^^"];
            
            //背景
            UIImageView *imgNewsView = (UIImageView *)[self.contentView viewWithTag:IMGNEWSTAG];
            
            //大图
            TapImageView *iTopImage = (TapImageView *)[imgNewsView viewWithTag:TOPIMGTAG];
            NSDictionary *tmpDic = [NSDictionary dictionaryWithObjectsAndKeys:tmpObj1,[NSString stringWithFormat:@"%d",0], nil];
            iTopImage.identifier = tmpDic;
            
            //大图描述性文字
            UILabel *title = (UILabel *)[iTopImage viewWithTag:TOPIMGTITLETAG];
            title.text = [NSString stringWithFormat:@" %@",tmpObj1.h_title];
            
            
            if ([picArr1 count] > 0)
            {
                [iTopImage setImageWithURL:[NSURL URLWithString:[picArr1 objectAtIndex:0]] placeholderImage:[UIImage imageNamed:@"home_cell_place"]];
            }
            else
            {
                [iTopImage setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"home_cell_place"]];
            }
            
            @try
            {
                //获取行的大背景
                for (int i = 0; i < 2; i ++)
                {
                    UIImageView *bgView = (UIImageView *)[self.contentView viewWithTag:IMGNEWSTAG*10 + i];
                    UIImageView *bgView2 = (UIImageView *)[self.contentView viewWithTag:IMGNEWSTAG*10 + i + 1];
                    bgView.hidden = YES;
                    bgView2.hidden= YES;
                    
                    HomeObject *tmpObj2 = [tmpArr objectAtIndex:1 + i];
                    NSArray *picArr2 = [tmpObj2.h_imgUrl componentsSeparatedByString:@"^^"];
                    //标题
                    UILabel *rowTitle = (UILabel *)[bgView viewWithTag:IMGNEWSTAG*30 + i];
                    
                    //三张图片全部影藏
                    for (UIView *tmpView in bgView.subviews)
                    {
                        if ([tmpView isKindOfClass:[UIImageView class]])
                        {
                            tmpView.hidden = YES;
                        }
                    }
                    
                    //给三张图片赋值
                    for (int m = 0; m < [picArr2 count]; m ++)
                    {
                        TapImageView *headerImageView = (TapImageView *)[bgView viewWithTag:IMGNEWSTAG*20 + m];
                        headerImageView.hidden = NO;
                        NSDictionary *tmpDic = [NSDictionary dictionaryWithObjectsAndKeys:tmpObj2,[NSString stringWithFormat:@"%d",m], nil];
                        headerImageView.identifier = tmpDic;
                        [headerImageView setImageWithURL:[NSURL URLWithString:[picArr2 objectAtIndex:m]] placeholderImage:[UIImage imageNamed:@"cell_place"]];
                    }
                    
                    bgView.hidden = NO;
                    
                    rowTitle.text = tmpObj2.h_title;
                }
            }
            @catch (NSException *exception)
            {
                
            }
            
            
        }
            break;
    }
}

- (void) setCellDelegate:(id) object
{
    self.h_delegate = object;
}

#pragma mark -
#pragma mark - 控件事件
- (void) btnTapped:(UIButton *) sender
{
    if (self.h_delegate && [self.h_delegate respondsToSelector:@selector(homeCellTapWithObject:)])
    {
        [self.h_delegate homeCellTapWithObject:nil];
    }
}

#pragma mark -
#pragma mark - custom delegate
- (void) tapWithObject:(id)sender
{
    if (self.h_delegate && [self.h_delegate respondsToSelector:@selector(homeCellTapWithObject:)])
    {
        [self.h_delegate homeCellTapWithObject:sender];
    }
}

@end
