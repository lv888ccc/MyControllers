//
//  WeatherViewController.m
//  SanMen
//
//  Created by lcc on 13-12-21.
//  Copyright (c) 2013年 lcc. All rights reserved.
//

#import "WeatherViewController.h"
#import "WeatherObject.h"


@interface WeatherViewController ()

@property (strong, nonatomic) IBOutlet UIView *ui_headerView;
@property (strong, nonatomic) IBOutlet UIImageView *ui_bgImgView;
@property (strong, nonatomic) IBOutlet UIImageView *ui_weatherImgView;
@property (strong, nonatomic) IBOutlet UILabel *ui_weatherLabel;
@property (strong, nonatomic) IBOutlet UILabel *ui_tempLabel;
@property (strong, nonatomic) IBOutlet UIScrollView *ui_scrollView;
@property (strong, nonatomic) IBOutlet UIScrollView *ui_bgScrollView;


@end

@implementation WeatherViewController

- (void)dealloc
{
    self.ui_headerView = nil;
    self.ui_bgImgView = nil;
    self.ui_weatherImgView = nil;
    self.ui_weatherLabel = nil;
    self.ui_tempLabel = nil;
    self.ui_scrollView = nil;
    self.ui_bgScrollView = nil;
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
    
    if ([SMApp.weatherArr count] > 0)
    {
        WeatherObject *tmpObj = [SMApp.weatherArr objectAtIndex:0];
        
        if ([tmpObj.w_weatherInfo rangeOfString:@"晴"].length > 0)
        {
            self.ui_bgImgView.image = [UIImage imageNamed:@"sunny.jpg"];
        }
        
        if ([tmpObj.w_weatherInfo rangeOfString:@"雨"].length > 0)
        {
            self.ui_bgImgView.image = [UIImage imageNamed:@"rain.jpg"];
        }
        
        if ([tmpObj.w_weatherInfo rangeOfString:@"云"].length > 0 || [tmpObj.w_weatherInfo rangeOfString:@"阴"].length > 0)
        {
            self.ui_bgImgView.image = [UIImage imageNamed:@"cloud.jpg"];
        }
        
        if ([tmpObj.w_weatherInfo rangeOfString:@"雪"].length > 0)
        {
            self.ui_bgImgView.image = [UIImage imageNamed:@"snow.jpg"];
        }
        
        self.ui_tempLabel.text = [[tmpObj.w_temp componentsSeparatedByString:@"~"] objectAtIndex:0];
        self.ui_weatherImgView.image = [UIImage imageNamed:tmpObj.w_img];
        self.ui_weatherLabel.text = tmpObj.w_weatherInfo;
        
        [self addWeather];
    }
    
    self.ui_headerView.frame = (CGRect){0,-155,self.ui_headerView.frame.size};
    [self.ui_scrollView addSubview:self.ui_headerView];
    self.ui_scrollView.clipsToBounds = NO;
    
    self.ui_headerView.backgroundColor = [UIColor clearColor];
    
    self.ui_bgScrollView.contentSize = CGSizeMake(self.ui_bgScrollView.contentSize.width, 568 + 5);
    
    if (viewHeight > 480)
    {
        self.ui_scrollView.frame = (CGRect){12,388,self.ui_scrollView.frame.size};
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - custom method
- (void) addWeather
{
    for (int i = 0; i < [SMApp.weatherArr count]; i ++)
    {
        WeatherObject *tmpObj = [SMApp.weatherArr objectAtIndex:i];
        UIView *tmpView = [[UIView alloc] initWithFrame:CGRectMake(99*i, 0, 99, 166)];
        tmpView.backgroundColor = [UIColor clearColor];
        
        //星期
        UILabel *weekLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 99, 45)];
        weekLabel.font = [UIFont systemFontOfSize:16];
        weekLabel.textAlignment = NSTextAlignmentCenter;
        weekLabel.textColor = [UIColor whiteColor];
        weekLabel.alpha = 0.7;
        weekLabel.backgroundColor = [UIColor clearColor];
        [tmpView addSubview:weekLabel];
        weekLabel.text = tmpObj.w_weekDay;
        
        //天气状况图标
        UIImageView *weathSignView = [[UIImageView alloc] initWithFrame:CGRectMake(32, 45, 35, 35)];
        weathSignView.image = [UIImage imageNamed:tmpObj.w_img];
        [tmpView addSubview:weathSignView];
        
        //天气温度
        UILabel *weatherLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 90, 99, 20)];
        weatherLabel.font = [UIFont systemFontOfSize:15];
        weatherLabel.textColor = [UIColor whiteColor];
        weatherLabel.alpha = 0.7;
        weatherLabel.textAlignment = NSTextAlignmentCenter;
        weatherLabel.backgroundColor = [UIColor clearColor];
        [tmpView addSubview:weatherLabel];
        weatherLabel.text = tmpObj.w_temp;
        
        //天气状况
        UILabel *weatherInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 120, 99, 48)];
        weatherInfoLabel.font = [UIFont systemFontOfSize:16];
        weatherInfoLabel.textColor = [UIColor whiteColor];
        weatherInfoLabel.alpha = 0.7;
        weatherInfoLabel.textAlignment = NSTextAlignmentCenter;
        weatherInfoLabel.backgroundColor = [UIColor clearColor];
        [tmpView addSubview:weatherInfoLabel];
        weatherInfoLabel.text = tmpObj.w_weatherInfo;
        
        [self.ui_scrollView addSubview:tmpView];
    }
}

#pragma mark -
#pragma mark - 控件事件
- (IBAction)finishTapped:(id)sender
{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app.nav popViewControllerToRoot];
}

@end
