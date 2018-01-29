//
//  RCHttpApiConst.h
//  DotMerchant
//
//  Created by 倩倩 on 2017/10/24.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RCHttpApiConst : NSObject

/** http host */
extern NSString * const httpHost;
extern NSString * const imageHost;

/** register */
extern NSString * const registerInterface;
/** login */
extern NSString * const loginInterface;
/** retrieve */
extern NSString * const retrieveInterface;
/** bindAli */
extern NSString * const bindAplipay;
/** balance */
extern NSString * const getBalance;

/** apply shop */
extern NSString * const applyShop;
/** shop info */
extern NSString * const shopInfo;
/** save shop info */
extern NSString * const saveShopInfo;
/** payback info */
extern NSString * const paybackInfo;
/** save pay back info */
extern NSString * const savePaybackInfo;

/** notification list */
extern NSString * const messageList;

/** add goods */
extern NSString * const addGoods;
/** add goods category */
extern NSString * const addGoodsCategory;
/** goods category info */
extern NSString * const goodsCategoryInfo;
/** delete goods category */
extern NSString * const deleteGoodsCategory;
/** goods list */
extern NSString * const goodsList;
/** goods up or down */
extern NSString * const goodsUpOrDown;
/** godos detail */
extern NSString * const goodsInfo;
/** delete goods */
extern NSString * const deleteGoods;
/** add coupon */
extern NSString * const addCoupon;

/** paper list */
extern NSString * const paperManager;
/** apply paper */
extern NSString * const applyPaper;

/** comment info list */
extern NSString * const commentList;
/** comment reply */
extern NSString * const commentReply;

/** order list */
extern NSString * const orderList;
/** use ticket */
extern NSString * const orderUseTicket;
/** appeal order */
extern NSString * const orderAppeal;
/** appeal order upload pic */
extern NSString * const orderCommentPicUp;

/** advertisement company */
extern NSString * const advertisementCompany;
/** first category info */
extern NSString * const firstCategory;
/** second category info */
extern NSString * const secondCategory;
/** get pincode */
extern NSString * const pincodeMsg;
/** get store work on status */
extern NSString * const storeWorkOrNot;
/** store statistics */
extern NSString * const storeStatistics;
/** store orders amount and income */
extern NSString * const storeTotalOrderInfo;

/** withdraw info */
extern NSString * const withdrawInfo;
/** apply withdraw */
extern NSString * const withdrawApply;
/** employee stock info */
extern NSString * const employeeStockInfo;
/** feed back */
extern NSString * const feedback;
/** about us */
extern NSString * const aboutUs;
/** upload more than one pic */
extern NSString * const multiPicUpload;
/** get alipay order sign */
extern NSString * const payOrderSign;
/** refund stock */
extern NSString * const refundStock;
/** get check information */
extern NSString * const getCheckInfo;
/** bind bank card */
extern NSString * const bindBankCard;
/** bind bank card */
extern NSString * const employeeStockRules;


extern NSString * const contactUs;
extern NSString * const shareContent;

extern NSString * const couponList;
extern NSString * const couponInfo;
extern NSString * const couponDelete;
extern NSString * const couponStatus;
extern NSString * const getAuditStatus;

extern NSString * const shopType;
extern NSString * const disbindAli;
extern NSString * const disbindBank;

@end
