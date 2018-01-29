//
//  DTEmployeeViewController.m
//  DotMerchant
//
//  Created by 倩倩 on 2017/9/14.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTEmployeeViewController.h"
#import "DTBuyStockTableViewCell.h"
#import "DTSaleStockTableViewCell.h"
#import "DTPayCustomView.h"
#import "DTEmployeeRulesViewController.h"
#import "WXApi.h"
#import "DTProfitTableViewCell.h"

@interface DTEmployeeViewController () <UITableViewDataSource, UITableViewDelegate, DTSaleStockTableViewCellDelegate, DTBuyStockTableViewCellDelegate, DTPayCustomViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

/** 可购买数 */
@property (nonatomic, strong) NSString *buyNum;
/** 每股现价 */
@property (nonatomic, strong) NSString *curPrice;
/** 持有股数 */
@property (nonatomic, strong) NSString *ownNum;
/** 每股初始价 */
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *thighMoney;
/** <#description#> */
@property (nonatomic, strong) DTPayCustomView *payView;

@end

@implementation DTEmployeeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"员工股";
    self.tableView.tableFooterView = [self tableFooterView];
    [self loadData];
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
        DTProfitTableViewCell *cell = [DTProfitTableViewCell cellWithTableView:tableView];
        cell.profitLabel.text = self.thighMoney;
        return cell;
    } else if (indexPath.row == 1) {
        DTBuyStockTableViewCell *cell = [DTBuyStockTableViewCell cellWithTableView:tableView];
        cell.delegate = self;
        cell.buyStockLabel.text = self.buyNum;
        cellDefault = cell;
    } else {
        DTSaleStockTableViewCell *cell = [DTSaleStockTableViewCell cellWithTableView:tableView];
        cell.delegate = self;
        cell.myStockLabel.text = self.ownNum;
        cell.nowStockLabel.text = [NSString stringWithFormat:@"%@元", self.curPrice];
        cell.originStockLabel.text = self.price;
        cellDefault = cell;
    }
    
    return cellDefault;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 60;
    } else if (indexPath.row == 1) {
        return 260;
    } else {
        return 290;
    }
}

#pragma mark - DTSaleStockTableViewCellDelegate

- (void)touchSaleStockButton {
    weakSelf(self);
    UIAlertController *vwcAlert = [UIAlertController alertControllerWithTitle:@"退购员工股" message:@"您确定要退购吗？" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf salesStock];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf dismissViewControllerAnimated:true completion:nil];
    }];
    
    [vwcAlert addAction:sureAction];
    [vwcAlert addAction:cancelAction];
    
    [self presentViewController:vwcAlert animated:true completion:nil];
}

- (void)salesStock {
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:[TXModelAchivar getUserModel].token forKey:@"token"];
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
    [[RCHttpHelper sharedHelper] getUrl:[httpHost stringByAppendingPathComponent:refundStock] headParams:params bodyParams:nil success:^(AFHTTPSessionManager *operation, id responseObject) {
        
        if ([responseObject[@"status"] integerValue] == 1) {
            [ShowMessage showMessage:@"退购成功"];
            [self.tableView reloadData];
        } else {
            [ShowMessage showMessage:responseObject[@"msg"]];
        }
        [MBProgressHUD hideHUDForView:self.view animated:true];
    } failure:^(AFHTTPSessionManager *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:true];
        [ShowMessage showMessage:error.description];
    }];
}

#pragma mark - DTBuyStockTableViewCellDelegate

- (void)touchBuyStockButton {
    _payView = [DTPayCustomView shareInstanceManager];
    _payView.delegate = self;
    _payView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    _payView.priceLabel.text = [NSString stringWithFormat:@"￥%@", self.curPrice];
    [_payView show];
}

- (void)touchRulesButton {
    DTEmployeeRulesViewController *vwcWith = [[DTEmployeeRulesViewController alloc] initWithNibName:NSStringFromClass([DTEmployeeRulesViewController class]) bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:vwcWith animated:true];
}

#pragma mark - Custom Method

- (UIView *)tableFooterView {
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 150)];
    footer.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UIButton *commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    commitButton.frame = CGRectMake(42, 32, SCREEN_WIDTH - 84, 49);
    commitButton.titleLabel.font = FONT(18);
//    [commitButton setImage:[UIImage imageNamed:@"ic_camera"] forState:UIControlStateNormal];
    [commitButton setTitle:@"联系我们" forState:UIControlStateNormal];
    commitButton.backgroundColor = RGB(246, 30, 46);
    [commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    commitButton.layer.cornerRadius = 24.5;
    commitButton.layer.masksToBounds = true;
    [commitButton addTarget:self action:@selector(touchCommitBtn) forControlEvents:UIControlEventTouchUpInside];
    [footer addSubview:commitButton];
    return footer;
}

- (void)touchCommitBtn {
    [self contactWithUs];
}

#pragma mark - DTPayCustomViewDelegate

