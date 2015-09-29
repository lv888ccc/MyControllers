
//
//  ParseToObjectToDatabase.m
//  NetAccessShengji
//
//  Created by lcc on 13-11-1.
//  Copyright (c) 2013年 lcc. All rights reserved.
//

#import "CCParseToObjectToDatabase.h"
#import "JSON.h"
#import "ProgramObject.h"
#import "PublishObject.h"
#import "NewsObject.h"
#import "FoodObject.h"
#import "LocalNewsObject.h"
#import "FMDBManage.h"
#import "ZhengWuObject.h"
#import "ActivityObject.h"
#import "OrderObject.h"
#import "NewsDetailObject.h"
#import "StartImgObjec.h"
#import "AdObject.h"
#import "CommentObject.h"
#import "UserObject.h"
#import "PaiKeObject.h"
#import "HomeObject.h"
#import "FtpObject.h"
#import "GTMBase64.h"
#import "GetPrivatePropertyObject.h"
#import "ThemeObject.h"
#import "ConVinientObject.h"
#import "MovieObject.h"
#import "CinemaObject.h"
#import "BookObject.h"
#import "WeatherObject.h"

#define STATUS @"STATUS"
#define DATA @"DATA"
#define KEY @"KEY"
#define POSTDATA @"postData"
#define PAGENO @"pageNo"

@implementation CCParseToObjectToDatabase

#pragma mark -
#pragma mark - 入库

//左边栏目
+ (void) insertDBWithArray:(NSMutableArray *) arr
{
    for (ProgramObject *tmpObj in arr)
    {
        [FMDBManage updateTable:tmpObj setString:[NSString stringWithFormat:@"p_title='%@',p_imgUrl='%@'",tmpObj.p_title,tmpObj.p_imgUrl] WithString:[NSString stringWithFormat:@"p_id='%@'",tmpObj.p_id]];
    }
}

//用户信息入库
+ (void) insertUserWithArr:(NSMutableArray *) arr
{
    [FMDBManage deleteFromTable:[UserObject class] WithString:@"1=1"];
    for (UserObject *tmpObj in arr)
    {
        [FMDBManage updateTable:tmpObj setString:@"1=1" WithString:@"1=1"];
    }
}

+ (void) insertHomeObjectWithArr:(NSMutableArray *) arr
{
    for (HomeObject *tmpObj in arr)
    {
        [FMDBManage insertProgramWithObject:tmpObj];
    }
}

+ (void) insertLocalNewsWithArr:(NSDictionary *) arrDic
{
    
    [FMDBManage deleteFromTable:[LocalNewsObject class] WithString:[NSString stringWithFormat:@"l_newsType='%@'",[arrDic.allKeys objectAtIndex:0]]];
    
    for (LocalNewsObject *tmpObj in [arrDic objectForKey:[arrDic.allKeys objectAtIndex:0]])
    {
        [FMDBManage insertProgramWithObject:tmpObj];
    }
}

+ (void) insertNewsObjectWithObject:(NSDictionary *) arrDic
{
    [FMDBManage deleteFromTable:[NewsObject class] WithString:[NSString stringWithFormat:@"n_newsType='%@'",[arrDic.allKeys objectAtIndex:0]]];
    
    for (NewsObject *tmpObj in [arrDic objectForKey:[arrDic.allKeys objectAtIndex:0]])
    {
        [FMDBManage insertProgramWithObject:tmpObj];
    }
}

//电影列表
+ (void) insertMovieHomeListWithArr:(NSMutableArray *) arr
{
    [FMDBManage deleteFromTable:[CinemaObject class] WithString:@"1=1"];
    for (CinemaObject *tmpObj in arr)
    {
        [FMDBManage insertProgramWithObject:tmpObj];
    }
}

//电影详情
+ (void) insertMovieHomeListDetailWithArr:(NSMutableArray *) arr
{
    if ([arr count] > 0)
    {
        MovieObject *tmpObj = [arr objectAtIndex:0];
        [FMDBManage deleteFromTable:[MovieObject class] WithString:[NSString stringWithFormat:@"m_c_id='%@'",tmpObj.m_c_id]];
    }
    
    for (MovieObject *tmpObj in arr)
    {
        [FMDBManage insertProgramWithObject:tmpObj];
    }
}

//专题
+ (void) insertThemeHomeListWithArr:(NSMutableArray *) arr
{
    [FMDBManage deleteFromTable:[ThemeObject class] WithString:@"1=1"];
    for (ThemeObject *tmpObj in arr)
    {
        [FMDBManage insertProgramWithObject:tmpObj];
    }
}

//活动
+ (void) insertActivityHomeListWithArr:(NSMutableArray *) arr
{
    [FMDBManage deleteFromTable:[ActivityObject class] WithString:@"1=1"];
    for (ActivityObject *tmpObj in arr)
    {
        [FMDBManage insertProgramWithObject:tmpObj];
    }
}

//便民
+ (void) insertConvinientWithArr:(NSDictionary *) infoDic
{
    [FMDBManage deleteFromTable:[ConVinientObject class] WithString:[NSString stringWithFormat:@"c_type='%@'",[infoDic.allKeys objectAtIndex:0]]];
    for (ConVinientObject *tmpObj in [infoDic.allValues objectAtIndex:0])
    {
        [FMDBManage insertProgramWithObject:tmpObj];
    }
}

/*
 功能:数据解析
 date:2013-5-22
 params:jsonString待解析的json
 request:反问的返回
 */
