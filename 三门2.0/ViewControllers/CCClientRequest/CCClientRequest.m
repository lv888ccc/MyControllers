//
//  CCClientRequest.m
//  WoZaiXianChang
//
//  Created by lcc on 13-9-17.
//  Copyright (c) 2013年 lcc. All rights reserved.
//

#import "CCClientRequest.h"
#import "CCDataParseSubClass.h"
#import "MetaData.h"
#import "NetWorkObserver.h"

//刷新时间
#define FreshTimeTypeOne 3
#define FreshTimeTypeTwo 0

@interface CCClientRequest()
{
    DataParseSuper *superRequest;
}

@end

//所有界面数据返回 与 请求
@implementation CCClientRequest

- (void)dealloc
{
    [superRequest setWDelegateWithObject:nil];
    superRequest = nil;
}

- (id) init
{
    self = [super init];
    
    if (self)
    {
        superRequest = [[CCDataParseSubClass alloc] init];
        [superRequest setWDelegateWithObject:self];
    }
    
    return self;
}

#pragma mark - 
#pragma mark - 所有数据请求
//首页
- (void) homeNewsType
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[NSString stringWithFormat:@"%d",HOMENEWSTYP] forKey:@"action"];
    [self addParamToDic:params];
    [superRequest beginPostRequestDataWithParam:params systemParams:nil methodName:HOMENEWSTYPMETHOD freshTime:FreshTimeTypeOne];
}

//启动图片
- (void) startImg
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [self addParamToDic:params];
    [params setValue:[NSString stringWithFormat:@"%d",STARTIMG] forKey:@"action"];
    [params setValue:[NSString stringWithFormat:@"%d",viewHeight > 480?7:6] forKey:@"platform"];
    [superRequest beginPostRequestDataWithParam:params systemParams:nil methodName:STARTIMGMETHOD freshTime:FreshTimeTypeOne];
}

//首页－左边栏目
- (void) leftLanMu
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[NSString stringWithFormat:@"%d",LEFTLANMU] forKey:@"action"];
    [self addParamToDic:params];
    [superRequest beginPostRequestDataWithParam:params systemParams:nil methodName:LEFTLANMUMETHOD freshTime:FreshTimeTypeOne];
}

//版本更新
- (void) checkUpdate
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[NSString stringWithFormat:@"%d",CHECKUPDATE] forKey:@"action"];
    [params setValue:ClientType forKey:@"clientType"];
    [params setValue:[MetaData getCurrVer] forKey:@"clientVer"];
    [self addParamToDic:params];
    [superRequest beginPostRequestDataWithParam:params systemParams:nil methodName:CHECKUPDATEMGMETHOD freshTime:FreshTimeTypeOne];
}

//天气
- (void) weatherInfo
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[NSString stringWithFormat:@"%d",WEATHERINFO] forKey:@"action"];
    [self addParamToDic:params];
    [superRequest beginPostRequestDataWithParam:params systemParams:nil methodName:WEATHERINFOMETHOD freshTime:FreshTimeTypeOne];
}

//新闻类型详情
- (void) newsTypeDetailWithId:(NSString *) newsId
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[NSString stringWithFormat:@"%d",NEWSTYPEDETAIL] forKey:@"action"];
    [params setValue:newsId forKey:@"newsId"];
    [self addParamToDic:params];
    [superRequest beginPostRequestDataWithParam:params systemParams:nil methodName:NEWSTYPEDETAILMETHOD freshTime:FreshTimeTypeTwo];
}

//新闻评论列表
- (void) newsCommentWithId:(NSString *) newsId pageNo:(NSInteger)pageNo
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[NSString stringWithFormat:@"%d",NEWSCOMMENT] forKey:@"action"];
    [params setValue:newsId forKey:@"newsId"];
    [params setValue:[NSString stringWithFormat:@"%d",pageNo] forKey:@"pageNo"];
    [self addParamToDic:params];
    [superRequest beginPostRequestDataWithParam:params systemParams:nil methodName:NEWSCOMMENTMETHOD freshTime:FreshTimeTypeTwo];
}

