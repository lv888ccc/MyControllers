//
//  NewsDetailViewController.m
//  SanMen
//
//  Created by lcc on 13-12-22.
//  Copyright (c) 2013年 lcc. All rights reserved.
//

#import "NewsDetailViewController.h"
#import "NewsCommentViewController.h"
#import "MLNavigationController.h"
#import "CCClientRequest.h"
#import "NewsDetailObject.h"
#import "GTMBase64.h"
#import "FMDBManage.h"
#import "CollectionObject.h"
#import "LoginViewController.h"
#import "UMSocial.h"
#import "NewDetailImageViewController.h"

#define FONTLARGE @"font_largex"
#define FONTMID @"font_large"
#define FONTSMALL @"font_small"

#define HTMLCONTENT [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"content_template" ofType:@"html"] encoding:NSUTF8StringEncoding error:NULL]

@interface NewsDetailViewController ()<MLNavigationControllerDelegate,UIWebViewDelegate>
{
    NSInteger fontSize;
    BOOL isBigger;
    BOOL isConllected;
    BOOL isPressShare;
}

@property (strong, nonatomic) CCClientRequest *myRequest;

@property (strong, nonatomic) IBOutlet UIWebView *ui_webView;
@property (strong, nonatomic) IBOutlet UIView *ui_commentWriteView;
@property (strong, nonatomic) IBOutlet UIButton *ui_markView;
@property (strong, nonatomic) IBOutlet UITextView *ui_textView;
@property (strong, nonatomic) IBOutlet UIView *ui_commentView;
@property (strong, nonatomic) IBOutlet UILabel *ui_commentLabel;
@property (strong, nonatomic) IBOutlet UIView *ui_tipView;
@property (strong, nonatomic) IBOutlet UILabel *ui_loadingLabel;
@property (strong, nonatomic) IBOutlet UIView *ui_buttomView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *ui_activity;
@property (strong, nonatomic) IBOutlet UIView *ui_collectionTipView;
@property (strong, nonatomic) IBOutlet UIImageView *ui_collectedImgView;
@property (strong, nonatomic) IBOutlet UILabel *ui_collectionTipLabel;
@property (strong, nonatomic) IBOutlet UIButton *ui_collectionBtn;
@property (strong, nonatomic) IBOutlet UIButton *ui_fontBtn;
@property (strong, nonatomic) IBOutlet UIButton *ui_commitBtn;
@property (strong, nonatomic) IBOutlet UIImageView *ui_sendingImgView;

@property (nonatomic, strong) NewsDetailObject *newsObject;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *ui_loadingWebActivity;
@property (strong, nonatomic) IBOutlet UIButton *ui_shareBtn;

@end

@implementation NewsDetailViewController

