//
//  DTVerifyNameViewController.m
//  DotMerchant
//
//  Created by 倩倩 on 2017/9/14.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTVerifyNameViewController.h"
#import "DTApplyStoreViewController.h"

@interface DTVerifyNameViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *cardTF;
@property (weak, nonatomic) IBOutlet UIButton *uploadBtn;

@end

@implementation DTVerifyNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"实名认证";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)textFieldDidChange:(NSNotification *)noti {
    if (self.nameTF.text.length != 0 &&
        self.cardTF.text.length != 0) {
        self.uploadBtn.enabled = true;
        [self.uploadBtn setBackgroundColor:RGB(246, 30, 46)];
    } else {
        self.uploadBtn.enabled = false;
        [self.uploadBtn setBackgroundColor:RGB(153, 153, 153)];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)touchUploadBtn:(id)sender {
    
    if (![NSString checkUserName:self.nameTF.text]) {
        [ShowMessage showMessage:@"请输入正确的姓名"];
        return;
    }
    
    if (![NSString checkUserIdCard:self.cardTF.text]) {
        [ShowMessage showMessage:@"请输入正确的身份证号码"];
        return;
    }
    
    DTApplyStoreViewController *vwcApply = [[DTApplyStoreViewController alloc] initWithNibName:NSStringFromClass([DTApplyStoreViewController class]) bundle:[NSBundle mainBundle]];
    vwcApply.userName = self.nameTF.text;
    vwcApply.cardNo = self.cardTF.text;
    [self.navigationController pushViewController:vwcApply animated:true];
}


@end