//新闻评论提交
- (void) commitCommentWithContent:(NSString *) comment newsId:(NSString *) newsId userId:(NSString *) userId
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[NSString stringWithFormat:@"%d",COMMITCOMMENT] forKey:@"action"];
    [params setValue:newsId forKey:@"newsId"];
    [params setValue:userId forKey:@"userId"];
    [params setValue:comment forKey:@"content"];
    [self addParamToDic:params];
    [superRequest beginPostRequestDataWithParam:params systemParams:nil methodName:COMMITCOMMENTMETHOD freshTime:FreshTimeTypeOne];
}

//三门广告新闻广告图
- (void) sanMenTopAd
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[NSString stringWithFormat:@"%d",SANMENTOPAD] forKey:@"action"];
    [self addParamToDic:params];
    [superRequest beginPostRequestDataWithParam:params systemParams:nil methodName:SANMENTOPADMETHOD freshTime:FreshTimeTypeOne];
}

//三门-新闻-视频
//新闻
- (void) newsSanMenWithPageNo:(NSInteger) pageNo
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[NSString stringWithFormat:@"%d",NEWSSAMEN] forKey:@"action"];
    [params setValue:[NSString stringWithFormat:@"%d",pageNo] forKey:@"pageNo"];
    [self addParamToDic:params];
    [superRequest beginPostRequestDataWithParam:params systemParams:nil methodName:NEWSSAMENMETHOD freshTime:pageNo == 1?FreshTimeTypeOne*6:0];
}

//天下
- (void) newsWorld
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[NSString stringWithFormat:@"%d",NEWSWORLD] forKey:@"action"];
    [params setValue:SITEID forKey:SITEIDVALUE];
    
    [self addParamToDic:params];
    [superRequest beginPostRequestDataWithParam:params systemParams:nil methodName:NEWSWORLDMETHOD freshTime:FreshTimeTypeOne];
}

//天下详情
- (void) worldDetailWithId:(NSString *) newsId
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[NSString stringWithFormat:@"%d",WORLDDETAIL] forKey:@"action"];
    [params setValue:newsId forKey:@"id"];
    [self addParamToDic:params];
    [superRequest beginPostRequestDataWithParam:params systemParams:nil methodName:WORLDDETAILMETHOD freshTime:FreshTimeTypeTwo];
}

//视频
- (void) newsVideoWithPageNo:(NSInteger) pageNo
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[NSString stringWithFormat:@"%d",NEWSVIDEDIO] forKey:@"action"];
    [params setValue:[NSString stringWithFormat:@"%d",pageNo] forKey:@"pageNo"];
    [self addParamToDic:params];
    [superRequest beginPostRequestDataWithParam:params systemParams:nil methodName:NEWSVIDEDIOMETHOD freshTime:pageNo == 1?FreshTimeTypeOne:FreshTimeTypeTwo];
}

//政务-公告公示-政府公开-权力公开
- (void) zhengWuPublicNoticeWithPageNo:(NSInteger) pageNo
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[NSString stringWithFormat:@"%d",ZHENGWUPUBLICNOTICE] forKey:@"action"];
    [params setValue:[NSString stringWithFormat:@"%d",pageNo] forKey:@"pageNo"];
    [self addParamToDic:params];
    [superRequest beginPostRequestDataWithParam:params systemParams:nil methodName:ZHENGWUPUBLICNOTICEMETHOD freshTime:pageNo == 1?FreshTimeTypeOne:0];
}

- (void) zhengWuGovernmentWithPageNo:(NSInteger) pageNo
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[NSString stringWithFormat:@"%d",ZHENGWUGOVERNMENT] forKey:@"action"];
    [params setValue:[NSString stringWithFormat:@"%d",pageNo] forKey:@"pageNo"];
    [self addParamToDic:params];
    [superRequest beginPostRequestDataWithParam:params systemParams:nil methodName:ZHENGWUGOVERNMENTMETHOD freshTime:pageNo == 1?FreshTimeTypeOne:0];
}

- (void) zhengWuPowerOpenWithPageNo:(NSInteger) pageNo
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[NSString stringWithFormat:@"%d",ZHENGWUPOWEROPEN] forKey:@"action"];
    [params setValue:[NSString stringWithFormat:@"%d",pageNo] forKey:@"pageNo"];
    [self addParamToDic:params];
    [superRequest beginPostRequestDataWithParam:params systemParams:nil methodName:ZHENGWUPOWEROPENMETHOD freshTime:pageNo == 1?FreshTimeTypeOne:0];
}


