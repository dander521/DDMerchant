//
//  DTPersonalCenterViewController.m
//  DotMerchant
//
//  Created by 倩倩 on 2017/9/12.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTPersonalCenterViewController.h"
#import "DTPersonalCenterTableViewCell.h"
#import "DTPersonalCenterHeaderView.h"
#import "RCExpandHeader.h"
#import "DTNewLoginViewController.h"
#import "DTRegisterViewController.h"
#import "DTVerifyNameViewController.h"
#import "DTApplyStoreViewController.h"

@interface DTPersonalCenterViewController ()<UITableViewDelegate, UITableViewDataSource, DTPersonalCenterHeaderViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *centerTableView;
@property (nonatomic, strong) DTPersonalCenterHeaderView *headerView;

@property (nonatomic, strong) NSArray *imagesArray;
@property (nonatomic, strong) NSArray *titlesArray;

@end

@implementation DTPersonalCenterViewController {
    RCExpandHeader *_header;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    adjustsScrollViewInsets_NO(self.centerTableView, self);
    self.imagesArray = @[@[@"ic_wallet", @"ic_employee", @"ic_apply_paper", @"ic_open_store"], @[@"ic_contact_us", @"ic_advertisment"], @[@"ic_set"]];
    self.titlesArray = @[@[@"我的钱包", @"员工股", @"纸巾申领", @"开店申请"], @[@"联系我们", @"推广店铺"], @[@"设置"]];
    
//    _header = [RCExpandHeader expandWithScrollView:self.centerTableView expandView:[self tableHeaderView]];
    if ([[TXUserModel defaultUser] userLoginStatus]) {
        self.centerTableView.tableHeaderView = [self tableHeaderViewWithType:DTPersonalHeaderShowTypeIsLogin];
        self.headerView.nameLabel.text = [TXModelAchivar getUserModel].nickName;
        [self.headerView.storeImageView sd_setImageWithURL:[NSURL URLWithString:[imageHost stringByAppendingPathComponent:[TXModelAchivar getUserModel].face]] placeholderImage:[UIImage imageNamed:@"user"]];
    } else {
        self.centerTableView.tableHeaderView = [self tableHeaderViewWithType:DTPersonalHeaderShowTypeNotLogin];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess:) name:kNotificationLoginSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginOutSuccess:) name:kNotificationLoginOutSuccess object:nil];
}

- (void)loginSuccess:(NSNotification *)noti {
    self.centerTableView.tableHeaderView = [self tableHeaderViewWithType:DTPersonalHeaderShowTypeIsLogin];
    self.headerView.nameLabel.text = [TXModelAchivar getUserModel].nickName;
    [self.headerView.storeImageView sd_setImageWithURL:[NSURL URLWithString:[imageHost stringByAppendingPathComponent:[TXModelAchivar getUserModel].face]] placeholderImage:[UIImage imageNamed:@"user"]];
}

- (void)loginOutSuccess:(NSNotification *)noti {
    self.centerTableView.tableHeaderView = [self tableHeaderViewWithType:DTPersonalHeaderShowTypeNotLogin];
    self.headerView.nameLabel.text = [TXModelAchivar getUserModel].nickName;
    [self.headerView.storeImageView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"user"]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = true;
    [self getAuditStatus];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = false;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) return 4;
    if (section == 1) return 2;
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DTPersonalCenterTableViewCell *cell = [DTPersonalCenterTableViewCell cellWithTableView:tableView];
    cell.iconImageView.image = [UIImage imageNamed:self.imagesArray[indexPath.section][indexPath.row]];
    cell.titleLabel.text = self.titlesArray[indexPath.section][indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 8.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    if (![[TXUserModel defaultUser] userLoginStatus] && indexPath.section != 2) {
        [ShowMessage showMessage:@"请登录"];
        return;
    }
    if (indexPath.section == 1 && indexPath.row == 0) {
        [self contactWithUs];
    } if (indexPath.section == 0 && indexPath.row == 2) {
        NSString *controller = nil;
        if ([[TXUserModel defaultUser] isOpenPaper]) {
            controller = @"DTApplyPaperViewController";
        } else {
            controller = @"DTPaperRequireViewController";
        }
        [self customPushActionWithControllerName:controller];
    } if (indexPath.section == 0 && indexPath.row == 3) {
        if ([TXModelAchivar getUserModel].shopId != 0) {
            [ShowMessage showMessage:@"已开店，无需申请"];
            return;
        }
        
        NSString *controller = nil;
        if ([[TXModelAchivar getUserModel].auditStatus integerValue] != 2 &&
            [TXModelAchivar getUserModel].auditStatus != 0) {
            controller = @"DTVerifyNameViewController";
        } else if ([[TXModelAchivar getUserModel].auditStatus integerValue] == 2) {
                controller = @"DTApplyStoreViewController";
        } else if ([[TXModelAchivar getUserModel].auditStatus integerValue] == 1) {
            [ShowMessage showMessage:@"正在实名审核，请耐心等待"];
        }
        [self customPushActionWithControllerName:controller];
    } else {
        NSArray *subControllers = @[@[@"DTWalletViewController", @"DTEmployeeViewController", @"", @""], @[@"", @"DTContactUsViewController"], @[@"DTSettingViewController"]];
        [self customPushActionWithControllerName:subControllers[indexPath.section][indexPath.row]];
    }
}