- (void)dealloc
{
    self.myRequest.c_delegate = nil;
    self.myRequest = nil;
    
    self.newsObject = nil;
    self.ui_webView.delegate = nil;
    self.ui_commentWriteView = nil;
    self.ui_markView = nil;
    self.ui_textView = nil;
    self.ui_webView = nil;
    self.ui_commentView = nil;
    self.ui_commentLabel = nil;
    self.ui_tipView = nil;
    self.ui_loadingLabel = nil;
    self.ui_buttomView = nil;
    self.ui_activity = nil;
    self.ui_collectionTipView = nil;
    self.ui_commitBtn = nil;
    self.ui_sendingImgView = nil;
    self.ui_loadingWebActivity = nil;
    self.ui_shareBtn = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LOGINSUCCESSNOTIFICATION object:nil];
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(msg_LOGINSUCCESSNOTIFICATION:) name:LOGINSUCCESSNOTIFICATION
                                                   object:nil];
        
        self.myRequest = [[CCClientRequest alloc] init];
        self.myRequest.c_delegate = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initControllers];
    
    if (self.isConvinient)
    {
        self.ui_commentView.hidden = YES;
        self.ui_buttomView.hidden = YES;

        self.ui_webView.frame = CGRectMake(0, 64, 320, viewHeight - 64);
    }
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark - custom method
- (void) initControllers
{
    if (self.noCollection == YES)
    {
        self.ui_collectionBtn.hidden = YES;
        
        CGRect shareRect = self.ui_shareBtn.frame;
        shareRect.origin.x = shareRect.origin.x + 5;
        self.ui_shareBtn.frame = shareRect;
        
        CGRect fRect = self.ui_fontBtn.frame;
        fRect.origin.x = fRect.origin.x - 10;
        self.ui_fontBtn.frame = fRect;
    }
    
    self.view.clipsToBounds = YES;
    isConllected = NO;
    
    //控件属性设置
    self.ui_commentWriteView.frame = CGRectMake(0, viewHeight + 20, 320, 145);
    self.ui_textView.backgroundColor = [UIColor clearColor];
    self.ui_webView.clipsToBounds = NO;
    self.ui_webView.hidden = YES;
    self.ui_commitBtn.enabled = NO;
    [self.ui_loadingWebActivity stopAnimating];
    isPressShare = NO;
    
    //webview
    for (UIView *tmpView in self.ui_webView.subviews)
    {
        if ([tmpView isKindOfClass:[UIScrollView class]])
        {
            [tmpView setBackgroundColor:[UIColor clearColor]];
            tmpView.clipsToBounds = NO;
        }
        
        for (UIView *shadowView in [tmpView subviews])
        {
            if ([shadowView isKindOfClass:[UIImageView class]])
            {
                shadowView.hidden = YES;
            }
        }
    }
    
    //提示语言
    [self changeLoadingStatusWithSign:0];
    //end
    
    
    //网络数据请求
    [self.myRequest newsTypeDetailWithId:self.newsId];
    //end
    
    //判断是否收藏了
    NSMutableArray *tmpArr = [FMDBManage getDataFromTable:[CollectionObject class] WithString:[NSString stringWithFormat:@"c_id='%@' and c_modelType<>'%d'",self.newsId,THEMEPRO]];
    if ([tmpArr count] > 0)
    {
        [self.ui_collectionBtn setImage:[UIImage imageNamed:@"collected"] forState:UIControlStateNormal];
        isConllected = YES;
    }
    //end
    
    //字号判断
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *tmpFontSize = [userDefaults objectForKey:FONTSIZE];
    isBigger = YES;
    //是否有保存，没有的话是默认字号28
    if (tmpFontSize == nil)
    {
        fontSize = 28;
    }
    else
    {
        fontSize = [tmpFontSize integerValue];
    }
    
    if (fontSize == 38)
    {
        [self.ui_fontBtn setImage:[UIImage imageNamed:@"font_less"] forState:UIControlStateNormal];
        [self.ui_fontBtn setImage:[UIImage imageNamed:@"font_less_press"] forState:UIControlStateHighlighted];
        isBigger = NO;
    }
    //end
    
    //动画旋转
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI];
    rotationAnimation.duration = 0.5;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = HUGE_VALF;
    [self.ui_sendingImgView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    //end
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
            self.ui_buttomView.hidden = YES;
            break;
            
        case 1://加载失败
            if (!self.newsObject)
            {
                self.ui_webView.hidden = YES;
            }
            self.ui_loadingLabel.text = TappedAgain;
            self.ui_tipView.userInteractionEnabled = YES;
            [self.ui_activity stopAnimating];
            self.ui_sendingImgView.hidden = YES;
            self.ui_collectedImgView.hidden = NO;
            self.ui_collectedImgView.image = [UIImage imageNamed:@"net_fail"];
            self.ui_collectionTipLabel.text = NetFailTip;
            
            break;
            
        case 2://加载成功
            self.ui_webView.hidden = NO;
            self.ui_loadingLabel.text = DoneLoading;
            if (self.isConvinient == NO)
            {
                self.ui_buttomView.hidden = NO;
            }
            [self.ui_activity stopAnimating];
            break;
            
        case 3://提交中
            self.ui_sendingImgView.hidden = NO;
            self.ui_collectedImgView.hidden = YES;
            self.ui_sendingImgView.image = [UIImage imageNamed:@"face_sending"];
            self.ui_collectionTipLabel.text = Committing;
            break;
            
        case 4://提交评论成功
            self.ui_sendingImgView.hidden = YES;
            self.ui_collectedImgView.hidden = NO;
            self.ui_collectedImgView.image = [UIImage imageNamed:@"face_done"];
            self.ui_collectionTipLabel.text = SucessComment;
            break;
            
        case 5://提交评论失败
            self.ui_sendingImgView.hidden = YES;
            self.ui_collectedImgView.hidden = NO;
            self.ui_collectedImgView.image = [UIImage imageNamed:@"net_fail"];
            self.ui_collectionTipLabel.text = FailTip;
            break;
            
        default:
            break;
    }
}

