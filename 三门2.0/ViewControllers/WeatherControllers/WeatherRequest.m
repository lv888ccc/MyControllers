//
//  WeatherRequest.m
//  SanMen
//
//  Created by lcc on 14-2-22.
//  Copyright (c) 2014年 lcc. All rights reserved.
//

#import "WeatherRequest.h"
#import "JSON.h"
#import "WeatherObject.h"
#import "CCClientRequest.h"

@interface WeatherRequest()

@property (nonatomic, strong) CCClientRequest *myRequest;

@end

@implementation WeatherRequest

- (void)dealloc
{
    self.webData = nil;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        self.myRequest = [[CCClientRequest alloc] init];
        self.myRequest.c_delegate = self;
    }
    return self;
}

#pragma mark -
#pragma mark - custome method
- (void) getWeather
{
//    NSURLConnection *tmpCon = [[NSURLConnection alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:WEATHERURL]] delegate:self];
//    if( tmpCon )
//	{
//        self.webData = [[NSMutableData alloc] initWithLength:0];
//    }
    
    [self.myRequest weatherInfo];
}

#pragma mark -
#pragma mark - request delegate
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[self.webData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    //开始调用xml方面的函数
    
    @try
    {
        NSString *str = [[NSString alloc]
                         initWithBytes:[self.webData mutableBytes]
                         length:[self.webData length]
                         encoding:NSUTF8StringEncoding];
        
        NSDictionary *tmpDic = [str JSONValue];
        
        //天气解析
        tmpDic = [tmpDic objectForKey:@"weatherinfo"];
        NSMutableArray *tmpArr = [[NSMutableArray alloc] init];
        for (int i = 0; i < 6; i ++)
        {
            WeatherObject *tmpObj = [[WeatherObject alloc] init];
            tmpObj.w_weatherInfo = [tmpDic objectForKey:[NSString stringWithFormat:@"img_title%d",i+1]];
            tmpObj.w_temp = [tmpDic objectForKey:[NSString stringWithFormat:@"temp%d",i+1]];
            
            if ([tmpObj.w_weatherInfo rangeOfString:@"晴"].length > 0)
            {
                tmpObj.w_img = @"晴";
            }
            
            if ([tmpObj.w_weatherInfo rangeOfString:@"大雨"].length > 0)
            {
                tmpObj.w_img = @"大雨";
            }
            
            if ([tmpObj.w_weatherInfo rangeOfString:@"雪"].length > 0)
            {
                tmpObj.w_img = @"雪";
            }
            
            if ([tmpObj.w_weatherInfo rangeOfString:@"多云"].length > 0)
            {
                tmpObj.w_img = @"多云";
            }
            
            if ([tmpObj.w_weatherInfo rangeOfString:@"阴"].length > 0)
            {
                tmpObj.w_img = @"阴";
            }
            
            if ([tmpObj.w_weatherInfo rangeOfString:@"小雨"].length > 0)
            {
                tmpObj.w_img = @"小雨";
            }
            
            //取出当前日期
            NSDate *date = [NSDate date];
            
            //获取当前周几
            NSCalendar *calendar = [NSCalendar currentCalendar];
            NSDateComponents *comps =  [calendar components:(NSWeekCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit) fromDate:date];
            NSInteger weekday = [comps weekday]; // 星期几（注意，周日是“1”，周一是“2”。。。。）
            
            switch ((weekday + i)>7?(weekday + i)-7:(weekday + i))
            {
                case 1:
                    tmpObj.w_weekDay = @"星期天";
                    break;
                case 2:
                    tmpObj.w_weekDay = @"星期一";
                    break;
                case 3:
                    tmpObj.w_weekDay = @"星期二";
                    break;
                case 4:
                    tmpObj.w_weekDay = @"星期三";
                    break;
                case 5:
                    tmpObj.w_weekDay = @"星期四";
                    break;
                case 6:
                    tmpObj.w_weekDay = @"星期五";
                    break;
                case 7:
                    tmpObj.w_weekDay = @"星期六";
                    break;
                    
                default:
                    break;
            }
            [tmpArr addObject:tmpObj];
        }
        
        if ([tmpArr count] > 0)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:LOADDONEWEATHERINFO object:[tmpArr objectAtIndex:0]];
        }
        
        SMApp.weatherArr = tmpArr;
    }
    @catch (NSException *exception)
    {
        
    }

}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    //NSLog(@"error:%@",error);
}

#pragma mark - 
#pragma mark - 网络数据返回
- (void) weatherInfoCallBack:(id) objectData
{
    NSMutableArray *tmpArr = objectData;
    if ([tmpArr count] > 0)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:LOADDONEWEATHERINFO object:[tmpArr objectAtIndex:0]];
    }
    
    SMApp.weatherArr = tmpArr;
    
}
@end
