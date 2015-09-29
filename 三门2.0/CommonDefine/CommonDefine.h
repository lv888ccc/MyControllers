//
//  CommonDefine.h
//  TWindowPhoneStyle
//
//  Created by lcc on 13-5-3.
//  Copyright (c) 2013年 lcc. All rights reserved.
//

#ifndef TWindowPhoneStyle_CommonDefine_h
#define TWindowPhoneStyle_CommonDefine_h

//------------------------- 系统公共 ---------------------------------------------
#import "AppDelegate.h"
#import "StatusBarObject.h"
#import "CommonUrl.h"

#define SMApp ((AppDelegate*)[[UIApplication sharedApplication] delegate])
#define PicPath [NSString stringWithFormat:@"%@/Documents/Paike/",NSHomeDirectory()]
//----------------------------end-------------------------------------------------

//-----------------    常用配置   ----------------
#define viewHeight [[UIScreen mainScreen] bounds].size.height
//1正式版，2测试版
#define ClientDev @"2"
//发布类型
#define ClientType @"1" //1是iOS 

//注册和找回密码类型
#define FORGETPSW @"2"//找回密码
#define REGISTER @"1"//注册

#define PhoneNUM1 @"057683332853"
#define PhoneNUM2 @"057683327928"
#define PhoneNUM3 @"057683327929"

#define TOPNEWS @"头条"

//每次返回数据条数
#define PAGESIZE 20

//友盟等账号
#define YouMengKey @"52bd2c9856240bb51b077ca2"
#define WeiChatKey @"wx18e30d1bb98f2eb0"
#define SettingShareText @"我正在使用“掌上三门”客户端浏览最新资讯，下载地址：http://www.chinasanmen.com/"
#define ShareText @"快来下载“掌上三门”客户端，下载地址：http://www.chinasanmen.com/ "

//中国网事下载地址
#define ZHONGGUOWANGSHI @"http://app.zhongguowangshi.com/app/"

//便民查询
#define BusUrl @"http://t.cn/8F0tlGW"
#define TrainUrl @"http://t.cn/8F0tTNO"
#define CarUrl @"http://t.cn/8F0tEZh"

//中国网事配置
#define SITEID @"siteid"
#define SITEIDVALUE @"65"

//-----------------     end     ----------------

//-----------------    常用消息   ----------------
#define SCROLLUPNOTIFICATION @"SCROLLUPNOTIFICATION" //向上滚动
#define SCROLLDOWNNOTIFICATION @"SCROLLDOWNNOTIFICATION" //向下滚动
#define CHANGETITLENOTIFICATION @"CHANGETITLENOTIFICATION" //该表标题
#define LOGINSUCCESSNOTIFICATION @"LOGINSUCCESSNOTIFICATION" //注册成功
#define LOGOUTSUCCESSNOTIFICATION @"LOGOUTSUCCESSNOTIFICATION" //登出
#define LOADDONEWEATHERINFO @"LOADDONEWEATHERINFO" //天气
//-----------------     end     -----------------

