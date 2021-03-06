//
//  StatusTipView.m
//  SanMen
//
//  Created by lcc on 14-1-16.
//  Copyright (c) 2014年 lcc. All rights reserved.
//

#import "StatusTipView.h"

#define TIPLABELTAG 10
#define STATUSIMGTAG 11
#define FACEIMGTAG 12

@implementation StatusTipView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0.7;
        
        //提示语
        UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 38, 120, 29)];
        tipLabel.textColor = [UIColor whiteColor];
        tipLabel.backgroundColor = [UIColor clearColor];
        [tipLabel setFont:[UIFont systemFontOfSize:15.0f]];
        tipLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:tipLabel];
        tipLabel.tag = TIPLABELTAG;
        
        //转圈
        UIImageView *statusImgView = [[UIImageView alloc] initWithFrame:CGRectMake(47, 10, 27, 27)];
        [self addSubview:statusImgView];
        statusImgView.tag = STATUSIMGTAG;
        
        //换图片
        UIImageView *faceImgView = [[UIImageView alloc] initWithFrame:CGRectMake(47, 10, 27, 27)];
        [self addSubview:faceImgView];
        faceImgView.tag = FACEIMGTAG;
    }
    return self;
}

#pragma mark -
#pragma mark - custom method
/*
 功能：提示语言
 by: cc
 data:2014-1-16
 */
- (void) changeLoadingStatusWithSign:(TipStringType) sign tipString:(NSString *) tipString
{
    UILabel *tipLabel = (UILabel *)[self viewWithTag:TIPLABELTAG];
    UIImageView *statusImgView = (UIImageView *)[self viewWithTag:STATUSIMGTAG];
    UIImageView *faceImgView = (UIImageView *)[self viewWithTag:FACEIMGTAG];
    
    switch (sign)
    {
        case SigleNetFailTip://网络加载失败
            statusImgView.hidden = YES;
            faceImgView.hidden = NO;
            [faceImgView setImage:[UIImage imageNamed:@"net_fail"]];
            break;
            
        case InfoCommittingTip://信息提交中
            statusImgView.hidden = NO;
            faceImgView.hidden = YES;
            [statusImgView setImage:[UIImage imageNamed:@"face_sending"]];
            [self addAnimationWithImgView:statusImgView];
            break;

            
        case SuccessTip:
            statusImgView.hidden = YES;
            faceImgView.hidden = NO;
            faceImgView.image = [UIImage imageNamed:@"face_done"];
            break;
            
        case SuccessTipTypeTwo:
            statusImgView.hidden = YES;
            faceImgView.hidden = NO;
            faceImgView.image = [UIImage imageNamed:@"face_success"];
            break;
            
        case CommittingFailTip:
            statusImgView.hidden = YES;
            faceImgView.hidden = NO;
            faceImgView.image = [UIImage imageNamed:@"net_fail"];
            break;
            
        case DataIsNullTip:
            statusImgView.hidden = YES;
            faceImgView.hidden = NO;
            faceImgView.image = [UIImage imageNamed:@"face_no_imgs"];
            break;
            
        case SuccessCollect:
            statusImgView.hidden = YES;
            faceImgView.hidden = NO;
            faceImgView.image = [UIImage imageNamed:@"face_success_collect"];
            break;
            
        case CancelCollect:
            statusImgView.hidden = YES;
            faceImgView.hidden = NO;
            faceImgView.image = [UIImage imageNamed:@"face_cancel_collect"];
            break;
            
        default:
            break;
    }
    
    tipLabel.text = tipString;
}

//添加动画
- (void) addAnimationWithImgView:(UIImageView *) imgView
{
    //动画旋转
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI];
    rotationAnimation.duration = 0.5;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = HUGE_VALF;
    [imgView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    //end
}

//删除动画
- (void) removeAnimationWithImgView:(UIImageView *)imgView
{
    [imgView.layer removeAnimationForKey:@"rotationAnimation"];
}

//显示动画
- (void) tipShowWithType:(TipStringType) type tipString:(NSString *) tipString isHidden:(BOOL) isHidden
{
    [self changeLoadingStatusWithSign:type tipString:tipString];
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect = self.frame;
        rect.origin.x = 200;
        self.frame = rect;
    } completion:^(BOOL finished) {
        if (isHidden)
        {
            [self performSelector:@selector(tipHide) withObject:nil afterDelay:1.0];
        }
    }];
}

//隐藏动画
- (void) tipHide
{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect rect = self.frame;
        rect.origin.x = 320;
        self.frame = rect;
    } completion:^(BOOL finished) {
        UIImageView *statusImgView = (UIImageView *)[self viewWithTag:STATUSIMGTAG];
        [self removeAnimationWithImgView:statusImgView];
    }];
    
}

@end