- (void)getAuditStatus {
    if (![[TXUserModel defaultUser] userLoginStatus]) {
        [ShowMessage showMessage:@"请登录"];
        return;
    }
    
    if ([TXModelAchivar getUserModel].shopId != 0 && [TXModelAchivar getUserModel].paperId != 0) {
        return;
    }
    
    [[RCHttpHelper sharedHelper] getUrl:[httpHost stringByAppendingPathComponent:getAuditStatus] headParams:@{@"token": [TXModelAchivar getUserModel].token} bodyParams:nil success:^(AFHTTPSessionManager *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view];
        if ([responseObject[@"status"] integerValue] == 1) {
            [TXModelAchivar updateUserModelWithKey:@"shopId" value:responseObject[@"data"][@"shopId"]];
            [TXModelAchivar updateUserModelWithKey:@"paperId" value:responseObject[@"data"][@"paperId"]];
        }
    } failure:^(AFHTTPSessionManager *operation, NSError *error) {
    }];
}

- (void)contactWithUs {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[RCHttpHelper sharedHelper] getUrl:[httpHost stringByAppendingPathComponent:contactUs]
                             headParams:nil
                             bodyParams:nil
                                success:^(AFHTTPSessionManager *operation, id responseObject) {
                                    [MBProgressHUD hideHUDForView:self.view];
                                    [ShowMessage showMessage:responseObject[@"msg"]];
                                    if ([responseObject[@"status"] integerValue] == 1) {
                                        NSString *phoneNum = [NSString isTextEmpty:responseObject[@"data"]] ? @"暂未设置联系方式" : responseObject[@"data"];
                                        [TXCustomTools callStoreWithPhoneNo:phoneNum target:self];
                                    }
                                }
                                failure:^(AFHTTPSessionManager *operation, NSError *error) {
                                    [ShowMessage showMessage:error.description];
                                    [MBProgressHUD hideHUDForView:self.view];
                                }];
}

#pragma mark - DTPersonalCenterHeaderViewDelegate

- (void)touchLoginButton {
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromTop;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    DTNewLoginViewController *vwcLogin = [[DTNewLoginViewController alloc] initWithNibName:NSStringFromClass([DTNewLoginViewController class]) bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:vwcLogin animated:false];
}

- (void)touchRegisterButton {
    CATransition *transition = [CATransition animation];
    transition.duration = 0.2f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionMoveIn;
    transition.subtype = kCATransitionFromTop;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    DTRegisterViewController *vwcRegister = [[DTRegisterViewController alloc] initWithNibName:NSStringFromClass([DTRegisterViewController class]) bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:vwcRegister animated:false];
}

- (void)touchUserAvatar {
    NSLog(@"touchUserAvatar");
}

#pragma mark - Custom Method

- (void)customPushActionWithControllerName:(NSString *)controllerName {
    if ([NSString isTextEmpty:controllerName]) {
        return;
    }
    UIViewController *vwc = [NSClassFromString(controllerName) new];
    vwc.hidesBottomBarWhenPushed = true;
    [self.navigationController pushViewController:vwc animated:true];
}

- (UIView *)tableHeaderViewWithType:(DTPersonalHeaderShowType)type {
    _headerView = [DTPersonalCenterHeaderView instanceView];
    _headerView.delegate = self;
    _headerView.showType = type;
    _headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 200);
    return _headerView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
