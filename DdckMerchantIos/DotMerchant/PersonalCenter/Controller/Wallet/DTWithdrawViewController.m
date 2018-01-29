//
//  DTWithdrawViewController.m
//  DotMerchant
//
//  Created by 倩倩 on 2017/9/17.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTWithdrawViewController.h"

@interface DTWithdrawViewController ()
@property (weak, nonatomic) IBOutlet UITextField *inputTF;

@property (weak, nonatomic) IBOutlet UILabel *withdrawTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *withdrawBtn;
@property (weak, nonatomic) IBOutlet UILabel *userTxMinLabel;
@property (weak, nonatomic) IBOutlet UILabel *pumpingMoneyLabel;

@property (weak, nonatomic) IBOutlet UIButton *aliBtn;
@property (weak, nonatomic) IBOutlet UIButton *bankBtn;

/** <#description#> */
@property (nonatomic, assign) NSInteger withType;

@end

@implementation DTWithdrawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"提现";
    self.withType = 1;
    [self.aliBtn setImage:[UIImage imageNamed:@"ic_selected"] forState:UIControlStateNormal];
    [self.bankBtn setImage:[UIImage imageNamed:@"ic_unselected"] forState:UIControlStateNormal];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    [self loadLimitData];
}

- (void)textFieldDidChange:(NSNotification *)noti {
    if (self.inputTF.text.length != 0) {
        self.withdrawBtn.enabled = true;
        [self.withdrawBtn setBackgroundColor:RGB(246, 30, 46)];
    } else {
        self.withdrawBtn.enabled = false;
        [self.withdrawBtn setBackgroundColor:RGB(153, 153, 153)];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)touchWithdrawBtn:(id)sender {
    
    if (![[TXUserModel defaultUser] userLoginStatus]) {
        [ShowMessage showMessage:@"请登录"];
        return;
    }
    
    // 提交提现数据
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
    
    [[RCHttpHelper sharedHelper] postUrl:[httpHost stringByAppendingPathComponent:withdrawApply] headParams:@{@"token":[TXModelAchivar getUserModel].token} bodyParams:@{@"money":self.inputTF.text, @"type" : [NSString stringWithFormat:@"%zd", self.withType]} success:^(AFHTTPSessionManager *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view];
        if ([responseObject[@"status"] integerValue] == 1) {
            [self.navigationController popViewControllerAnimated:true];
        }
        [ShowMessage showMessage:responseObject[@"msg"]];
    } failure:^(AFHTTPSessionManager *operation, NSError *error) {
        [ShowMessage showMessage:error.description];
        [MBProgressHUD hideHUDForView:self.view];
    }];
}

// 获取限制次数接口
- (void)loadLimitData {
    if (![[TXUserModel defaultUser] userLoginStatus]) {
        [ShowMessage showMessage:@"请登录"];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
    
    [[RCHttpHelper sharedHelper] getUrl:[httpHost stringByAppendingPathComponent:withdrawInfo] headParams:@{@"token":[TXModelAchivar getUserModel].token} bodyParams:nil success:^(AFHTTPSessionManager *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view];
        if ([responseObject[@"status"] integerValue] == 1) {
            self.withdrawTimeLabel.text = [NSString stringWithFormat:@"%zd", [responseObject[@"data"][@"count"] integerValue]];
            self.userTxMinLabel.text = [NSString stringWithFormat:@"最低%zd元起提(建议一个月提现一次省手续费)", [responseObject[@"data"][@"minMoney"] integerValue]];
            NSLog(@"抽成百分比 %@", responseObject[@"data"][@"pumping"]);
        }
        [ShowMessage showMessage:responseObject[@"msg"]];
    } failure:^(AFHTTPSessionManager *operation, NSError *error) {
        [ShowMessage showMessage:error.description];
        [MBProgressHUD hideHUDForView:self.view];
    }];
    
}

- (IBAction)touchAliButton:(id)sender {
    self.withType = 1;
    [self.aliBtn setImage:[UIImage imageNamed:@"ic_selected"] forState:UIControlStateNormal];
    [self.bankBtn setImage:[UIImage imageNamed:@"ic_unselected"] forState:UIControlStateNormal];
}

- (IBAction)touchBankButton:(id)sender {
    self.withType = 2;
    [self.aliBtn setImage:[UIImage imageNamed:@"ic_unselected"] forState:UIControlStateNormal];
    [self.bankBtn setImage:[UIImage imageNamed:@"ic_selected"] forState:UIControlStateNormal];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
