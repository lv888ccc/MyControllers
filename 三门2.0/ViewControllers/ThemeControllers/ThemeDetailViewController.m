//
//  ThemeDetailViewController.m
//  SanMen
//
//  Created by lcc on 14-2-14.
//  Copyright (c) 2014年 lcc. All rights reserved.
//

#import "ThemeDetailViewController.h"
#import "ImageScaleAndSlip.h"
#import "CCClientRequest.h"
#import "PaiKeContentDetailViewController.h"
#import "PaiKeObject.h"
#import "NewsCommentViewController.h"
#import "FMDBManage.h"
#import "CollectionObject.h"
#import "StatusTipView.h"
#import "UMSocial.h"

UIKIT_EXTERN void UIImageWriteToSavedPhotosAlbum(UIImage *image, id completionTarget, SEL completionSelector, void *contextInfo);

@interface ThemeDetailViewController ()<UIScrollViewDelegate>
{
    NSInteger currentIndex;
    BOOL isConllected;
}

@property (strong, nonatomic) IBOutlet UIScrollView *ui_scrollView;
@property (strong, nonatomic) IBOutlet UILabel *ui_titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *ui_indexLabel;
@property (strong, nonatomic) IBOutlet UIScrollView *ui_subTitleScrollView;
@property (strong, nonatomic) IBOutlet UILabel *ui_commentLabel;
@property (strong, nonatomic) IBOutlet UIView *ui_buttomView;
@property (strong, nonatomic) IBOutlet UIView *ui_commentView;
@property (strong, nonatomic) IBOutlet UIButton *ui_collectionBtn;
@property (strong, nonatomic) IBOutlet UIButton *ui_saveBtn;
@property (strong, nonatomic) IBOutlet UILabel *ui_subTitleLabel;

@property (strong, nonatomic) NSMutableArray *imgsArr;
@property (strong, nonatomic) CCClientRequest *myRequest;
@property (strong, nonatomic) StatusTipView *tipView;

@end

@implementation ThemeDetailViewController

- (void)dealloc
{
    self.ui_scrollView = nil;
    self.ui_titleLabel = nil;
    self.ui_indexLabel = nil;
    self.ui_subTitleScrollView = nil;
    self.themeObject = nil;
    self.ui_commentView = nil;
    self.ui_collectionBtn = nil;
    self.ui_saveBtn = nil;
    
    [self.myRequest setC_delegate:nil];
    self.myRequest = nil;
    self.imgsArr = nil;
    self.tipView = nil;
    self.ui_subTitleLabel = nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        //网络请求
        self.myRequest = [[CCClientRequest alloc] init];
        self.myRequest.c_delegate = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tipView = [[StatusTipView alloc] initWithFrame:CGRectMake(320, 160, 120, 70)];
    [self.view addSubview:self.tipView];
    
    //判断是否收藏了
    NSMutableArray *tmpArr = [FMDBManage getDataFromTable:[CollectionObject class] WithString:[NSString stringWithFormat:@"c_id='%@' and c_modelType='%d'",self.themeObject.t_id,THEMEPRO]];
    if ([tmpArr count] > 0)
    {
        [self.ui_collectionBtn setImage:[UIImage imageNamed:@"collected"] forState:UIControlStateNormal];
        isConllected = YES;
    }
    //end
    
    //网络请求
    [self.myRequest paikeImgDetailWithPid:self.themeObject.t_id];
    [self.tipView tipShowWithType:InfoCommittingTip tipString:Loading isHidden:NO];
    //end
    
    self.ui_scrollView.clipsToBounds = NO;
    self.ui_scrollView.frame = CGRectMake(0, 0, 340, viewHeight);
    self.ui_scrollView.pagingEnabled = YES;
    self.ui_scrollView.showsHorizontalScrollIndicator = NO;
    self.ui_subTitleScrollView.showsVerticalScrollIndicator = NO;
    
    self.view.clipsToBounds = YES;
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [StatusBarObject setStatusBarStyleWithIndex:1];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.isLight == NO)
    {
        [StatusBarObject setStatusBarStyleWithIndex:0];
    }
}

