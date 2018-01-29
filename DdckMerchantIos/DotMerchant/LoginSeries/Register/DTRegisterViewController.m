//
//  DTRegisterViewController.m
//  DotMerchant
//
//  Created by 倩倩 on 2017/9/14.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTRegisterViewController.h"

@interface DTRegisterViewController ()

@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *pincodeTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UITextField *confirmTF;

@property (weak, nonatomic) IBOutlet UIButton *getPincodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

@end

@implementation DTRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"注册";
    
    [self addLeftBarButtonItem];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)textFieldDidChange:(NSNotification *)noti {
    if (self.phoneTF.text.length != 0 &&
        self.pincodeTF.text.length != 0 &&
        self.passwordTF.text.length != 0 &&
        self.confirmTF.text.length != 0) {
        self.registerBtn.enabled = true;
        [self.registerBtn setBackgroundColor:RGB(246, 30, 46)];
    } else {
        self.registerBtn.enabled = false;
        [self.registerBtn setBackgroundColor:RGB(153, 153, 153)];
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
    [[RCHttpHelper sharedHelper] getUrl:[httpHost stringByAppendingPathComponent:pincodeMsg] headParams:nil bodyParams:@{@"phone" : self.phoneTF.text, @"type" : @"1"} success:^(AFHTTPSessionManager *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view];
        [ShowMessage showMessage:responseObject[@"msg"]];
        if ([responseObject[@"status"] integerValue] == 1) {
            
        }
    } failure:^(AFHTTPSessionManager *operation, NSError *error) {
        [ShowMessage showMessage:error.description];
        [MBProgressHUD hideHUDForView:self.view];
    }];
}

- (IBAction)touchRegisterBtn:(id)sender {
    
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
    [[RCHttpHelper sharedHelper] postUrl:[httpHost stringByAppendingPathComponent:registerInterface] headParams:nil bodyParams:@{@"account" : self.phoneTF.text,@"password" : self.passwordTF.text,@"rPassword" : self.confirmTF.text,@"code" : self.pincodeTF.text} success:^(AFHTTPSessionManager *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view];
        [ShowMessage showMessage:responseObject[@"msg"]];
        if ([responseObject[@"status"] integerValue] == 1) {
            // 通知个人中心页面处理数据
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRegisterSuccess object:nil];
            TXUserModel *model = [TXUserModel defaultUser];
            model = [model initWithDictionary:responseObject[@"data"]];
            [TXModelAchivar achiveUserModel];
    
            [self backAction];
        }
    } failure:^(AFHTTPSessionManager *operation, NSError *error) {
        [ShowMessage showMessage:error.description];
        [MBProgressHUD hideHUDForView:self.view];
    }];
}

- (void)addLeftBarButtonItem {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_nav_arrow"]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(backAction)];
}

- (void)backAction {
    if (self.isFromLogin) {
        [self.navigationController popViewControllerAnimated:true];
        return;
    }
    CATransition *transition = [CATransition animation];
    transition.duration = 0.25f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionReveal;
    transition.subtype = kCATransitionFromBottom;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController popViewControllerAnimated:NO];
}

@end
