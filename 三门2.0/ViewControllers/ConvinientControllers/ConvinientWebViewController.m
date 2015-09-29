//
//  ConvinientWebViewController.m
//  SanMen
//
//  Created by lcc on 14-2-13.
//  Copyright (c) 2014年 lcc. All rights reserved.
//

#import "ConvinientWebViewController.h"
#import "StatusTipView.h"

@interface ConvinientWebViewController ()<UIWebViewDelegate>
{
    BOOL isPressShare;
}

@property (strong, nonatomic) IBOutlet UIWebView *ui_webView;
@property (strong, nonatomic) IBOutlet UIButton *ui_backBtn;
@property (strong, nonatomic) IBOutlet UIButton *ui_forwardBtn;
@property (strong, nonatomic) IBOutlet UILabel *ui_titleLabel;
@property (strong, nonatomic) StatusTipView *tipView;

@end

@implementation ConvinientWebViewController

- (void)dealloc
{
    self.ui_webView.delegate = nil;
    self.ui_webView = nil;
    
    self.ui_titleLabel = nil;
    self.ui_backBtn = nil;
    self.ui_forwardBtn = nil;
    self.ui_backBtn = nil;
    
    self.tipView = nil;
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
    
    self.ui_titleLabel.text = self.titleString;
    
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
    
    [self.ui_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.webUrl]]];
    self.ui_webView.clipsToBounds = NO;
    
    isPressShare = NO;
    
    self.tipView = [[StatusTipView alloc] initWithFrame:CGRectMake(320, 160, 120, 70)];
    [self.view addSubview:self.tipView];
    
    [self.view bringSubviewToFront:self.tipView];
    [self.tipView tipShowWithType:InfoCommittingTip tipString:Loading isHidden:NO];
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

- (IBAction)freshTapped:(id)sender
{
    [self.ui_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.webUrl]]];
}


#pragma mark -
#pragma mark - web delegate
- (void) webViewDidStartLoad:(UIWebView *)webView
{

}

- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    [self setBtnEnable];
    [self.tipView tipShowWithType:SuccessTipTypeTwo tipString:DoneLoading isHidden:YES];
}

@end