//----------------------方法-----------------------------
typedef enum
{
    STARTIMG = 10000,            //启动图
    LEFTLANMU = 10001,           //栏目
    CHECKUPDATE = 10003,         //版本更新
    WEATHERINFO = 10004,         //天气
    
    NEWSSAMEN = 10101,           //新闻-三门
    NEWSWORLD = 10102,           //新闻-天下
    NEWSVIDEDIO = 10103,         //新闻-视频
    NEWSTYPEDETAIL = 10104,      //新闻详情
    SANMENTOPAD = 10105,         //三门广告新闻广告图
    COMMITCOMMENT = 10106,       //新闻评论提交
    NEWSCOMMENT = 10107,         //新闻评论
    WORLDDETAIL = 10108,         //天下详情
    
    ZHENGWUPUBLICNOTICE = 10201,          //政务-公告公示
    ZHENGWUGOVERNMENT = 10202,            //政务-政府公开
    ZHENGWUPOWEROPEN = 10203,             //政务-权力公开
    
    LOCALNEWSABOUTSANMEN = 10301,     //县情-三门概况
    LOCALNEWSINTERESTINGPLACE = 10302,//县情-旅游景点
    LOCALNEWSEAT = 10303,             //县情-特色小吃
    LOCALNEWSVIDEO = 10304,           //县情-视频三门
    
    FOODEAT = 10401,              //美食-餐饮
    FOODPHONE = 10402,            //美食-外卖电话
    FOODLIVE = 10403,             //美食-酒店住宿
    
    PUBLISH = 10501,              //发布
    BROADORDER = 10601,           //广播节目单
    ACTIVITY = 10701,             //活动
    
    NEWSTHEME = 10800,                  //新闻专题
    NEWSTHEMELIST = 10801,              //新闻专题详情列表
    XINHUABOOKNEWS = 10802,             //新华书讯
    HOTSELLBOOKNEWS = 10803,            //畅销榜
    WONDEFULLBOOKCOMMENTNEWS = 10804,   //精彩书评
    CBIKEADDRESSNEWS = 10805,           //自行车
    
    NOTICESENDMSG = 20001,        //通知发短息
    COMPARECODE = 20002,          //校验验证码
    
    FINISHREGIST = 20003,         //完成注册
    USERLOGIN = 20004,            //用户登陆
    COMMITPSW = 20005,            //修改密码
    CHANGENICKNAME = 20006,       //更改昵称
    PAIKEUSER = 30001,            //随手拍
    PAIKECONTENTDETAIL = 30002,   //拍客详情
    PAIKETHEME = 30003,           //主题拍
    PAIKETHEMEDETAIL = 30004,     //主题拍二级
    PAIKEIMGDETAIL = 30005,       //拍客浏览图片
    PAIKECOMMENTLIST = 30006,     //拍客评论
    PAIKECOMMITCOMMENT = 30007,   //拍客评论提交
    
    THMEMHOME = 30008,            //专栏
    THMEMHOMELIST = 30009,        //专栏列表
    
    HOMENEWSTYP = 40001,          //新闻首页
    GOODADVICE = 50001,           //意见反馈
    FTPINFO = 60001,              //ftp信息获取
    UPLOADPICS = 60002,           //ftp上传
    MOVIEHOMELIST = 70001,        //电影首页列表
    MOVIEDETAILLISTINFO = 70002,      //电影院列表详情
    MOVIEDETAILLISTDETAILINFO = 70003, //电影详情
    PHONENOLIST = 80001           //热线电话的列表
    
} METHODTYPE;

#define STARTIMGMETHOD @"startImg"                //启动图片
#define LEFTLANMUMETHOD @"leftLanMu"              //栏目
#define CHECKUPDATEMGMETHOD @"checkUpdate"        //版本更新
#define NEWSTYPEDETAILMETHOD @"newsTypeDetail"    //新闻详情
#define SANMENTOPADMETHOD @"sanMenTopAd"          //三门广告新闻广告图
#define NEWSCOMMENTMETHOD @"newsComment"          //新闻评论列表
#define COMMITCOMMENTMETHOD @"commitComment"      //新闻评论列表

//新闻 - 三门 - 视频
#define NEWSSAMENMETHOD @"newsSanMen"      //三门
#define NEWSWORLDMETHOD @"newsWorld"       //三门
#define NEWSVIDEDIOMETHOD @"newsVideo"     //视频
#define WORLDDETAILMETHOD @"worldDetail"   //天下详情
#define WEATHERINFOMETHOD @"weatherInfo"   //天气
#define NEWSTHEMEMETHOD @"newsTheme" //新闻专题
#define NEWSTHEMELISTMETHOD @"newsThemeList" //新闻专题详情列表

