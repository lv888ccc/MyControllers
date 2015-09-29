//
//  PaiKeUploadViewController.m
//  SanMen
//
//  Created by lcc on 13-12-24.
//  Copyright (c) 2013年 lcc. All rights reserved.
//

#import "PaiKeUploadViewController.h"
#import "PlaceHolderTextView.h"
#import "CamaraObject.h"
#import "UIImage+Ext.h"
#import "CCClientRequest.h"
#import "FTPWrapper.h"
#import "FtpObject.h"
#import "LoginViewController.h"
#import "GTMBase64.h"
#import "StatusTipView.h"
#import "NetWorkObserver.h"

UIKIT_EXTERN void UIImageWriteToSavedPhotosAlbum(UIImage *image, id completionTarget, SEL completionSelector, void *contextInfo);

#define IPHONE4 130
#define IPHONE5 218

@interface PaiKeUploadViewController ()<UITextFieldDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,IFtpUploadDelegate>
{
    CamaraObject *camaraObj;
    NSInteger index;
    NSInteger uploadIndex;
    BOOL isCancel;
    BOOL originIsLight;
    
    NSInteger photoType;
}

@property (strong, nonatomic) IBOutlet PlaceHolderTextView *ui_textView;
@property (strong, nonatomic) IBOutlet UITextField *ui_textField;
@property (strong, nonatomic) IBOutlet UIView *ui_buttomView;
@property (strong, nonatomic) IBOutlet UIScrollView *ui_scrollView;
@property (strong, nonatomic) IBOutlet UIView *ui_picsView;
@property (strong, nonatomic) IBOutlet UIView *ui_sheetView;
@property (strong, nonatomic) IBOutlet UIButton *ui_markBtn;
@property (strong, nonatomic) IBOutlet UIView *ui_delView;
@property (strong, nonatomic) IBOutlet UIButton *ui_delMarkBtn;
@property (strong, nonatomic) StatusTipView *tipView;
@property (strong, nonatomic) IBOutlet UIView *ui_uploadStatusView;
@property (strong, nonatomic) IBOutlet UILabel *ui_uploadTipLabel;
@property (strong, nonatomic) IBOutlet UISlider *ui_uploadProcessView;

@property (strong, nonatomic) IBOutlet UIButton *ui_sendBtn;
@property (nonatomic) BOOL isUploading;

@property (strong, nonatomic) NSString *fileString;
@property (strong, nonatomic) NSMutableArray *imgsArr;
@property (strong, nonatomic) CCClientRequest *myRequest;
@property (strong, nonatomic) FtpObject *ftpObject;
@property (strong, nonatomic) FTPWrapper *ftp;
@property (strong, nonatomic) IBOutlet UIView *ui_stopUploadView;
@property (strong, nonatomic) IBOutlet UIButton *ui_loadingMarkBtn;


@end

@implementation PaiKeUploadViewController

