//
//  WorldDetailViewController.m
//  SanMen
//
//  Created by lcc on 14-1-11.
//  Copyright (c) 2014年 lcc. All rights reserved.
//

#import "WorldDetailViewController.h"
#import "CCClientRequest.h"
#import "GTMBase64.h"
#import "NewsDetailObject.h"

#define Source @"来源：新华社中国网事"

#define HTMLCONTENT [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"content_template" ofType:@"html"] encoding:NSUTF8StringEncoding error:NULL]

@interface WorldDetailViewController ()<UIWebViewDelegate>

@property (strong, nonatomic) IBOutlet UIWebView *ui_webView;
@property (strong, nonatomic) CCClientRequest *myRequest;
@property (strong, nonatomic) IBOutlet UIView *ui_tipView;
@property (strong, nonatomic) IBOutlet UILabel *ui_loadingLabel;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *ui_activity;
@property (strong, nonatomic) NewsDetailObject *newsObject;

@property (strong, nonatomic) IBOutlet UILabel *ui_freshTipLabel;
@property (strong, nonatomic) IBOutlet UIView *ui_failTipView;
@property (strong, nonatomic) IBOutlet UIImageView *ui_failTipImgView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *ui_loadingWebActivity;

@end

@implementation WorldDetailViewController

- (void)dealloc
{
    self.ui_webView.delegate = nil;
    self.ui_webView = nil;
    
    self.newsId = nil;
    
    self.myRequest.c_delegate = nil;
    self.myRequest = nil;
    
    self.ui_tipView = nil;
    self.ui_loadingLabel = nil;
    self.ui_activity = nil;
    self.newsObject = nil;
    
    self.ui_freshTipLabel = nil;
    self.ui_failTipView = nil;
    self.ui_failTipImgView = nil;
    self.ui_loadingWebActivity = nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.myRequest = [[CCClientRequest alloc] init];
        self.myRequest.c_delegate = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.clipsToBounds = YES;
    
    //控件属性设置
    self.ui_webView.clipsToBounds = NO;
    self.ui_webView.hidden = YES;
    [self.ui_loadingWebActivity stopAnimating];
    
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
    
    self.ui_webView.clipsToBounds = NO;
    
    [self freshTapped:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [StatusBarObject setStatusBarStyleWithIndex:0];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [StatusBarObject setStatusBarStyleWithIndex:1];
}

#pragma mark -
#pragma mark - custom method
//让提示语消失
- (void) tipDispear
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect = self.ui_failTipView.frame;
        rect.origin.x = 320;
        self.ui_failTipView.frame = rect;
    }];
}

//网络状态提示语改变
- (void) changeLoadingStatusWithSign:(NSInteger) sign
{
    switch (sign)
    {
        case 0://加载中
            self.ui_webView.hidden = YES;
            self.ui_loadingLabel.text = Loading;
            self.ui_tipView.userInteractionEnabled = NO;
            [self.ui_activity startAnimating];
            break;
            
        case 1://加载失败
            if (!self.newsObject)
            {
                self.ui_webView.hidden = YES;
            }
            self.ui_loadingLabel.text = TappedAgain;
            self.ui_tipView.userInteractionEnabled = YES;
            [self.ui_activity stopAnimating];
            self.ui_freshTipLabel.text = NetFailTip;
            
            break;
            
        case 2://加载成功
            self.ui_webView.hidden = NO;
            self.ui_loadingLabel.text = DoneLoading;
            [self.ui_activity stopAnimating];
            break;
            
        default:
            break;
    }
}

#pragma mark -
#pragma mark - 控件事件
- (IBAction)backTapped:(id)sender
{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app.nav popViewController];
}

- (IBAction)freshTapped:(id)sender
{
    [self.myRequest worldDetailWithId:self.newsId];
    [self changeLoadingStatusWithSign:0];
}

#pragma mark -
#pragma mark - 网络数据回调
//天下详情回调
- (void) worldDetailCallBack:(id) objectData
{
    if ([objectData count] > 0)
    {
        NewsDetailObject *tmpObj = [objectData objectAtIndex:0];
        self.newsObject = tmpObj;
        
        NSData *tmpData = [GTMBase64 decodeString:tmpObj.n_detailContent];
        NSString *tmpString = [[NSString alloc] initWithData:tmpData encoding:NSUTF8StringEncoding];
        
        NSString *htmlContent = HTMLCONTENT;
        //本地模版内容替换
        htmlContent = [htmlContent stringByReplacingOccurrencesOfString:@"{Title}" withString:tmpObj.n_title];
        htmlContent = [htmlContent stringByReplacingOccurrencesOfString:@"{PublishDate}" withString:[NSString stringWithFormat:@"发布时间：%@",tmpObj.n_datetime]];
        htmlContent = [htmlContent stringByReplacingOccurrencesOfString:@"{Content}" withString:tmpString];
        
        htmlContent = [htmlContent stringByReplacingOccurrencesOfString:@"{NewsSource}" withString:Source];
        
        htmlContent = [htmlContent stringByReplacingOccurrencesOfString:@"{className}" withString:@"font_large"];
        
        //开始加载
        [self.ui_webView loadHTMLString:htmlContent baseURL:nil];
        
        [self changeLoadingStatusWithSign:2];
    }
}

#pragma mark -
#pragma mark - 网络回调失败
- (void) failLoadData:(id) reasonString
{
    if (reasonString)
    {
        [self changeLoadingStatusWithSign:1];
        
        [UIView animateWithDuration:0.3 animations:^{
            CGRect rect = self.ui_failTipView.frame;
            rect.origin.x = 200;
            self.ui_failTipView.frame = rect;
        } completion:^(BOOL finished) {
            [self performSelector:@selector(tipDispear) withObject:nil afterDelay:1];
        }];
    }
}

#pragma mark -
#pragma mark - web delegate
- (void) webViewDidStartLoad:(UIWebView *)webView
{
    [self.ui_loadingWebActivity startAnimating];
}

- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    [self.ui_loadingWebActivity stopAnimating];
}

@end
