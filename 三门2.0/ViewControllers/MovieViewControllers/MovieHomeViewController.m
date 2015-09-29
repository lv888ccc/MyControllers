//
//  MovieHomeViewController.m
//  SanMen
//
//  Created by lcc on 13-12-18.
//  Copyright (c) 2013年 lcc. All rights reserved.
//

#import "MovieHomeViewController.h"
#import "DJQRateView.h"
#import "TapImageView.h"
#import "MovieDetailViewController.h"
#import "CCClientRequest.h"
#import "MovieObject.h"
#import "UIImageView+WebCache.h"
#import "RTLabel.h"
#import "FMDBManage.h"

#define Iphone4Width 210
#define Iphone4Height 294

#define Iphone5Width 250
#define Iphone5Height 350

@interface MovieHomeViewController ()<UIScrollViewDelegate,TapImageViewDelegate>
{
    CGPoint beginPoint;
    int lastPage;
    int currentPage;
    
    int imgWidth;
    int imgHeight;
    int imgWWidth;
    
    UIWebView *webView;
}

@property (strong, nonatomic) IBOutlet UIScrollView *ui_imgsScrollView;
@property (strong, nonatomic) IBOutlet DJQRateView *ui_starView;
@property (strong, nonatomic) IBOutlet UIView *ui_detailView;
@property (strong, nonatomic) IBOutlet UIButton *ui_markBtn;
@property (strong, nonatomic) IBOutlet UILabel *ui_startLabel;
@property (strong, nonatomic) NSMutableArray *movieArr;
@property (strong, nonatomic) IBOutlet UILabel *ui_titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *ui_nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *ui_detailNameLabel;
@property (strong, nonatomic) RTLabel *ui_contentLabel;
@property (strong, nonatomic) IBOutlet UIScrollView *ui_buttomScrollView;

@property (strong, nonatomic) NSString *phoneString;

@property (nonatomic, strong) CCClientRequest *myRequest;

@end

@implementation MovieHomeViewController

- (void)dealloc
{
    self.myRequest.c_delegate = nil;
    self.myRequest = nil;
    
    self.ui_imgsScrollView = nil;
    self.ui_starView = nil;
    self.ui_detailView = nil;
    self.ui_markBtn = nil;
    self.phoneString = nil;
    
    self.ui_titleLabel = nil;
    self.ui_nameLabel = nil;
    self.ui_detailNameLabel = nil;
    self.ui_contentLabel = nil;
    self.ui_buttomScrollView = nil;
    
    self.movieArr = nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.myRequest = [[CCClientRequest alloc] init];
        [self.myRequest setC_delegate:self];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    //网络调用
    [self.myRequest movieDetailListWithCId:self.cinemaId];
    //end
    
    [self initControllers];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

#pragma mark -
#pragma mark - custom method
- (void) initControllers
{
    self.movieArr = [[NSMutableArray alloc] init];
    
    CGSize cSize = self.ui_buttomScrollView.contentSize;
    cSize.height = 301;
    self.ui_buttomScrollView.contentSize = cSize;
    self.ui_buttomScrollView.showsVerticalScrollIndicator = NO;
    
    
    webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:webView];
    
    imgWidth = viewHeight > 480?Iphone5Width:Iphone4Width;
    imgHeight = viewHeight > 480?Iphone5Height:Iphone4Height;
    imgWWidth = viewHeight > 480?5:15;
    
    self.ui_imgsScrollView.pagingEnabled = YES;
    self.ui_imgsScrollView.clipsToBounds = NO;
    self.ui_imgsScrollView.showsHorizontalScrollIndicator = NO;
    CGRect scrollRect = self.ui_imgsScrollView.frame;
    scrollRect.size = CGSizeMake(imgWidth + imgWWidth, imgHeight);
    scrollRect.origin = CGPointMake(160 - imgWidth/2, viewHeight > 480?(15+scrollRect.origin.y):scrollRect.origin.y);
    self.ui_imgsScrollView.frame = scrollRect;
    
    self.view.clipsToBounds = YES;
    
    lastPage = 0;
    currentPage = 0;
    //end
    
    //影院详情
    CGRect detailRect = self.ui_detailView.frame;
    detailRect.origin.y = viewHeight;
    self.ui_detailView.frame = detailRect;
    [self.view addSubview:self.ui_detailView];
    //end
    
    //遮罩层
    [self.view addSubview:self.ui_markBtn];
    //end
    
    self.ui_contentLabel = [[RTLabel alloc] initWithFrame:CGRectMake(9, 54, 303, 100)];
    [self.ui_buttomScrollView addSubview:self.ui_contentLabel];
    self.ui_contentLabel.font = [UIFont systemFontOfSize:15];
    self.ui_contentLabel.alpha = 0.7;
    self.ui_contentLabel.backgroundColor = [UIColor clearColor];
    self.ui_contentLabel.textColor = [UIColor blackColor];
    
    //本地缓存读取
    NSArray *tmpArr = [FMDBManage getDataFromTable:[MovieObject class] WithString:[NSString stringWithFormat:@"m_c_id='%@'",self.cinemaId]];
    if (tmpArr)
    {
        [self.movieArr addObjectsFromArray:tmpArr];
    }
    
    if ([self.movieArr count] > 0)
    {
        [self addMovieInfo];
    }
}