- (void)dealloc
{
    self.ui_textView = nil;
    self.ui_textField = nil;
    self.ui_buttomView = nil;
    self.ui_scrollView = nil;
    self.ui_picsView = nil;
    self.ui_sheetView = nil;
    self.ui_markBtn = nil;
    self.ui_delView = nil;
    self.ui_delMarkBtn = nil;
    self.ui_sendBtn = nil;
    
    self.fileString = nil;
    self.imgsArr = nil;
    self.myRequest.c_delegate = self;
    self.myRequest = nil;
    self.ftpObject = nil;
    self.tipView = nil;
    self.ui_uploadStatusView = nil;
    self.ui_uploadTipLabel = nil;
    self.ui_uploadProcessView = nil;
    self.ui_stopUploadView = nil;
    self.ui_loadingMarkBtn = nil;
    
    [self releaseFtpObject];
    [self clearPics];
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.imgsArr = [[NSMutableArray alloc] init];
        self.myRequest = [[CCClientRequest alloc] init];
        self.myRequest.c_delegate = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self keyTapped:nil];
    
    [self.ui_uploadProcessView setMinimumTrackImage:[[UIImage imageNamed:@"volume_blue"] stretchableImageWithLeftCapWidth:5 topCapHeight:0] forState:UIControlStateNormal];
    [self.ui_uploadProcessView setMaximumTrackImage:[UIImage imageNamed:@"volume_gray"] forState:UIControlStateNormal];
    [self.ui_uploadProcessView setThumbImage:[UIImage imageNamed:@"upload_process"] forState:UIControlStateHighlighted];
    [self.ui_uploadProcessView setThumbImage:[UIImage imageNamed:@"upload_process"] forState:UIControlStateNormal];
    self.ui_uploadProcessView.userInteractionEnabled = NO;
    
    self.ui_textView.placeholder = @"输入内容";
    self.ui_textView.backgroundColor = [UIColor clearColor];
    self.ui_textView.alpha = 0.8f;
    
    camaraObj = [[CamaraObject alloc] init];
    camaraObj.c_delegate = self;
    
    self.tipView = [[StatusTipView alloc] initWithFrame:CGRectMake(320, 160, 120, 70)];
    [self.view addSubview:self.tipView];
    
    [self addImgs];
    
    //sheet表单
    [SMApp.nav.view addSubview:self.ui_sheetView];
    [SMApp.nav.view addSubview:self.ui_markBtn];
    [SMApp.nav.view addSubview:self.ui_stopUploadView];
    
    CGRect rect = self.ui_sheetView.frame;
    rect.origin.y = viewHeight;
    self.ui_sheetView.frame = rect;
    
    CGRect uRect = self.ui_stopUploadView.frame;
    uRect.origin.y = viewHeight;
    self.ui_stopUploadView.frame = uRect;
    
    [SMApp.nav.view bringSubviewToFront:self.ui_markBtn];
    [SMApp.nav.view bringSubviewToFront:self.ui_sheetView];
    //end
    
    //删除提示
    [SMApp.nav.view addSubview:self.ui_delMarkBtn];
    [SMApp.nav.view addSubview:self.ui_delView];
    
    CGRect delRect = self.ui_delView.frame;
    delRect.origin.y = viewHeight;
    self.ui_delView.frame = delRect;
    //end
    
    //获取ftp接口信息
    [self.myRequest ftpInfo];
    uploadIndex = 0;
    
    self.isUploading = NO;
    isCancel = YES;
    
    self.ui_loadingMarkBtn.hidden = YES;
    [self.view addSubview:self.ui_loadingMarkBtn];
    CGRect mRect = self.ui_loadingMarkBtn.frame;
    mRect.origin.y = 64;
    self.ui_loadingMarkBtn.frame = mRect;
    
    originIsLight = self.isLight;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [StatusBarObject setStatusBarStyleWithIndex:0];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    SMApp.nav.isSlider = NO;
    
    if (!([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0))
    {
        [self performSelector:@selector(freshViewFrame) withObject:nil afterDelay:0.1];
    }
    
    self.isLight = originIsLight;
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.isLight == YES)
    {
        [StatusBarObject setStatusBarStyleWithIndex:1];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    SMApp.nav.isSlider = YES;
}

