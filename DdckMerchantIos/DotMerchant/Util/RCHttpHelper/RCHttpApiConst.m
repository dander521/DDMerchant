//
//  RCHttpApiConst.m
//  DotMerchant
//
//  Created by 倩倩 on 2017/10/24.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "RCHttpApiConst.h"

@implementation RCHttpApiConst

/** http host */
NSString * const httpHost = @"http://www.diandiancangku.com/ddckback";
NSString * const imageHost = @"http://www.diandiancangku.com/img";

/** register */
NSString * const registerInterface = @"user/register";
/** login */
NSString * const loginInterface = @"user/login";
/** retrieve */
NSString * const retrieveInterface = @"user/forgetPwd";
/** bindAli */
NSString * const bindAplipay = @"user/bindZFB";
/** balance */
NSString * const getBalance = @"user/balanceInfo";

/** apply shop */
NSString * const applyShop = @"shop/apply";
/** shop info */
NSString * const shopInfo = @"shop/info";
/** save shop info */
NSString * const saveShopInfo = @"shop/save";
/** payback info */
NSString * const paybackInfo = @"shop/packetInfo";
/** save pay back info */
NSString * const savePaybackInfo = @"shop/packetSave";

/** notification list */
NSString * const messageList = @"message/list";

/** add goods */
NSString * const addGoods = @"product/append";
/** add goods category */
NSString * const addGoodsCategory = @"product/appendType";
/** goods category info */
NSString * const goodsCategoryInfo = @"product/productType";
/** delete goods category */
NSString * const deleteGoodsCategory = @"product/trunType";
/** goods list */
NSString * const goodsList = @"product/sList";
/** goods up or down */
NSString * const goodsUpOrDown = @"product/pullOrDown";
/** godos detail */
NSString * const goodsInfo = @"product/details";
/** delete goods */
NSString * const deleteGoods = @"product/delete";
/** add coupon */
NSString * const addCoupon = @"product/addCoupon";

/** paper list */
NSString * const paperManager = @"paper/list";
/** apply paper */
NSString * const applyPaper = @"paper/salerApply";

/** comment info list */
NSString * const commentList = @"comment/list";
/** comment reply */
NSString * const commentReply = @"comment/reply";

/** order list */
NSString * const orderList = @"order/list";
/** use ticket */
NSString * const orderUseTicket = @"order/use";
/** appeal order */
NSString * const orderAppeal = @"order/complaint";
/** appeal order upload pic */
NSString * const orderCommentPicUp = @"common/upload";

/** advertisement company */
NSString * const advertisementCompany = @"common/notice";
/** first category info */
NSString * const firstCategory = @"common/firstType";
/** second category info */
NSString * const secondCategory = @"common/twoType";
/** get pincode */
NSString * const pincodeMsg = @"common/sendSms";
/** get store work on status */
NSString * const storeWorkOrNot = @"shop/status";
/** store statistics */
NSString * const storeStatistics = @"revenue/statistics";
/** store orders amount and income */
NSString * const storeTotalOrderInfo = @"revenue/totalInfo";

/** withdraw info */
NSString * const withdrawInfo = @"withdrawals/info";
/** apply withdraw */
NSString * const withdrawApply = @"withdrawals/apply";
/** employee stock info */
NSString * const employeeStockInfo = @"thigh/info";
/** feed back */
NSString * const feedback = @"common/opinion";
/** about us */
NSString * const aboutUs = @"common/aboutUs";
/** upload more than one pic */
NSString * const multiPicUpload = @"common/uploads";

/** get alipay order sign */
NSString * const payOrderSign = @"pay/getPayOrderSign";
/** refund stock */
NSString * const refundStock = @"thigh/refund";
/** get check information */
NSString * const getCheckInfo = @"user/getAuditStatus";
/** bind bank card */
NSString * const bindBankCard = @"user/bindBank";
/** bind bank card */
NSString * const employeeStockRules = @"common/thighRule";
NSString * const contactUs = @"common/contactUs";
NSString * const shareContent = @"common/share";

NSString * const couponList = @"product/couponList";
NSString * const couponInfo = @"product/couponDetail";
NSString * const couponDelete = @"product/couponDelete";
NSString * const couponStatus = @"product/couponStatus";
NSString * const getAuditStatus = @"user/getAuditStatus";

NSString * const shopType = @"product/shopType";
NSString * const disbindAli = @"user/unBindZFB";
NSString * const disbindBank = @"user/unBindBank";

@end

