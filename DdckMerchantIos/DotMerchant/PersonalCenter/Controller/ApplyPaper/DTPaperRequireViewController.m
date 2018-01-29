//
//  DTPaperRequireViewController.m
//  DotMerchant
//
//  Created by 倩倩 on 2017/9/18.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTPaperRequireViewController.h"
#import "DTApplyPaperViewController.h"

@interface DTPaperRequireViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UIButton *applyButton;

@end

@implementation DTPaperRequireViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"纸巾申领";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)textFieldDidChange:(NSNotification *)noti {
    if (self.nameTF.text.length != 0 &&
        self.phoneTF.text.length != 0) {
        self.applyButton.enabled = true;
        [self.applyButton setBackgroundColor:RGB(246, 30, 46)];
    } else {
        self.applyButton.enabled = false;
        [self.applyButton setBackgroundColor:RGB(153, 153, 153)];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)touchApplyBtn:(id)sender {
    
    if (![NSString checkUserName:self.nameTF.text]) {
        [ShowMessage showMessage:@"请输入正确的姓名"];
        return;
    }
    
    if (![NSString isPhoneNumCorrectPhoneNum:self.phoneTF.text]) {
        [ShowMessage showMessage:@"请输入正确的手机号码"];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
    [[RCHttpHelper sharedHelper] postUrl:[httpHost stringByAppendingPathComponent:applyPaper] headParams:@{@"token":[TXModelAchivar getUserModel].token} bodyParams:@{@"name":self.nameTF.text,@"phone":self.phoneTF.text} success:^(AFHTTPSessionManager *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:true];
        if ([responseObject[@"status"] integerValue] == 1) {
            DTApplyPaperViewController *vwcApply = [[DTApplyPaperViewController alloc] initWithNibName:NSStringFromClass([DTApplyPaperViewController class]) bundle:[NSBundle mainBundle]];
            vwcApply.name = self.nameTF.text;
            vwcApply.phone = self.phoneTF.text;
            [self.navigationController pushViewController:vwcApply animated:true];
        }
        [ShowMessage showMessage:responseObject[@"msg"]];
    } failure:^(AFHTTPSessionManager *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:true];
        [ShowMessage showMessage:error.description];
    }];
    
}


@end
