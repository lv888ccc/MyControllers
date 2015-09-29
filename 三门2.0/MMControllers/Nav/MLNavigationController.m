//
//  MLNavigationController.m
//  MultiLayerNavigation
//
//  Created by Feather Chan on 13-4-12.
//  Copyright (c) 2013年 Feather Chan. All rights reserved.
//

#define KEY_WINDOW  [[UIApplication sharedApplication]keyWindow]
#define ViewHeight  [[UIScreen mainScreen] bounds].size.height
#define DetailController @"NewsDetailViewController"
#define CommentController @"NewsCommentViewController"
#define LoginController @"LoginViewController"

#define PopWidth 160
#define MarkAlpha 0.8f

#import "MLNavigationController.h"
#import <QuartzCore/QuartzCore.h>
#import "RootViewController.h"

@interface MLNavigationController ()
{
    CGPoint startTouch;
    UIPanGestureRecognizer *recognizer;
    BOOL isComment;
    BOOL isDetailPop;
    NSInteger originY;
}
@property (nonatomic, strong) NSMutableArray *viewControlsArr;
@property (strong, nonatomic) RootViewController *rootViewController;
@property (strong, nonatomic) UIView *markView;

@end

@implementation MLNavigationController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    recognizer = nil;
    self.viewControlsArr = nil;
    self.rootViewController = nil;
    self.markView = nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        
        self.viewControlsArr = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    isComment = NO;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        originY = 0;
    }
    else
    {
        originY = -20;
    }
    
    self.isSlider = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

//只支持portait,不能旋转:
-(BOOL)shouldAutorotate
{
    return NO;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark -
#pragma mark - custom method
//添加滑动手势
- (void) addRecognizer
{
    recognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self
                                                        action:@selector(paningGestureReceive:)];
    recognizer.delaysTouchesBegan = NO;
    recognizer.maximumNumberOfTouches = 1;
    [self.view addGestureRecognizer:recognizer];
}

//移除滑动手势
- (void) removeRecognizer
{
    [self.view removeGestureRecognizer:recognizer];
    recognizer = nil;
    
}

//入栈
- (void) pushViewController:(UIViewController *)viewController
{
    if (self.rootViewController == nil)
    {
        self.rootViewController = [self.viewControllers objectAtIndex:0];
    }
    
    if (self.markView == nil)
    {
        self.markView = [[UIView alloc] initWithFrame:CGRectMake(0, originY, 320, ViewHeight)];
        [self.markView setBackgroundColor:[UIColor blackColor]];
        [self.rootViewController.view addSubview:self.markView];
        self.markView.alpha = 0;
    }
    else
    {
        self.markView.hidden = NO;
        self.markView.alpha = 0;
    }
    
    //取出底下的viewcontroller
    UIViewController *tmpSecView = self.viewControlsArr.count > 0?[self.viewControlsArr objectAtIndex:0]:nil;
    
    viewController.view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
    
    viewController.view.frame = CGRectMake(320, originY, 319, ViewHeight);
    [self.rootViewController.view bringSubviewToFront:self.markView];
    [self.rootViewController.view addSubview:viewController.view];
    
    [UIView animateWithDuration:0.4
                     animations:^{
                         viewController.view.frame = CGRectMake(0, originY, 320, ViewHeight);
                         tmpSecView.view.frame = CGRectMake(-PopWidth, originY, 320, ViewHeight);
                         if (!tmpSecView)
                         {
                             [self.rootViewController setViewFrame:[NSNumber numberWithFloat:-PopWidth]];
                         }
                         self.markView.alpha = MarkAlpha;
                     }
                     completion:^(BOOL finish){
                         [self.viewControlsArr insertObject:viewController atIndex:0];
                         
                         //判定系统版本。
                         double version = [[UIDevice currentDevice].systemVersion doubleValue];
                         if(version >= 7.0f)
                         {
                             if ([self.view.gestureRecognizers count] == 1 && [self.viewControlsArr count] > 0)
                             {
                                 [self addRecognizer];
                             }
                         }
                         else
                         {
                             if ([self.view.gestureRecognizers count] == 0 && [self.viewControlsArr count] > 0)
                             {
                                 [self addRecognizer];
                             }
                         }
                         
                     }];
}

