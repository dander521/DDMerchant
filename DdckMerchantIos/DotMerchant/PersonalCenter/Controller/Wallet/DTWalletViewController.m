//
//  DTWalletViewController.m
//  DotMerchant
//
//  Created by 倩倩 on 2017/9/14.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTWalletViewController.h"
#import "DTWalletHeaderView.h"
#import "DTPersonalCenterTableViewCell.h"
#import "DTWithdrawViewController.h"
#import "DTBindAliViewController.h"

@interface DTWalletViewController () <UITableViewDataSource, UITableViewDelegate, NetErrorViewDelegate>

/** 加载页面 */
@property (strong, nonatomic) NetErrorView *netView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) DTWalletHeaderView *headerView;

@end

@implementation DTWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"我的钱包";
//    adjustsScrollViewInsets_NO(self.tableView, self);
    self.tableView.tableHeaderView = [self tableViewHeader];
    [self.netView showAddedTo:self.view isClearBgc:false];
    [self getBalance];
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
    DTPersonalCenterTableViewCell *cell = [DTPersonalCenterTableViewCell cellWithTableView:tableView];
  
    if (indexPath.row == 0) {
        cell.iconImageView.image = [UIImage imageNamed:@"ic_wechat"];
        cell.titleLabel.text = @"提现";
    } else if (indexPath.row == 1) {
        cell.iconImageView.image = [UIImage imageNamed:@"ic_ali"];
        cell.titleLabel.text = @"绑定支付宝";
    } else {
        cell.iconImageView.image = [UIImage imageNamed:@"icon_yinhangka"];
        cell.titleLabel.text = @"绑定银行卡";
    }
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        DTWithdrawViewController *vwcWith = [[DTWithdrawViewController alloc] initWithNibName:NSStringFromClass([DTWithdrawViewController class]) bundle:[NSBundle mainBundle]];
        [self.navigationController pushViewController:vwcWith animated:true];
    } else if (indexPath.row == 1) {
        DTBindAliViewController *vwcBind = [[DTBindAliViewController alloc] initWithNibName:NSStringFromClass([DTBindAliViewController class]) bundle:[NSBundle mainBundle]];
        vwcBind.isBindAli = true;
        vwcBind.isBind = ![NSString isTextEmpty:[TXModelAchivar getUserModel].aliAccount];
        [self.navigationController pushViewController:vwcBind animated:true];
    } else {
        DTBindAliViewController *vwcBind = [[DTBindAliViewController alloc] initWithNibName:NSStringFromClass([DTBindAliViewController class]) bundle:[NSBundle mainBundle]];
        vwcBind.isBindAli = false;
        vwcBind.isBind = ![NSString isTextEmpty:[TXModelAchivar getUserModel].bankCard];
        [self.navigationController pushViewController:vwcBind animated:true];
    }
}

- (UIView *)tableViewHeader {
    self.headerView = [DTWalletHeaderView instanceView];
    return self.headerView;
}

#pragma mark - Data Request

- (void)getBalance {
    if (![[TXUserModel defaultUser] userLoginStatus]) {
        [ShowMessage showMessage:@"请登录"];
        return;
    }
    
    [[RCHttpHelper sharedHelper] getUrl:[httpHost stringByAppendingPathComponent:getBalance] headParams:@{@"token" : [TXModelAchivar getUserModel].token} bodyParams:nil success:^(AFHTTPSessionManager *operation, id responseObject) {
        if ([responseObject[@"status"] integerValue] == 1) {
            [self.netView stopNetViewLoadingFail:false error:false];
            self.headerView.priceLabel.text = [NSString stringWithFormat:@"￥ %.2f", [responseObject[@"data"][@"yue"] floatValue]];
        } else {
            [self.netView stopNetViewLoadingFail:false error:true];
        }
    } failure:^(AFHTTPSessionManager *operation, NSError *error) {
        [self.netView stopNetViewLoadingFail:true error:false];
    }];
}

#pragma mark - NetErrorViewDelegate

- (void)reloadDataNetErrorView:(NetErrorView *)errorView {
    [self getBalance];
}

#pragma mark - Lazy

/**
 网络错误页
 */
- (NetErrorView *)netView {
    if (!_netView) {
        _netView = [[NetErrorView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
        _netView.delegate = self;
    }
    return _netView;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
