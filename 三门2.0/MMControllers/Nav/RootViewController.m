//
//  RootViewController.m
//  TestNav
//
//  Created by lcc on 13-11-6.
//  Copyright (c) 2013年 lcc. All rights reserved.
//

#import "RootViewController.h"
#import "AppDelegate.h"

@interface RootViewController ()
{
    NSInteger originY;
}

@property (strong, nonatomic) IBOutlet UIView *ui_rootView;

@end

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.ui_rootView addSubview:self.rootController.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) setViewFrame:(NSNumber *) floatNum
{
    CGRect rect = self.ui_rootView.frame;
    rect.origin.x = [floatNum floatValue];
    self.ui_rootView.frame = rect;
}

@end
