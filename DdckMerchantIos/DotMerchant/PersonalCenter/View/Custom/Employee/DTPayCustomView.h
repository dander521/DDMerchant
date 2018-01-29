//
//  DTPayCustomView.h
//  DotMerchant
//
//  Created by 倩倩 on 2017/9/17.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, DTPayCustomViewPayType) {
    DTPayCustomViewPayTypeAli = 1,
    DTPayCustomViewPayTypeWechat
};

@protocol DTPayCustomViewDelegate <NSObject>

- (void)touchPayBtnWithPayType:(DTPayCustomViewPayType)type;

- (void)touchCloseViewButton;

@end

@interface DTPayCustomView : UIView<UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *wechatBtn;
@property (weak, nonatomic) IBOutlet UIButton *aliBtn;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (assign, nonatomic) id <DTPayCustomViewDelegate> delegate;

/** <#description#> */
@property (nonatomic, assign) DTPayCustomViewPayType payType;

+ (instancetype)shareInstanceManager;

- (void)show;

- (void)hide;

@end
