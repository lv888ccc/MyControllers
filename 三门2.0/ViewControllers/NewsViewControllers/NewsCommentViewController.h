//
//  NewsCommentViewController.h
//  SanMen
//
//  Created by lcc on 13-12-22.
//  Copyright (c) 2013年 lcc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsCommentViewController : UIViewController

@property (nonatomic, strong) NSString *newsId;
@property (weak) id newsDelegate;
@property (nonatomic) BOOL isNews;

@end
