//
//  DTNewLoginViewController.m
//  DotCustomer
//
//  Created by 倩倩 on 2017/10/16.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTNewLoginViewController.h"
#import "DTRetrieveViewController.h"
#import "DTVerifyNameViewController.h"
#import "DTRegisterViewController.h"
#import "DTLoginTableViewCell.h"
#import "UMessage.h"

@interface DTNewLoginViewController () <UITableViewDataSource, UITableViewDelegate, DTLoginTableViewCellDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) UITextField *phoneTF;
@property (nonatomic, strong) UITextField *pwdTF;
@property (nonatomic, strong) UIButton *loginBtn;

@end

@implementation DTNewLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    adjustsScrollViewInsets_NO(self.tableView, self);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)touchBackBtn:(id)sender {
    CATransition *transition = [CATransition animation];
    transition.duration = 0.25f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionReveal;
    transition.subtype = kCATransitionFromBottom;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = true;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.navigationController.navigationBarHidden = false;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DTLoginTableViewCell *cell = [DTLoginTableViewCell cellWithTableView:tableView];
    cell.delegate = self;
    self.phoneTF = cell.phoneTF;
    self.pwdTF = cell.pwdTF;
    self.phoneTF.delegate = self;
    self.pwdTF.delegate = self;
//    self.phoneTF.text = @"18328578219";
//    self.pwdTF.placeholder = @"测试密码:123456";
    self.loginBtn = cell.loginBtn;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SCREEN_HEIGHT;
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidChange:(NSNotification *)noti {
    if (self.phoneTF.text.length != 0 &&
        self.pwdTF.text.length != 0) {
        self.loginBtn.enabled = true;
        [self.loginBtn setBackgroundColor:RGB(246, 30, 46)];
    } else {
        self.loginBtn.enabled = false;
        [self.loginBtn setBackgroundColor:RGB(153, 153, 153)];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return true;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:true];
    return true;
}

#pragma mark - DTLoginTableViewCellDelegate

- (void)touchLoginButton {
    if (![NSString isPhoneNumCorrectPhoneNum:self.phoneTF.text]) {
        [ShowMessage showMessage:@"请输入正确的手机号"];
        return;
    }
    
    if (self.pwdTF.text.length < 6 || self.pwdTF.text.length > 20) {
        [ShowMessage showMessage:@"请输入6-20位数字和字母组成的密码"];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[RCHttpHelper sharedHelper] getUrl:[httpHost stringByAppendingPathComponent:loginInterface]
                             headParams:nil
                             bodyParams:@{@"phone" : self.phoneTF.text, @"password" : self.pwdTF.text}
                                success:^(AFHTTPSessionManager *operation, id responseObject) {
                                    [MBProgressHUD hideHUDForView:self.view];
                                    [ShowMessage showMessage:responseObject[@"msg"]];
                                    if ([responseObject[@"status"] integerValue] == 1) {
                                        
                                        TXUserModel *model = [TXUserModel defaultUser];
                                        model = [model initWithDictionary:responseObject[@"data"]];
                                        [TXModelAchivar achiveUserModel];
                                        
                                        [TXModelAchivar updateUserModelWithKey:@"account" value:self.phoneTF.text];
                                        
                                        [UMessage setAlias:self.phoneTF.text type:@"ddmerchant" response:^(id responseObject, NSError *error) {
                                            
                                        }];
                                        
                                        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationLoginSuccess object:nil userInfo:nil];
                                        
                                        if ([[TXModelAchivar getUserModel].auditStatus integerValue] != 2 &&
                                            [[TXModelAchivar getUserModel].auditStatus integerValue] != 0) {
                                            DTVerifyNameViewController *vwcVerify = [[DTVerifyNameViewController alloc] initWithNibName:NSStringFromClass([DTVerifyNameViewController class]) bundle:[NSBundle mainBundle]];
                                            [self.navigationController pushViewController:vwcVerify animated:true];
                                        } else {
                                            [self.navigationController popViewControllerAnimated:true];
                                        }
                                    }
    }
                                failure:^(AFHTTPSessionManager *operation, NSError *error) {
                                    [ShowMessage showMessage:error.description];
                                    [MBProgressHUD hideHUDForView:self.view];
    }];
}

- (void)touchRetrieveButton {
    DTRetrieveViewController *vwcRetrieve = [[DTRetrieveViewController alloc] initWithNibName:NSStringFromClass([DTRetrieveViewController class]) bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:vwcRetrieve animated:true];
}

- (void)touchRegisterButton {
    DTRegisterViewController *vwcRetrieve = [[DTRegisterViewController alloc] initWithNibName:NSStringFromClass([DTRegisterViewController class]) bundle:[NSBundle mainBundle]];
    vwcRetrieve.isFromLogin = true;
    [self.navigationController pushViewController:vwcRetrieve animated:true];
}

@end
