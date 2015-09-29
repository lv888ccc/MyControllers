//
//  SuperViewController.m
//  TestNav
//
//  Created by lcc on 13-12-12.
//  Copyright (c) 2013年 lcc. All rights reserved.
//

#import "SuperViewController.h"

@interface SuperViewController ()

@end

@implementation SuperViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - 自定义方法
- (void) setCenterVCWithString:(NSString *) VCString object:(id) object
{
    if ([self.s_delegate respondsToSelector:@selector(setCenterViewControllerWithString:object:)])
    {
        [self.s_delegate performSelector:@selector(setCenterViewControllerWithString:object:) withObject:VCString withObject:object];
    }
}

- (void) loadWithObject:(id) object
{
    NSLog(@"%@",object);
}

@end