#pragma mark -
#pragma mark - custom method
- (void) addImgs
{
    for (UIView *tmpView in self.ui_picsView.subviews)
    {
        [tmpView removeFromSuperview];
    }
    
    for (int i = 0; i < 4; i ++)
    {
        if (i > ([self.imgsArr count] - 1) || [self.imgsArr count] == 0)
        {
            UIButton *tmpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            tmpBtn.frame = CGRectMake(8 + 77*i, 0, 60, 60);
            [self.ui_picsView addSubview:tmpBtn];
            [tmpBtn addTarget:self action:@selector(camaraTapped:) forControlEvents:UIControlEventTouchUpInside];
            [tmpBtn setImage:[UIImage imageNamed:@"tip_add_img"] forState:UIControlStateNormal];
            return;
        }
        
        NSMutableDictionary *tmpDic = [self.imgsArr objectAtIndex:i];
        
        UIButton *tmpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        tmpBtn.frame = CGRectMake(8 + 77*i, 0, 60, 60);
        [self.ui_picsView addSubview:tmpBtn];
        tmpBtn.tag = 10 + i;
        [tmpBtn addTarget:self action:@selector(imgTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *tmpImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        tmpImgView.contentMode = UIViewContentModeScaleAspectFill;
        tmpImgView.clipsToBounds = YES;
        [tmpImgView setImage:[tmpDic objectForKey:@"image"]];
        
        [tmpBtn addSubview:tmpImgView];
    }
}

- (void) addImgObjWith:(NSMutableDictionary *) dic
{
    [self.imgsArr addObject:dic];
}

- (void) saveToLocalWithImg:(UIImage *) image
{
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    [imageData writeToFile:self.fileString atomically:NO];
}

- (FTPWrapper *) getFtpObject
{
    FTPWrapper *tmpFtp = [[FTPWrapper alloc] init];
    [tmpFtp initRemoteFtpServer:self.ftpObject.f_ip port:[self.ftpObject.f_port intValue] userName:self.ftpObject.f_userName passwd:self.ftpObject.f_psw];
    tmpFtp.uploadDelegate = self;
    return tmpFtp;
}

- (void) releaseFtpObject
{
    if (self.ftp)
    {
        self.ftp.uploadDelegate = nil;
        [self.ftp stopUpload];
        self.ftp = nil;
    }
    
    UIView *statusView = (UIView *)[[UIApplication sharedApplication] valueForKey:@"statusBar"];
    for (UIView *tmpView in statusView.subviews)
    {
        if (tmpView.tag == 100000)
        {
            [tmpView removeFromSuperview];
        }
    }
}

- (void) uploadData
{
    if (uploadIndex == [self.imgsArr count])
    {
        if ([NetWorkObserver dataNetworkTypeFromStatusBar] == NETWORK_TYPE_2G )
        {
            [self performSelector:@selector(uploadImgInfo) withObject:nil afterDelay:6];
        }
        else if  ([NetWorkObserver dataNetworkTypeFromStatusBar] == NETWORK_TYPE_3G)
        {
            [self performSelector:@selector(uploadImgInfo) withObject:nil afterDelay:4];
        }
        else
        {
            [self performSelector:@selector(uploadImgInfo) withObject:nil afterDelay:2];
        }
        
        return;
    }
    else
    {
        if (self.ftp)
        {
            self.ftp.uploadDelegate = nil;
            [self.ftp stopUpload];
            self.ftp = nil;
        }
    }
    
    self.ui_uploadProcessView.value = 0;
    [self sendTapped:nil];
}

- (void) uploadImgInfo
{
    //上传成功
    [self.myRequest uploadPicWithParam:[self getParam]];
    uploadIndex = 0;
    self.isUploading = NO;
}

- (NSString *) getParam
{
    NSString *paramString = [[NSString alloc] init];
    NSMutableString *parameterList=[NSMutableString stringWithCapacity:64];
    
    [parameterList appendString:@"["];
    
    for (int i = 0 ; i < [self.imgsArr count];i ++)
    {
        NSDictionary *tmpDic = [self.imgsArr objectAtIndex:i];
        
        if (i == 0)
        {
            [parameterList appendString:[NSString stringWithFormat:@"{'Url': 'ios/%@/%@/%@','Width': %@,'Height': %@}",SMApp.userObject.u_id,[tmpDic objectForKey:@"datetime"],[tmpDic objectForKey:@"name"],[tmpDic objectForKey:@"Width"],[tmpDic objectForKey:@"Height"]]];
            continue;
        }

        [parameterList appendString:[NSString stringWithFormat:@",{'Url': 'ios/%@/%@/%@','Width': %@,'Height': %@}",SMApp.userObject.u_id,[tmpDic objectForKey:@"datetime"],[tmpDic objectForKey:@"name"],[tmpDic objectForKey:@"Width"],[tmpDic objectForKey:@"Height"]]];
    }
    
    [parameterList appendString:@"]"];
    
    paramString = [NSString stringWithFormat:@"{ServerId:%@,Title:\"%@\",UserId:%@,NickName:\"%@\",Content:\"%@\",Img:%@}",self.ftpObject.f_id,self.ui_textField.text,SMApp.userObject.u_id,SMApp.userObject.u_userName,self.ui_textView.text,parameterList];
    
    NSData *tmpData = [GTMBase64 encodeData:[paramString dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *tmpString = [[NSString alloc] initWithData:tmpData encoding:NSUTF8StringEncoding];
    
    return tmpString;
}

- (void) popViewController
{
    if (self.isLight == YES)
    {
        [StatusBarObject setStatusBarStyleWithIndex:1];
    }
    
    [self releaseFtpObject];
    [self delCancelTapped:nil];
    [self clearPics];
    
    [SMApp.nav popViewController];
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

- (void) clearPics
{
    NSString *extension = @"jpg";
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:PicPath error:NULL];
    NSEnumerator *e = [contents objectEnumerator];
    NSString *filename;
    while ((filename = [e nextObject]))
    {
        
        if ([[filename pathExtension] isEqualToString:extension]) {
            
            [fileManager removeItemAtPath:[PicPath stringByAppendingPathComponent:filename] error:NULL];
        }
    }
}

#pragma mark -
#pragma mark - 控件事件
- (IBAction)backTapped:(id)sender
{
    if (self.isUploading)
    {
        [SMApp.nav.view bringSubviewToFront:self.ui_stopUploadView];
        [UIView animateWithDuration:0.3
                         animations:^{
                             CGRect rect = self.ui_stopUploadView.frame;
                             rect.origin.y = viewHeight - rect.size.height;
                             self.ui_stopUploadView.frame = rect;
                             self.ui_delMarkBtn.alpha = 0.4;
                         }];
    }
    else
    {
//        AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//        [app.nav popViewController];
        [self popViewController];
    }
}

- (IBAction)keyTapped:(id)sender
{
    if (isCancel == YES)
    {
        [self.ui_textField becomeFirstResponder];
        isCancel = NO;
    }
    else
    {
        [self.ui_textField resignFirstResponder];
        [self.ui_textView resignFirstResponder];
        isCancel = YES;
    }
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         CGPoint point = CGPointMake(0, 0);
                         self.ui_scrollView.contentOffset = point;
                     } completion:^(BOOL finished) {
                         CGSize size = self.ui_scrollView.contentSize;
                         size.height = viewHeight - 110;
                         self.ui_scrollView.contentSize = size;
                         
                         CGRect scrollRect = self.ui_scrollView.frame;
                         scrollRect.size.height = viewHeight - 110;
                         self.ui_scrollView.frame = scrollRect;
                         
                         CGRect rect = self.ui_textView.frame;
                         rect.size.height = viewHeight - 240;
                         self.ui_textView.frame = rect;
                         
                         CGRect picRect = self.ui_picsView.frame;
                         picRect.origin.y = viewHeight - 182;
                         self.ui_picsView.frame = picRect;
                     }];
}

- (IBAction)camaraTapped:(id)sender
{
    if (!self.isUploading)
    {
        isCancel = NO;
        [self keyTapped:nil];
        
        [UIView animateWithDuration:0.3
                         animations:^{
                             
                             CGRect rect = self.ui_sheetView.frame;
                             rect.origin.y = viewHeight - rect.size.height;
                             self.ui_sheetView.frame = rect;
                             self.ui_markBtn.alpha = 0.4;
                         }];
    }
}


- (IBAction)openCamaraTapped:(id)sender
{
    photoType = 1;
    
    [camaraObj openPicOrVideoWithSign:photoType];
    [self markTapped:nil];
}

- (IBAction)selectTapped:(id)sender
{
    photoType = 0;
    
    [camaraObj openPicOrVideoWithSign:photoType];
    [StatusBarObject setStatusBarStyleWithIndex:0];
    [self markTapped:nil];
}

- (IBAction)cancelTapped:(id)sender
{
    [self markTapped:nil];
}

- (IBAction)markTapped:(id)sender
{
    self.isLight = NO;
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         
                         CGRect rect = self.ui_sheetView.frame;
                         rect.origin.y = viewHeight;
                         self.ui_sheetView.frame = rect;
                         
                         self.ui_markBtn.alpha = 0;
                     }];
}

