//
//  ViewController.m
//  NumLabel
//
//  Created by chenchen.lcc on 15/9/28.
//  Copyright (c) 2015年 chenchen.lcc. All rights reserved.
//

#import "ViewController.h"
#import "NumberLabel.h"

@interface ViewController ()

@property (nonatomic, strong) NumberLabel *numLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.numLabel = [[NumberLabel alloc] initWithFrame:(CGRect){0,100,[UIScreen mainScreen].bounds.size.width,48} hideFraction:YES];
    
    self.numLabel.textAlignment = NSTextAlignmentCenter;
    self.numLabel.font = [UIFont systemFontOfSize:40];
    [self.view addSubview:self.numLabel];
    
    [self performSelector:@selector(fire) withObject:nil afterDelay:1.0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) fire
{
    [self.numLabel animateFrom:990 to:1000];
}

@end