//让提示语消失
- (void) tipDispear:(UIView *) sender
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect = sender.frame;
        rect.origin.x = 320;
        sender.frame = rect;
    }];
}

//收藏入库与出库
- (void) collectionWithSign:(NSInteger) sign
{
    self.ui_sendingImgView.hidden = YES;
    self.ui_collectedImgView.hidden = NO;
    
    //取消收藏
    if (sign == 0)
    {
        [FMDBManage deleteFromTable:[CollectionObject class] WithString:[NSString stringWithFormat:@"c_id='%@'",self.newsId]];
        [self.ui_collectionBtn setImage:[UIImage imageNamed:@"collection"] forState:UIControlStateNormal];
        isConllected = NO;
        
        [self.ui_collectedImgView setImage:[UIImage imageNamed:@"face_cancel_collect"]];
        self.ui_collectionTipLabel.text = CancelCollection;
    }
    //添加收藏
    else
    {
        CollectionObject *tmpObj = [[CollectionObject alloc] init];
        tmpObj.c_id = self.newsId;
        tmpObj.c_title = self.newsObject.n_title;
        tmpObj.c_imgUrl = self.newsObject.n_imgUrl;
        tmpObj.c_modelType = SMApp.newsType;
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
        
        [self.ui_collectedImgView setImage:[UIImage imageNamed:@"face_success_collect"]];
        self.ui_collectionTipLabel.text = SucessCollection;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect = self.ui_collectionTipView.frame;
        rect.origin.x = 200;
        self.ui_collectionTipView.frame = rect;
    } completion:^(BOOL finished) {
        [self performSelector:@selector(tipDispear:) withObject:self.ui_collectionTipView afterDelay:1];
        
    }];
}

//禁用发送按钮
- (void) setBtnEnable
{
    if ([self.ui_textView.text stringByReplacingOccurrencesOfString:@" " withString:@""].length > 0 && [self.ui_textView.text stringByReplacingOccurrencesOfString:@"\n" withString:@""].length > 0)
    {
        self.ui_commitBtn.enabled = YES;
    }
    else
    {
        self.ui_commitBtn.enabled = NO;
    }
}

- (void) addCommentCount
{
    self.ui_commentLabel.text = [NSString stringWithFormat:@"%d",[self.ui_commentLabel.text integerValue] + 1];
}

#pragma mark -
#pragma mark - 控件事件
- (IBAction)backTapped:(id)sender
{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app.nav popViewController];
}

//打开评论页
- (IBAction)commentTapped:(id)sender
{
    NewsCommentViewController *comment = [[NewsCommentViewController alloc] init];
    comment.newsId = self.newsId;
    comment.newsDelegate = self;
    comment.isNews = YES;
    [SMApp.nav pushViewController:comment];
}

- (IBAction)markTapped:(id)sender
{
    [self.ui_textView resignFirstResponder];
}

//评论
- (IBAction)commentSignTapped:(id)sender
{
    [self.ui_textView becomeFirstResponder];
}

//分享
- (IBAction)shareTapped:(id)sender
{
    //设置微信分享应用类型，用户点击消息将跳转到应用，或者到下载页面
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeApp;
    //分享图文样式到微信朋友圈显示字数比较少，只显示分享标题
    [UMSocialData defaultData].extConfig.title = self.newsObject.n_title;
    //设置微信好友或者朋友圈的分享url,下面是微信好友，微信朋友圈对应wechatTimelineData
    [UMSocialData defaultData].extConfig.wechatSessionData.url = SAMDOWNURL;
    
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:YouMengKey
                                      shareText:[NSString stringWithFormat:@"『%@』%@",self.newsObject.n_title,ShareText]
                                     shareImage:nil
                                shareToSnsNames:nil
                                       delegate:nil];
    
    isPressShare = YES;
}

