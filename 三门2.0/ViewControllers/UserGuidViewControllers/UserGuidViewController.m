//
//  UserGuidViewController.m
//  SanMen
//
//  Created by lcc on 13-12-29.
//  Copyright (c) 2013年 lcc. All rights reserved.
//

#import "UserGuidViewController.h"
#import "MetaData.h"
#import "FMDBManage.h"
#import "SettingObject.h"

@interface UserGuidViewController ()<UIScrollViewDelegate>
{
    NSInteger currentIndex;
}

@property (strong, nonatomic) IBOutlet UIImageView *ui_bgImgView;
@property (strong, nonatomic) IBOutlet UIScrollView *ui_scrollView;

//动画第一页
@property (strong, nonatomic) IBOutlet UIView *ui_firstView;
@property (strong, nonatomic) IBOutlet UIView *ui_f_bgView;
@property (strong, nonatomic) IBOutlet UIImageView *ui_f_iphoneImgView;
@property (strong, nonatomic) IBOutlet UIImageView *ui_f_headerImgView;
@property (strong, nonatomic) IBOutlet UIImageView *ui_f_contentImgView;
@property (strong, nonatomic) IBOutlet UIImageView *ui_f_lineImgView;


//第二页面动画
@property (strong, nonatomic) IBOutlet UIView *ui_s_view;
@property (strong, nonatomic) IBOutlet UIImageView *ui_leftImgView;
@property (strong, nonatomic) IBOutlet UIImageView *ui_rightImgView;
@property (strong, nonatomic) IBOutlet UIImageView *ui_s_handImgView;

//第三个页面动画
@property (strong, nonatomic) IBOutlet UIView *ui_t_view;
@property (strong, nonatomic) IBOutlet UIImageView *ui_t_topImgView;
@property (strong, nonatomic) IBOutlet UIImageView *ui_t_rightImgView;
@property (strong, nonatomic) IBOutlet UIImageView *ui_t_leftImgView;
@property (strong, nonatomic) IBOutlet UIImageView *ui_t_plane;
@property (strong, nonatomic) IBOutlet UIButton *ui_startBtn;
@property (strong, nonatomic) IBOutlet UIView *ui_blockBgView;

//第四个页面动画
@property (strong, nonatomic) IBOutlet UIView *ui_f_view;

//滑动标识
@property (strong, nonatomic) IBOutlet UIView *ui_sliderView;
@property (strong, nonatomic) IBOutlet UIImageView *ui_slider_current;



@end

