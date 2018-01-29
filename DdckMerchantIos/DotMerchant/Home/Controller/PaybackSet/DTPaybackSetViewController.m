//
//  DTPaybackSetViewController.m
//  DotMerchant
//
//  Created by 倩倩 on 2017/9/13.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTPaybackSetViewController.h"
#import "DTPaybackModel.h"

@interface DTPaybackSetViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UIButton *fixBtn;
@property (weak, nonatomic) IBOutlet UIButton *randomBtn;

@property (weak, nonatomic) IBOutlet UILabel *fixPerLabel;
@property (weak, nonatomic) IBOutlet UILabel *fixLabel;

@property (weak, nonatomic) IBOutlet UILabel *randomLabel;
@property (weak, nonatomic) IBOutlet UILabel *randomFromPerLabel;
@property (weak, nonatomic) IBOutlet UILabel *randomToPerLabel;
@property (weak, nonatomic) IBOutlet UILabel *randomDesLabel;
@property (weak, nonatomic) IBOutlet UILabel *randomMiddleLabel;

@property (weak, nonatomic) IBOutlet UITextField *fixTF;
@property (weak, nonatomic) IBOutlet UITextField *randomFromTF;
@property (weak, nonatomic) IBOutlet UITextField *randomToTF;

@property (weak, nonatomic) IBOutlet UIView *fixBgView;
@property (weak, nonatomic) IBOutlet UIView *randomFromBgView;
@property (weak, nonatomic) IBOutlet UIView *randomToBgView;

/** <#description#> */
@property (nonatomic, strong) DTPaybackModel *paybackModel;

@end

@implementation DTPaybackSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"红包设置";
    
    self.fixTF.delegate = self;
    
    self.randomFromTF.delegate = self;
    self.randomToTF.delegate = self;
    
    self.randomToBgView.layer.borderWidth = 1;
    self.randomToBgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.randomFromBgView.layer.borderWidth = 1;
    self.randomFromBgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)touchFixBtn:(id)sender {
    
    self.paybackModel.type = @"1";
    
    [self.fixBtn setImage:[UIImage imageNamed:@"ic_selected"] forState:UIControlStateNormal];
    self.fixPerLabel.textColor = RGB(246, 30, 46);
    self.fixBgView.backgroundColor = RGB(246, 30, 46);
    
    self.fixTF.text = self.paybackModel.rate;
    self.randomFromTF.text = self.paybackModel.minRate;
    self.randomToTF.text = self.paybackModel.maxRate;
    self.randomDesLabel.text = [NSString stringWithFormat:@"红包比例最低%@%%", self.paybackModel.minRateConf];
    
    [self.randomBtn setImage:[UIImage imageNamed:@"ic_unselected"] forState:UIControlStateNormal];
    self.randomFromPerLabel.textColor = RGB(184, 184, 184);
//    self.randomFromBgView.backgroundColor = RGB(184, 184, 184);
    self.randomToPerLabel.textColor = RGB(184, 184, 184);
//    self.randomToBgView.backgroundColor = RGB(184, 184, 184);
    self.randomDesLabel.textColor = RGB(184, 184, 184);
    self.randomMiddleLabel.textColor = RGB(184, 184, 184);
    
    [self.sureBtn setBackgroundColor:RGB(246, 30, 46)];
}

- (IBAction)touchRandomBtn:(id)sender {
    
    self.paybackModel.type = @"2";
    
    [self.randomBtn setImage:[UIImage imageNamed:@"ic_selected"] forState:UIControlStateNormal];
    self.randomFromPerLabel.textColor = RGB(246, 30, 46);
    self.randomToPerLabel.textColor = RGB(246, 30, 46);
    self.randomDesLabel.textColor = RGB(246, 30, 46);
    self.randomMiddleLabel.textColor = RGB(46, 46, 46);
    
    self.fixTF.text = self.paybackModel.rate;
    self.randomFromTF.text = self.paybackModel.minRate;
    self.randomToTF.text = self.paybackModel.maxRate;
    self.randomDesLabel.text = [NSString stringWithFormat:@"红包比例最低%@%%", self.paybackModel.minRateConf];
    
    [self.fixBtn setImage:[UIImage imageNamed:@"ic_unselected"] forState:UIControlStateNormal];
    self.fixPerLabel.textColor = RGB(184, 184, 184);
    self.fixBgView.backgroundColor = RGB(184, 184, 184);
    
    [self.sureBtn setBackgroundColor:RGB(246, 30, 46)];
}


- (IBAction)touchSureBtn:(id)sender {
    
    // 请求数据
    if (![[TXUserModel defaultUser] userLoginStatus]) {
        [ShowMessage showMessage:@"请登录"];
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    if ([self.paybackModel.type integerValue] == 1 && [NSString isTextEmpty:self.fixTF.text]) {
        [ShowMessage showMessage:@"请输入固定模式比例"];
        return;
    }
    
    if ([self.paybackModel.type integerValue] == 2 && ([NSString isTextEmpty:self.randomFromTF.text] || [NSString isTextEmpty:self.randomToTF.text])) {
        [ShowMessage showMessage:@"请输入随机模式比例"];
        return;
    }
    
    if ([self.paybackModel.type integerValue] == 2 && ([self.randomToTF.text integerValue] <= [self.randomFromTF.text integerValue] || [self.randomFromTF.text integerValue] < [self.paybackModel.minRateConf integerValue])) {
        [ShowMessage showMessage:@"请输入正确的随机模式比例"];
        return;
    }
    
    if ([self.paybackModel.type integerValue] == 1) {
        [params setValue:@"1" forKey:@"type"];
        [params setValue:self.fixTF.text forKey:@"rate"];
    } else if ([self.paybackModel.type integerValue] == 2) {
        [params setValue:@"2" forKey:@"type"];
        [params setValue:self.randomFromTF.text forKey:@"minRate"];
        [params setValue:self.randomToTF.text forKey:@"maxRate"];
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
    [[RCHttpHelper sharedHelper] postUrl:[httpHost stringByAppendingPathComponent:savePaybackInfo] headParams:@{@"token" : [TXModelAchivar getUserModel].token} bodyParams:params success:^(AFHTTPSessionManager *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:true];
        if ([responseObject[@"status"] integerValue] == 1) {
            [ShowMessage showMessage:@"修改成功"];
            [self.navigationController popViewControllerAnimated:true];
        } else {
            [ShowMessage showMessage:responseObject[@"msg"]];
        }
    } failure:^(AFHTTPSessionManager *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:true];
        [ShowMessage showMessage:error.description];
    }];

}

#pragma mark - Data Request

- (void)loadData {
    
    // 请求数据
    if (![[TXUserModel defaultUser] userLoginStatus]) {
        [ShowMessage showMessage:@"请登录"];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
    [[RCHttpHelper sharedHelper] getUrl:[httpHost stringByAppendingPathComponent:paybackInfo] headParams:@{@"token" : [TXModelAchivar getUserModel].token} bodyParams:nil success:^(AFHTTPSessionManager *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:true];
        if ([responseObject[@"status"] integerValue] == 1) {
            self.paybackModel = [DTPaybackModel mj_objectWithKeyValues:responseObject[@"data"]];
            if ([self.paybackModel.type integerValue] == 1) {
                // 固定
                [self touchFixBtn:self.fixBtn];
            } else if ([self.paybackModel.type integerValue] == 2)  {
                // 随机
                [self touchRandomBtn:self.randomBtn];
            }
        } else {
            [ShowMessage showMessage:responseObject[@"msg"]];
        }
    } failure:^(AFHTTPSessionManager *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:true];
        [ShowMessage showMessage:error.description];
    }];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
