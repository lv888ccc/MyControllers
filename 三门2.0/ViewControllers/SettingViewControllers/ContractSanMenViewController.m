//
//  ContractSanMenViewController.m
//  SanMen
//
//  Created by lcc on 13-12-25.
//  Copyright (c) 2013年 lcc. All rights reserved.
//

#import "ContractSanMenViewController.h"

@interface ContractSanMenViewController ()
{
    UIWebView *webView;
}

@end

@implementation ContractSanMenViewController

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
    
    webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:webView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - 控件事件
- (IBAction)backTapped:(id)sender
{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app.nav popViewController];
}

- (IBAction)callTapped:(id)sender
{
    
    NSURL *phoneURL = nil;
    
    switch (((UIButton *)sender).tag)
    {
        case 10:
            phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",PhoneNUM1]];
            break;
            
        case 11:
            phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",PhoneNUM2]];
            break;
            
        case 12:
            phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",PhoneNUM3]];
            break;
            
        default:
            break;
    }
    
    [webView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
    
}

@end