- (IBAction)delTapped:(id)sender
{
    if (self.isUploading == NO)
    {
        NSMutableDictionary *tmpDic = [self.imgsArr objectAtIndex:index];
        [[NSFileManager defaultManager] removeItemAtPath:[tmpDic objectForKey:@"localPath"] error:nil];
        
        [self.imgsArr removeObjectAtIndex:index];
        [self addImgs];
        
        [self delCancelTapped:nil];
    }
}

- (IBAction)sendTapped:(id)sender
{
    isCancel = NO;
    [self keyTapped:nil];
    
    if ([self.ui_textField.text stringByReplacingOccurrencesOfString:@" " withString:@""].length == 0)
    {
        [self.view bringSubviewToFront:self.tipView];
        [self.tipView tipShowWithType:DataIsNullTip tipString:TitleNil isHidden:YES];
        
        return;
    }
    
    if ([self.imgsArr count] == 0)
    {
        [self.view bringSubviewToFront:self.tipView];
        [self.tipView tipShowWithType:DataIsNullTip tipString:ImageNil isHidden:YES];
        
        return;
    }
    
    if (self.ftpObject)
    {
        if (SMApp.userObject)
        {
            if (self.ftpObject)
            {
                self.isUploading = YES;
                [self.view bringSubviewToFront:self.ui_loadingMarkBtn];
                self.ui_loadingMarkBtn.hidden = NO;
                
                [self.view bringSubviewToFront:self.tipView];
                [self.tipView tipShowWithType:InfoCommittingTip tipString:UploadingData isHidden:NO];
                
                UIView *statusView = (UIView *)[[UIApplication sharedApplication] valueForKey:@"statusBar"];
                
                self.ui_sendBtn.enabled = NO;
                [self.ui_sendBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                
                //上传第一个对象
                self.ftp = [self getFtpObject];
                NSDictionary *tmpDic = [self.imgsArr objectAtIndex:uploadIndex];
                self.ui_uploadTipLabel.text = [NSString stringWithFormat:@"第%d张图上传中...",(uploadIndex + 1)];
                [self.ftp setFtpUploadPath:[NSString stringWithFormat:@"%@/ios/%@/%@/%@",self.ftpObject.f_path,SMApp.userObject.u_id,[tmpDic objectForKey:@"datetime"],[tmpDic objectForKey:@"name"]]];
                
                if (uploadIndex == 0)
                {
                    [statusView addSubview:self.ui_uploadStatusView];
                }
                
                [self.ftp uploadFile:[tmpDic objectForKey:@"localPath"]];
            }
        }
        else
        {
            LoginViewController *login = [[LoginViewController alloc] init];
            AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [app.nav pushViewController:login];
        }
    }
    else
    {
        
        [self.view bringSubviewToFront:self.tipView];
        [self.tipView tipShowWithType:CommittingFailTip tipString:FailTip isHidden:YES];
        
        //请求ftp信息
        [self.myRequest ftpInfo];
    }
}



- (void) imgTapped:(UIButton *) sender
{
    index = sender.tag - 10;
    [SMApp.nav.view bringSubviewToFront:self.ui_delView];
    [UIView animateWithDuration:0.3
                     animations:^{
                         CGRect delRect = self.ui_delView.frame;
                         delRect.origin.y = viewHeight - delRect.size.height;
                         self.ui_delView.frame = delRect;
                         self.ui_delMarkBtn.alpha = 0.5;
                     }];
}

- (IBAction)delCancelTapped:(id)sender
{
    [UIView animateWithDuration:0.3
                     animations:^{
                        CGRect delRect = self.ui_delView.frame;
                        delRect.origin.y = viewHeight;
                        self.ui_delView.frame = delRect;
                         self.ui_delMarkBtn.alpha = 0;
                         
                         CGRect uRect = self.ui_stopUploadView.frame;
                         uRect.origin.y = viewHeight;
                         self.ui_stopUploadView.frame = uRect;
                     }];
}

- (IBAction)stopUploadTapped:(id)sender
{
    self.myRequest.c_delegate = nil;
    [self delCancelTapped:nil];
    [self releaseFtpObject];
    if (self.isLight == YES)
    {
        [StatusBarObject setStatusBarStyleWithIndex:1];
    }
    self.isUploading = NO;
    
    [SMApp.nav popViewController];
}

#pragma mark -
#pragma mark - 消息处理函数
- (void)keyboardWillShow:(NSNotification *)notification
{
    
    [self.view bringSubviewToFront:self.ui_buttomView];
    
    /* Move the toolbar to above the keyboard */
    CGRect keyboardFrame;
	[[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrame];
	CGFloat keyboardHight = CGRectGetHeight(keyboardFrame);
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.3];
    
	CGRect newRect = self.ui_buttomView.frame;
	newRect.origin = CGPointMake(0, [[UIScreen mainScreen] bounds].size.height - keyboardHight - newRect.size.height);
    self.ui_buttomView.frame = newRect;
    
	[UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.ui_buttomView.frame;
        if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation))
        {
            frame.origin.y = self.view.frame.size.height - 44;
        }
        else
        {
            frame.origin.y = self.view.frame.size.width - 44;
        }
        self.ui_buttomView.frame = frame;
    }];
    
}

