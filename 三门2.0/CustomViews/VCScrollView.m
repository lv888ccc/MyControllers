//
//  VCScrollView.m
//  SanMen
//
//  Created by lcc on 13-12-17.
//  Copyright (c) 2013年 lcc. All rights reserved.
//

#import "VCScrollView.h"

@interface VCScrollView()<UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableDictionary *vcArr;

@end

@implementation VCScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.vcArr = [[NSMutableDictionary alloc] init];
        self.delegate = self;
        self.bounces = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor colorWithRed:242.0f/255.0f green:242.0f/255.0f blue:242.0f/255.0f alpha:1.0f];
        
        for (int i = 0; i < 4; i ++)
        {
            UIImageView *logoSignView = [[UIImageView alloc] initWithFrame:CGRectMake(320*i, 0, frame.size.width, frame.size.height)];
            logoSignView.image = [UIImage imageNamed:@"blank_default"];
            logoSignView.contentMode = UIViewContentModeCenter;
            [self addSubview:logoSignView];
            logoSignView.backgroundColor = [UIColor clearColor];
        }
        
    }
    return self;
}

#pragma mark -
#pragma mark - custom method
- (void) setVcArrWithViewControllerString:(NSString *) viewControllerString keyString:(NSString *)key
{
    //判断传入的窗体是否已经建立
    if ([self.vcArr.allKeys containsObject:key])
    {
        UIViewController *tmpVC = [self.vcArr objectForKey:key];
        [self bringSubviewToFront:tmpVC.view];
    }
    else
    {
        UIViewController *tmpVC = [[NSClassFromString(viewControllerString) alloc] init];
        [self.vcArr setObject:tmpVC forKey:key];
        tmpVC.view.frame = (CGRect){320*[key intValue],0,320,self.frame.size.height};
        [self addSubview:tmpVC.view];
        if ([tmpVC respondsToSelector:@selector(scrollUpDown)])
        {
            [tmpVC performSelector:@selector(scrollUpDown) withObject:nil];
        }
        

    }
}

//获取view所在的viewcontroller
- (UIViewController*) viewController
{
    for (UIView* next = [[[self superview] superview] superview]; next; next = next.superview)
    {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]])
        {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}


#pragma mark -
#pragma mark - scroll delegate
- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //每页宽度
    CGFloat pageWidth = scrollView.frame.size.width;
    //根据当前的坐标与页宽计算当前页码
    int currentPage = floor((scrollView.contentOffset.x - pageWidth/2)/pageWidth)+1;
    
    if (self.v_delegate && [self.v_delegate respondsToSelector:@selector(vcScrollViewSelectVCAtIndex:)])
    {
        [self.v_delegate vcScrollViewSelectVCAtIndex:currentPage];
    }
    
}

@end

