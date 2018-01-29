//
//  DTContactUsViewController.m
//  DotMerchant
//
//  Created by 倩倩 on 2017/9/14.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTContactUsViewController.h"
#import "DTStoreNameTableViewCell.h"
#import "DTGoodsDetailTableViewCell.h"

@interface DTContactUsViewController () <UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) UITextField *nameTF;
@property (nonatomic, strong) UITextField *phoneTF;
@property (nonatomic, strong) UITextView *descriptionTV;
@property (nonatomic, strong) UIButton *commitButton;

@end

@implementation DTContactUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"推广店铺";
    self.tableView.tableHeaderView = [self tableHeaderView];
    self.tableView.tableFooterView = [self tableFooterView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidChanged:) name:UITextViewTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)textViewDidChanged:(NSNotification *)noti {
    if (self.nameTF.text.length != 0 &&
        self.phoneTF.text.length != 0 &&
        self.descriptionTV.text.length != 0) {
        self.commitButton.enabled = true;
        [self.commitButton setBackgroundColor:RGB(246, 30, 46)];
    } else {
        self.commitButton.enabled = false;
        [self.commitButton setBackgroundColor:RGB(153, 153, 153)];
    }
}

- (void)textFieldDidChange:(NSNotification *)noti {
    if (self.nameTF.text.length != 0 &&
        self.phoneTF.text.length != 0 &&
        self.descriptionTV.text.length != 0) {
        self.commitButton.enabled = true;
        [self.commitButton setBackgroundColor:RGB(246, 30, 46)];
    } else {
        self.commitButton.enabled = false;
        [self.commitButton setBackgroundColor:RGB(153, 153, 153)];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TXSeperateLineCell *cellDefault = nil;
    if (indexPath.row == 0) {
        DTStoreNameTableViewCell *cell = [DTStoreNameTableViewCell cellWithTableView:tableView];
        cell.nameLabel.text = @"姓名：";
        self.nameTF = cell.contentTF;
        self.nameTF.textColor = RGB(46, 46, 46);
        cellDefault = cell;
    } else if (indexPath.row == 1) {
        DTStoreNameTableViewCell *cell = [DTStoreNameTableViewCell cellWithTableView:tableView];
        cell.nameLabel.text = @"手机号：";
        self.phoneTF = cell.contentTF;
        self.phoneTF.keyboardType = UIKeyboardTypeNumberPad;
        self.phoneTF.textColor = RGB(46, 46, 46);
        cellDefault = cell;
    } else {
        DTGoodsDetailTableViewCell *cell = [DTGoodsDetailTableViewCell cellWithTableView:tableView];
        cell.desLabel.text = @"描述：";
        [cell.contentTextView addPlaceholderWithText:@"请填写您的合作要求" textColor:RGB(153, 153, 153) font:[UIFont fontWithName:@"Helvetica-Light" size:16]];
        self.descriptionTV = cell.contentTextView;
        cellDefault = cell;
    }
    
    cellDefault.cellLineType = TXCellSeperateLinePositionType_Single;
    cellDefault.cellLineRightMargin = TXCellRightMarginType0;
    return cellDefault;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0 || indexPath.row == 1) {
        return 58.0;
    }
    return 140.0;
}

#pragma mark - Custom Method

- (UIView *)tableHeaderView {
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
    footer.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UILabel *footerLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 10, SCREEN_WIDTH-24, 40)];
    footerLabel.textColor = RGB(246, 30, 46);
    footerLabel.textAlignment = NSTextAlignmentLeft;
    footerLabel.text = @"有意与平台进行纸巾订购，请填写资料，随后会有专人与您联系";
    footerLabel.font = FONT(16);
    footerLabel.numberOfLines = 2;
    footerLabel.backgroundColor = [UIColor clearColor];
    [footer addSubview:footerLabel];
    return footer;
}

- (UIView *)tableFooterView {
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
    footer.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UILabel *footerLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 10, SCREEN_WIDTH-24, 42)];
    footerLabel.textColor = RGB(153, 153, 153);
    footerLabel.textAlignment = NSTextAlignmentLeft;
    footerLabel.text = @"纸巾在你店铺附近的纸巾店进行派送，印刷5000包起/399元";
    footerLabel.numberOfLines = 2;
    footerLabel.font = FONT(16);
    footerLabel.backgroundColor = [UIColor clearColor];
    [footer addSubview:footerLabel];
    
    _commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _commitButton.frame = CGRectMake(42, 82, SCREEN_WIDTH - 84, 49);
    _commitButton.titleLabel.font = FONT(18);
    [_commitButton setTitle:@"确定提交" forState:UIControlStateNormal];
    _commitButton.backgroundColor = RGB(153, 153, 153);
    [_commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _commitButton.layer.cornerRadius = 24.5;
    _commitButton.layer.masksToBounds = true;
    [_commitButton addTarget:self action:@selector(touchCommitBtn) forControlEvents:UIControlEventTouchUpInside];
    [footer addSubview:_commitButton];
    return footer;
}

- (void)touchCommitBtn {
    if (![NSString checkUserName:self.nameTF.text]) {
        [ShowMessage showMessage:@"请输入正确的姓名"];
        return;
    }
    
    if (![NSString isPhoneNumCorrectPhoneNum:self.phoneTF.text]) {
        [ShowMessage showMessage:@"请输入正确的手机号码"];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
    [[RCHttpHelper sharedHelper] postUrl:[httpHost stringByAppendingPathComponent:advertisementCompany] headParams:nil bodyParams:@{@"name":self.nameTF.text,@"phone":self.phoneTF.text,@"remark":self.descriptionTV.text, @"type":@"2"} success:^(AFHTTPSessionManager *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:true];
        if ([responseObject[@"status"] integerValue] == 1) {
            [self.navigationController popViewControllerAnimated:true];
        }
        [ShowMessage showMessage:responseObject[@"msg"]];
    } failure:^(AFHTTPSessionManager *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:true];
        [ShowMessage showMessage:error.description];
    }];
}

@end