@implementation UserGuidViewController

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
    
    UIView *tmpView = (UIView *)[[UIApplication sharedApplication] valueForKey:@"statusBar"];
    tmpView.alpha = 0;
    
    self.ui_scrollView.pagingEnabled = YES;
    self.ui_scrollView.contentSize = CGSizeMake(320, viewHeight*3);
    self.ui_scrollView.showsVerticalScrollIndicator = NO;
    self.ui_scrollView.bounces = NO;
    self.ui_scrollView.alpha = 0.0f;
    CGRect scrollRect = self.ui_scrollView.frame;
    scrollRect.size.height = viewHeight;
    self.ui_scrollView.frame = scrollRect;
    
    currentIndex = 1;
    
    //添加第一个view
    [self.ui_scrollView addSubview:self.ui_firstView];
    self.ui_firstView.clipsToBounds = YES;
    self.ui_f_bgView.clipsToBounds = YES;
    CGRect fRect = self.ui_firstView.frame;
    fRect.size.height = viewHeight;
    self.ui_firstView.frame = fRect;
    
    //添加第二个view
    CGRect s_rect = self.ui_s_view.frame;
    s_rect.origin.y = viewHeight;
    s_rect.size.height = viewHeight;
    self.ui_s_view.frame = s_rect;
    self.ui_s_view.clipsToBounds = YES;
    [self.ui_scrollView addSubview:self.ui_s_view];
    
    CGRect hRect = self.ui_s_handImgView.frame;
    hRect.origin.x = 28;
    hRect.origin.y = 38;
    self.ui_s_handImgView.frame = hRect;
    [self.ui_leftImgView addSubview:self.ui_s_handImgView];
    
    //添加第三个view
    CGRect tRect = self.ui_t_view.frame;
    tRect.origin.y = viewHeight*2;
    tRect.size.height = viewHeight;
    self.ui_t_view.frame = tRect;
    self.ui_t_view.clipsToBounds = YES;
    [self.ui_scrollView addSubview:self.ui_t_view];
    
    CGRect planeRect =  self.ui_t_plane.frame;
    planeRect.origin.y = viewHeight > 480?421:403;
    self.ui_t_plane.frame = planeRect;
    
    CGRect bgRect = self.ui_blockBgView.frame;
    bgRect.origin.y = viewHeight > 480?212:188;
    self.ui_blockBgView.frame = bgRect;
    
    //添加第四个view
    CGRect forthRect = self.ui_f_view.frame;
    forthRect.origin.y = 40;
    forthRect.size.height = viewHeight;
    self.ui_f_view.alpha = 0.1;
    self.ui_f_view.frame = forthRect;
    self.ui_f_view.clipsToBounds = YES;
    [self.view addSubview:self.ui_f_view];
    
    [self performSelector:@selector(startForthViewAnimation) withObject:nil afterDelay:0.1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - custom method
- (void) setAlpha
{
    UIView *tmpView = (UIView *)[[UIApplication sharedApplication] valueForKey:@"statusBar"];
    tmpView.alpha = 0;
}

//第一个页面动画 开始与结束
- (void) firstViewIphoneAnimation
{
    CGRect rect = self.ui_f_iphoneImgView.frame;
    rect.origin.y = 0;
    [UIView animateWithDuration:1
                     animations:^{
                         self.ui_f_iphoneImgView.frame = rect;
                         self.ui_f_lineImgView.alpha = 1.0f;
                     }];
}

- (void) firstViewHeaderAnimation
{
    CGRect rect = self.ui_f_headerImgView.frame;
    rect.origin.y = 68;
    [UIView animateWithDuration:1
                     animations:^{
                         self.ui_f_headerImgView.frame = rect;
                     }];
}


- (void) firstViewContentAnimation
{
    CGRect rect = self.ui_f_contentImgView.frame;
    rect.origin.y = 160;
    [UIView animateWithDuration:0.8
                     animations:^{
                         self.ui_f_contentImgView.frame = rect;
                     }];
}

//开始第一页动画
- (void) startFirstViewAnimation
{
    [self performSelector:@selector(firstViewIphoneAnimation) withObject:nil afterDelay:0.0];
    [self performSelector:@selector(firstViewHeaderAnimation) withObject:nil afterDelay:0.3];
    [self performSelector:@selector(firstViewContentAnimation) withObject:nil afterDelay:1.0];
}

//停止第一页动画
- (void) stopFirstViewAnimation
{
    
    CGRect iphoneRect = self.ui_f_iphoneImgView.frame;
    iphoneRect.origin.y = 280;
    self.ui_f_iphoneImgView.frame = iphoneRect;
    
    CGRect headerRect = self.ui_f_headerImgView.frame;
    headerRect.origin.y = 282;
    self.ui_f_headerImgView.frame = headerRect;
    
    CGRect contentRect = self.ui_f_contentImgView.frame;
    contentRect.origin.y = 282;
    self.ui_f_contentImgView.frame = contentRect;
    
    self.ui_f_lineImgView.alpha = 0.1f;

}

//第二个页面动画
- (void) startSecViewAnimation
{
    CGRect leftRect = self.ui_leftImgView.frame;
    leftRect.origin.x = 183;
    
    CGRect rightRect = self.ui_rightImgView.frame;
    rightRect.origin.x = 68;
    
    [UIView animateWithDuration:0.6
                     animations:^{
                         self.ui_s_handImgView.alpha = 1.0f;
                     } completion:^(BOOL finished) {
                         
                         [UIView animateWithDuration:0.8
                                          animations:^{
                                              self.ui_leftImgView.frame = leftRect;
                                              self.ui_rightImgView.frame = rightRect;
                                          }];

                     }];
}

- (void) stopSecViewAnimation
{
    CGRect leftRect = self.ui_leftImgView.frame;
    leftRect.origin.x = 68;
    self.ui_leftImgView.frame = leftRect;
    
    CGRect rightRect = self.ui_rightImgView.frame;
    rightRect.origin.x = 183;
    self.ui_rightImgView.frame = rightRect;
    
    self.ui_s_handImgView.alpha = 0;
}

//第三个页面动画
- (void) startThirdViewAnimation
{
     [self performSelector:@selector(thirdViewPlaneImgViewAnimation) withObject:nil afterDelay:0.0];
     [self performSelector:@selector(thirdViewTopImgViewAnimation) withObject:nil afterDelay:1.2];
     [self performSelector:@selector(thirdViewRightImgViewAnimation) withObject:nil afterDelay:0.4];
     [self performSelector:@selector(thirdViewLeftImgViewAnimation) withObject:nil afterDelay:0.8];

}

- (void) thirdViewPlaneImgViewAnimation
{
    CGRect planeRect = self.ui_t_plane.frame;
    planeRect.origin.x = -114;
    planeRect.origin.y = 115;
    
    CGRect btnRect = self.ui_startBtn.frame;
    btnRect.origin.y = viewHeight > 480?450:414;
    
    [UIView animateWithDuration:1.8
                     animations:^{
                         self.ui_t_plane.frame = planeRect;
                     } completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.5
                                          animations:^{
                                              self.ui_startBtn.frame = btnRect;
                                          }];
                     }];
}

- (void) thirdViewTopImgViewAnimation
{
    [UIView animateWithDuration:0.5
                     animations:^{
                         self.ui_t_topImgView.alpha = 1.0f;
                     }];
    
}

- (void) thirdViewRightImgViewAnimation
{
    [UIView animateWithDuration:0.5
                     animations:^{
                         self.ui_t_rightImgView.alpha = 1.0f;
                     }];
    
}

