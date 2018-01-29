//
//  DTVoucherViewController.m
//  DotMerchant
//
//  Created by 倩倩 on 2017/9/17.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTVoucherViewController.h"
#import "DTStoreNameTableViewCell.h"
#import "DTGoodsDetailTableViewCell.h"

@interface DTVoucherViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) UITextField *salePriceTF;
@property (nonatomic, strong) UITextField *reachPriceTF;
@property (nonatomic, strong) UITextView *voucherDetailTV;
@property (nonatomic, strong) UIButton *commitButton;

@end

@implementation DTVoucherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"添加代金券";
    self.tableView.tableFooterView = [self tableFooterView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidChanged:) name:UITextViewTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)textViewDidChanged:(NSNotification *)noti {
    if (self.salePriceTF.text.length != 0 &&
        self.reachPriceTF.text.length != 0 &&
        self.voucherDetailTV.text.length != 0) {
        self.commitButton.enabled = true;
        [self.commitButton setBackgroundColor:RGB(246, 30, 46)];
    } else {
        self.commitButton.enabled = false;
        [self.commitButton setBackgroundColor:RGB(153, 153, 153)];
    }
}

- (void)textFieldDidChange:(NSNotification *)noti {
    if (self.salePriceTF.text.length != 0 &&
        self.reachPriceTF.text.length != 0 &&
        self.voucherDetailTV.text.length != 0) {
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
        cell.nameLabel.text = @"售卖价格：";
        self.salePriceTF = cell.contentTF;
        self.salePriceTF.text = self.model.price;
        self.salePriceTF.keyboardType = UIKeyboardTypeNumberPad;
        cellDefault = cell;
    } else if (indexPath.row == 1) {
        DTStoreNameTableViewCell *cell = [DTStoreNameTableViewCell cellWithTableView:tableView];
        cell.nameLabel.text = @"抵用价格：";
        self.reachPriceTF = cell.contentTF;
        self.reachPriceTF.text = self.model.usePrice;
        self.reachPriceTF.keyboardType = UIKeyboardTypeNumberPad;
        cellDefault = cell;
    } else {
        DTGoodsDetailTableViewCell *cell = [DTGoodsDetailTableViewCell cellWithTableView:tableView];
        self.voucherDetailTV = cell.contentTextView;
        cell.desLabel.text = @"代金券说明：";
        self.voucherDetailTV.text = self.model.remark;
        cellDefault = cell;
    }
    
    cellDefault.cellLineType = TXCellSeperateLinePositionType_Single;
    cellDefault.cellLineRightMargin = TXCellRightMarginType0;
    
    return cellDefault;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0 || indexPath.row == 1) return 50.0;
    return 140.0;
}

#pragma mark - Custom Method

- (UIView *)tableFooterView {
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 150)];
    footer.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    _commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _commitButton.frame = CGRectMake(42, 32, SCREEN_WIDTH - 84, 49);
    _commitButton.titleLabel.font = FONT(18);
    [_commitButton setTitle:@"确认添加" forState:UIControlStateNormal];
    _commitButton.backgroundColor = RGB(153, 153, 153);
    _commitButton.enabled = false;
    [_commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _commitButton.layer.cornerRadius = 24.5;
    _commitButton.layer.masksToBounds = true;
    [_commitButton addTarget:self action:@selector(touchCommitBtn) forControlEvents:UIControlEventTouchUpInside];
    [footer addSubview:_commitButton];
    return footer;
}

- (void)touchCommitBtn {
    if (![[TXUserModel defaultUser] userLoginStatus]) {
        [ShowMessage showMessage:@"请登录"];
        return;
    }
    
    if ([self.salePriceTF.text integerValue] > [self.reachPriceTF.text integerValue]) {
        [ShowMessage showMessage:@"请确认代金券价格不能大于抵用价格"];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
    [[RCHttpHelper sharedHelper] postUrl:[httpHost stringByAppendingPathComponent:addCoupon] headParams:@{@"token":[TXModelAchivar getUserModel].token} bodyParams:@{@"price" : self.salePriceTF.text ,@"usePrice":self.reachPriceTF.text,@"remark":self.voucherDetailTV.text} success:^(AFHTTPSessionManager *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view];
        if ([responseObject[@"status"] integerValue] == 1) {
            [ShowMessage showMessage:@"添加成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationAddGoodsSuccess object:nil userInfo:nil];
            [self.navigationController popViewControllerAnimated:true];
        }
        [ShowMessage showMessage:responseObject[@"msg"]];
    } failure:^(AFHTTPSessionManager *operation, NSError *error) {
        [ShowMessage showMessage:error.description];
        [MBProgressHUD hideHUDForView:self.view];
    }];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
