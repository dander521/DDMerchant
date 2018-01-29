//
//  DTAboutViewController.m
//  DotMerchant
//
//  Created by 倩倩 on 2017/9/18.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTAboutViewController.h"

@interface DTAboutViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation DTAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"关于";
    [self getAboutUsData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getAboutUsData {
    weakSelf(self);
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
    [[RCHttpHelper sharedHelper] getUrl:[httpHost stringByAppendingPathComponent:aboutUs] headParams:nil bodyParams:nil success:^(AFHTTPSessionManager *operation, id responseObject) {

        if ([responseObject[@"status"] integerValue] == 1) {
            [weakSelf.webView loadHTMLString:responseObject[@"data"] baseURL:[NSURL URLWithString:imageHost]];
        }
        [MBProgressHUD hideHUDForView:self.view animated:true];
        [ShowMessage showMessage:responseObject[@"msg"]];
    } failure:^(AFHTTPSessionManager *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:true];
        [ShowMessage showMessage:error.description];
    }];
}

@end