- (void)touchPayBtnWithPayType:(DTPayCustomViewPayType)type {
    NSString *typePay = nil;
    if (type == DTPayCustomViewPayTypeWechat) {
        typePay = @"2";
    } else {
        typePay = @"1";
    }
    
    [self.payView hide];

    NSMutableDictionary *paramHeader = [NSMutableDictionary new];
    [paramHeader setValue:[TXModelAchivar getUserModel].token forKey:@"token"];
    
    NSMutableDictionary *paramBody = [NSMutableDictionary new];
    [paramBody setValue:typePay forKey:@"type"];
    [paramBody setValue:self.curPrice forKey:@"money"];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[RCHttpHelper sharedHelper] postUrl:[httpHost stringByAppendingPathComponent:payOrderSign]
                              headParams:paramHeader
                              bodyParams:paramBody
                                 success:^(AFHTTPSessionManager *operation, id responseObject) {
                                     [MBProgressHUD hideHUDForView:self.view];
                                     
                                     if ([responseObject[@"status"] integerValue] == 1) {
                                         if (type == DTPayCustomViewPayTypeAli) {
                                             [[AlipaySDK defaultService] payOrder:responseObject[@"data"][@"data"] fromScheme:alipayScheme callback:^(NSDictionary *resultDic) {
                                                 
                                                 
                                             }];
                                         } else {
                                             NSDictionary *dic = responseObject[@"data"][@"data"];
                                             
                                             //需要创建这个支付对象
                                             PayReq *req   = [[PayReq alloc] init];
                                             //由用户微信号和AppID组成的唯一标识，用于校验微信用户
                                             req.openID = dic[@"appid"];
                                             // 商家id，在注册的时候给的
                                             req.partnerId = dic[@"partnerid"];
                                             // 预支付订单这个是后台跟微信服务器交互后，微信服务器传给你们服务器的，你们服务器再传给你
                                             req.prepayId  = dic[@"prepayid"];
                                             // 根据财付通文档填写的数据和签名
                                             //这个比较特殊，是固定的，只能是即req.package = Sign=WXPay
                                             req.package   = @"Sign=WXPay";
                                             // 随机编码，为了防止重复的，在后台生成
                                             req.nonceStr  = dic[@"noncestr"];
                                             // 这个是时间戳，也是在后台生成的，为了验证支付的
                                             NSString * stamp = dic[@"timestamp"];
                                             req.timeStamp = stamp.intValue;
                                             // 这个签名也是后台做的
                                             req.sign = dic[@"sign"];
                                             //发送请求到微信，等待微信返回onResp
                                             [WXApi sendReq:req];
                                         }
                                     } else {
                                         
                                         [ShowMessage showMessage:responseObject[@"msg"]];
                                     }
                                 }
                                 failure:^(AFHTTPSessionManager *operation, NSError *error) {
                                     [ShowMessage showMessage:error.description];
                                     [MBProgressHUD hideHUDForView:self.view];
                                 }];
}

- (void)touchCloseViewButton {
    
}

#pragma mark - Data Request

- (void)loadData {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
    [[RCHttpHelper sharedHelper] getUrl:[httpHost stringByAppendingPathComponent:employeeStockInfo] headParams:@{@"token":[TXModelAchivar getUserModel].token} bodyParams:nil success:^(AFHTTPSessionManager *operation, id responseObject) {
        
        if ([responseObject[@"status"] integerValue] == 1) {
            self.buyNum = [NSString stringWithFormat:@"%zd", [responseObject[@"data"][@"buyNum"] integerValue]];
            self.curPrice = [NSString stringWithFormat:@"%zd", [responseObject[@"data"][@"curPirce"] integerValue]];
            self.ownNum = [NSString stringWithFormat:@"%zd", [responseObject[@"data"][@"ownNum"] integerValue]];
            self.price = [NSString stringWithFormat:@"%zd元", [responseObject[@"data"][@"price"] integerValue]];
            self.thighMoney = [NSString stringWithFormat:@"%zd元", [responseObject[@"data"][@"thighMoney"] integerValue]];
            [self.tableView reloadData];
        }
        [MBProgressHUD hideHUDForView:self.view animated:true];
        [ShowMessage showMessage:responseObject[@"msg"]];
    } failure:^(AFHTTPSessionManager *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:true];
        [ShowMessage showMessage:error.description];
    }];
}

#pragma mark - Pay Order

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 添加通知
 */
- (void)addAddressNotification {
    // 阿里支付成功
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rechargeAlipayCallBack:) name:kNSNotificationAliPaySuccess object:nil];
    // 微信支付成功
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weChatPaySuccess) name:kNSNotificationWXPaySuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(againReload) name:kNSNotificationWXPayFail object:nil];
    
}

- (void)rechargeAlipayCallBack:(NSNotification *)notification {
    
    NSDictionary *resultDic = notification.userInfo;
    NSString *message;
    
    if ([resultDic[ServerResponse_resultStatus] isEqualToString:ServerResponse_alipayCodeSuccess]) { // 充值成功后
        dispatch_async(dispatch_get_main_queue(), ^{
            [self loadData];
        });
    } else {
        if ([resultDic[ServerResponse_resultStatus] isEqualToString:ServerResponse_alipayCodeDealing]) {
            message = @"正在处理中";
        }
        else if ([resultDic[ServerResponse_resultStatus] isEqualToString:ServerResponse_alipayCodeFail]) {
            message = @"订单支付失败";
        }
        else if ([resultDic[ServerResponse_resultStatus] isEqualToString:ServerResponse_alipayCodeCancel]) {
            message = @"用户中途取消";
        }
        else {
            message = @"订单支付失败";
        }
        [ShowMessage showMessage:@"支付未成功"];
    }
}

- (void)weChatPaySuccess {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self loadData];
    });
}

- (void)againReload {
    dispatch_async(dispatch_get_main_queue(), ^{
        [ShowMessage showMessage:@"支付未成功" withCenter:self.view.center];
    });
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

@end
