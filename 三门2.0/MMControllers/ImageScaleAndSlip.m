//
//  ImageScaleAndSlip.m
//  D5Media
//
//  Created by mmc on 12-6-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ImageScaleAndSlip.h"

@implementation ImageScaleAndSlip

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        self.delegate = self;
		self.minimumZoomScale = 0.5;
		self.maximumZoomScale = 2.5;
		self.showsVerticalScrollIndicator = NO;
		self.showsHorizontalScrollIndicator = NO;
		
		self.imageView  = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
		self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        
		[self addSubview:self.imageView];
    }
    return self;
}

- (void)setImagePath:(NSString *)imageStr
{
	[self.imageView setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:@"img_defalut_loading"]];
}

#pragma mark -
#pragma mark === UIScrollView Delegate ===
#pragma mark -
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{	
	return self.imageView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale
{
	CGFloat zs = scrollView.zoomScale;
	zs = MAX(zs, 1.0);
	zs = MIN(zs, 2.0);	
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];		
	scrollView.zoomScale = zs;	
	[UIView commitAnimations];
}

#pragma mark -
#pragma mark === UITouch Delegate ===
#pragma mark -
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
//    UIScrollView *tmpSuper = (UIScrollView *)[self superview];
//    
//    if (tmpSuper.isDragging)
//    {
//        return;
//    }
    
    UITouch *touch = [touches anyObject];
    
    switch (touch.tapCount) {
        case 1:
            [self performSelector:@selector(singleTap) withObject:nil afterDelay:0.5];
            break;
        case 2:
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(singleTap) object:nil];
            [self performSelector:@selector(doubleTap) withObject:nil afterDelay:0];
        default:
            break;
    }
}

-(void)singleTap 
{

    if (self.scale_slip_delegate != nil && [self.scale_slip_delegate respondsToSelector:@selector(imageScaleAndSliDelegateTapOne)])
    {
        [self.scale_slip_delegate imageScaleAndSliDelegateTapOne];
    }
}
-(void)doubleTap
{

    CGFloat zs = self.zoomScale;
    zs = (zs == 1.0) ? 2.0 : 1.0;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];			
    self.zoomScale = zs;	
    [UIView commitAnimations];
}

@end