- (void) addMovieInfo
{
    for (UIView *tmpView in self.ui_imgsScrollView.subviews)
    {
        [tmpView removeFromSuperview];
    }
    
    //scroll 设置
    CGSize size = self.ui_imgsScrollView.contentSize;
    size.width = (imgWidth + imgWWidth)*[self.movieArr count];
    self.ui_imgsScrollView.contentSize = size;
    
    for (int i = 0; i < [self.movieArr count]; i++)
    {
        MovieObject *tmpObj = [self.movieArr objectAtIndex:i];
        
        UIView *tmpView = [[UIView alloc] initWithFrame:(CGRect){(imgWidth + imgWWidth)*i,0,imgWidth,imgHeight}];
        [tmpView setBackgroundColor:[UIColor clearColor]];
        
        TapImageView *tmpImgView = [[TapImageView alloc] initWithFrame:(CGRect){20,30,imgWidth - 40,imgHeight - 60}];
        [tmpImgView setImageWithURL:[NSURL URLWithString:tmpObj.m_imgUrl] placeholderImage:[UIImage imageNamed:@"movie_default"]];
        if (i == 0)
        {
            tmpImgView.frame = (CGRect){0,0,imgWidth,imgHeight};
        }
        [tmpImgView setT_delegate:self];
        tmpImgView.tag = i + 111;
        [tmpView addSubview:tmpImgView];
        tmpImgView.identifier = tmpObj;
        
        tmpView.tag = i + 10;
        [self.ui_imgsScrollView addSubview:tmpView];
        
        if (i == 0)
        {
            //星星
            self.ui_starView.rate = [tmpObj.m_starCount floatValue];
            //end
            
            //影片名字
            self.ui_nameLabel.text = tmpObj.m_movieName;
            self.ui_startLabel.text = [NSString stringWithFormat:@"%@",tmpObj.m_starCount];
            
            //电话-标题-影院名称
            self.phoneString = tmpObj.m_mobile;
            self.ui_titleLabel.text = tmpObj.m_cinemaName;
            self.ui_detailNameLabel.text = tmpObj.m_cinemaName;
            
            CGSize contentSize = [tmpObj.m_info sizeWithFont:[UIFont systemFontOfSize:15] constrainedToSize:CGSizeMake(303, 1000) lineBreakMode:NSLineBreakByTruncatingTail];
            
            //影院简介
            CGRect contentRect = self.ui_contentLabel.frame;
            contentRect.size.height = contentSize.height;
            self.ui_contentLabel.frame = contentRect;
            self.ui_contentLabel.text = tmpObj.m_info;
            
            if (contentSize.height > 246)
            {
                CGSize tmpSize = self.ui_buttomScrollView.contentSize;
                tmpSize.height = tmpSize.height + contentSize.height - 246;
                self.ui_buttomScrollView.contentSize = tmpSize;
                
                self.ui_contentLabel.frame = contentRect;
            }
        }
        
    }
}