#pragma mark -
#pragma mark - //收藏入库与出库
- (void) collectionWithSign:(NSInteger) sign
{
    
    [self.view bringSubviewToFront:self.tipView];
    
    //取消收藏
    if (sign == 0)
    {
        [FMDBManage deleteFromTable:[CollectionObject class] WithString:[NSString stringWithFormat:@"c_id='%@'",self.themeObject.t_id]];
        [self.ui_collectionBtn setImage:[UIImage imageNamed:@"collection"] forState:UIControlStateNormal];
        isConllected = NO;
        
        [self.tipView tipShowWithType:CancelCollect tipString:CancelCollection isHidden:YES];
    }
    //添加收藏
    else
    {
        CollectionObject *tmpObj = [[CollectionObject alloc] init];
        tmpObj.c_id = self.themeObject.t_id;
        tmpObj.c_title = self.themeObject.t_title;
        tmpObj.c_imgUrl = self.themeObject.t_imgUrl;
        tmpObj.c_modelType = [NSString stringWithFormat:@"%d",THEMEPRO];
        tmpObj.c_newsTypeName = SMApp.newsTypeName == nil?TOPNEWS:SMApp.newsTypeName;
        
        //收藏时间
        NSDate *  senddate=[NSDate date];
        NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"MM-dd HH:mm:ss"];
        NSString *  morelocationString=[dateformatter stringFromDate:senddate];
        
        tmpObj.c_collectionTime = [NSString stringWithFormat:@"收藏于 %@",morelocationString];
        [FMDBManage insertProgramWithObject:tmpObj];
        [self.ui_collectionBtn setImage:[UIImage imageNamed:@"collected"] forState:UIControlStateNormal];
        isConllected = YES;
        
        [self.tipView tipShowWithType:SuccessCollect tipString:SucessCollection isHidden:YES];
    }
    
}

#pragma mark -
#pragma mark - 控件事件
- (IBAction)backTapped:(id)sender
{
    [SMApp.nav popViewController];
}

- (IBAction)downloadTapped:(id)sender
{
    ImageScaleAndSlip *ascrView = (ImageScaleAndSlip *)[self.ui_scrollView viewWithTag:currentIndex + 1000];
    [self.tipView tipShowWithType:SuccessTip tipString:SuccessSaveImg isHidden:YES];
    UIImageWriteToSavedPhotosAlbum(ascrView.imageView.image,nil, nil, nil);
}

- (IBAction)shareTapped:(id)sender
{
    //设置微信分享应用类型，用户点击消息将跳转到应用，或者到下载页面
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeApp;
    //分享图文样式到微信朋友圈显示字数比较少，只显示分享标题
    [UMSocialData defaultData].extConfig.title = self.themeObject.t_title;
    //设置微信好友或者朋友圈的分享url,下面是微信好友，微信朋友圈对应wechatTimelineData
    [UMSocialData defaultData].extConfig.wechatSessionData.url = SAMDOWNURL;
    
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:YouMengKey
                                      shareText:[NSString stringWithFormat:@"『%@』%@",self.themeObject.t_title,ShareText]
                                     shareImage:nil
                                shareToSnsNames:nil
                                       delegate:nil];
}

- (IBAction)collectionTapped:(id)sender
{
    if (isConllected)
    {
        [self collectionWithSign:0];
    }
    else
    {
        [self collectionWithSign:1];
    }
}
- (IBAction)commentTapped:(id)sender
{
    NewsCommentViewController *comment = [[NewsCommentViewController alloc] init];
    comment.newsId = self.themeObject.t_id;
    comment.newsDelegate = self;
    [SMApp.nav pushViewController:comment];
}

#pragma mark - 
#pragma mark - custom delegate
- (void) addCommentCount
{
    self.ui_commentLabel.text = [NSString stringWithFormat:@"%d",[self.ui_commentLabel.text integerValue] + 1];
}

