//
//  PowerOpenWapViewController.m
//  SanMen
//
//  Created by lcc on 14-3-12.
//  Copyright (c) 2014年 lcc. All rights reserved.
//

#import "PowerOpenWapViewController.h"

@interface PowerOpenWapViewController ()<UIWebViewDelegate>

@property (strong, nonatomic) IBOutlet UIWebView *ui_webView;

@property (strong, nonatomic) IBOutlet UIImageView *ui_freshImgView;
@property (strong, nonatomic) IBOutlet UIButton *ui_backBtn;
@property (strong, nonatomic) IBOutlet UIButton *ui_forwardBtn;

@end

@implementation PowerOpenWapViewController

- (void)dealloc
{
    _ui_webView.delegate = nil;
    _ui_webView = nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.clipsToBounds = YES;
    
    //控件属性设置
    self.ui_webView.clipsToBounds = NO;
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
    
    [self.ui_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:SAMOPENPOWERURL]]];
    
    //动画旋转
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI];
    rotationAnimation.duration = 0.5;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = HUGE_VALF;
    [self.ui_freshImgView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    //end
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