#pragma mark -
#pragma mark - 控件事件
- (IBAction)backTapped:(id)sender
{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app.nav popViewController];
}

- (IBAction)callTapped:(id)sender
{
    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",self.phoneString]];
    [webView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
}

- (IBAction)detailTapped:(id)sender
{
    [self.view bringSubviewToFront:self.ui_markBtn];
    [self.view bringSubviewToFront:self.ui_detailView];
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect detailRect = self.ui_detailView.frame;
        detailRect.origin.y = viewHeight - detailRect.size.height;
        self.ui_detailView.frame = detailRect;
        self.ui_markBtn.alpha = 0.7;
    }];
}

- (IBAction)cancelTapped:(id)sender
{
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect detailRect = self.ui_detailView.frame;
        detailRect.origin.y = viewHeight;
        self.ui_detailView.frame = detailRect;
        self.ui_markBtn.alpha = 0.0;
    }];
}

#pragma mark -
#pragma mark - custom delegate
- (void) tapWithObject:(id)sender
{
    MovieObject *tmpObj = (MovieObject *)sender;
    MovieDetailViewController *movieDetail = [[MovieDetailViewController alloc] init];
    movieDetail.movieObj = tmpObj;
    [SMApp.nav pushViewController:movieDetail];
}

#pragma mark -
#pragma mark - scroll delegate
- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    beginPoint = scrollView.contentOffset;
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    currentPage = floor((scrollView.contentOffset.x - (imgWidth + imgWWidth)/2)/(imgWidth + imgWWidth))+1;
    
    if (currentPage <= [self.movieArr count] - 1)
    {
        MovieObject *tmpObj = [self.movieArr objectAtIndex:currentPage];
        
        //星星
        self.ui_starView.rate = [tmpObj.m_starCount floatValue];
        //end
        
        //影片名字
        self.ui_nameLabel.text = tmpObj.m_movieName;
        
        //评分
        self.ui_startLabel.text = [NSString stringWithFormat:@"%@",tmpObj.m_starCount];
        
        
        if (lastPage != currentPage)
        {
            [UIView beginAnimations:@"" context:nil];
            [UIView setAnimationDuration:0.3];
            
            UIImageView *lastImgView = (UIImageView *)[[self.ui_imgsScrollView viewWithTag:lastPage + 10] viewWithTag:lastPage + 111];
            lastImgView.frame = (CGRect){20,30,imgWidth - 40,imgHeight - 60};
            
            UIImageView *newImgView = (UIImageView *)[[self.ui_imgsScrollView viewWithTag:currentPage + 10] viewWithTag:currentPage + 111];
            newImgView.frame = (CGRect){0,0,imgWidth,imgHeight};
            
            [UIView commitAnimations];
            lastPage = currentPage;
        }
    }
    
}

#pragma mark -
#pragma mark - 网络数据返回
- (void) movieDetailListCallBack:(id) objectData
{
    self.movieArr = objectData;
    
    [self addMovieInfo];
}

#pragma mark -
#pragma mark - 网络回调失败
- (void) failLoadData:(id) reasonString
{
//    [self.myTable doneLoadingTableViewData];
//    if (reasonString)
//    {
//        if ([self.tableData count] == 0)
//        {
//            self.myTable.hidden = YES;
//            self.ui_freshTipLabel.hidden = NO;
//        }
//        [self.view bringSubviewToFront:self.tipView];
//        [self.tipView tipShowWithType:SigleNetFailTip tipString:NetFailTip isHidden:YES];
//    }
}

@end
