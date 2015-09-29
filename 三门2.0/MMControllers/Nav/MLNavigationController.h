//
//  MLNavigationController.h
//  MultiLayerNavigation
//
//  Created by Feather Chan on 13-4-12.
//  Copyright (c) 2013年 Feather Chan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MLNavigationControllerDelegate <NSObject>

- (UIViewController *) pushCommentViewController;

@end

@interface MLNavigationController : UINavigationController

@property (weak) id<MLNavigationControllerDelegate> m_delegate;

//外部控制滑动
@property (nonatomic) BOOL isSlider;

- (void) addRecognizer;
- (void) removeRecognizer;

- (void) pushViewController:(UIViewController *)viewController;
- (void) popViewController;
- (void) popViewControllerToRoot;
- (void) popToViewController:(NSString *) viewControlString;
- (void) popToDownViewController:(NSString *) viewControlString;

@end