+ (id) paraseDataFromJson:(NSString *) jsonString methodName:(NSString *)methodString saveDic:(NSDictionary *) saveDic request:(ASIHTTPRequest *) request
{
    NSDictionary *infoDic = (NSDictionary *)[jsonString JSONValue];
    NSMutableArray *infoArr = [[NSMutableArray alloc] init];
    
    if ([infoDic.allKeys containsObject:STATUS])
    {
        //数据解析
        if ([[infoDic allKeys] containsObject:DATA])
        {
            //取数据
            id tmpArr = [infoDic objectForKey:DATA];
            NSLog(@"%@-%@",methodString,tmpArr);
            
            @try
            {
                //具体接口判断
                switch ([[infoDic objectForKey:STATUS] intValue])
                {
                    case CurrVer:
                    case NewVer:
                    {
                        if ([methodString isEqualToString:CHECKUPDATEMGMETHOD])
                        {
                            for (int i = 0; i < [tmpArr count]; i++)
                            {
                                NSDictionary *tmpDic = [tmpArr objectAtIndex:i];
                                [infoArr addObject:tmpDic];
                            }
                        }

                    }
                        break;
                    case Success: //返回成功
                    {
                        //首页
                        if ([methodString isEqualToString:HOMENEWSTYPMETHOD])
                        {
                            //清空本地首页
                            [FMDBManage deleteFromTable:[HomeObject class] WithString:@"1=1"];
                            
                            for (int i = 0; i < [tmpArr count]; i++)
                            {
                                NSDictionary *tmpDic = [tmpArr objectAtIndex:i];
                                [infoArr addObject:[self getDataArrWithDic:tmpDic]];
                            }
                        }
                        //启动图片
                        else if ([methodString isEqualToString:STARTIMGMETHOD])
                        {
                            for (int i = 0; i < [tmpArr count]; i++)
                            {
                                NSDictionary *tmpDic = [tmpArr objectAtIndex:i];
                                StartImgObjec *tmpObj = [[StartImgObjec alloc] init];
                                
                                tmpObj.s_appId = [tmpDic objectForKey:@"APP_ID"];
                                tmpObj.s_imgUrl = [tmpDic objectForKey:@"HTTPFULLNAME"];
                                
                                [infoArr addObject:tmpObj];
                            }
                        }
                        //左边栏目
                        else if ([methodString isEqualToString:LEFTLANMUMETHOD])
                        {
                            for (int i = 0; i < [tmpArr count]; i++)
                            {
                                NSDictionary *tmpDic = [tmpArr objectAtIndex:i];
                                ProgramObject *tmpObj = [[ProgramObject alloc] init];
                                
                                tmpObj.p_id = [tmpDic objectForKey:@"SHOW_LINKED_ID"];
                                tmpObj.p_title = [tmpDic objectForKey:@"LINKED_TITLE"];
                                tmpObj.p_imgUrl = [tmpDic objectForKey:@"HTTPFULLNAME"];
                                tmpObj.p_modelType = [tmpDic objectForKey:@"SHOW_MODULE_TYPE"];
                                
                                [infoArr addObject:tmpObj];
                            }
                            
                            if ([infoArr count] > 0)
                            {
                                [self performSelector:@selector(insertDBWithArray:) withObject:infoArr afterDelay:3];
                            }
                            
                        }
                        //三门-新闻-广告
                        else if ([methodString isEqualToString:SANMENTOPADMETHOD])
                        {
                            for (int i = 0; i < [tmpArr count]; i++)
                            {
                                NSDictionary *tmpDic = [tmpArr objectAtIndex:i];
                                AdObject *tmpObj = [[AdObject alloc] init];
                                
                                tmpObj.a_id = [tmpDic objectForKey:@"LINKED_DATA_ID"];
                                tmpObj.a_title = [tmpDic objectForKey:@"LINKED_TITLE"];
                                tmpObj.a_imgUrl = [tmpDic objectForKey:@"HTTPFULLNAME"];
                                tmpObj.a_modelType = [tmpDic objectForKey:@"SHOW_MODULE_TYPE"];
                                tmpObj.a_linkerId = [tmpDic objectForKey:@"SHOW_LINKED_ID"];
                                tmpObj.a_webUrl = [tmpDic objectForKey:@"OUT_LINK"];
                                tmpObj.a_isOut = [tmpDic objectForKey:@"IS_OUT_LINK"];
                                
                                [infoArr addObject:tmpObj];
                            }
                        }
                        //三门-新闻
                        else if ([methodString isEqualToString:NEWSSAMENMETHOD])
                        {
                            for (int i = 0; i < [tmpArr count]; i++)
                            {
                                NSDictionary *tmpDic = [tmpArr objectAtIndex:i];
                                NewsObject *tmpObj = [[NewsObject alloc] init];
                                
                                tmpObj.n_id = [tmpDic objectForKey:@"NEWS_ID"];
                                tmpObj.n_title = [tmpDic objectForKey:@"NEWS_TITLE"];
                                tmpObj.n_imgUrl = [tmpDic objectForKey:@"HTTPFULLNAME"];
                                tmpObj.n_subTitle = [tmpDic objectForKey:@"NEWS_MEMO"];
                                tmpObj.n_newsType = methodString;
                                
                                [infoArr addObject:tmpObj];
                            }
                            
                            NSInteger pageIndex = [GetPrivatePropertyObject getValueWithName:POSTDATA object:request containKey:PAGENO];
                            
                            if (pageIndex == 1)
                            {
                                if ([infoArr count] > 0)
                                {
                                    NSDictionary *tmpDic = [NSDictionary dictionaryWithObject:infoArr forKey:methodString];
                                    [self performSelector:@selector(insertNewsObjectWithObject:) withObject:tmpDic afterDelay:3];
                                }
                            }
                        }
                        //三门-天下
                        else if ([methodString isEqualToString:NEWSWORLDMETHOD])
                        {
                            for (int i = 0; i < [tmpArr count]; i++)
                            {
                                NSDictionary *tmpDic = [tmpArr objectAtIndex:i];
                                NewsObject *tmpObj = [[NewsObject alloc] init];
                                
                                tmpObj.n_id = [tmpDic objectForKey:@"id"];
                                tmpObj.n_title = [tmpDic objectForKey:@"title"];
                                tmpObj.n_imgUrl = [tmpDic objectForKey:@"imgUrl"];
                                
                                [infoArr addObject:tmpObj];
                            }
                        }
                        //三门-天下详情
                        else if ([methodString isEqualToString:WORLDDETAILMETHOD])
                        {
                            for (int i = 0; i < [tmpArr count]; i++)
                            {
                                NSDictionary *tmpDic = [tmpArr objectAtIndex:i];
                                NewsDetailObject *tmpObj = [[NewsDetailObject alloc] init];
                                
                                tmpObj.n_imgUrl = [tmpDic objectForKey:@"ImgUrl"];
                                tmpObj.n_commentCount = [tmpDic objectForKey:@"Comment"];
                                tmpObj.n_detailContent = [tmpDic objectForKey:@"NewsContent"];
                                tmpObj.n_datetime = [tmpDic objectForKey:@"ReleaseDate"];
                                tmpObj.n_source = [tmpDic objectForKey:@"NewsSource"];
                                tmpObj.n_subTitle = [tmpDic objectForKey:@"SubTitle"];
                                tmpObj.n_title = [tmpDic objectForKey:@"Title"];
                                tmpObj.n_videoUrl = [tmpDic objectForKey:@"IphoneVodUrl"];
                                
                                [infoArr addObject:tmpObj];
                            }
                        }
                        //三门-视频
                        else if ([methodString isEqualToString:NEWSVIDEDIOMETHOD])
                        {
                            for (int i = 0; i < [tmpArr count]; i++)
                            {
                                NSDictionary *tmpDic = [tmpArr objectAtIndex:i];
                                NewsObject *tmpObj = [[NewsObject alloc] init];
                                
                                tmpObj.n_id = [tmpDic objectForKey:@"PROG_ID"];
                                tmpObj.n_title = [tmpDic objectForKey:@"PROG_TITLE"];
                                tmpObj.n_imgUrl = [tmpDic objectForKey:@"HTTPIMG"];
                                tmpObj.n_videoUrl = [tmpDic objectForKey:@"HTTPVOD"];
                                
                                [infoArr addObject:tmpObj];
                            }
                        }
                        //县情-关于三门-旅游景点-特色小吃
                        else if ([methodString isEqualToString:LOCALNEWSABOUTSANMENMETHOD]||[methodString isEqualToString:LOCALNEWSEATMETHOD]||[methodString isEqualToString:LOCALNEWSINTERESTINGPLACEMETHOD])
                        {
                            for (int i = 0; i < [tmpArr count]; i++)
                            {
                                NSDictionary *tmpDic = [tmpArr objectAtIndex:i];
                                LocalNewsObject *tmpObj = [[LocalNewsObject alloc] init];
                                
                                tmpObj.l_id = [tmpDic objectForKey:@"NEWS_ID"];
                                tmpObj.l_title = [tmpDic objectForKey:@"NEWS_TITLE"];
                                tmpObj.l_imgUrl = [tmpDic objectForKey:@"HTTPFULLNAME"];
                                tmpObj.l_subTitle = [tmpDic objectForKey:@"NEWS_MEMO"];
                                tmpObj.l_newsType = methodString;
                                
                                [infoArr addObject:tmpObj];
                            }
                            
                           NSInteger pageIndex = [GetPrivatePropertyObject getValueWithName:POSTDATA object:request containKey:PAGENO];
                            
                            if (pageIndex == 1)
                            {
                                NSDictionary *tmpDic = [NSDictionary dictionaryWithObject:infoArr forKey:methodString];
                                if ([infoArr count] > 0)
                                {
                                    [self performSelector:@selector(insertLocalNewsWithArr:) withObject:tmpDic afterDelay:3];
                                }
                            }
                            
                        }
                        //县情-视频新闻
                        else if ([methodString isEqualToString:LOCALNEWSVIDEOMETHOD])
                        {
                            for (int i = 0; i < [tmpArr count]; i++)
                            {
                                NSDictionary *tmpDic = [tmpArr objectAtIndex:i];
                                LocalNewsObject *tmpObj = [[LocalNewsObject alloc] init];
                                
                                tmpObj.l_id = [tmpDic objectForKey:@"PROG_ID"];
                                tmpObj.l_title = [tmpDic objectForKey:@"PROG_TITLE"];
                                tmpObj.l_imgUrl = [tmpDic objectForKey:@"HTTPIMG"];
                                tmpObj.l_videoUrl = [tmpDic objectForKey:@"HTTPVOD"];
                                
                                [infoArr addObject:tmpObj];
                            }
                            
                            NSInteger pageIndex = [GetPrivatePropertyObject getValueWithName:POSTDATA object:request containKey:PAGENO];
                            
                            if (pageIndex == 1)
                            {
                                NSDictionary *tmpDic = [NSDictionary dictionaryWithObject:infoArr forKey:methodString];
                                if ([infoArr count] > 0)
                                {
                                    [self performSelector:@selector(insertLocalNewsWithArr:) withObject:tmpDic afterDelay:3];
                                }
                            }
                        }
                        //美食-餐饮-外卖-住宿
                        else if ([methodString isEqualToString:FOODEATMETHOD]||[methodString isEqualToString:FOODPHONEMETHOD]||[methodString isEqualToString:FOODLIVEMETHOD])
                        {
                            for (int i = 0; i < [tmpArr count]; i++)
                            {
                                NSDictionary *tmpDic = [tmpArr objectAtIndex:i];
                                FoodObject *tmpObj = [[FoodObject alloc] init];
                                
                                tmpObj.f_id = [tmpDic objectForKey:@"NEWS_ID"];
                                tmpObj.f_title = [tmpDic objectForKey:@"NEWS_TITLE"];
                                tmpObj.f_imgUrl = [tmpDic objectForKey:@"HTTPFULLNAME"];
                                tmpObj.f_subTitle = [tmpDic objectForKey:@"NEWS_MEMO"];
                                
                                [infoArr addObject:tmpObj];
                            }
                        }
                        //政务-公告公示-政府公开-权力公开
                        else if ([methodString isEqualToString:ZHENGWUGOVERNMENTMETHOD]||[methodString isEqualToString:ZHENGWUPOWEROPENMETHOD]||[methodString isEqualToString:ZHENGWUPUBLICNOTICEMETHOD])
                        {
                            for (int i = 0; i < [tmpArr count]; i++)
                            {
                                NSDictionary *tmpDic = [tmpArr objectAtIndex:i];
                                ZhengWuObject *tmpObj = [[ZhengWuObject alloc] init];
                                
                                tmpObj.z_id = [tmpDic objectForKey:@"NEWS_ID"];
                                tmpObj.z_title = [tmpDic objectForKey:@"NEWS_TITLE"];
                                tmpObj.z_imgUrl = [tmpDic objectForKey:@"HTTPFULLNAME"];
                                tmpObj.z_subTitle = [tmpDic objectForKey:@"NEWS_MEMO"];
                                
                                [infoArr addObject:tmpObj];
                            }
                        }
                        //发布
                        else if ([methodString isEqualToString:PUBLISHMETHOD])
                        {
                            for (int i = 0; i < [tmpArr count]; i++)
                            {
                                NSDictionary *tmpDic = [tmpArr objectAtIndex:i];
                                PublishObject *tmpObj = [[PublishObject alloc] init];
                                
                                tmpObj.p_id = [tmpDic objectForKey:@"NEWS_ID"];
                                tmpObj.p_title = [tmpDic objectForKey:@"NEWS_TITLE"];
                                tmpObj.p_imgUrl = [tmpDic objectForKey:@"HTTPFULLNAME"];
                                tmpObj.p_subTitle = [tmpDic objectForKey:@"NEWS_MEMO"];
                                
                                [infoArr addObject:tmpObj];
                            }
                        }
                        //广播清单
                        else if ([methodString isEqualToString:BROADORDERMETHOD])
                        {
                            NSDictionary *tmpInfoDic = [tmpArr objectAtIndex:0];
                            tmpArr = [tmpInfoDic objectForKey:@"Bill"];
                            for (int i = 0; i < [tmpArr count]; i++)
                            {
                                NSDictionary *tmpDic = [tmpArr objectAtIndex:i];
                                OrderObject *tmpObj = [[OrderObject alloc] init];
                                
                                tmpObj.o_title = [tmpDic objectForKey:@"BILL_TITLE"];
                                tmpObj.o_beginTime = [tmpDic objectForKey:@"BILL_START_TIME"];
                                tmpObj.o_endTime = [tmpDic objectForKey:@"BILL_END_TIME"];
                                tmpObj.o_pTitle = [tmpInfoDic objectForKey:@"LIVE_TITLE"];
                                tmpObj.o_videoUrl = [tmpInfoDic objectForKey:@"LIVE_URL"];
                                
                                [infoArr addObject:tmpObj];
                            }
                        }
                        //活动
                        else if ([methodString isEqualToString:ACTIVITYMETHOD])
                        {
                            for (int i = 0; i < [tmpArr count]; i++)
                            {
                                NSDictionary *tmpDic = [tmpArr objectAtIndex:i];
                                ActivityObject *tmpObj = [[ActivityObject alloc] init];
                                
                                tmpObj.a_id = [tmpDic objectForKey:@"NEWS_ID"];
                                tmpObj.a_title = [tmpDic objectForKey:@"NEWS_TITLE"];
                                tmpObj.a_imgUrl = [tmpDic objectForKey:@"HTTPFULLNAME"];
                                tmpObj.a_subTitle = [tmpDic objectForKey:@"NEWS_SUBTITLE"];
                                
                                [infoArr addObject:tmpObj];
                            }
                            if ([infoArr count] > 0)
                            {
                                [self performSelector:@selector(insertActivityHomeListWithArr:) withObject:infoArr afterDelay:3];
                            }
                        }
                        //新闻详情
                        else if ([methodString isEqualToString:NEWSTYPEDETAILMETHOD])
                        {
                            for (int i = 0; i < [tmpArr count]; i++)
                            {
                                NSDictionary *tmpDic = [tmpArr objectAtIndex:i];
                                NewsDetailObject *tmpObj = [[NewsDetailObject alloc] init];
                                
                                tmpObj.n_imgUrl = [tmpDic objectForKey:@"HTTPFULLNAME"];
                                tmpObj.n_author = [tmpDic objectForKey:@"NEWS_AUTHOR"];
                                tmpObj.n_commentCount = [tmpDic objectForKey:@"NEWS_COMMENT_COUNT"];
                                tmpObj.n_detailContent = [tmpDic objectForKey:@"NEWS_DETAIL"];
                                tmpObj.n_id = [tmpDic objectForKey:@"NEWS_ID"];
                                tmpObj.n_keyWord = [tmpDic objectForKey:@"NEWS_KEYWORD"];
                                tmpObj.n_des = [tmpDic objectForKey:@"NEWS_MEMO"];
                                tmpObj.n_datetime = [tmpDic objectForKey:@"NEWS_PUBLISH_DATE"];
                                tmpObj.n_source = [tmpDic objectForKey:@"NEWS_SOURCE"];
                                tmpObj.n_subTitle = [tmpDic objectForKey:@"NEWS_SUBTITLE"];
                                tmpObj.n_title = [tmpDic objectForKey:@"NEWS_TITLE"];
                                
                                [infoArr addObject:tmpObj];
                            }
                        }
                        //评论列表
                        else if ([methodString isEqualToString:NEWSCOMMENTMETHOD])
                        {
                            for (int i = 0; i < [tmpArr count]; i++)
                            {
                                NSDictionary *tmpDic = [tmpArr objectAtIndex:i];
                                CommentObject *tmpObj = [[CommentObject alloc] init];
                                
                                tmpObj.c_id = [tmpDic objectForKey:@"COMMENT_ID"];
                                tmpObj.c_content = [tmpDic objectForKey:@"COMMENT_CONTENT"];
                                tmpObj.c_datetime = [tmpDic objectForKey:@"CREATE_DATE"];
                                tmpObj.c_newsId = [tmpDic objectForKey:@"NEWS_ID"];
                                tmpObj.c_userId = [tmpDic objectForKey:@"USER_ID"];
                                tmpObj.c_userName = [tmpDic objectForKey:@"USER_NAME"];
                                
                                [infoArr addObject:tmpObj];
                            }
                        }
                        //提交评论
                        //请求发送验证码
                        //校验验证码
                        //修改昵称
                        //拍客评论提交
                        //提交意见
                        //上传成功
                        else if ([methodString isEqualToString:COMMITCOMMENTMETHOD] || [methodString isEqualToString:NOTICESENDMSGMETHOD] || [methodString isEqualToString:COMPARECODEMETHOD] || [methodString isEqualToString:CHANGENICKNAMEMETHOD] || [methodString isEqualToString:PAIKECOMMITCOMMENTMETHOD] || [methodString isEqualToString:GOODADVICEMETHOD] || [methodString isEqualToString:UPLOADPICSMETHOD])
                        {
                            [infoArr addObject:[NSString stringWithFormat:@"%d",Success]];
                            if ([methodString isEqualToString:NOTICESENDMSGMETHOD])
                            {
                                [infoArr addObject:[NSString stringWithFormat:@"%@",tmpArr]];
                            }
                        }
                        
                        //完成注册 - 用户登陆 - 密码修改
                        else if ([methodString isEqualToString:COMMITPSWMETHOD])
                        {
                            [infoArr insertObject:[NSString stringWithFormat:@"%d",Success] atIndex:0];
                        }
                        else if ([methodString isEqualToString:FINISHREGISTMETHOD] | [methodString isEqualToString:USERLOGINMETHOD])
                        {
                            for (int i = 0; i < [tmpArr count]; i++)
                            {
                                NSDictionary *tmpDic = [tmpArr objectAtIndex:i];
                                UserObject *tmpObj = [[UserObject alloc] init];
                                
                                tmpObj.u_id = [tmpDic objectForKey:@"USER_ID"];
                                tmpObj.u_phoneNo = [tmpDic objectForKey:@"USER_ACCOUNT"];
                                tmpObj.u_userName = [tmpDic objectForKey:@"USER_NAME"];
                                tmpObj.u_imgUrl = [tmpDic objectForKey:@"HTTPFULLNAME"];
                                
                                [infoArr addObject:tmpObj];
                            }
                            
                            [self insertUserWithArr:infoArr];
                            
                            [infoArr insertObject:[NSString stringWithFormat:@"%d",Success] atIndex:0];
                        }
                        //拍客主题拍
                        else if ([methodString isEqualToString:PAIKETHEMEMETHOD])
                        {
                            for (int i = 0; i < [tmpArr count]; i++)
                            {
                                NSDictionary *tmpDic = [tmpArr objectAtIndex:i];
                                PaiKeObject *tmpObj = [[PaiKeObject alloc] init];
                                
                                tmpObj.p_id = [tmpDic objectForKey:@"id"];
                                tmpObj.p_title = [tmpDic objectForKey:@"title"];
                                tmpObj.p_imgUrl = [tmpDic objectForKey:@"imgUrl"];
                                
                                [infoArr addObject:tmpObj];
                            }
                        }
                        //拍客随手拍 -- 主题拍二级
                        else if ([methodString isEqualToString:PAIKEUSERMETHOD] || [methodString isEqualToString:PAIKETHEMEDETAILMETHOD])
                        {
                            for (int i = 0; i < [tmpArr count]; i++)
                            {
                                NSDictionary *tmpDic = [tmpArr objectAtIndex:i];
                                PaiKeObject *tmpObj = [[PaiKeObject alloc] init];
                                
                                tmpObj.p_id = [tmpDic objectForKey:@"id"];
                                tmpObj.p_title = [tmpDic objectForKey:@"title"];
                                tmpObj.p_imgUrl = [tmpDic objectForKey:@"imgUrl"];
                                tmpObj.p_height = [tmpDic objectForKey:@"height"];
                                tmpObj.p_width = [tmpDic objectForKey:@"width"];
                                
                                [infoArr addObject:tmpObj];
                            }
                        }
                        //拍客详情头--图片浏览
                        else if ([methodString isEqualToString:PAIKECONTENTDETAILMETHOD]||[methodString isEqualToString:PAIKEIMGDETAILMETHOD])
                        {
                            for (int i = 0; i < [tmpArr count]; i++)
                            {
                                NSDictionary *tmpDic = [tmpArr objectAtIndex:i];
                                PaiKeObject *tmpObj = [[PaiKeObject alloc] init];
                                
                                tmpObj.p_id = [tmpDic objectForKey:@"id"];
                                tmpObj.p_title = [tmpDic objectForKey:@"title"];
                                tmpObj.p_imgUrl = [tmpDic objectForKey:@"imgUrl"];
                                tmpObj.p_height = [tmpDic objectForKey:@"height"];
                                tmpObj.p_width = [tmpDic objectForKey:@"width"];
                                tmpObj.p_subTitle = [NSString stringWithFormat:@"%@",[tmpDic objectForKey:@"content"]];
                                tmpObj.p_name = [NSString stringWithFormat:@"%@",[tmpDic objectForKey:@"nickName"]];
                                tmpObj.p_time = [tmpDic objectForKey:@"datetime"];
                                tmpObj.p_count = [tmpDic objectForKey:@"count"];
                                
                                [infoArr addObject:tmpObj];
                            }
                        }
                        //拍客评论列表
                        else if ([methodString isEqualToString:PAIKECOMMENTLISTMETHOD])
                        {
                            for (int i = 0; i < [tmpArr count]; i++)
                            {
                                NSDictionary *tmpDic = [tmpArr objectAtIndex:i];
                                CommentObject *tmpObj = [[CommentObject alloc] init];
                                
                                tmpObj.c_id = [tmpDic objectForKey:@"id"];
                                tmpObj.c_userName = [tmpDic objectForKey:@"nickName"];
                                tmpObj.c_datetime = [tmpDic objectForKey:@"datetime"];
                                tmpObj.c_content = [tmpDic objectForKey:@"content"];
                                
                                [infoArr addObject:tmpObj];
                            }
                        }
                        //ftp地址和端口号
                        else if ([methodString isEqualToString:FTPINFOMETHOD])
                        {
                            for (int i = 0; i < [tmpArr count]; i++)
                            {
                                NSDictionary *tmpDic = [tmpArr objectAtIndex:i];
                                FtpObject *tmpObj = [[FtpObject alloc] init];
                                
                                tmpObj.f_id = [tmpDic objectForKey:@"id"];
                                tmpObj.f_userName = [self getStringFromBaseString:[tmpDic objectForKey:@"userName"]];
                                tmpObj.f_ip = [self getStringFromBaseString:[tmpDic objectForKey:@"ip"]];
                                tmpObj.f_path = [self getStringFromBaseString:[tmpDic objectForKey:@"path"]];
                                tmpObj.f_psw = [self getStringFromBaseString:[tmpDic objectForKey:@"userPwd"]];
                                tmpObj.f_port = [self getStringFromBaseString:[tmpDic objectForKey:@"port"]];
                                
                                [infoArr addObject:tmpObj];
                            }
                        }
                        //专栏--新闻专题
                        else if ([methodString isEqualToString:THMEMHOMEMETHOD]||[methodString isEqualToString:NEWSTHEMEMETHOD])
                        {
                            for (int i = 0; i < [tmpArr count]; i++)
                            {
                                NSDictionary *tmpDic = [tmpArr objectAtIndex:i];
                                ThemeObject *tmpObj = [[ThemeObject alloc] init];
                                
                                tmpObj.t_id = [tmpDic objectForKey:@"id"];
                                tmpObj.t_title = [tmpDic objectForKey:@"title"];
                                tmpObj.t_imgUrl = [tmpDic objectForKey:@"imgUrl"];
                                
                                [infoArr addObject:tmpObj];
                            }
                            if ([infoArr count] > 0)
                            {
                                [self performSelector:@selector(insertThemeHomeListWithArr:) withObject:infoArr afterDelay:3];
                            }
                        }
                        //专栏列表-新闻装体列表
                        else if ([methodString isEqualToString:THMEMHOMELISTMETHOD]||[methodString isEqualToString:NEWSTHEMELISTMETHOD])
                        {
                            for (int i = 0; i < [tmpArr count]; i++)
                            {
                                NSDictionary *tmpDic = [tmpArr objectAtIndex:i];
                                ThemeObject *tmpObj = [[ThemeObject alloc] init];
                                
                                tmpObj.t_id = [tmpDic objectForKey:@"id"];
                                tmpObj.t_title = [tmpDic objectForKey:@"title"];
                                tmpObj.t_index = [NSString stringWithFormat:@"%d",i];
                                NSArray *tmpPicArr = (NSArray *)[tmpDic objectForKey:@"pics"];
                                
                                NSMutableString *tmpString = [NSMutableString stringWithFormat:@""];
                                for (int m = 0; m < [tmpPicArr count]; m ++)
                                {
                                    NSDictionary *tmpPicDic = [tmpPicArr objectAtIndex:m];
                                    
                                    if (m == [tmpPicArr count] - 1)
                                    {
                                        [tmpString appendString:[tmpPicDic objectForKey:@"imgUrl"]];
                                        break;
                                    }
                                    else
                                    {
                                        [tmpString appendFormat:@"%@^^",[tmpPicDic objectForKey:@"imgUrl"]];
                                    }
                                    
                                }
                                tmpObj.t_imgUrl = tmpString;
                                
                                [infoArr addObject:tmpObj];
                            }
                        }
                        //电话号码
                        else if ([methodString isEqualToString:PHONENOLISTMETHOD])
                        {
                            for (int i = 0; i < [tmpArr count]; i++)
                            {
                                NSDictionary *tmpDic = [tmpArr objectAtIndex:i];
                                ConVinientObject *tmpObj = [[ConVinientObject alloc] init];
                                
                                tmpObj.c_title = [tmpDic objectForKey:@"title"];
                                tmpObj.c_phoneNo = [tmpDic objectForKey:@"mobile"];
                                tmpObj.c_type = methodString;
                                
                                [infoArr addObject:tmpObj];
                            }
                            
                            if ([infoArr count] > 0)
                            {
                                [self performSelector:@selector(insertConvinientWithArr:) withObject:[NSDictionary dictionaryWithObject:infoArr forKey:methodString] afterDelay:3];
                            }
                        }
                        //自行车
                        else if ([methodString isEqualToString:CBIKEADDRESSNEWSMETHOD])
                        {
                            for (int i = 0; i < [tmpArr count]; i++)
                            {
                                NSDictionary *tmpDic = [tmpArr objectAtIndex:i];
                                ConVinientObject *tmpObj = [[ConVinientObject alloc] init];
                                
                                tmpObj.c_id = [tmpDic objectForKey:@"NEWS_ID"];
                                tmpObj.c_title = [tmpDic objectForKey:@"NEWS_TITLE"];
                                tmpObj.c_type = methodString;
                                
                                [infoArr addObject:tmpObj];
                            }
                            
                            if ([infoArr count] > 0)
                            {
                                 [self performSelector:@selector(insertConvinientWithArr:) withObject:[NSDictionary dictionaryWithObject:infoArr forKey:methodString] afterDelay:3];
                            }
                        }
                        //影院列表
                        else if ([methodString isEqualToString:MOVIEHOMELISTMETHOD])
                        {
                            for (int i = 0; i < [tmpArr count]; i++)
                            {
                                NSDictionary *tmpDic = [tmpArr objectAtIndex:i];
                                CinemaObject *tmpObj = [[CinemaObject alloc] init];
                                
                                tmpObj.c_name = [tmpDic objectForKey:@"title"];
                                tmpObj.c_id = [tmpDic objectForKey:@"id"];
                                tmpObj.c_imgUrl = [tmpDic objectForKey:@"imgUrl"];
                                
                                [infoArr addObject:tmpObj];
                            }
                            
                            if ([infoArr count] > 0)
                            {
                                [self performSelector:@selector(insertMovieHomeListWithArr:) withObject:infoArr afterDelay:3];
                            }
                        }
                        //影院中的影片
                        else if ([methodString isEqualToString:MOVIEDETAILLISTINFOMETHOD])
                        {
                            for (int i = 0; i < [tmpArr count]; i++)
                            {
                                
                                NSDictionary *tmpDic = [tmpArr objectAtIndex:i];
                                
                                NSArray *tmpMArr = [tmpDic objectForKey:@"list"];
                                for (NSDictionary *dictionary in tmpMArr)
                                {
                                    MovieObject *tmpObj = [[MovieObject alloc] init];
                                    
                                    //影院信息
                                    tmpObj.m_c_id = [tmpDic objectForKey:@"id"];
                                    tmpObj.m_mobile = [tmpDic objectForKey:@"mobile"];
                                    tmpObj.m_info = [tmpDic objectForKey:@"content"];
                                    tmpObj.m_cinemaName = [tmpDic objectForKey:@"title"];
                                    
                                    //电影信息
                                    tmpObj.m_id = [dictionary objectForKey:@"id"];
                                    tmpObj.m_starCount = [dictionary objectForKey:@"star"];
                                    tmpObj.m_movieName = [dictionary objectForKey:@"title"];
                                    tmpObj.m_imgUrl = [dictionary objectForKey:@"imgUrl"];
                                    
                                    [infoArr addObject:tmpObj];
                                }
                            }
                            
                            if ([infoArr count] > 0)
                            {
                                [self performSelector:@selector(insertMovieHomeListDetailWithArr:) withObject:infoArr afterDelay:3];
                            }
                        }
                        //影片详情
                        else if ([methodString isEqualToString:MOVIEDETAILLISTDETAILINFOMETHOD])
                        {
                            for (int i = 0; i < [tmpArr count]; i++)
                            {
                                NSDictionary *tmpDic = [tmpArr objectAtIndex:i];
                                MovieObject *tmpObj = [[MovieObject alloc] init];

                                //电影信息
                                tmpObj.m_id = [tmpDic objectForKey:@"id"];
                                tmpObj.m_starCount = [tmpDic objectForKey:@"star"];
                                tmpObj.m_movieName = [tmpDic objectForKey:@"title"];
                                tmpObj.m_imgUrl = [tmpDic objectForKey:@"imgUrl"];
                                
                                tmpObj.m_director = [tmpDic objectForKey:@"director"];
                                tmpObj.m_actors = [tmpDic objectForKey:@"starring"];
                                tmpObj.m_timeLength = [tmpDic objectForKey:@"timeLen"];
                                tmpObj.m_videoId = [tmpDic objectForKey:@"videoId"];
                                
                                tmpObj.m_orderObject = [tmpDic objectForKey:@"bill"];
                                tmpObj.m_info = [tmpDic objectForKey:@"content"];
                                
                                tmpObj.m_place = [tmpDic objectForKey:@"area"];
                                tmpObj.m_type = [tmpDic objectForKey:@"type"];
                                tmpObj.m_playTime = [tmpDic objectForKey:@"showtime"];
        
                                
                                [infoArr addObject:tmpObj];
                            }
                        }
                        //新华书讯
                        //精彩书评
                        //畅销榜
                        else if ([methodString isEqualToString:XINHUABOOKNEWSMETHOD] || [methodString isEqualToString:WONDEFULLBOOKCOMMENTNEWSMETHOD] || [methodString isEqualToString:HOTSELLBOOKNEWSMETHOD])
                        {
                            for (int i = 0; i < [tmpArr count]; i++)
                            {
                                NSDictionary *tmpDic = [tmpArr objectAtIndex:i];
                                BookObject *tmpObj = [[BookObject alloc] init];
                                
                                tmpObj.b_id = [tmpDic objectForKey:@"NEWS_ID"];
                                tmpObj.b_title = [tmpDic objectForKey:@"NEWS_TITLE"];
                                tmpObj.b_subTitle = [tmpDic objectForKey:@"NEWS_SUBTITLE"];
                                tmpObj.b_imgUrl = [tmpDic objectForKey:@"HTTPFULLNAME"];
                                tmpObj.b_info = [tmpDic objectForKey:@"NEWS_MEMO"];
                                
                                [infoArr addObject:tmpObj];
                            }
                        }
                        
                        else if ([methodString isEqualToString:WEATHERINFOMETHOD])
                        {
                            for (int i = 0; i < [tmpArr count]; i++)
                            {
                                NSDictionary *tmpDic = [tmpArr objectAtIndex:i];
                                WeatherObject *tmpObj = [[WeatherObject alloc] init];
                                tmpObj.w_weatherInfo = [tmpDic objectForKey:@"weather"];
                                tmpObj.w_temp = [tmpDic objectForKey:@"temp"];
                                tmpObj.w_weekDay = [tmpDic objectForKey:@"week"];
                                tmpObj.w_datetime = [tmpDic objectForKey:@"dateTime"];
                                tmpObj.w_wind = [tmpDic objectForKey:@"wind"];
                                
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
                                
                                [infoArr addObject:tmpObj];
                            }
                        }
                    }
                        break;
                    case RegExistAccount:
                    {
                        //完成注册 -- 用户重复
                        if ([methodString isEqualToString:FINISHREGISTMETHOD])
                        {
                            [infoArr insertObject:[NSString stringWithFormat:@"%d",RegExistAccount] atIndex:0];
                        }
                        //请求发送验证码
                        else if ([methodString isEqualToString:NOTICESENDMSGMETHOD])
                        {
                            [infoArr addObject:[NSString stringWithFormat:@"%d",RegExistAccount]];
                        }
                    }
                        break;
                        
                    case DataIsNull:
                    {
                        //完成注册 -- 用户重复
                        if ([methodString isEqualToString:USERLOGINMETHOD])
                        {
                            [infoArr insertObject:[NSString stringWithFormat:@"%d",DataIsNull] atIndex:0];
                        }
                    }
                        break;
                      
                    case Failure:
                    {
                        //验证码失败
                        [infoArr addObject:[NSString stringWithFormat:@"%d",Failure]];
                    }
                        break;
                        
                    case DataIsNotExist:
                    {
                        //忘记密码 -- 号码不存在
                        [infoArr addObject:[NSString stringWithFormat:@"%d",DataIsNotExist]];
                    }
                        break;
                        
                    default:
                        break;
                }
            }
            @catch (NSException *exception)
            {
                
            }
            @finally
            {
                
            }
        }
    }
    
    
    //判断返回的的数据
    
    return infoArr;
}

