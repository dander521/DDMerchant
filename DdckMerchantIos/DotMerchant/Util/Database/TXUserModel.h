//
//  TXUserModel.h
//  TailorX
//
//  Created by Qian Shen on 24/3/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TXUserModel : NSObject

/** 是否登录*/
@property (nonatomic, copy) NSString *isLogin; // 1:已登录 其他：未登录
/** 令牌*/
@property (nonatomic, copy) NSString *st;
/** TGT*/
@property (nonatomic, copy) NSString *tgt;
/** udid*/
@property (nonatomic, copy) NSString *udid;
/** Token*/
@property (nonatomic, copy) NSString *deviceToken;
/** 密码*/
@property (nonatomic, copy) NSString *password;
/** 用户名（登录时录入）*/
@property (nonatomic, copy) NSString *accountA;
/** 用户名（获取时使用）*/


@property (nonatomic, copy) NSString *openType;

/** 第三方注册标记 */
@property (nonatomic, copy) NSString *thirdGisterSign;

/*****************************OPENSDK*********************************/

@property (nonatomic, copy) NSString *accessToken;

@property (nonatomic, copy) NSString *unionId;

@property (nonatomic, copy) NSString *openId;

/*****************************获取用户个人信息-返回*********************************/

/** 用户当前所在的城市 */
@property (nonatomic, strong) NSString *currentCity;
/** 用户当前的经度 */
@property (nonatomic, strong) NSString *longitude;
/** 用户当前的纬度 */
@property (nonatomic, strong) NSString *latitude;
/** 默认地址 */
@property (nonatomic, strong) NSString *address;
/** */
@property (nonatomic, strong) NSString *genderText;
/** 客户联系电话 */
@property (nonatomic, strong) NSString *phone;
/** 头像 */
@property (nonatomic, strong) NSString *photo;
/** 性别 女 0 男 1 */
@property (nonatomic, assign) NSInteger gender;
/** 用户ID */
@property (nonatomic, assign) NSInteger userId;
/** 身高cm */
@property (nonatomic, assign) NSInteger height;
/** 体重kg */
@property (nonatomic, assign) NSInteger weight;
/** 手机绑定时间 */
@property (nonatomic, assign) NSInteger mobileBindDate;
/** 是否设置身体数据 */
@property (nonatomic, assign) BOOL hasBodyData;
/** 是否完善个人资料 */
@property (nonatomic, assign) BOOL hasFinishCustomerInfo;
/** 支付宝是否绑定 */
@property (nonatomic, assign) BOOL payBind;
/** 微信是否绑定 */
@property (nonatomic, assign) BOOL weixinBind;
/** qq是否绑定 */
@property (nonatomic, assign) BOOL qqBind;
/** 是否实名认证 */
@property (nonatomic, assign) BOOL realAuth;
/** 实名认证视频上传路径 */
@property (nonatomic, strong) NSString *videoPath;

/*****************************获取用户个人信息-返回*********************************/

/** 未读消息数量 */
@property (nonatomic, assign) NSInteger unreadMsgCount;
/** 推送的id */
@property (nonatomic, strong) NSString * deviceID;
/** 是否显示咨询引导页 */
@property (nonatomic, assign) BOOL isShowLeading;

/** 环信是否登录成功 */
@property (nonatomic, assign) BOOL hxLoginStatus;

/** 上次登录的用户 */
@property (nonatomic, strong) NSString *lastLoginAccount;



/*------------------------------------------------------------------------*/

@property (nonatomic, strong) NSString * aliAccount; // 支付宝帐号
@property (nonatomic, strong) NSString * aliName; // 支付宝姓名
@property (nonatomic, strong) NSString * auditStatus; // 实名开店申请状态 ””:未申请，0：已申请，1：未通过2：已通过
@property (nonatomic, strong) NSString * card; // 身份证号
@property (nonatomic, strong) NSString * face; // 头像
@property (nonatomic, strong) NSString * nickName; // 昵称
@property (nonatomic, assign) NSInteger paperId; // 纸巾是否开通（0：未开通，非0为已开通）
@property (nonatomic, assign) NSInteger shopId; // 店铺ID（0：未申请店铺，非0为已开通）
@property (nonatomic, assign) NSInteger shopStatus; // 店铺状态（1：营业，2：停业）
@property (nonatomic, strong) NSString * token; // 登录token
@property (nonatomic, assign) NSInteger userType; // 用户类型1：用户2：商家
@property (nonatomic, assign) NSInteger pushMsg;
@property (nonatomic, copy) NSString *account;
@property (nonatomic, strong) NSString *bank;
@property (nonatomic, strong) NSString *bankCard;
@property (nonatomic, strong) NSString *bankName;


/*________________________________________________________________________*/

+ (TXUserModel *)defaultUser;

/**
 * 清楚用户数据
 */
- (void)resetModelData;

/**
 * 字典转模型
 */
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

/**
 判断用户登录状态

 @return true：登录 false：未登录
 */
- (BOOL)userLoginStatus;

/**
 是否开通纸巾

 @return true 开通 false 未开通
 */
- (BOOL)isOpenPaper;

@end
