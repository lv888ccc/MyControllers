//
//  NewsDetailViewController.h
//  SanMen
//
//  Created by lcc on 13-12-22.
//  Copyright (c) 2013年 lcc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsDetailViewController : UIViewController

@property (strong, nonatomic) NSString *newsId;
@property (nonatomic) BOOL noCollection;
@property (nonatomic) BOOL isConvinient;

@end
