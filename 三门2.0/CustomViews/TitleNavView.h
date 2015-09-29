//
//  TitleNavView.h
//  VCScroller
//
//  Created by lcc on 13-12-17.
//  Copyright (c) 2013年 lcc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TitleNavViewDelegate <NSObject>

- (void) titleNavViewSelectAtIndex:(NSInteger) tagIndex;

@end

@interface TitleNavView : UIView
{
    UIButton *currentBtn;
}

@property (nonatomic, strong) NSMutableArray *tagArr;
@property (weak) id<TitleNavViewDelegate> t_delegate;

- (void) setContent;
- (void) selectAtIndex:(NSInteger) tagIndex;

@end
