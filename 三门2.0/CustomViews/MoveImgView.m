//
//  MoveImgView.m
//  DragButtonDemo
//
//  Created by lcc on 13-12-13.
//
//

#import "MoveImgView.h"
#import "UIImageView+WebCache.h"

#define BGTAG 100000
#define IMGTAG 100001
#define TXTTAG 100002

@implementation MoveImgView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        UIImageView *bgPressView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 70, 70)];
        [bgPressView setImage:[UIImage imageNamed:@"no_press"]];
        bgPressView.tag = BGTAG;
        [self addSubview:bgPressView];
        bgPressView.hidden = YES;
        
        self.userInteractionEnabled=YES;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imgTapped:)];
        [self addGestureRecognizer:tapGesture];
        
        UIImageView *titleImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 50, 50)];
        titleImage.tag = IMGTAG;
        [self addSubview:titleImage];
        
        //栏目名称
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, 70, 30)];
        nameLabel.textColor = [UIColor whiteColor];
        nameLabel.tag = TXTTAG;
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.font = [UIFont systemFontOfSize:14];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:nameLabel];
    }
    return self;
}

#pragma mark -
#pragma mark - 自定义方法
//按钮晃动
- (void)wobble:(BOOL)wobble
{
    if (wobble)
    {
        self.transform = CGAffineTransformMakeRotation(-0.03);
        
        [UIView animateWithDuration:0.1
                              delay:0.0
                            options:UIViewAnimationOptionRepeat|UIViewAnimationOptionAutoreverse|UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionCurveLinear
                         animations:^{
                             self.transform = CGAffineTransformMakeRotation(0.03);
                         } completion:nil];
        self.isWobble = YES;

    }
    else
    {
        [UIView animateWithDuration:0.1
                              delay:0.0
                            options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             self.transform = CGAffineTransformIdentity;
                         } completion:nil];
        self.isWobble = NO;
    }
}

//切换图片
- (void) pressView:(BOOL) isPress
{
    UIImageView *tmpView = (UIImageView *)[self viewWithTag:BGTAG];
    if (isPress)
    {
        tmpView.hidden = NO;
    }
    else
    {
        tmpView.hidden = YES;
    }
}

- (void) setContentWithString:(NSString *) titleString
{
    UILabel *titleLabel = (UILabel *)[self viewWithTag:TXTTAG];
    UIImageView *titleImage = (UIImageView *)[self viewWithTag:IMGTAG];
    
    [titleImage setImageWithURL:[NSURL URLWithString:self.p_imgUrl] placeholderImage:[UIImage imageNamed:@"left_placeholder"]];
    titleLabel.text = titleString;
    
    self.p_title = titleString;
}

#pragma mark -
#pragma mark - 单击 事件
- (void) imgTapped:(UITapGestureRecognizer *) gesture
{
    if (!self.isWobble)
    {
        if (self.m_delegate && [self.m_delegate respondsToSelector:@selector(moveImgViewTapped:)])
        {
            [self.m_delegate moveImgViewTapped:self];
        }
    }
}


@end
