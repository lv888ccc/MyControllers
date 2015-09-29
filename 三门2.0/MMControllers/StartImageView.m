//
//  StartImageView.m
//  WoZaiXianChang
//
//  Created by lcc on 13-9-16.
//  Copyright (c) 2013年 lcc. All rights reserved.
//

#import "StartImageView.h"
#import "UIImageView+WebCache.h"
#import "SDWebImageManager.h"
#import "CCClientRequest.h"
#import "StartImgObjec.h"

UIKIT_EXTERN void UIImageWriteToSavedPhotosAlbum(UIImage *image, id completionTarget, SEL completionSelector, void *contextInfo);

#define IMGTAG 10
#define BTNTAG 11
#define TIPTAG 12

@interface StartImageView()

@property (strong, nonatomic) CCClientRequest *myRequest;

@end

@implementation StartImageView

- (void)dealloc
{
    self.myRequest.c_delegate = nil;
    self.myRequest = nil;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self beginRequest];
        
        //获取状态栏设置透明
        UIView *tmpView = (UIView *)[[UIApplication sharedApplication] valueForKey:@"statusBar"];
        tmpView.alpha = 0.0f;
        //end
        
        //添加提示语
        UIView *tipView = [[UIView alloc] initWithFrame:CGRectMake(320, 160, 120, 70)];
        tipView.backgroundColor = [UIColor blackColor];
        tipView.alpha = 0.8f;
        tipView.tag = TIPTAG;
        [self addSubview:tipView];
        
        UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 38, 120, 29)];
        tipLabel.textColor = [UIColor whiteColor];
        tipLabel.backgroundColor = [UIColor clearColor];
        [tipLabel setFont:[UIFont systemFontOfSize:15.0f]];
        tipLabel.textAlignment = NSTextAlignmentCenter;
        tipLabel.text = @"保存成功";
        [tipView addSubview:tipLabel];
        
        UIImageView *tipImgView = [[UIImageView alloc] initWithFrame:CGRectMake(47, 10, 27, 27)];
        tipImgView.image = [UIImage imageNamed:@"face_done"];
        [tipView addSubview:tipImgView];
        //end
        
        //取出本地的启动图片 判断图片是否已经被下载
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        NSString *imgString = [userDefault objectForKey:IMGURL];
        UIImage *tmpImage = [[SDWebImageManager sharedManager] imageWithURL:[NSURL URLWithString:imgString]];
        
        if (tmpImage == nil)
        {
            [self setDispearNoImage];
        }
        else
        {
            [self performSelector:@selector(setDispear) withObject:nil afterDelay:3.5];
        }
        //end
        
        //显示启动图片和下载按钮
        UIImageView *startImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, frame.size.height)];
        [startImageView setImageWithURL:[NSURL URLWithString:imgString]];
        [startImageView setBackgroundColor:[UIColor clearColor]];
        startImageView.tag = IMGTAG;
        [self addSubview:startImageView];
        
        //下载按钮
        UIButton *downloadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        downloadBtn.frame = CGRectMake(20, viewHeight - 64, 44, 44);
        downloadBtn.tag = BTNTAG;
        [downloadBtn setImage:[UIImage imageNamed:@"start_download"] forState:UIControlStateNormal];
        [downloadBtn addTarget:self action:@selector(downImgTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:downloadBtn];
        //end
    }
    return self;
}

#pragma mark -
#pragma mark - custom method
//图片显示3.5秒后消失
- (void) setDispear
{
    UIView *tmpView = (UIView *)[[UIApplication sharedApplication] valueForKey:@"statusBar"];
    [UIView animateWithDuration:0.8 animations:^{
        self.alpha = 0;
        tmpView.alpha = 1.0f;
    } completion:^(BOOL finish){
        [self removeFromSuperview];
    }];
}

//如果图片没有下载，不显示
- (void) setDispearNoImage
{
    self.alpha = 0;
    [self removeFromSuperview];
    UIView *tmpView = (UIView *)[[UIApplication sharedApplication] valueForKey:@"statusBar"];
    tmpView.alpha = 1.0f;
}

- (void) beginRequest
{
    self.myRequest = [[CCClientRequest alloc] init];
    self.myRequest.c_delegate = self;
    [self.myRequest startImg];
}

- (void) tipDispear
{
    UIView *tipView = [self viewWithTag:TIPTAG];
    [UIView animateWithDuration:0.3
                     animations:^{
                         tipView.frame = (CGRect){320,160,tipView.frame.size};
                     }];
}

#pragma mark -
#pragma mark - 控件事件
- (void) downImgTapped:(UIButton *)sender
{
    UIImageView *tmpImgView = (UIImageView *)[self viewWithTag:IMGTAG];
    UIImageWriteToSavedPhotosAlbum(tmpImgView.image,nil, nil, nil);
    
    UIView *tipView = [self viewWithTag:TIPTAG];
    [self bringSubviewToFront:tipView];
    [UIView animateWithDuration:0.3
                     animations:^{
                         tipView.frame = (CGRect){200,160,tipView.frame.size};
                     } completion:^(BOOL finished) {
                         [self performSelector:@selector(tipDispear) withObject:nil afterDelay:1.0f];
                     }];
}

#pragma mark -
#pragma mark - 网络数据放回
- (void) startImgCallBack:(id) objectData
{
    NSMutableArray *tmpArr = objectData;
    
    if ([tmpArr count] > 0)
    {
        StartImgObjec *tmpObj = [tmpArr objectAtIndex:0];
        UIImageView *tmpImgView = [[UIImageView alloc] init];
        [tmpImgView setImageWithURL:[NSURL URLWithString:tmpObj.s_imgUrl]];
        
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setValue:tmpObj.s_imgUrl forKey:IMGURL];
    }
}

@end