//县情 - 关于三门 - 旅游景点 - 特色小吃 - 视频新闻
//关于三门
- (void) localNewsAboutSanMenWithPageNo:(NSInteger) pageNo
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[NSString stringWithFormat:@"%d",LOCALNEWSABOUTSANMEN] forKey:@"action"];
    [params setValue:[NSString stringWithFormat:@"%d",pageNo] forKey:@"pageNo"];
    [self addParamToDic:params];
    [superRequest beginPostRequestDataWithParam:params systemParams:nil methodName:LOCALNEWSABOUTSANMENMETHOD freshTime:pageNo == 1?FreshTimeTypeOne*6:0];
}
//旅游景点
- (void) localNewsInterestingPlaceWithPageNo:(NSInteger) pageNo
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[NSString stringWithFormat:@"%d",LOCALNEWSINTERESTINGPLACE] forKey:@"action"];
    [params setValue:[NSString stringWithFormat:@"%d",pageNo] forKey:@"pageNo"];
    [self addParamToDic:params];
    [superRequest beginPostRequestDataWithParam:params systemParams:nil methodName:LOCALNEWSINTERESTINGPLACEMETHOD freshTime:FreshTimeTypeOne];
}
//特色小吃
- (void) localNewsEatWithPageNo:(NSInteger) pageNo
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[NSString stringWithFormat:@"%d",LOCALNEWSEAT] forKey:@"action"];
    [params setValue:[NSString stringWithFormat:@"%d",pageNo] forKey:@"pageNo"];
    [self addParamToDic:params];
    [superRequest beginPostRequestDataWithParam:params systemParams:nil methodName:LOCALNEWSEATMETHOD freshTime:pageNo == 1?FreshTimeTypeOne:0];
}
//视频新闻
- (void) localNewsVideoWithPageNo:(NSInteger) pageNo
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[NSString stringWithFormat:@"%d",LOCALNEWSVIDEO] forKey:@"action"];
    [params setValue:[NSString stringWithFormat:@"%d",pageNo] forKey:@"pageNo"];
    [self addParamToDic:params];
    [superRequest beginPostRequestDataWithParam:params systemParams:nil methodName:LOCALNEWSVIDEOMETHOD freshTime:pageNo == 1?FreshTimeTypeOne:0];
}

//美食 - 餐饮 - 外卖电话 - 酒店住宿
//餐饮
- (void) foodEatWithPageNo:(NSInteger) pageNo
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[NSString stringWithFormat:@"%d",FOODEAT] forKey:@"action"];
    [params setValue:[NSString stringWithFormat:@"%d",pageNo] forKey:@"pageNo"];
    [self addParamToDic:params];
    [superRequest beginPostRequestDataWithParam:params systemParams:nil methodName:FOODEATMETHOD freshTime:pageNo == 1?FreshTimeTypeOne:0];
}

//外卖电话
- (void) foodPhoneWithPageNo:(NSInteger) pageNo
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[NSString stringWithFormat:@"%d",FOODPHONE] forKey:@"action"];
    [params setValue:[NSString stringWithFormat:@"%d",pageNo] forKey:@"pageNo"];
    [self addParamToDic:params];
    [superRequest beginPostRequestDataWithParam:params systemParams:nil methodName:FOODPHONEMETHOD freshTime:pageNo == 1?FreshTimeTypeOne:0];
}
//酒店住宿
- (void) foodLiveWithPageNo:(NSInteger) pageNo
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[NSString stringWithFormat:@"%d",FOODLIVE] forKey:@"action"];
    [params setValue:[NSString stringWithFormat:@"%d",pageNo] forKey:@"pageNo"];
    [self addParamToDic:params];
    [superRequest beginPostRequestDataWithParam:params systemParams:nil methodName:FOODLIVEMETHOD freshTime:pageNo == 1?FreshTimeTypeOne:0];
}

//发布
- (void) publishWithPageNo:(NSInteger) pageNo
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[NSString stringWithFormat:@"%d",PUBLISH] forKey:@"action"];
    [params setValue:[NSString stringWithFormat:@"%d",pageNo] forKey:@"pageNo"];
    [self addParamToDic:params];
    [superRequest beginPostRequestDataWithParam:params systemParams:nil methodName:PUBLISHMETHOD freshTime:pageNo == 1?FreshTimeTypeOne:0];
}

