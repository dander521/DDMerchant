//
//  DTEmployeeRulesViewController.m
//  DotMerchant
//
//  Created by 倩倩 on 2017/10/25.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTEmployeeRulesViewController.h"

@interface DTEmployeeRulesViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;


@end

@implementation DTEmployeeRulesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"员工股介绍及规则";
    
    [self getStockRules];
}

- (void)getStockRules {
    weakSelf(self);
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
    [[RCHttpHelper sharedHelper] getUrl:[httpHost stringByAppendingPathComponent:employeeStockRules] headParams:nil bodyParams:nil success:^(AFHTTPSessionManager *operation, id responseObject) {
        
        if ([responseObject[@"status"] integerValue] == 1) {
            
            [weakSelf.webView loadHTMLString:responseObject[@"data"] baseURL:[NSURL URLWithString:imageHost]];
        } else {
            [ShowMessage showMessage:responseObject[@"msg"]];
        }
        [MBProgressHUD hideHUDForView:self.view animated:true];
    } failure:^(AFHTTPSessionManager *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:true];
        [ShowMessage showMessage:error.description];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
