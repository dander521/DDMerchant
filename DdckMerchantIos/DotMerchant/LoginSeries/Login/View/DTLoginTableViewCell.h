//
//  DTLoginTableViewCell.h
//  DotCustomer
//
//  Created by 倩倩 on 2017/10/16.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DTLoginTableViewCellDelegate <NSObject>

- (void)touchLoginButton;

- (void)touchRetrieveButton;

- (void)touchRegisterButton;

@end

@interface DTLoginTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *secondBgView;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *pwdTF;

@property (assign, nonatomic) id <DTLoginTableViewCellDelegate> delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
