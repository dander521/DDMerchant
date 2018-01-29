//
//  DTBindAliViewController.m
//  DotMerchant
//
//  Created by 倩倩 on 2017/9/17.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTBindAliViewController.h"

@interface DTBindAliViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *alipayTF;
@property (weak, nonatomic) IBOutlet UIButton *bindBtn;
@property (weak, nonatomic) IBOutlet UILabel *desLabel;
@property (weak, nonatomic) IBOutlet UILabel *noDesLabel;
@property (weak, nonatomic) IBOutlet UITextField *pincodeTF;
@property (weak, nonatomic) IBOutlet UIButton *pincodeBtn;
@property (weak, nonatomic) IBOutlet UIView *pincodeView;
@property (weak, nonatomic) IBOutlet UIView *bankNameView;
@property (weak, nonatomic) IBOutlet UITextField *bankNameTF;

@end

@implementation DTBindAliViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.isBind) {
        self.navigationItem.title = self.isBindAli ? @"支付宝解绑" : @"银行卡解绑";
    } else {
        self.navigationItem.title = self.isBindAli ? @"支付宝绑定" : @"银行卡";
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    
    self.pincodeBtn.layer.cornerRadius = 15;
    self.pincodeBtn.layer.masksToBounds = true;
    
    if (self.isBindAli) {
        if (![NSString isTextEmpty:[TXModelAchivar getUserModel].aliName]) {
            self.nameTF.text = [TXModelAchivar getUserModel].aliName;
        }
        if (![NSString isTextEmpty:[TXModelAchivar getUserModel].aliAccount]) {
            self.alipayTF.text = [TXModelAchivar getUserModel].aliAccount;
        }
        self.desLabel.text = @"支付宝绑定后方可提现";
        self.noDesLabel.text = @"支付宝账号:";
        self.alipayTF.placeholder = @"请输入您的支付宝账号";
        [self.bankNameView removeFromSuperview];
    } else {
        
        if (![NSString isTextEmpty:[TXModelAchivar getUserModel].bank]) {
            self.bankNameTF.text = [TXModelAchivar getUserModel].bank;
        }
        if (![NSString isTextEmpty:[TXModelAchivar getUserModel].bankCard]) {
            self.alipayTF.text = [TXModelAchivar getUserModel].bankCard;
        }
        if (![NSString isTextEmpty:[TXModelAchivar getUserModel].bankName]) {
            self.nameTF.text = [TXModelAchivar getUserModel].bankName;
        }
        
        self.desLabel.text = @"银行卡绑定后方可提现";
        self.noDesLabel.text = @"银行卡账号:";
        self.alipayTF.placeholder = @"请输入您的银行卡账号";
    }
    
    if (self.isBind) {
        [self.pincodeView removeFromSuperview];
        
        self.alipayTF.enabled = false;
        self.bankNameTF.enabled = false;
        self.pincodeTF.enabled = false;
        self.nameTF.enabled = false;
        self.bindBtn.enabled = true;
        [self.bindBtn setBackgroundColor:RGB(246, 30, 46)];
        [self.bindBtn setTitle:@"解除绑定" forState:UIControlStateNormal];
    } else {
        self.bindBtn.enabled = false;
        [self.bindBtn setBackgroundColor:RGB(153, 153, 153)];
        [self.bindBtn setTitle:@"确认绑定" forState:UIControlStateNormal];
    }
}

