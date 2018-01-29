//
//  DTApplyPaperViewController.m
//  DotMerchant
//
//  Created by 倩倩 on 2017/9/14.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTApplyPaperViewController.h"
#import "DTPaperListModel.h"

@interface DTApplyPaperViewController ()
@property (weak, nonatomic) IBOutlet UITextField *inputTF;
@property (weak, nonatomic) IBOutlet UIButton *applyBtn;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;

@end

@implementation DTApplyPaperViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"纸巾申领";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    [self loadData];
}

- (void)textFieldDidChange:(NSNotification *)noti {
    if (self.inputTF.text.length != 0) {
        self.applyBtn.enabled = true;
        [self.applyBtn setBackgroundColor:RGB(246, 30, 46)];
    } else {
        self.applyBtn.enabled = false;
        [self.applyBtn setBackgroundColor:RGB(153, 153, 153)];
    }
}

- (void)loadData {
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:[TXModelAchivar getUserModel].token forKey:@"token"];
    
    [[RCHttpHelper sharedHelper] getUrl:[httpHost stringByAppendingPathComponent:paperManager] headParams:params bodyParams:@{@"page": [NSString stringWithFormat:@"%zd", 1], @"pageSize": [NSString stringWithFormat:@"%zd", 1]} success:^(AFHTTPSessionManager *operation, id responseObject) {
        if ([responseObject[@"status"] integerValue] == 1) {
            [ShowMessage showMessage:responseObject[@"msg"]];
            DTPaperListModel *colloectionModel = [DTPaperListModel mj_objectWithKeyValues:responseObject[@"data"]];
            self.numLabel.text = colloectionModel.num;
        } else {
            [ShowMessage showMessage:responseObject[@"msg"]];
        }
    } failure:^(AFHTTPSessionManager *operation, NSError *error) {
        [ShowMessage showMessage:error.description];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)touchAppyBtn:(id)sender {
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:self.inputTF.text forKey:@"num"];
    [params setValue:self.name forKey:@"name"];
    [params setValue:self.phone forKey:@"phone"];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
    [[RCHttpHelper sharedHelper] postUrl:[httpHost stringByAppendingPathComponent:applyPaper] headParams:@{@"token":[TXModelAchivar getUserModel].token} bodyParams:params success:^(AFHTTPSessionManager *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:true];
        if ([responseObject[@"status"] integerValue] == 1) {
            [self.navigationController popToRootViewControllerAnimated:true];
            [ShowMessage showMessage:@"申领成功,等待审核..."];
        }
        [ShowMessage showMessage:responseObject[@"msg"]];
        
    } failure:^(AFHTTPSessionManager *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:true];
        [ShowMessage showMessage:error.description];
    }];
}



@end
