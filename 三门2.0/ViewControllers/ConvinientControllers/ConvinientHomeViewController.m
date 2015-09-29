//
//  ConvinientHomeViewController.m
//  SanMen
//
//  Created by lcc on 14-2-13.
//  Copyright (c) 2014年 lcc. All rights reserved.
//

#import "ConvinientHomeViewController.h"
#import "BikeViewController.h"
#import "PhoneViewController.h"
#import "ConvinientWebViewController.h"

@interface ConvinientHomeViewController ()

@property (strong, nonatomic) IBOutlet UIScrollView *ui_scrollView;

@end

@implementation ConvinientHomeViewController

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
    
    CGSize size = self.ui_scrollView.contentSize;
    size.height = 568 + 5;
    self.ui_scrollView.contentSize = size;
    
    self.ui_scrollView.showsVerticalScrollIndicator = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - 控件事件
- (IBAction)convinientTapped:(id)sender
{
    UIButton *tmpBtn = (UIButton *)sender;
    
    switch (tmpBtn.tag)
    {
            
        case 10://客运
        {
            ConvinientWebViewController *web = [[ConvinientWebViewController alloc] init];
            web.titleString = @"客运查询";
            web.webUrl = BusUrl;
            [SMApp.nav pushViewController:web];
        }
            break;
            
        case 11://火车
        {
            ConvinientWebViewController *web = [[ConvinientWebViewController alloc] init];
            web.titleString = @"火车查询";
            web.webUrl = TrainUrl;
            [SMApp.nav pushViewController:web];
        }
            break;
            
        case 12://违章查询
        {
            ConvinientWebViewController *web = [[ConvinientWebViewController alloc] init];
            web.titleString = @"违章查询";
            web.webUrl = CarUrl;
            [SMApp.nav pushViewController:web];
        }
            break;
            
        case 13://自行车
        {
            BikeViewController *bike = [[BikeViewController alloc] init];
            [SMApp.nav pushViewController:bike];
        }
            break;
            
        case 14://热线电话
        {
            PhoneViewController *phone = [[PhoneViewController alloc] init];
            [SMApp.nav pushViewController:phone];
        }
            break;
            
        default:
            
            break;
    }
}


@end
