//
//  VCScrollView.h
//  SanMen
//
//  Created by lcc on 13-12-17.
//  Copyright (c) 2013年 lcc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VCScrollViewDelegate <NSObject>

@optional

- (void) vcScrollViewSelectVCAtIndex:(NSInteger) index;

@end

@interface VCScrollView : UIScrollView

@property (nonatomic) NSInteger maxWidth;
@property (weak) id<VCScrollViewDelegate> v_delegate;

- (void) setVcArrWithViewControllerString:(NSString *) viewControllerString keyString:(NSString *)key;

@end