#pragma mark -
#pragma mark - 解析首页函数
+ (NSMutableArray *) getDataArrWithDic:(NSDictionary *) dic
{
    NSMutableArray *typeArr = [[NSMutableArray alloc] init];
    NSString *tmpString = [NSString stringWithFormat:@"%@",[dic objectForKey:KEY]];
    NSMutableArray *tmpArr = [dic objectForKey:DATA];
    for (int i = 0; i < [tmpArr count]; i ++)
    {
        NSDictionary *tmpDic = [tmpArr objectAtIndex:i];
        
        HomeObject *tmpObj = [[HomeObject alloc] init];
        tmpObj.h_id = [tmpDic valueForKey:@"id"];
        tmpObj.h_type = tmpString;
        tmpObj.h_title = [tmpDic valueForKey:@"title"];
        
        if ([tmpDic.allKeys containsObject:@"pics"])
        {
            NSArray *tmpPicArr = (NSArray *)[tmpDic objectForKey:@"pics"];
            NSMutableString *tmpString = [NSMutableString stringWithFormat:@""];
            for (int m = 0; m < [tmpPicArr count]; m ++)
            {
                NSDictionary *tmpPicDic = [tmpPicArr objectAtIndex:m];
                
                if (m == [tmpPicArr count] - 1)
                {
                    [tmpString appendString:[tmpPicDic objectForKey:@"imgUrl"]];
                    break;
                }
                else
                {
                    [tmpString appendFormat:@"%@^^",[tmpPicDic objectForKey:@"imgUrl"]];
                }
                
            }
            tmpObj.h_imgUrl = tmpString;
        }
        else
        {
            tmpObj.h_imgUrl = [tmpDic valueForKey:@"imgUrl"];
        }
        
        tmpObj.h_modelType = [NSString stringWithFormat:@"%@",[tmpDic valueForKey:@"moduleType"]];
        tmpObj.h_outUrl = [tmpDic valueForKey:@"outLink"];
        
        [typeArr addObject:tmpObj];
    }
    
    [self insertHomeObjectWithArr:typeArr];
    
    return typeArr;
}

+ (NSString *) getStringFromBaseString:(NSString*) baseString
{
    NSData *tmpData = [GTMBase64 decodeString:baseString];
    NSString *returnString = [[NSString alloc] initWithData:tmpData encoding:NSUTF8StringEncoding];
    return returnString;
}

@end