#pragma mark -
#pragma mark - 自定义代理
- (void) uploadBegin
{
    
}

- (void) uploadStopped
{
    
}

- (void) uploadProgress:(float)progress
{
    self.ui_uploadProcessView.value = progress;
}

- (void) uploadFinished
{
    uploadIndex ++;
    
    CGFloat animationDuration = 2;
    
    if (NETWORK_TYPE_2G == [NetWorkObserver dataNetworkTypeFromStatusBar])
    {
        animationDuration = 4;
    }
    
    if (self.isUploading == YES && self.myRequest.c_delegate)
    {
        [self performSelector:@selector(uploadData) withObject:nil afterDelay:animationDuration];
    }
}

#pragma mark -
#pragma mark - 网络回调
- (void) ftpInfoCallBack:(id) objectData
{
    if ([objectData count] > 0)
    {
        self.ftpObject = [objectData objectAtIndex:0];
    }
}

- (void) uploadPicCallBack:(id) objectData
{
    [self.view bringSubviewToFront:self.tipView];
    [self.tipView tipShowWithType:SuccessTipTypeTwo tipString:SuccessUpload isHidden:YES];
    [self performSelector:@selector(popViewController) withObject:nil afterDelay:0.7];
    self.ui_loadingMarkBtn.hidden = YES;
    
    self.ui_sendBtn.enabled = NO;
    [self.ui_sendBtn setTitleColor:[UIColor colorWithRed:51.0f/255.0f green:150.0f/255.0f blue:255.0f/255.0f alpha:1] forState:UIControlStateNormal];
}