- (void) thirdViewLeftImgViewAnimation
{
    [UIView animateWithDuration:0.5
                     animations:^{
                         self.ui_t_leftImgView.alpha = 1.0f;
                     }];
    
}

- (void) stopThirdViewAnimation
{
    self.ui_t_topImgView.alpha = 0.3;
    self.ui_t_rightImgView.alpha = 0.3;
    self.ui_t_leftImgView.alpha = 0.3;
    
    CGRect btnRect = self.ui_startBtn.frame;
    btnRect.origin.y = viewHeight + 2;
    self.ui_startBtn.frame = btnRect;
    
    CGRect planeRect = self.ui_t_plane.frame;
    planeRect.origin.x = 320;
    planeRect.origin.y = viewHeight > 480?421:403;
    self.ui_t_plane.frame = planeRect;
}

//开始第四个动画
- (void) startForthViewAnimation
{
    CGRect rect = self.ui_f_view.frame;
    rect.origin.y = 0;
    
    [UIView animateWithDuration:0.9 animations:^{
        self.ui_f_view.frame = rect;
        self.ui_f_view.alpha = 1.0f;
    } completion:^(BOOL finished) {
        [self performSelector:@selector(startAllAnimationFirst) withObject:nil afterDelay:1.2];
    }];
}

- (void) startAllAnimationFirst
{
    [UIView animateWithDuration:0.6
                     animations:^{
                         CGRect rect = self.ui_f_view.frame;
                         rect.origin.y = -viewHeight;
                         self.ui_f_view.frame = rect;
                         self.ui_scrollView.alpha = 1.0f;
                         self.ui_sliderView.alpha = 1.0f;
                     }
                     completion:^(BOOL finished) {
                         
                     }];
    [self startFirstViewAnimation];
}

#pragma mark -
#pragma mark - 控件事件
- (IBAction)startTapped:(id)sender
{
    UIView *tmpView = (UIView *)[[UIApplication sharedApplication] valueForKey:@"statusBar"];
    [UIView animateWithDuration:0.3 animations:^{
        self.view.alpha = 0;
        tmpView.alpha = 1;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        
//        SettingObject *tmpObj = [[SettingObject alloc] init];
//        
//        tmpObj.s_home = @"-1";
//        tmpObj.s_left = @"-1";
//        tmpObj.s_camara = @"-1";
//        tmpObj.s_crrVer = [MetaData getCurrVer];
//        
//        //入库
//        [FMDBManage updateTable:tmpObj setString:[NSString stringWithFormat:@"s_home='-1',s_left='-1',s_camara='-1',s_crrVer='%@'",tmpObj.s_crrVer] WithString:@"1=1"];
    }];
}


#pragma mark -
#pragma mark - scroll delegate
- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    UIView *upView = (UIView *)[self.ui_scrollView viewWithTag:currentIndex - 1];
    if (upView && ![upView isKindOfClass:[UIScrollView class]])
    {
        upView.alpha = fabs((scrollView.contentOffset.y - (currentIndex - 1)*viewHeight)/viewHeight);
    }
    
    UIView *midView = (UIView *)[self.ui_scrollView viewWithTag:currentIndex];
    if (midView && ![midView isKindOfClass:[UIScrollView class]])
    {
        CGFloat alpha = fabs((scrollView.contentOffset.y - currentIndex*viewHeight)/viewHeight);
        if (alpha > 1)
        {
            midView.alpha = 2 - alpha;
        }
        else
        {
            midView.alpha = alpha;
        }
    }
    
    UIView *downView = (UIView *)[self.ui_scrollView viewWithTag:currentIndex + 1];
    if (downView && ![downView isKindOfClass:[UIScrollView class]])
    {
        downView.alpha = 1 - fabs((currentIndex*viewHeight - scrollView.contentOffset.y)/viewHeight);
    }
    
    
    CGRect bgRect = self.ui_bgImgView.frame;
    bgRect.origin.y = -scrollView.contentOffset.y*(bgRect.size.height - viewHeight)/(viewHeight*2);
    self.ui_bgImgView.frame = bgRect;
    
    CGRect sliderRect = self.ui_slider_current.frame;
    sliderRect.origin.y = scrollView.contentOffset.y*69/(viewHeight*2);
    self.ui_slider_current.frame = sliderRect;
}

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageHeight = scrollView.frame.size.height;
    currentIndex = floor((scrollView.contentOffset.y - pageHeight / 2) / pageHeight) + 2;
    
    switch (currentIndex)
    {
        case 1:
            [self startFirstViewAnimation];
            [self stopSecViewAnimation];
            [self stopThirdViewAnimation];
            break;
            
        case 2:
            [self startSecViewAnimation];
            [self stopFirstViewAnimation];
            [self stopThirdViewAnimation];
            break;
            
        case 3:
            [self startThirdViewAnimation];
            [self stopFirstViewAnimation];
            [self stopSecViewAnimation];
            break;
            
        default:
            break;
    }
}

@end