//出栈
- (void) popViewController
{
    UIViewController *tmpSecView = nil;
    if ([self.viewControlsArr count] > 1)
    {
        tmpSecView = [self.viewControlsArr objectAtIndex:1];
    }
    else
    {
        [self removeRecognizer];
    }
    
    __block UIViewController *tmpView = [self.viewControlsArr objectAtIndex:0];
    
    [UIView animateWithDuration:0.4 animations:^{
        tmpView.view.frame = CGRectMake(320, originY, 320, ViewHeight);
        tmpSecView.view.frame = CGRectMake(0, originY, 320, ViewHeight);
        if (!tmpSecView)
        {
            [self.rootViewController setViewFrame:[NSNumber numberWithFloat:0]];
        }
        self.markView.alpha = 0;
        
    } completion:^(BOOL finish){
        
        [self.rootViewController.view bringSubviewToFront:self.markView];
        [self.rootViewController.view bringSubviewToFront:tmpSecView.view];
        
        [tmpView.view removeFromSuperview];
        [self.viewControlsArr removeObjectAtIndex:0];
        tmpView = nil;
        
        if ([self.viewControlsArr count] <= 0)
        {
            self.markView.hidden = YES;
        }
        
        self.markView.alpha = MarkAlpha;
        
        [tmpSecView viewWillAppear:YES];
    }];
}

//全部出栈
- (void) popViewControllerToRoot
{
    //清空view和viewcontroller
    for (int i = 1; i < [self.viewControlsArr count]; i ++)
    {
        UIViewController *tmpVc = [self.viewControlsArr objectAtIndex:i];
        [tmpVc.view removeFromSuperview];
    }
    [self.viewControlsArr removeObjectsInRange:NSMakeRange(1, [self.viewControlsArr count] - 1)];
    
    [self popViewController];
}

//跳转到制定堆栈
- (void) popToViewController:(NSString *) viewControlString
{
    //清空view和viewcontroller
    NSInteger startIndex = 1;
    NSInteger lastIndex = 1;
    for (int i = startIndex; i < [self.viewControlsArr count]; i ++)
    {
        UIViewController *tmpVc = [self.viewControlsArr objectAtIndex:i];
        NSString *classString = [NSString stringWithFormat:@"%@",[tmpVc class]];
        if ([classString isEqualToString:viewControlString])
        {
            lastIndex = i;
            break;
        }
        [tmpVc.view removeFromSuperview];
    }
    
    [self.viewControlsArr removeObjectsInRange:NSMakeRange(startIndex, lastIndex - 1)];
    
    [self popViewController];
}

- (void) popToDownViewController:(NSString *) viewControlString
{
    //清空view和viewcontroller
    NSInteger startIndex = 1;
    NSInteger lastIndex = 1;
    for (int i = startIndex; i < [self.viewControlsArr count]; i ++)
    {
        UIViewController *tmpVc = [self.viewControlsArr objectAtIndex:i];
        NSString *classString = [NSString stringWithFormat:@"%@",[tmpVc class]];
        [tmpVc.view removeFromSuperview];
        
        if ([classString isEqualToString:viewControlString])
        {
            lastIndex = i;
            break;
        }
    }
    
    [self.viewControlsArr removeObjectsInRange:NSMakeRange(startIndex, lastIndex)];
    
    [self popViewController];
}

#pragma mark -
#pragma mark - 消息处理方法
- (void)keyboardWillShow:(NSNotification *)notification
{
    [self removeRecognizer];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    [self addRecognizer];
}