- (void)textFieldDidChange:(NSNotification *)noti {
    if (!self.isBind) {
        if (self.isBindAli) {
            if (self.nameTF.text.length != 0 &&
                self.alipayTF.text.length != 0 &&
                self.pincodeTF.text.length != 0) {
                self.bindBtn.enabled = true;
                [self.bindBtn setBackgroundColor:RGB(246, 30, 46)];
            } else {
                self.bindBtn.enabled = false;
                [self.bindBtn setBackgroundColor:RGB(153, 153, 153)];
            }
        } else {
            if (self.nameTF.text.length != 0 &&
                self.alipayTF.text.length != 0 &&
                self.bankNameTF.text.length != 0 &&
                self.pincodeTF.text.length != 0) {
                self.bindBtn.enabled = true;
                [self.bindBtn setBackgroundColor:RGB(246, 30, 46)];
            } else {
                self.bindBtn.enabled = false;
                [self.bindBtn setBackgroundColor:RGB(153, 153, 153)];
            }
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)touchBindAlipayBtn:(id)sender {
    if (![NSString checkUserName:self.nameTF.text]) {
        [ShowMessage showMessage:@"请输入正确的联系人"];
        return;
    }
    
    if (![[TXUserModel defaultUser] userLoginStatus]) {
        [ShowMessage showMessage:@"请登录"];
        return;
    }
    if (!self.isBind) {
        if (self.isBindAli) {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [[RCHttpHelper sharedHelper] postUrl:[httpHost stringByAppendingPathComponent:bindAplipay] headParams:@{@"token" : [TXModelAchivar getUserModel].token} bodyParams:@{@"name" : self.nameTF.text, @"account" : self.alipayTF.text, @"code" : self.pincodeTF.text} success:^(AFHTTPSessionManager *operation, id responseObject) {
                [MBProgressHUD hideHUDForView:self.view];
                if ([responseObject[@"status"] integerValue] == 1) {
                    [ShowMessage showMessage:@"绑定审核中"];
                    [TXModelAchivar updateUserModelWithKey:@"aliAccount" value:self.alipayTF.text];
                    [TXModelAchivar updateUserModelWithKey:@"aliName" value:self.nameTF.text];
                    [self.navigationController popViewControllerAnimated:true];
                } else {
                    [ShowMessage showMessage:responseObject[@"msg"]];
                }
            } failure:^(AFHTTPSessionManager *operation, NSError *error) {
                [ShowMessage showMessage:error.description];
                [MBProgressHUD hideHUDForView:self.view];
            }];
        } else {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [[RCHttpHelper sharedHelper] postUrl:[httpHost stringByAppendingPathComponent:bindBankCard] headParams:@{@"token" : [TXModelAchivar getUserModel].token} bodyParams:@{@"name" : self.nameTF.text, @"card" : self.alipayTF.text, @"bank" : self.bankNameTF.text, @"code" : self.pincodeTF.text} success:^(AFHTTPSessionManager *operation, id responseObject) {
                [MBProgressHUD hideHUDForView:self.view];
                if ([responseObject[@"status"] integerValue] == 1) {
                    [TXModelAchivar updateUserModelWithKey:@"bankName" value:self.nameTF.text];
                    [TXModelAchivar updateUserModelWithKey:@"bank" value:self.bankNameTF.text];
                    [TXModelAchivar updateUserModelWithKey:@"bankCard" value:self.alipayTF.text];
                    [ShowMessage showMessage:@"绑定审核中"];
                    [self.navigationController popViewControllerAnimated:true];
                } else {
                    [ShowMessage showMessage:responseObject[@"msg"]];
                }
            } failure:^(AFHTTPSessionManager *operation, NSError *error) {
                [ShowMessage showMessage:error.description];
                [MBProgressHUD hideHUDForView:self.view];
            }];
        }
    } else {
        weakSelf(self);
        UIAlertController *vwcAlert = [UIAlertController alertControllerWithTitle:@"确定解绑" message:@"您确定要解除支付宝绑定吗？" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf disbindAlipay];
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf dismissViewControllerAnimated:true completion:nil];
        }];
        
        [vwcAlert addAction:sureAction];
        [vwcAlert addAction:cancelAction];
        
        [self presentViewController:vwcAlert animated:true completion:nil];
        
    }
    
}

// 解除绑定
- (void)disbindAlipay {
    
    NSString *url = self.isBindAli ? disbindAli : disbindBank;

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[RCHttpHelper sharedHelper] getUrl:[httpHost stringByAppendingPathComponent:url] headParams:@{@"token" : [TXModelAchivar getUserModel].token} bodyParams:nil success:^(AFHTTPSessionManager *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view];
        if ([responseObject[@"status"] integerValue] == 1) {
            [ShowMessage showMessage:@"解绑成功"];
            if (self.isBindAli) {
                [TXModelAchivar updateUserModelWithKey:@"aliAccount" value:@""];
                [TXModelAchivar updateUserModelWithKey:@"aliName" value:@""];
            } else {
                [TXModelAchivar updateUserModelWithKey:@"bank" value:@""];
                [TXModelAchivar updateUserModelWithKey:@"bankCard" value:@""];
                [TXModelAchivar updateUserModelWithKey:@"bankName" value:@""];
            }
            
            [self.navigationController popViewControllerAnimated:true];
        } else {
            [ShowMessage showMessage:responseObject[@"msg"]];
        }
    } failure:^(AFHTTPSessionManager *operation, NSError *error) {
        [ShowMessage showMessage:error.description];
        [MBProgressHUD hideHUDForView:self.view];
    }];
}

- (IBAction)touchGetPincodeButton:(id)sender {
    [[TXCountDownTime sharedTXCountDownTime] startWithTime:60 title:@"获取验证码" countDownTitle:@"重新获取" mainColor:RGB(246, 30, 46) countColor:[UIColor lightGrayColor] atBtn:self.pincodeBtn];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *codeType = self.isBindAli ? @"3" : @"4";

    [[RCHttpHelper sharedHelper] getUrl:[httpHost stringByAppendingPathComponent:pincodeMsg] headParams:nil bodyParams:@{@"phone" : [TXModelAchivar getUserModel].account, @"type" : codeType} success:^(AFHTTPSessionManager *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view];
        [ShowMessage showMessage:responseObject[@"msg"]];
        if ([responseObject[@"status"] integerValue] == 1) {
            
        }
    } failure:^(AFHTTPSessionManager *operation, NSError *error) {
        [ShowMessage showMessage:error.description];
        [MBProgressHUD hideHUDForView:self.view];
    }];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