//政务-公告公示-政府公开-权力公开
#define ZHENGWUPUBLICNOTICEMETHOD @"zhengWuPublicNotice"        //公告公示
#define ZHENGWUGOVERNMENTMETHOD @"zhengWuGovernment"            //政府公开
#define ZHENGWUPOWEROPENMETHOD @"zhengWuPowerOpen"              //权力公开

//县情-关于三门-旅游景点-特色小吃-视频新闻
#define LOCALNEWSABOUTSANMENMETHOD @"localNewsAboutSanMen"              //关于三门
#define LOCALNEWSINTERESTINGPLACEMETHOD @"localNewsInterestingPlace"    //旅游景点
#define LOCALNEWSEATMETHOD @"localNewsEat"                              //特色小吃
#define LOCALNEWSVIDEOMETHOD @"localNewsVideo"                          //视频新闻

//美食-餐饮-外卖电话-酒店住宿
#define FOODEATMETHOD @"foodEat"        //餐饮
#define FOODPHONEMETHOD @"foodPhone"    //外卖电话
#define FOODLIVEMETHOD @"foodLive"      //酒店住宿

//专栏
#define THMEMHOMEMETHOD @"themeHome"
#define THMEMHOMELISTMETHOD @"themeHomeList" //专栏列表
#define THMEMHOMELISTDETAILMETHOD @"themeHomeListDetail" //专栏列表详情

//发布
#define PUBLISHMETHOD @"publish"

//广播节目单
#define BROADORDERMETHOD @"broadOrder"

//活动
#define ACTIVITYMETHOD @"activity"

//用户部分 - 通知发送验证码 - 完成注册 - 更改昵称 - 用户登陆
#define NOTICESENDMSGMETHOD @"noticeSendMsg"
#define COMPARECODEMETHOD @"compareCode"
#define FINISHREGISTMETHOD @"finishRegist"
#define USERLOGINMETHOD @"userLogin"
#define CHANGENICKNAMEMETHOD @"changeNickname"
#define COMMITPSWMETHOD @"commitPsw"

//拍客 主题拍 随手拍
#define PAIKEUSERMETHOD @"paikeUser"
#define PAIKETHEMEMETHOD @"paikeTheme"

//主题拍二级
#define PAIKETHEMEDETAILMETHOD @"paikeThemeDetail"

//拍客详情
#define PAIKECONTENTDETAILMETHOD @"paikeContentDetail"

//拍客浏览图片
#define PAIKEIMGDETAILMETHOD @"paikeImgDetail"
//拍客评论
#define PAIKECOMMENTLISTMETHOD @"paikeCommentDetail"
//拍客评论提交
#define PAIKECOMMITCOMMENTMETHOD @"paikeCommitComment"

//首页新闻
#define HOMENEWSTYPMETHOD @"homeNewsType"

//意见反馈
#define GOODADVICEMETHOD @"goodAdvice"

//获取ftp信息
#define FTPINFOMETHOD @"ftpInfo"

//上传
#define UPLOADPICSMETHOD @"uploadPic"

//电话号码
#define PHONENOLISTMETHOD @"phoneNOList"

#define MOVIEHOMELISTMETHOD @"movieHomeList"        //电影首页列表
#define MOVIEDETAILLISTINFOMETHOD @"movieDetailList"      //电影院列表详情
#define MOVIEDETAILLISTDETAILINFOMETHOD @"movieDetailListDetailInfo" //电影详情

#define XINHUABOOKNEWSMETHOD @"xinHuaBookNews"                   //新华书讯
#define HOTSELLBOOKNEWSMETHOD @"hotSellBookNews"                 //畅销榜
#define WONDEFULLBOOKCOMMENTNEWSMETHOD @"wondefullBookComment"   //精彩书评
#define CBIKEADDRESSNEWSMETHOD @"cBikeAddressNews"               //自行车

//----------------------end------------------------------------

