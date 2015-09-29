//
//  NewDetailImageViewController.m
//  SanMen
//
//  Created by lcc on 14-1-15.
//  Copyright (c) 2014年 lcc. All rights reserved.
//

#import "NewDetailImageViewController.h"
#import "ImageScaleAndSlip.h"

@interface NewDetailImageViewController ()<ImageScaleAndSliDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *ui_imgScrollView;


@end

@implementation NewDetailImageViewController

- (void)dealloc
{
    self.ui_imgScrollView = nil;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    ImageScaleAndSlip *tmpImgView = [[ImageScaleAndSlip alloc] initWithFrame:CGRectMake(0, 0, 320,viewHeight)];
    tmpImgView.imagePath = self.imgUrl;
    tmpImgView.scale_slip_delegate = self;
    [self.view addSubview:tmpImgView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - img delegate
- (void) imageScaleAndSliDelegateTapOne
{
    [SMApp.nav dismissModalViewControllerAnimated:NO];
}

@end