//广播节目单
- (void) broadOrder
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[NSString stringWithFormat:@"%d",BROADORDER] forKey:@"action"];
    [self addParamToDic:params];
    [superRequest beginPostRequestDataWithParam:params systemParams:nil methodName:BROADORDERMETHOD freshTime:FreshTimeTypeOne];
}

//活动
- (void) activityWithPageNo:(NSInteger) pageNo
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[NSString stringWithFormat:@"%d",ACTIVITY] forKey:@"action"];
    [params setValue:[NSString stringWithFormat:@"%d",pageNo] forKey:@"pageNo"];
    [self addParamToDic:params];
    [superRequest beginPostRequestDataWithParam:params systemParams:nil methodName:ACTIVITYMETHOD freshTime:pageNo == 1?FreshTimeTypeOne:0];
}

//通知发送验证码
- (void) noticeSendMsgWithPhoneNo:(NSString *)phoneNo type:(NSString *) typeString
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[NSString stringWithFormat:@"%d",NOTICESENDMSG] forKey:@"action"];
    [params setValue:phoneNo forKey:@"phone"];
    [params setValue:typeString forKey:@"captchaType"];
    [self addParamToDic:params];
    [superRequest beginPostRequestDataWithParam:params systemParams:nil methodName:NOTICESENDMSGMETHOD freshTime:FreshTimeTypeOne];
}
//校验验证码
- (void) compareCodeWithPhoneNo:(NSString *)phoneNo type:(NSString *) typeString code:(NSString *) codeString
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[NSString stringWithFormat:@"%d",COMPARECODE] forKey:@"action"];
    [params setValue:phoneNo forKey:@"phone"];
    [params setValue:typeString forKey:@"captchaType"];
    [params setValue:codeString forKey:@"captcha"];
    [self addParamToDic:params];
    [superRequest beginPostRequestDataWithParam:params systemParams:nil methodName:COMPARECODEMETHOD freshTime:FreshTimeTypeOne];
}

//从修改密码
- (void) commitPswWithPhoneNo:(NSString *)phoneNo psw:(NSString *) password
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[NSString stringWithFormat:@"%d",COMMITPSW] forKey:@"action"];
    [params setValue:phoneNo forKey:@"phone"];
    [params setValue:password forKey:@"pwd"];
    [self addParamToDic:params];
    [superRequest beginPostRequestDataWithParam:params systemParams:nil methodName:COMMITPSWMETHOD freshTime:FreshTimeTypeOne];
}

//完成注册
- (void) finishRegistWithPhoneNo:(NSString *)phoneNo nickname:(NSString *) nickname psw:(NSString *) password
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[NSString stringWithFormat:@"%d",FINISHREGIST] forKey:@"action"];
    [params setValue:phoneNo forKey:@"phone"];
    [params setValue:nickname forKey:@"name"];
    [params setValue:password forKey:@"pwd"];
    [self addParamToDic:params];
    [superRequest beginPostRequestDataWithParam:params systemParams:nil methodName:FINISHREGISTMETHOD freshTime:FreshTimeTypeOne];
}

//用户登陆
- (void) userLoginWithPhoneNo:(NSString *)phoneNo psw:(NSString *) password
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[NSString stringWithFormat:@"%d",USERLOGIN] forKey:@"action"];
    [params setValue:phoneNo forKey:@"phone"];
    [params setValue:password forKey:@"pwd"];
    [self addParamToDic:params];
    [superRequest beginPostRequestDataWithParam:params systemParams:nil methodName:USERLOGINMETHOD freshTime:FreshTimeTypeOne];
}

//更改昵称
- (void) changeNicknameWithUid:(NSString *)uId nickname:(NSString *) nickname
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[NSString stringWithFormat:@"%d",CHANGENICKNAME] forKey:@"action"];
    [params setValue:uId forKey:@"userId"];
    [params setValue:nickname forKey:@"name"];
    [self addParamToDic:params];
    [superRequest beginPostRequestDataWithParam:params systemParams:nil methodName:CHANGENICKNAMEMETHOD freshTime:FreshTimeTypeOne];
}

//拍客-随手拍-主题
- (void) paikeUserWithPageNo:(NSInteger) pageNo;
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[NSString stringWithFormat:@"%d",PAIKEUSER] forKey:@"action"];
    [params setValue:[NSString stringWithFormat:@"%d",pageNo] forKey:@"pageNo"];
    [self addParamToDic:params];
    [superRequest beginPostRequestDataWithParam:params systemParams:nil methodName:PAIKEUSERMETHOD freshTime:pageNo == 1?FreshTimeTypeOne:0];
}