#pragma mark -
#pragma mark - Gesture Recognizer 处理方法
- (void)paningGestureReceive:(UIPanGestureRecognizer *)recoginzer
{
    if (self.isSlider)
    {
        if (self.viewControlsArr.count <= 0)
            return;
        
        CGPoint touchPoint = [recoginzer locationInView:KEY_WINDOW];
        
        UIViewController *tmpView = [self.viewControlsArr objectAtIndex:0];
        CGRect frame = tmpView.view.frame;
        
        //取出底下的viewcontroller
        UIViewController *tmpSecView = self.viewControlsArr.count > 1?[self.viewControlsArr objectAtIndex:1]:nil;
        CGRect secFrame = tmpSecView == nil?CGRectMake(0, originY, originY, 0):tmpSecView.view.frame;
        
        if (recoginzer.state == UIGestureRecognizerStateBegan)
        {
            startTouch = touchPoint;
            
            UIViewController *topVc = [self.viewControlsArr objectAtIndex:0];
            if ([topVc isKindOfClass:NSClassFromString(CommentController)])
            {
                isComment = YES;
            }
            else
            {
                isComment = NO;
            }
        }
        else if (recoginzer.state == UIGestureRecognizerStateEnded)
        {
            CGFloat flipWidth = 100;
            
            isDetailPop = NO;
            
            if (isComment == NO)
            {
                if ([tmpSecView isKindOfClass:NSClassFromString(DetailController)])
                {
                    flipWidth = 200;
                }
            }
            
            if (tmpView.view.frame.origin.x < flipWidth)
            {
                [UIView animateWithDuration:0.3 animations:^{
                    [tmpView.view setFrame:CGRectMake(0, originY, 320, ViewHeight)];
                    [tmpSecView.view setFrame:CGRectMake(-PopWidth, originY, 320, ViewHeight)];
                    if (!tmpSecView)
                    {
                        [self.rootViewController setViewFrame:[NSNumber numberWithFloat:-PopWidth]];
                    }
                    self.markView.alpha = (1.0-frame.origin.x/320.0)*MarkAlpha;
                }];
            }
            else
            {
                [self popViewController];
            }
            return;
        }
        
        if (touchPoint.x - startTouch.x > 0)
        {
            isDetailPop = YES;
            
            if (isComment == NO)
            {
                if ([tmpSecView isKindOfClass:NSClassFromString(DetailController)] && ![tmpView isKindOfClass:NSClassFromString(DetailController)] && ![tmpView isKindOfClass:NSClassFromString(LoginController)])
                {
                    [tmpView.view removeFromSuperview];
                    [self.viewControlsArr removeObjectAtIndex:0];
                    [self.rootViewController.view bringSubviewToFront:self.markView];
                    [self.rootViewController.view bringSubviewToFront:tmpSecView.view];
                    self.markView.alpha = MarkAlpha;
                    tmpSecView = nil;
                    tmpView = nil;
                    return;
                }
            }
            
            frame.origin.x = touchPoint.x - startTouch.x;
            secFrame.origin.x = frame.origin.x/2 - PopWidth;
            if (!tmpSecView)
            {
                [self.rootViewController setViewFrame:[NSNumber numberWithFloat:secFrame.origin.x]];
            }
        }
        else if (touchPoint.x - startTouch.x < 0)
        {
            if (isComment == NO)
            {
                //左滑加载评论页面
                //如果是详情页面
                UIViewController *tmpViewController = [self.viewControlsArr objectAtIndex:0];
                if ([tmpViewController isKindOfClass:NSClassFromString(DetailController)] && tmpViewController != nil)
                {
                    if (self.m_delegate && [self.m_delegate respondsToSelector:@selector(pushCommentViewController)])
                    {
                        if (isDetailPop == NO)
                        {
                            tmpViewController = [self.m_delegate pushCommentViewController];
                            
                            if (tmpViewController)
                            {
                                if (self.markView == nil)
                                {
                                    self.markView = [[UIView alloc] initWithFrame:CGRectMake(0, originY, 320, ViewHeight)];
                                    [self.markView setBackgroundColor:[UIColor blackColor]];
                                    [self.rootViewController.view addSubview:self.markView];
                                    self.markView.alpha = 0;
                                }
                                else
                                {
                                    self.markView.hidden = NO;
                                    self.markView.alpha = 0;
                                }
                                
                                tmpViewController.view.frame = CGRectMake(320, originY, 319, ViewHeight);
                                [self.rootViewController.view bringSubviewToFront:self.markView];
                                [self.rootViewController.view addSubview:tmpViewController.view];
                                [self.viewControlsArr insertObject:tmpViewController atIndex:0];
                                
                                tmpView = tmpViewController;
                                frame = tmpView.view.frame;
                            }
                            
                        }
                        else
                        {
                            //防止全部左滑动
                            frame.origin.x = 0;
                        }
                        
                    }
                    else
                    {
                        //防止全部左滑动
                        frame.origin.x = 0;
                    }
                }
                else
                {
                    
                    if (![tmpSecView isKindOfClass:NSClassFromString(DetailController)])
                    {
                        //防止全部左滑动
                        frame.origin.x = 0;
                    }
                    else
                    {
                        //如果是登陆放行 这个地方和详情有冲突（登陆和详情页和评论页面）
                        if (![tmpView isKindOfClass:NSClassFromString(LoginController)])
                        {
                            frame.origin.x = 320 - startTouch.x + touchPoint.x;
                        }
                        else
                        {
                            frame.origin.x = 0;
                        }
                        
                        //滑动到一半
                        secFrame.origin.x = (touchPoint.x - startTouch.x)/2;
                    }
                }
            }
            else
            {
                //防止全部左滑动
                frame.origin.x = 0;
            }
        }
        tmpView.view.frame = frame;
        tmpSecView.view.frame = secFrame;
        self.markView.alpha = (1.0-frame.origin.x/320.0)*MarkAlpha;
    }
}

@end
