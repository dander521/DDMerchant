//
//  DTTicketVerifyViewController.m
//  DotMerchant
//
//  Created by 倩倩 on 2017/9/13.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTTicketVerifyViewController.h"

@interface DTTicketVerifyViewController ()
@property (weak, nonatomic) IBOutlet UITextField *verifyTF;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@end

@implementation DTTicketVerifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"券密码认证";
    
    self.bottomView.layer.shadowOffset = CGSizeMake(2, 2);
    self.bottomView.layer.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2].CGColor;
    self.bottomView.layer.shadowOpacity = 0.5;
    self.bottomView.backgroundColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)touchVerifyBtn:(id)sender {
    
    if (![[TXUserModel defaultUser] userLoginStatus]) {
        [ShowMessage showMessage:@"请登录"];
        return;
    }
    
    if ([NSString isTextEmpty:self.verifyTF.text]) {
        [ShowMessage showMessage:@"请输入正确的代金券"];
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:self.verifyTF.text forKey:@"code"];
    
    [[RCHttpHelper sharedHelper] getUrl:[httpHost stringByAppendingPathComponent:orderUseTicket] headParams:@{@"token" : [TXModelAchivar getUserModel].token} bodyParams:params success:^(AFHTTPSessionManager *operation, id responseObject) {
        if ([responseObject[@"status"] integerValue] == 1) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [ShowMessage showMessage:@"核销成功"];
                [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationCheckSuccess object:nil userInfo:nil];
                [self.navigationController popViewControllerAnimated:true];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                [ShowMessage showMessage:responseObject[@"msg"]];
            });
        }
    } failure:^(AFHTTPSessionManager *operation, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:true];
            [ShowMessage showMessage:error.description];
        });
    }];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