- (void) paikeThemeWithPageNo:(NSInteger) pageNo;
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[NSString stringWithFormat:@"%d",PAIKETHEME] forKey:@"action"];
    [params setValue:[NSString stringWithFormat:@"%d",pageNo] forKey:@"pageNo"];
    [self addParamToDic:params];
    [superRequest beginPostRequestDataWithParam:params systemParams:nil methodName:PAIKETHEMEMETHOD freshTime:pageNo == 1?FreshTimeTypeOne:0];
}

//主题拍的二
- (void) paikeThemeDetailWithPageNo:(NSInteger) pageNo pId:(NSString *)pId
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[NSString stringWithFormat:@"%d",PAIKETHEMEDETAIL] forKey:@"action"];
    [params setValue:[NSString stringWithFormat:@"%d",pageNo] forKey:@"pageNo"];
    [params setValue:pId forKey:@"atlasType"];
    [self addParamToDic:params];
    [superRequest beginPostRequestDataWithParam:params systemParams:nil methodName:PAIKETHEMEDETAILMETHOD freshTime:FreshTimeTypeTwo];
}

//拍客详情
- (void) paikeContentDetailWithPid:(NSString *) pId
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[NSString stringWithFormat:@"%d",PAIKECONTENTDETAIL] forKey:@"action"];
    [params setValue:pId forKey:@"id"];
    [self addParamToDic:params];
    [superRequest beginPostRequestDataWithParam:params systemParams:nil methodName:PAIKECONTENTDETAILMETHOD freshTime:FreshTimeTypeTwo];
}

//拍客浏览图片
- (void) paikeImgDetailWithPid:(NSString *) pId
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[NSString stringWithFormat:@"%d",PAIKEIMGDETAIL] forKey:@"action"];
    [params setValue:pId forKey:@"atlasId"];
    [self addParamToDic:params];
    [superRequest beginPostRequestDataWithParam:params systemParams:nil methodName:PAIKEIMGDETAILMETHOD freshTime:FreshTimeTypeTwo];
}

//拍客评论
- (void) paikeCommentDetailWithPageNo:(NSInteger) pageNo pid:(NSString *) pId
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[NSString stringWithFormat:@"%d",PAIKECOMMENTLIST] forKey:@"action"];
    [params setValue:pId forKey:@"id"];
    [params setValue:[NSString stringWithFormat:@"%d",pageNo] forKey:@"pageNo"];
    [self addParamToDic:params];
    [superRequest beginPostRequestDataWithParam:params systemParams:nil methodName:PAIKECOMMENTLISTMETHOD freshTime:FreshTimeTypeTwo];
}

//拍客评论提交
- (void) paikeCommitCommentWithContent:(NSString *) comment pId:(NSString *) pId userId:(NSString *) userId
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[NSString stringWithFormat:@"%d",PAIKECOMMITCOMMENT] forKey:@"action"];
    [params setValue:pId forKey:@"atlasId"];
    [params setValue:userId forKey:@"userId"];
    [params setValue:comment forKey:@"content"];
    [self addParamToDic:params];
    [superRequest beginPostRequestDataWithParam:params systemParams:nil methodName:PAIKECOMMITCOMMENTMETHOD freshTime:FreshTimeTypeOne];
}

//意见反馈
- (void) goodAdviceWithDeviceNum:(NSString *) deviceNum sysVer:(NSString *) sysVer curVer:(NSString *) curVer content:(NSString *) content linkMethod:(NSString *)linkMethod userId:(NSString *) userId
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[NSString stringWithFormat:@"%d",GOODADVICE] forKey:@"action"];
    [params setValue:deviceNum forKey:@"deviceNum"];
    [params setValue:sysVer forKey:@"sysVer"];
    [params setValue:curVer forKey:@"curVer"];
    [params setValue:content forKey:@"content"];
    [params setValue:linkMethod forKey:@"linkMethod"];
    [params setValue:userId forKey:@"userId"];
    [self addParamToDic:params];
    [superRequest beginPostRequestDataWithParam:params systemParams:nil methodName:GOODADVICEMETHOD freshTime:FreshTimeTypeOne];
}

