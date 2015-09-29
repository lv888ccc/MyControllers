//
//  PaiKeViewController.m
//  SanMen
//
//  Created by lcc on 13-12-22.
//  Copyright (c) 2013年 lcc. All rights reserved.
//

#import "PaiKeViewController.h"
#import "TitleNavView.h"
#import "VCScrollView.h"

@interface PaiKeViewController ()<TitleNavViewDelegate,VCScrollViewDelegate>
{
    TitleNavView *navView;
    VCScrollView *vcScrollView;
    NSInteger currentIndex;
}


@end

@implementation PaiKeViewController

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
    
    //导航
    navView = [[TitleNavView alloc] initWithFrame:CGRectMake(12, 0, 296, 30)];
    NSMutableArray *tmpArr = [NSMutableArray arrayWithObjects:@"主题拍",@"随手拍", nil];
    navView.tagArr = tmpArr;
    [self.view addSubview:navView];
    [navView setContent];
    [navView setT_delegate:self];
    
    //滚动窗体载体
    vcScrollView = [[VCScrollView alloc] initWithFrame:CGRectMake(0, 45, 320, viewHeight - 45 - 64)];
    vcScrollView.maxWidth = 320;
    vcScrollView.pagingEnabled = YES;
    CGSize contentSize = vcScrollView.contentSize;
    contentSize.width = 320*tmpArr.count;
    vcScrollView.contentSize = contentSize;
    [vcScrollView setV_delegate:self];
    [self.view addSubview:vcScrollView];
    
    [vcScrollView setVcArrWithViewControllerString:@"ThemePaiKeViewController" keyString:@"0"];
    
    //添加左右滑动割断
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, viewHeight - 64)];
    [self.view addSubview:leftView];
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(305, 0, 15, viewHeight - 64)];
    [self.view addSubview:rightView];
    
    //创建拍客路径
    if ([[NSFileManager defaultManager] isExecutableFileAtPath:PicPath] == NO)
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:PicPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
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
//获取view所在的viewcontroller
- (UIViewController*) viewControllerWithView:(UIView *) view
{
    for (UIView* next = view; next; next = next.superview)
    {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]])
        {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

- (void) setViewControllerWithIndex:(NSInteger) index
{
    switch (index)
    {
        case 0://公告公示
            [vcScrollView setVcArrWithViewControllerString:@"ThemePaiKeViewController" keyString:[NSString stringWithFormat:@"%d",index]];
            break;
            
        case 1://政府公开
            [vcScrollView setVcArrWithViewControllerString:@"UserPaiKeViewController" keyString:[NSString stringWithFormat:@"%d",index]];
            break;
            
        default:
            break;
    }
}

//向上滚动和向下滚动
- (void) scrollUp
{
    if (navView.frame.origin.y == 0)
    {
        [UIView animateWithDuration:0.2 animations:^{
            
            if (navView.frame.origin.y == 0)
            {
                //上移动导航栏
                CGRect navRect = navView.frame;
                navRect.origin.y = -30;
                navView.frame = navRect;
                
                //变大载体
                CGRect scrollRect = vcScrollView.frame;
                scrollRect.origin.y = scrollRect.origin.y - 45;
                scrollRect.size.height = scrollRect.size.height + 45;
                vcScrollView.frame = scrollRect;
            }

            for (UIView *tmpView in vcScrollView.subviews)
            {
                CGRect rect = tmpView.frame;
                rect.size.height = vcScrollView.frame.size.height;
                tmpView.frame = rect;
                //获取view所在controller
                UIViewController *tmpVC = [self viewControllerWithView:tmpView];
                if ([tmpVC respondsToSelector:@selector(scrollUpDown)])
                {
                    
                    [tmpVC performSelector:@selector(scrollUpDown) withObject:nil];
                }
            }
        }];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:SCROLLUPNOTIFICATION object:[navView.tagArr objectAtIndex:currentIndex]];
    }
}

//下滚动
- (void) scrollDown
{
    if (navView.frame.origin.y == -30)
    {
        CGRect navRect = navView.frame;
        navRect.origin.y = 0;
        
        CGRect scrollRect = vcScrollView.frame;
        scrollRect.size.height = scrollRect.size.height - 45;
        scrollRect.origin.y = scrollRect.origin.y + 45;
        
        [UIView animateWithDuration:0.2 animations:^{
            
            if (navView.frame.origin.y < 0)
            {
                //上移动导航栏
                navView.frame = navRect;
                
                //变大载体
                vcScrollView.frame = scrollRect;
            }
            
        }];
        
        for (UIView *tmpView in vcScrollView.subviews)
        {
            CGRect rect = tmpView.frame;
            rect.size.height = scrollRect.size.height;
            tmpView.frame = rect;
            //获取view所在controller
            UIViewController *tmpVC = [self viewControllerWithView:tmpView];
            if ([tmpVC respondsToSelector:@selector(scrollUpDown)])
            {
                [tmpVC performSelector:@selector(scrollUpDown) withObject:nil];
            }
        }
        
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:SCROLLDOWNNOTIFICATION object:[navView.tagArr objectAtIndex:currentIndex]];
}

#pragma mark -
#pragma mark - custom delegate
//滚动的scrollview
- (void) vcScrollViewSelectVCAtIndex:(NSInteger)index
{
    [self setViewControllerWithIndex:index];
    [navView selectAtIndex:index];
    currentIndex = index;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:CHANGETITLENOTIFICATION object:[navView.tagArr objectAtIndex:currentIndex]];
}

//导航栏目
- (void) titleNavViewSelectAtIndex:(NSInteger)tagIndex
{
    vcScrollView.contentOffset = CGPointMake(320*tagIndex, 0);
    [self setViewControllerWithIndex:tagIndex];
    currentIndex = tagIndex;
    
//    UIViewController *tmpVC = [self viewControllerWithView:[[self.view superview] superview]];
//    if (tagIndex == 0 || tagIndex == 1)
//    {
//        if (tmpVC)
//        {
//            [tmpVC performSelector:@selector(addGesture) withObject:nil];
//        }
//    }
//    else
//    {
//        if (tmpVC)
//        {
//            [tmpVC performSelector:@selector(removeGesture) withObject:nil];
//        }
//    }
}

@end

