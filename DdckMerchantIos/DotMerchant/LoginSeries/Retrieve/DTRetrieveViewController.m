//
//  DTRetrieveViewController.m
//  DotMerchant
//
//  Created by 倩倩 on 2017/9/14.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTRetrieveViewController.h"

@interface DTRetrieveViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *pincodeTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UITextField *confirmTF;
@property (weak, nonatomic) IBOutlet UIButton *getPincodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *retrieveBtn;

@end

@implementation DTRetrieveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = self.isSetSecret ? @"修改密码" : @"忘记密码";
    if (self.isSetSecret) {
        self.phoneTF.enabled = false;
    }
    self.phoneTF.text = [TXModelAchivar getUserModel].account;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)textFieldDidChange:(NSNotification *)noti {
    if (self.phoneTF.text.length != 0 &&
        self.pincodeTF.text.length != 0 &&
        self.passwordTF.text.length != 0 &&
        self.confirmTF.text.length != 0) {
        self.retrieveBtn.enabled = true;
        [self.retrieveBtn setBackgroundColor:RGB(246, 30, 46)];
    } else {
        self.retrieveBtn.enabled = false;
        [self.retrieveBtn setBackgroundColor:RGB(153, 153, 153)];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)touchGetPincodeBtn:(id)sender {
    if (![NSString isPhoneNumCorrectPhoneNum:self.phoneTF.text]) {
        [ShowMessage showMessage:@"请输入正确的手机号"];
        return;
    }
    
    [[TXCountDownTime sharedTXCountDownTime] startWithTime:60 title:@"获取验证码" countDownTitle:@"重新获取" mainColor:RGB(246, 30, 46) countColor:[UIColor lightGrayColor] atBtn:self.getPincodeBtn];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[RCHttpHelper sharedHelper] getUrl:[httpHost stringByAppendingPathComponent:pincodeMsg] headParams:nil bodyParams:@{@"phone" : self.phoneTF.text, @"type" : @"2"} success:^(AFHTTPSessionManager *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view];
        [ShowMessage showMessage:responseObject[@"msg"]];
        if ([responseObject[@"status"] integerValue] == 1) {
            
        }
    } failure:^(AFHTTPSessionManager *operation, NSError *error) {
        [ShowMessage showMessage:error.description];
        [MBProgressHUD hideHUDForView:self.view];
    }];
}

- (IBAction)touchRetrieveBtn:(id)sender {
    if (![NSString isPhoneNumCorrectPhoneNum:self.phoneTF.text]) {
        [ShowMessage showMessage:@"请输入正确的手机号"];
        return;
    }
    
    if (self.pincodeTF.text.length == 0) {
        [ShowMessage showMessage:@"请输入4位正确验证码"];
        return;
    }
    
    if (self.passwordTF.text.length < 6 || self.passwordTF.text.length > 20) {
        [ShowMessage showMessage:@"请输入6-20位数字和字母组成的密码"];
        return;
    }
    
    if (self.confirmTF.text.length < 6 || self.confirmTF.text.length > 20) {
        [ShowMessage showMessage:@"请输入6-20位数字和字母组成的密码"];
        return;
    }
    
    if (![self.passwordTF.text isEqualToString:self.confirmTF.text]) {
        [ShowMessage showMessage:@"两次输入密码不一致"];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[RCHttpHelper sharedHelper] postUrl:[httpHost stringByAppendingPathComponent:retrieveInterface] headParams:nil bodyParams:@{@"phone" : self.phoneTF.text,@"pwd" : self.passwordTF.text,@"rPwd" : self.confirmTF.text,@"code" : self.pincodeTF.text} success:^(AFHTTPSessionManager *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view];
        [ShowMessage showMessage:responseObject[@"msg"]];
        if ([responseObject[@"status"] integerValue] == 1) {
            
            if (self.isSetSecret) {
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationLoginOutSuccess object:nil userInfo:nil];
                [self.navigationController popToRootViewControllerAnimated:true];
            } else {
                [self.navigationController popViewControllerAnimated:true];
            }
        }
    } failure:^(AFHTTPSessionManager *operation, NSError *error) {
        [ShowMessage showMessage:error.description];
        [MBProgressHUD hideHUDForView:self.view];
    }];
}


@end