//ftp信息获取
- (void) ftpInfo
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[NSString stringWithFormat:@"%d",FTPINFO] forKey:@"action"];
    [superRequest beginPostRequestDataWithParam:params systemParams:nil methodName:FTPINFOMETHOD freshTime:FreshTimeTypeOne];
}

//上传
- (void) uploadPicWithParam:(NSString *) param
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[NSString stringWithFormat:@"%d",UPLOADPICS] forKey:@"action"];
    [params setValue:param forKey:@"Param"];
    [self addParamToDic:params];
    [superRequest beginPostRequestDataWithParam:params systemParams:nil methodName:UPLOADPICSMETHOD freshTime:FreshTimeTypeOne];
}

//专栏首页
- (void) themeHomeWithPageNo:(NSInteger)pageNo
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[NSString stringWithFormat:@"%d",THMEMHOME] forKey:@"action"];
    [params setValue:[NSString stringWithFormat:@"%d",pageNo] forKey:@"pageNo"];
    [self addParamToDic:params];
    [superRequest beginPostRequestDataWithParam:params systemParams:nil methodName:THMEMHOMEMETHOD freshTime:FreshTimeTypeOne];
}

//专栏列表
- (void) themeHomeListWithPageNo:(NSInteger) pageNo tId:(NSString *) tId
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[NSString stringWithFormat:@"%d",THMEMHOMELIST] forKey:@"action"];
    [params setValue:tId forKey:@"mid"];
    [params setValue:[NSString stringWithFormat:@"%d",pageNo] forKey:@"pageNo"];
    [self addParamToDic:params];
    [superRequest beginPostRequestDataWithParam:params systemParams:nil methodName:THMEMHOMELISTMETHOD freshTime:FreshTimeTypeTwo];
}

//电影首页列表
- (void) movieHomeList
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[NSString stringWithFormat:@"%d",MOVIEHOMELIST] forKey:@"action"];
    [self addParamToDic:params];
    [superRequest beginPostRequestDataWithParam:params systemParams:nil methodName:MOVIEHOMELISTMETHOD freshTime:FreshTimeTypeOne];
}

//电影院列表详情
- (void) movieDetailListWithCId:(NSString *) cId
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[NSString stringWithFormat:@"%d",MOVIEDETAILLISTINFO] forKey:@"action"];
    [params setValue:cId forKey:@"id"];
    [self addParamToDic:params];
    [superRequest beginPostRequestDataWithParam:params systemParams:nil methodName:MOVIEDETAILLISTINFOMETHOD freshTime:FreshTimeTypeTwo];
}

//电影详情
- (void) movieDetailListDetailInfoWithMId:(NSString *) mId
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[NSString stringWithFormat:@"%d",MOVIEDETAILLISTDETAILINFO] forKey:@"action"];
    [params setValue:mId forKey:@"id"];
    [self addParamToDic:params];
    [superRequest beginPostRequestDataWithParam:params systemParams:nil methodName:MOVIEDETAILLISTDETAILINFOMETHOD freshTime:FreshTimeTypeOne];
}

//新华书讯
- (void) xinHuaBookNewsWithPageNo:(NSInteger) pageNo
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[NSString stringWithFormat:@"%d",XINHUABOOKNEWS] forKey:@"action"];
    [params setValue:[NSString stringWithFormat:@"%d",pageNo] forKey:@"pageNo"];
    [self addParamToDic:params];
    [superRequest beginPostRequestDataWithParam:params systemParams:nil methodName:XINHUABOOKNEWSMETHOD freshTime:pageNo == 1?FreshTimeTypeOne:FreshTimeTypeTwo];
}

//畅销榜
- (void) hotSellBookNewsWithPageNo:(NSInteger) pageNo
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[NSString stringWithFormat:@"%d",HOTSELLBOOKNEWS] forKey:@"action"];
    [params setValue:[NSString stringWithFormat:@"%d",pageNo] forKey:@"pageNo"];
    [self addParamToDic:params];
    [superRequest beginPostRequestDataWithParam:params systemParams:nil methodName:HOTSELLBOOKNEWSMETHOD freshTime:pageNo == 1?FreshTimeTypeOne:FreshTimeTypeTwo];
}