//收藏
- (IBAction)collectedTapped:(id)sender
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

//字体变大变小
- (IBAction)fontChangedTapped:(id)sender
{
    UIButton *tmpBtn = (UIButton *)sender;
    
    if (isBigger == YES)
    {
        fontSize += 5;
    }
    else
    {
        fontSize -= 5;
    }
    
    if (fontSize >= 38)
    {
        isBigger = NO;
        [tmpBtn setImage:[UIImage imageNamed:@"font_less"] forState:UIControlStateNormal];
        [tmpBtn setImage:[UIImage imageNamed:@"font_less_press"] forState:UIControlStateHighlighted];
        fontSize = 38;
    }
    
    if (fontSize <= 28)
    {
        [tmpBtn setImage:[UIImage imageNamed:@"font_add"] forState:UIControlStateNormal];
        [tmpBtn setImage:[UIImage imageNamed:@"font_add_press"] forState:UIControlStateHighlighted];
        isBigger = YES;
        fontSize = 28;
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:[NSString stringWithFormat:@"%d",fontSize] forKey:FONTSIZE];
    
    [self.ui_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"fontSize(%d)",fontSize]];
}

- (IBAction)freshTapped:(id)sender
{
    [self.myRequest newsTypeDetailWithId:self.newsId];
    [self changeLoadingStatusWithSign:0];
}

- (IBAction)commitTapped:(id)sender
{
    if (SMApp.userObject)
    {
        [self.myRequest commitCommentWithContent:self.ui_textView.text newsId:self.newsId userId:SMApp.userObject.u_id];
        [self changeLoadingStatusWithSign:3];
        [UIView animateWithDuration:0.3 animations:^{
            CGRect rect = self.ui_collectionTipView.frame;
            rect.origin.x = 200;
            self.ui_collectionTipView.frame = rect;
            [self.view bringSubviewToFront:self.ui_collectionTipView];
        }];
    }
    else
    {
        SMApp.nav.m_delegate = nil;
        LoginViewController *login = [[LoginViewController alloc] init];
        [SMApp.nav pushViewController:login];
    }
}

#pragma mark -
#pragma mark - 消息处理函数
- (void) msg_LOGINSUCCESSNOTIFICATION:(NSNotification *) notification
{
    SMApp.nav.m_delegate = self;
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    
    [self.view bringSubviewToFront:self.ui_markView];
    self.ui_markView.hidden = NO;
    [self.view bringSubviewToFront:self.ui_commentWriteView];
    
    /* Move the toolbar to above the keyboard */
    CGRect keyboardFrame;
	[[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrame];
	CGFloat keyboardHight = CGRectGetHeight(keyboardFrame);
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.4];
    
	CGRect newRect = self.ui_commentWriteView.frame;
	newRect.origin = CGPointMake(0, [[UIScreen mainScreen] bounds].size.height - keyboardHight - newRect.size.height);
    self.ui_commentWriteView.frame = newRect;
    self.ui_markView.alpha = 0.5;
    
	[UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.ui_commentWriteView.frame;
        if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation))
        {
            frame.origin.y = self.view.frame.size.height + 20;
        }
        else
        {
            frame.origin.y = self.view.frame.size.width + 20;
        }
        self.ui_commentWriteView.frame = frame;
        self.ui_markView.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.ui_markView.hidden = YES;
    }];
    
}

#pragma mark -
#pragma mark - push delegate
- (UIViewController *)pushCommentViewController
{
    if (self.isConvinient == NO)
    {
        NewsCommentViewController *comment = [[NewsCommentViewController alloc] init];
        comment.newsId = self.newsId;
        comment.newsDelegate = self;
        comment.isNews = YES;
        return comment;
    }
    else
    {
        return nil;
    }
}