#pragma mark -
#pragma mark - scrolldelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    currentIndex = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth)+1;
    
    ImageScaleAndSlip *ascrView = (ImageScaleAndSlip *)[self.ui_scrollView viewWithTag:1000 + currentIndex - 1];
    if (ascrView)
    {
        ascrView.zoomScale = 1;
    }
    
    if (currentIndex <= self.imgsArr.count - 1)
    {
        self.ui_indexLabel.text = [NSString stringWithFormat:@"%d/%d",currentIndex + 1,[self.imgsArr count]];
        
        PaiKeObject *tmpObj = [self.imgsArr objectAtIndex:currentIndex];
        self.ui_titleLabel.text = tmpObj.p_title;
        CGSize subTitleSize = [tmpObj.p_subTitle sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(302, 1000) lineBreakMode:NSLineBreakByTruncatingTail];
        
        if (subTitleSize.height > 85)
        {
            CGSize tmpSize = self.ui_subTitleScrollView.contentSize;
            tmpSize.height = subTitleSize.height;
            self.ui_subTitleScrollView.contentSize = tmpSize;
        }
        else
        {
            CGSize tmpSize = self.ui_subTitleScrollView.contentSize;
            tmpSize.height = 95;
            self.ui_subTitleScrollView.contentSize = tmpSize;
        }
        
        self.ui_subTitleLabel.text = tmpObj.p_subTitle;
        self.ui_subTitleLabel.frame = CGRectMake(0, 8, 302, subTitleSize.height);
        
        self.ui_commentLabel.text = [NSString stringWithFormat:@"%@",tmpObj.p_count];
    }
}

- (void) scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    CGFloat pageWidth = scrollView.frame.size.width;
    if (scrollView.contentOffset.x > ((pageWidth*(self.imgsArr.count - 1)) + pageWidth/4))
    {
        NewsCommentViewController *comment = [[NewsCommentViewController alloc] init];
        comment.newsId = self.themeObject.t_id;
        comment.newsDelegate = self;
        [SMApp.nav pushViewController:comment];
    }
}

#pragma mark -
#pragma mark - 网络数据放回
- (void) paikeImgDetailCallBack:(id) objectData
{
    NSMutableArray *tmpArr = (NSMutableArray *)objectData;
    self.imgsArr = tmpArr;
    if ([tmpArr count] > 0)
    {
        currentIndex = [self.themeObject.t_index integerValue];
        
        [UIView animateWithDuration:0.5 animations:^{
            CGRect rect = self.ui_commentView.frame;
            rect.origin.x = 260;
            self.ui_commentView.frame = rect;
        }];
        
        self.ui_buttomView.hidden = NO;
        self.ui_scrollView.hidden = NO;
        NSInteger imgCount = [tmpArr count];
        int imgWith = 340*imgCount;
        self.ui_scrollView.contentSize = CGSizeMake(imgWith, viewHeight);
        
        for (int i = 0 ; i < imgCount; i ++)
        {
            
            ImageScaleAndSlip *ascrView = [[ImageScaleAndSlip alloc] initWithFrame:CGRectMake(340*i, 0, 320, self.self.ui_scrollView.frame.size.height)];
            
            PaiKeObject *tmpObj = [tmpArr objectAtIndex:i];
            ascrView.imagePath = tmpObj.p_imgUrl;
            ascrView.tag = 1000+i;
            
            [self.self.ui_scrollView addSubview:ascrView];
        }
        
        PaiKeObject *tmpObj = [tmpArr objectAtIndex:currentIndex];
        self.ui_titleLabel.text = tmpObj.p_title;
        
        
        CGSize subTitleSize = [tmpObj.p_subTitle sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(302, 1000) lineBreakMode:NSLineBreakByTruncatingTail];
        
        if (subTitleSize.height > 85)
        {
            CGSize tmpSize = self.ui_subTitleScrollView.contentSize;
            tmpSize.height = subTitleSize.height;
            self.ui_subTitleScrollView.contentSize = tmpSize;
        }
        else
        {
            CGSize tmpSize = self.ui_subTitleScrollView.contentSize;
            tmpSize.height = 95;
            self.ui_subTitleScrollView.contentSize = tmpSize;
        }
        
        self.ui_subTitleLabel.text = tmpObj.p_subTitle;
        self.ui_subTitleLabel.frame = CGRectMake(0, 8, 302, subTitleSize.height);
        
        self.ui_commentLabel.text = [NSString stringWithFormat:@"%@",tmpObj.p_count];
        
        self.ui_indexLabel.hidden = NO;
        
        self.ui_scrollView.contentOffset = CGPointMake(340*currentIndex, 0);
        self.ui_indexLabel.text = [NSString stringWithFormat:@"%d/%d",currentIndex + 1,imgCount];
        
        [self.view bringSubviewToFront:self.ui_indexLabel];
        
    }
    else
    {
        self.self.ui_scrollView.hidden = YES;
    }
    
    [self.tipView tipShowWithType:SuccessTip tipString:DoneLoading isHidden:YES];
    
}

@end