//精彩书评
- (void) wondefullBookCommentWithPageNo:(NSInteger) pageNo
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[NSString stringWithFormat:@"%d",WONDEFULLBOOKCOMMENTNEWS] forKey:@"action"];
    [params setValue:[NSString stringWithFormat:@"%d",pageNo] forKey:@"pageNo"];
    [self addParamToDic:params];
    [superRequest beginPostRequestDataWithParam:params systemParams:nil methodName:WONDEFULLBOOKCOMMENTNEWSMETHOD freshTime:pageNo == 1?FreshTimeTypeOne:FreshTimeTypeTwo];
}

//自行车
- (void) cBikeAddressNews
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[NSString stringWithFormat:@"%d",CBIKEADDRESSNEWS] forKey:@"action"];
    [self addParamToDic:params];
    [superRequest beginPostRequestDataWithParam:params systemParams:nil methodName:CBIKEADDRESSNEWSMETHOD freshTime:FreshTimeTypeOne];
}

//电话列表
- (void) phoneNOList
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[NSString stringWithFormat:@"%d",PHONENOLIST] forKey:@"action"];
    [self addParamToDic:params];
    [superRequest beginPostRequestDataWithParam:params systemParams:nil methodName:PHONENOLISTMETHOD freshTime:FreshTimeTypeOne];
}

//新闻详情
- (void) newsThemeWithPageNo:(NSInteger) pageNo
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[NSString stringWithFormat:@"%d",NEWSTHEME] forKey:@"action"];
    [params setValue:[NSString stringWithFormat:@"%d",pageNo] forKey:@"pageNo"];
    [self addParamToDic:params];
    [superRequest beginPostRequestDataWithParam:params systemParams:nil methodName:NEWSTHEMEMETHOD freshTime:pageNo == 1?FreshTimeTypeOne:FreshTimeTypeTwo];
}

//新闻专题详情列表
- (void) newsThemeListWithPageNo:(NSInteger) pageNo themeId:(NSString *) themeId
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:[NSString stringWithFormat:@"%d",NEWSTHEMELIST] forKey:@"action"];
    [params setValue:[NSString stringWithFormat:@"%d",pageNo] forKey:@"pageNo"];
    [params setValue:themeId forKey:@"mid"];
    [self addParamToDic:params];
    [superRequest beginPostRequestDataWithParam:params systemParams:nil methodName:NEWSTHEMELISTMETHOD freshTime:FreshTimeTypeTwo];
}

#pragma mark -
#pragma mark - 网络数据返回到界面回调
- (void) finishLoadDataCallBack:(NSString *) methodName loadingData:(id) objectData
{
    //根据返回的方法明动态调用
    SEL selector = NSSelectorFromString([NSString stringWithFormat:@"%@CallBack:",methodName]);
    //代理回调
    if (self.c_delegate != nil && [self.c_delegate respondsToSelector:selector])
    {
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self.c_delegate performSelector:selector withObject:objectData];
        #pragma clang diagnostic pop
    }
}

#pragma mark -
#pragma mark - 网络回调失败
- (void) failLoadData:(id) reasonString
{
    if (self.c_delegate != nil && [self.c_delegate respondsToSelector:@selector(failLoadData:)])
    {
        [self.c_delegate performSelector:@selector(failLoadData:) withObject:reasonString];
    }
}

#pragma mark -
#pragma mark - 系统参数
- (void) addParamToDic:(NSMutableDictionary *) paramsDic
{
    [paramsDic setValue:ClientDev forKey:@"isDev"];
    [paramsDic setValue:[MetaData getUid] forKey:@"clientId"];
    [paramsDic setValue:ClientType forKey:@"clientType"];//1是iOS
    [paramsDic setValue:[MetaData getCurrVer] forKey:@"clientVer"];//客户端版本(1.0.0)
    [paramsDic setValue:[MetaData getLongOSVersion] forKey:@"clientOs"];//客户端系统(ios7.0,android2.3)
    [paramsDic setValue:[MetaData getPlatform] forKey:@"clientModel"];//客户端机型(iphone4s,LG820)
    [paramsDic setValue:[NSString stringWithFormat:@"%d",[NetWorkObserver dataNetworkTypeFromStatusBar]] forKey:@"clientNet"];  //1:wifi,2:2g,3:3g)
    [paramsDic setValue:[MetaData getToken] forKey:@"clientToken"];
}

@end