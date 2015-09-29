//
//  AcitivityDetailViewController.m
//  SanMen
//
//  Created by lcc on 14-1-13.
//  Copyright (c) 2014年 lcc. All rights reserved.
//

#import "AcitivityDetailViewController.h"
#import "CCClientRequest.h"
#import "GTMBase64.h"
#import "UMSocial.h"

@interface AcitivityDetailViewController() <UIWebViewDelegate>
{
    BOOL isPressShare;
}

@property (strong, nonatomic) IBOutlet UIWebView *ui_webView;
@property (strong, nonatomic) IBOutlet UIImageView *ui_freshImgView;
@property (strong, nonatomic) IBOutlet UIButton *ui_backBtn;
@property (strong, nonatomic) IBOutlet UIButton *ui_forwardBtn;

@end

@implementation AcitivityDetailViewController

- (void)dealloc
{
    self.ui_webView.delegate = nil;
    self.ui_webView = nil;
    
    self.ui_freshImgView = nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.clipsToBounds = YES;
    
    //控件属性设置
    self.ui_webView.scalesPageToFit = YES;
    self.ui_forwardBtn.enabled = NO;
    self.ui_backBtn.enabled = NO;
    
    //webview
    for (UIView *tmpView in self.ui_webView.subviews)
    {
        if ([tmpView isKindOfClass:[UIScrollView class]])
        {
            [tmpView setBackgroundColor:[UIColor clearColor]];
            tmpView.clipsToBounds = NO;
            
            for (UIView *shadowView in [tmpView subviews])
            {
                if ([shadowView isKindOfClass:[UIImageView class]])
                {
                    shadowView.hidden = YES;
                }
            }
        }
    }
    
    [self.ui_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.webUrl]]];
    self.ui_webView.clipsToBounds = NO;
    
    //动画旋转
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI];
    rotationAnimation.duration = 0.5;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = HUGE_VALF;
    [self.ui_freshImgView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    //end
    
    isPressShare = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [StatusBarObject setStatusBarStyleWithIndex:0];
    
    if (!([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0))
    {
        if (isPressShare)
        {
            [self performSelector:@selector(freshViewFrame) withObject:nil afterDelay:0.1];
        }
    }
    
    isPressShare = NO;
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (isPressShare)
    {
        [StatusBarObject setStatusBarStyleWithIndex:0];
    }
    else
    {
        [StatusBarObject setStatusBarStyleWithIndex:1];
    }
}

#pragma mark -
#pragma mark - custom method
- (void) setBtnEnable
{
    if ([self.ui_webView canGoBack] == NO)
    {
        self.ui_backBtn.enabled = NO;
    }
    else
    {
        self.ui_backBtn.enabled = YES;
    }
    
    if ([self.ui_webView canGoForward] == NO)
    {
        self.ui_forwardBtn.enabled = NO;
    }
    else
    {
        self.ui_forwardBtn.enabled = YES;
    }
}

//因为分享刷新页面
- (void) freshViewFrame
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect = self.view.frame;
        rect.origin.y = -20;
        rect.size.height = viewHeight;
        self.view.frame = rect;
    }];
}

#pragma mark -
#pragma mark - 控件事件
- (IBAction)backTapped:(id)sender
{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app.nav popViewController];
}

- (IBAction)wapBackTapped:(id)sender
{
    [self.ui_webView goBack];
    [self setBtnEnable];
}

- (IBAction)wapForewardTapped:(id)sender
{
    [self.ui_webView goForward];
    [self setBtnEnable];
}

//分享
- (IBAction)shareTapped:(id)sender
{
    //设置微信分享应用类型，用户点击消息将跳转到应用，或者到下载页面
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeApp;
    //分享图文样式到微信朋友圈显示字数比较少，只显示分享标题
    [UMSocialData defaultData].extConfig.title = ShareText;
    //设置微信好友或者朋友圈的分享url,下面是微信好友，微信朋友圈对应wechatTimelineData
    [UMSocialData defaultData].extConfig.wechatSessionData.url = SAMDOWNURL;
    
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:YouMengKey
                                      shareText:ShareText
                                     shareImage:nil
                                shareToSnsNames:nil
                                       delegate:nil];
    isPressShare = YES;
}

#pragma mark -
#pragma mark - web delegate
- (void) webViewDidStartLoad:(UIWebView *)webView
{
    self.ui_freshImgView.hidden = NO;
}

- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    self.ui_freshImgView.hidden = YES;
    [self setBtnEnable];
}

@end
