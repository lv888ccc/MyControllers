//
//  CCClientRequest.h
//  WoZaiXianChang
//
//  Created by lcc on 13-9-17.
//  Copyright (c) 2013年 lcc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCClientRequest : NSObject

@property (weak) id c_delegate;

//首页
- (void) homeNewsType;

//启动图
- (void) startImg;

//首页－左边栏目
- (void) leftLanMu;

//版本更新
- (void) checkUpdate;

//天气
- (void) weatherInfo;

//新闻类型详情
- (void) newsTypeDetailWithId:(NSString *) newsId;
//新闻评论列表
- (void) newsCommentWithId:(NSString *) newsId pageNo:(NSInteger) pageNo;
//新闻评论提交
- (void) commitCommentWithContent:(NSString *) comment newsId:(NSString *) newsId userId:(NSString *) userId;

//三门广告新闻广告图
- (void) sanMenTopAd;

//新闻 - 新闻 - 天下 - 视频
- (void) newsSanMenWithPageNo:(NSInteger) pageNo; //新闻
- (void) newsWorld; //天下
- (void) newsVideoWithPageNo:(NSInteger) pageNo;//视频
- (void) worldDetailWithId:(NSString *) newsId;//天下详情
- (void) newsThemeWithPageNo:(NSInteger) pageNo;//新闻详情
- (void) newsThemeListWithPageNo:(NSInteger) pageNo themeId:(NSString *) themeId;//新闻专题详情列表

//政务-公告公示-政府公开-权力公开
- (void) zhengWuPublicNoticeWithPageNo:(NSInteger) pageNo;
- (void) zhengWuGovernmentWithPageNo:(NSInteger) pageNo;
- (void) zhengWuPowerOpenWithPageNo:(NSInteger) pageNo;

//县情 - 关于三门 - 旅游景点 - 特色小吃 - 视频新闻
- (void) localNewsAboutSanMenWithPageNo:(NSInteger) pageNo;
- (void) localNewsInterestingPlaceWithPageNo:(NSInteger) pageNo;
- (void) localNewsEatWithPageNo:(NSInteger) pageNo;
- (void) localNewsVideoWithPageNo:(NSInteger) pageNo;

//美食 - 餐饮 - 外卖电话 - 酒店住宿
- (void) foodEatWithPageNo:(NSInteger) pageNo;
- (void) foodPhoneWithPageNo:(NSInteger) pageNo;
- (void) foodLiveWithPageNo:(NSInteger) pageNo;

//发布
- (void) publishWithPageNo:(NSInteger) pageNo;

//广播节目单
- (void) broadOrder;

//活动
- (void) activityWithPageNo:(NSInteger) pageNo;

//通知发送验证码-校验验证码-完成注册
- (void) noticeSendMsgWithPhoneNo:(NSString *)phoneNo type:(NSString *) typeString;
- (void) compareCodeWithPhoneNo:(NSString *)phoneNo type:(NSString *) typeString code:(NSString *) codeString;
- (void) finishRegistWithPhoneNo:(NSString *)phoneNo nickname:(NSString *) nickname psw:(NSString *) password;
- (void) commitPswWithPhoneNo:(NSString *)phoneNo psw:(NSString *) password;

//用户登陆
- (void) userLoginWithPhoneNo:(NSString *)phoneNo psw:(NSString *) password;

//更改昵称
- (void) changeNicknameWithUid:(NSString *)uId nickname:(NSString *) nickname;

//拍客-随手拍-主题
- (void) paikeUserWithPageNo:(NSInteger) pageNo;
- (void) paikeThemeWithPageNo:(NSInteger) pageNo;

//主题二级
- (void) paikeThemeDetailWithPageNo:(NSInteger) pageNo pId:(NSString *)pId;

//拍客详情
- (void) paikeContentDetailWithPid:(NSString *) pId;

//拍客浏览图片
- (void) paikeImgDetailWithPid:(NSString *) pId;
//拍客评论
- (void) paikeCommentDetailWithPageNo:(NSInteger) pageNo pid:(NSString *) pId;

//拍客评论提交
- (void) paikeCommitCommentWithContent:(NSString *) comment pId:(NSString *) pId userId:(NSString *) userId;

//意见反馈
- (void) goodAdviceWithDeviceNum:(NSString *) deviceNum sysVer:(NSString *) sysVer curVer:(NSString *) curVer content:(NSString *) content linkMethod:(NSString *)linkMethod userId:(NSString *) userId;

//ftp信息获取
- (void) ftpInfo;

//上传
- (void) uploadPicWithParam:(NSString *) param;

//专栏首页
- (void) themeHomeWithPageNo:(NSInteger) pageNo;
//专栏列表
- (void) themeHomeListWithPageNo:(NSInteger) pageNo tId:(NSString *) tId;

//电话列表
- (void) phoneNOList;

//电影首页列表
- (void) movieHomeList;
//电影院列表详情
- (void) movieDetailListWithCId:(NSString *) cId;
//电影详情
- (void) movieDetailListDetailInfoWithMId:(NSString *) mId;

//新华书讯
- (void) xinHuaBookNewsWithPageNo:(NSInteger) pageNo;
//畅销榜
- (void) hotSellBookNewsWithPageNo:(NSInteger) pageNo;
//精彩书评
- (void) wondefullBookCommentWithPageNo:(NSInteger) pageNo;
//自行车
- (void) cBikeAddressNews;

@end