#pragma mark -
#pragma mark - 网络回调失败
- (void) failLoadData:(id) reasonString
{
    if (reasonString)
    {
        self.ui_loadingMarkBtn.hidden = YES;
        [self.view bringSubviewToFront:self.tipView];
        [self.tipView tipShowWithType:SigleNetFailTip tipString:NetFailTip isHidden:YES];
        
        uploadIndex = 0;
        [self releaseFtpObject];
        self.isUploading = NO;
        self.ui_sendBtn.enabled = YES;
        self.ui_sendBtn.titleLabel.textColor = [UIColor colorWithRed:51.0f/255.0f green:153.0f/255.0f blue:1.0 alpha:1.0];
    }
}

#pragma mark -
#pragma mark - 系统代理
- (void) textViewDidBeginEditing:(UITextView *)textView
{
    CGSize size = self.ui_scrollView.contentSize;
    size.height = viewHeight - 120;
    self.ui_scrollView.contentSize = size;
    
    CGRect scrollRect = self.ui_scrollView.frame;
    scrollRect.size.height = viewHeight - 240;
    self.ui_scrollView.frame = scrollRect;
    
    CGRect rect = self.ui_textView.frame;
    rect.size.height = viewHeight - 370;
    self.ui_textView.frame = rect;
    
    CGRect picRect = self.ui_picsView.frame;
    picRect.origin.y = viewHeight - 312;
    self.ui_picsView.frame = picRect;
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         CGPoint point = CGPointMake(0, 50);
                         self.ui_scrollView.contentOffset = point;
                     }];
    
    isCancel = NO;
    
}

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    isCancel = NO;
}

//相机操作
-  (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissModalViewControllerAnimated:YES];
    
    NSMutableDictionary *infoDic = [[NSMutableDictionary alloc] init];
    
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:@"public.image"])
    {
        UIImage  *img = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        if (photoType == 1)
        {
            UIImageWriteToSavedPhotosAlbum(img,nil, nil, nil);
        }
        
        //缩减图片
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.image = img;
        CGSize imgSize = [imageView image].size;
        if (imgSize.width > 640)
        {
            img = [UIImage imageWithImage:img scaledToSize:CGSizeMake(640.0f, imgSize.height*(640.0f/imgSize.width))];
            imgSize.height = imgSize.height*(640.0f/imgSize.width);
            imgSize.width = 640.0f;
        }
        [infoDic setValue:[NSString stringWithFormat:@"%.0f",imgSize.width] forKey:@"Width"];
        [infoDic setValue:[NSString stringWithFormat:@"%.0f",imgSize.height] forKey:@"Height"];
        //end
        
        UIImage *image = [img shrinkImage:CGSizeMake(70, 70)];
        
        //图片名字
        //用当前时间保证文件名称唯一...
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
        NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
        
        //本地路径
        NSString *imagePath = [NSString stringWithFormat:@"%@%@.jpg",PicPath,strDate];
        self.fileString = imagePath;
        
        [infoDic setValue:imagePath forKey:@"localPath"];
        [infoDic setValue:[NSString stringWithFormat:@"%@.jpg",strDate] forKey:@"name"];
        [infoDic setValue:image forKey:@"image"];
        
        [dateFormatter setDateFormat:@"yyyyMMdd"];
        strDate = [dateFormatter stringFromDate:[NSDate date]];
        [infoDic setValue:strDate forKey:@"datetime"];
        
        
        [self performSelectorInBackground:@selector(saveToLocalWithImg:) withObject:img];
    }
    
    //多余四张替换第一张
    if ([self.imgsArr count] >= 4)
    {
        [self.imgsArr replaceObjectAtIndex:0 withObject:infoDic];
    }
    else
    {
        [self addImgObjWith:infoDic];
    }
    [self addImgs];
}


@end