//------------------------栏目标识id-------------------------------
//左页面
typedef enum {

    PHOME = 700001,         //首页
    PNEWS = 700002,         //新闻
    PZHENGWU = 700003,      //政务
    PPUBLISH = 700004,      //发布
    PLOCATIONNEWS = 700005,	//县情
    PBROADPLAYER = 700006,	//电台
    
    PPAIKE = 700007,	//拍客
    PFOOD = 700008,     //美食
    PACTIVITY = 700009,	//活动
    MOVIECENEMA = 700010,//影院
    THEMEPRO = 700011,   //专栏
    CONVINIENTPEOPLE = 700012,   //便民
    AROUNDME = 700013,   //周边
    READBOOK = 700014,   //阅读
    OPENPOWER = 700015,   //权利公开
    LEFTZHONGGUOWANGSHI = 700016   //中国网事
    
} PROGRAMID;

//中间页面
typedef enum {
    
    NEWSADTYPE = 50001,//广告
    NEWSTYPE = 50002,//图文
    VIDEOTYPE = 50003,//视频
    PUBLISHTYPE = 50004//发布

}HOMEPROGRAMTYPE;
//--------------------------end------------------------------------

//-------------------接口返回情况标识---------------------
typedef enum
{
    
    Illegal = 1001,			//违反访问规则
    Legitimate = 1002,		//成功访问
    Failure = 2001,			//操作失败
    Success = 2002,			//操作成功
    Exist = 2003,			//已存在
    DataIsNull = 2004,		//数据请求为空
    Error = 2005,			//服务器异常失败（try-catch）
    DataIsNotExist = 2006,
    RegExistEmail = 3001,	//邮箱已存在
    RegExistAccount = 3002,	//帐号已存在
    CurrVer = 4001,         //无最新版本
    NewVer = 4002           //有最新版本
    
} DATABACKINFO;
//------------------------end-----------------------------

//----------------------------user stadart----------------------------
#define VER @"vercode"
#define IMGURL @"imgUrl"
#define FONTSIZE @"fontSize"
#define VERINFO @"verInfo"
#define TOKENKEY @"token"
//--------------------------------end---------------------------------

//------------------------------- 提示语 ----------------------------------

//图文详情页面
#define SucessCollection @"收藏成功"
#define CancelCollection @"取消收藏"
#define SuccessSaveImg @"已保存至相册"

#define SucessComment  @"评论成功"
#define DoneLoading @"加载完成"
#define Committing @"提交中..."

#define FailTip @"失败 再试一次"
#define Loading @"加载中..."
#define Loginning @"登录中..."
#define TappedAgain @"点击屏幕 , 重新加载"
#define NetFailTip @"网络不给力哦"

#define SendingCode @"验证已经发出"
#define ErrorNo @"您输入的手机号有误"
#define RegistAlready @"您的号码已经被注册了"
#define NoPhoneNo @"请输入注册时用的手机号"
#define Erroring @"异常信息"

#define SuccessLogin @"登录成功"
#define NicknameNil @"您用户名是空哦"
#define PswNil @"您忘了输入密码哦"
#define NoInfo @"用户名或密码错误"
#define PswCantChange @"密码修改失败"

#define SuccessPassCode @"校验成功"
#define CodeFailCompare @"验证码错误"
#define CodeNil @"请输入验证码"
#define ErrorCode @"验证码输入有误"
#define SuccessRegist @"注册成功"
#define Registing @"注册中..."
#define PswLength @"密码位数要达到6位以上哦"
#define RepeatNickname @"这个昵称很热，很多人都在用哦"
#define SuccessPsw @"修改成功"
#define SuccessAdvice @"反馈成功"
#define SuccessUpload @"上传成功,待审核"
#define TitleNil @"标题不能为空"
#define ImageNil @"请选择图片"
#define AlreadySent @"验证码已发"
#define ChineseTip @"密码需要至少6个字符（字母、数字或下划线）"

#define UploadingData @"上传中..."
#define NNameChanging @"修改中..."
#define ClearDone @"清理完成"
#define CacheClearing @"缓存清理中..."

#define Searching @"搜索中..."

//--------------------------------end---------------------------------

#endif