//新闻类型详情
- (void) newsTypeDetailCallBack:(id) objectData
{
    if ([objectData count] > 0)
    {
        [UIView animateWithDuration:0.5 animations:^{
            CGRect rect = self.ui_commentView.frame;
            rect.origin.x = 260;
            self.ui_commentView.frame = rect;
        }];
        
        self.newsObject = [objectData objectAtIndex:0];
        self.ui_commentLabel.text = self.newsObject.n_commentCount;
        
        NSData *tmpData = [GTMBase64 decodeString:self.newsObject.n_detailContent];
        NSString *tmpString = [[NSString alloc] initWithData:tmpData encoding:NSUTF8StringEncoding];
    
        
        NSString *htmlContent = HTMLCONTENT;
        //本地模版内容替换
        htmlContent = [htmlContent stringByReplacingOccurrencesOfString:@"{Title}" withString:self.newsObject.n_title];
        htmlContent = [htmlContent stringByReplacingOccurrencesOfString:@"{PublishDate}" withString:[NSString stringWithFormat:@"发布日期：%@",self.newsObject.n_datetime]];
        htmlContent = [htmlContent stringByReplacingOccurrencesOfString:@"{Content}" withString:tmpString];
        htmlContent = [htmlContent stringByReplacingOccurrencesOfString:@"{NewsSource}" withString:[NSString stringWithFormat:@"来源：%@",self.newsObject.n_source]];
        
        switch (fontSize)
        {
            case 28:
                htmlContent = [htmlContent stringByReplacingOccurrencesOfString:@"{className}" withString:FONTSMALL];
                break;
                
            case 33:
                htmlContent = [htmlContent stringByReplacingOccurrencesOfString:@"{className}" withString:FONTMID];
                break;
                
            case 38:
                htmlContent = [htmlContent stringByReplacingOccurrencesOfString:@"{className}" withString:FONTLARGE];
                break;
                
            default:
                break;
        }
        
        //开始加载
        [self.ui_webView loadHTMLString:htmlContent baseURL:nil];
        [self changeLoadingStatusWithSign:2];
        
        SMApp.nav.m_delegate = self;
    }
}

//评论提交回调
- (void) commitCommentCallBack:(id) objectData
{
    if ([objectData count] > 0)
    {
        [self changeLoadingStatusWithSign:4];
        self.ui_textView.text = @"";
        [self setBtnEnable];
        [self addCommentCount];
    }
    else
    {
        [self changeLoadingStatusWithSign:5];
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect = self.ui_collectionTipView.frame;
        rect.origin.x = 200;
        self.ui_collectionTipView.frame = rect;
        [self.view bringSubviewToFront:self.ui_collectionTipView];
    } completion:^(BOOL finished) {
        [self performSelector:@selector(tipDispear:) withObject:self.ui_collectionTipView afterDelay:1];
        
    }];
}

#pragma mark -
#pragma mark - 网络回调失败
- (void) failLoadData:(id) reasonString
{
    if (reasonString)
    {
        [self changeLoadingStatusWithSign:1];
        
        [UIView animateWithDuration:0.3 animations:^{
            CGRect rect = self.ui_collectionTipView.frame;
            rect.origin.x = 200;
            self.ui_collectionTipView.frame = rect;
            [self.view bringSubviewToFront:self.ui_collectionTipView];
        } completion:^(BOOL finished) {
            [self performSelector:@selector(tipDispear:) withObject:self.ui_collectionTipView afterDelay:1];
            
        }];
        
        SMApp.nav.m_delegate = nil;
    }
}

#pragma mark -
#pragma mark - textView delegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    [self performSelector:@selector(setBtnEnable) withObject:nil afterDelay:0.3];
    return YES;
}

- (void) webViewDidStartLoad:(UIWebView *)webView
{
    [self.ui_loadingWebActivity startAnimating];
}

- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    [self.ui_loadingWebActivity stopAnimating];
}

- (BOOL) webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ([request.URL.absoluteString rangeOfString:@".png"].length > 0 || [request.URL.absoluteString rangeOfString:@".jpg"].length > 0 ||[request.URL.absoluteString rangeOfString:@".jpeg"].length > 0)
    {
        NewDetailImageViewController *imgDetail = [[NewDetailImageViewController alloc] init];
        imgDetail.imgUrl = request.URL.absoluteString;
        [SMApp.nav presentModalViewController:imgDetail animated:NO];
        isPressShare = YES;
        
        return NO;
    }
    
    return YES;
}

@end
