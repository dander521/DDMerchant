//
//  DTPersonalCenterHeaderView.h
//  DotMerchant
//
//  Created by 倩倩 on 2017/9/14.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 头部显示方式
 */
typedef NS_ENUM(NSUInteger, DTPersonalHeaderShowType) {
    DTPersonalHeaderShowTypeIsLogin, /**< 已登录 */
    DTPersonalHeaderShowTypeNotLogin /**< 未登录 */
};

@protocol DTPersonalCenterHeaderViewDelegate <NSObject>

- (void)touchLoginButton;

- (void)touchRegisterButton;

- (void)touchUserAvatar;

@end

@interface DTPersonalCenterHeaderView : UIView

@property (nonatomic, assign) id<DTPersonalCenterHeaderViewDelegate>delegate;
@property (nonatomic, assign) DTPersonalHeaderShowType showType;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *storeImageView;

/**
 *  实例方法
 */
+ (instancetype)instanceView;

@end
