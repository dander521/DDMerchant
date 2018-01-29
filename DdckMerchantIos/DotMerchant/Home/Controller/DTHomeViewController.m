//
//  DTHomeViewController.m
//  DotMerchant
//
//  Created by 倩倩 on 2017/9/12.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTHomeViewController.h"
#import "DTHomeCollectionViewCell.h"
#import "DTHeaderCollectionReusableView.h"
#import "SGQRCodeScanningVC.h"
#import <AVFoundation/AVFoundation.h>

static NSString *cellID = @"DTHomeCollectionViewCell";
static NSString *headerID = @"DTHeaderCollectionReusableView";

@interface DTHomeViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, DTHeaderCollectionReusableViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
/** 数据源*/
@property (nonatomic, strong) NSArray *imageDataSource;
@property (nonatomic, strong) NSArray *titleDataSource;
/** 头部 */
@property (nonatomic, strong) DTHeaderCollectionReusableView *reusableHeaderView;

@end

@implementation DTHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialDataSource];
    
    [self initializeInterface];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess:) name:kNotificationLoginSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginOutSuccess:) name:kNotificationLoginOutSuccess object:nil];
}

- (void)loginSuccess:(NSNotification *)noti {
    // shopStatus; // 店铺状态（1：营业，2：停业）
    if ([TXModelAchivar getUserModel].shopStatus == 1) {
        [self.reusableHeaderView.segmentControl setSelectedSegmentIndex:1];
    } else {
        [self.reusableHeaderView.segmentControl setSelectedSegmentIndex:0];
    }
}

- (void)loginOutSuccess:(NSNotification *)noti {
    
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

#pragma mark - init

- (void)initialDataSource {
    self.imageDataSource = @[@"img_order_comment", @"img_notification_center", @"img_order_list", @"img_qrcode_receipt", @"img_qrcode_paper", @"img_paper_manager", @"img_store_work", @"img_payback_set", @"img_revenue_statistics"];
    self.titleDataSource = @[@"评价管理", @"消息中心", @"订单列表", @"收款二维码", @"纸巾二维码", @"纸巾管理", @"店铺运营", @"红包设置", @"营收统计"];
}

- (void)initializeInterface {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, 250);
    self.collectionView.collectionViewLayout = flowLayout;
    //设置最小间距
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    //设置格子大小
    CGFloat w = (SCREEN_WIDTH-3)/3;
    CGFloat h = (SCREEN_WIDTH-3)/3*1.2;
    flowLayout.itemSize = CGSizeMake(w, h);
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.collectionView registerNib:[UINib nibWithNibName:cellID bundle:nil] forCellWithReuseIdentifier:cellID];
    [self.collectionView registerNib:[UINib nibWithNibName:headerID bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerID];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 9;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DTHomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.iconImageView.image = [UIImage imageNamed:self.imageDataSource[indexPath.item]];
    cell.homeItemLabel.text = self.titleDataSource[indexPath.item];
    return cell;
}

#pragma - mark  UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // 请求数据
    if (![[TXUserModel defaultUser] userLoginStatus]) {
        [ShowMessage showMessage:@"请登录"];
        return;
    }
    
    // 请求数据
    if ([NSString isTextEmpty:[NSString stringWithFormat:@"%@",[TXModelAchivar getUserModel].auditStatus]]) {
        [ShowMessage showMessage:@"请前往个人中心实名认证"];
        return;
    } else if ([[TXModelAchivar getUserModel].auditStatus integerValue] == 0) {
        [ShowMessage showMessage:@"正在实名审核，请耐心等待"];
        return;
    } else if ([[TXModelAchivar getUserModel].auditStatus integerValue] == 1) {
        [ShowMessage showMessage:@"实名认证未通过，请前往个人中心实名认证"];
        return;
    }
    
    // 请求数据
    if ([TXModelAchivar getUserModel].shopId == 0) {
        [ShowMessage showMessage:@"请前往个人中心申请开店"];
        return;
    }
    
    if (indexPath.row == 6) {
        if ([[TXModelAchivar getUserModel].auditStatus integerValue] == 2) {
            [self customPushActionWithControllerName:@"DTStoreWorkViewController"];
        }
        return;
    }
    
    if (indexPath.row == 5) {
        if ([TXModelAchivar getUserModel].paperId == 0) {
            [ShowMessage showMessage:@"请前往个人中心开通纸巾"];
            return;
        } else {
            [self customPushActionWithControllerName:@"DTPaperManagerViewController"];
        }
        return;
    }
    
    NSArray *subControllers = @[@"DTCommentManagerViewController", @"DTNotificationCenterViewController", @"DTOrderListCollectionViewController", @"DTReceiptQRViewController", @"DTPaperQRViewController", @"DTPaperManagerViewController", @"DTStoreWorkViewController", @"DTPaybackSetViewController", @"DTRevenueStaticticsViewController"];
    [self customPushActionWithControllerName:subControllers[indexPath.item]];
}

- (void)customPushActionWithControllerName:(NSString *)controllerName {
    UIViewController *vwc = [NSClassFromString(controllerName) new];
    vwc.hidesBottomBarWhenPushed = true;
    [self.navigationController pushViewController:vwc animated:true];
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    //判断当前设置视图的位置（头部或者）
    if (kind == UICollectionElementKindSectionHeader) {
        _reusableHeaderView = [self.collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerID forIndexPath:indexPath];
        _reusableHeaderView.delegate = self;
        if ([TXModelAchivar getUserModel].shopStatus == 1) {
            [self.reusableHeaderView.segmentControl setSelectedSegmentIndex:1];
        } else {
            [self.reusableHeaderView.segmentControl setSelectedSegmentIndex:0];
        }
        return _reusableHeaderView;
    } else {
        return nil;
    }
}

#pragma mark - DTHeaderCollectionReusableViewDelegate

- (void)touchTicketVerifyButton {
    if (![[TXUserModel defaultUser] userLoginStatus]) {
        [ShowMessage showMessage:@"请登录"];
        return;
    }
    [self customPushActionWithControllerName:@"DTTicketVerifyViewController"];
}

- (void)touchQRCodeVerifyButton {
    if (![[TXUserModel defaultUser] userLoginStatus]) {
        [ShowMessage showMessage:@"请登录"];
        return;
    }
    // 1、 获取摄像设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device) {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (status == AVAuthorizationStatusNotDetermined) {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        SGQRCodeScanningVC *vc = [[SGQRCodeScanningVC alloc] init];
                        [self.navigationController pushViewController:vc animated:YES];
                    });
                    // 用户第一次同意了访问相机权限
                    NSLog(@"用户第一次同意了访问相机权限 - - %@", [NSThread currentThread]);
                    
                } else {
                    // 用户第一次拒绝了访问相机权限
                    NSLog(@"用户第一次拒绝了访问相机权限 - - %@", [NSThread currentThread]);
                }
            }];
        } else if (status == AVAuthorizationStatusAuthorized) { // 用户允许当前应用访问相机
            SGQRCodeScanningVC *vc = [[SGQRCodeScanningVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        } else if (status == AVAuthorizationStatusDenied) { // 用户拒绝当前应用访问相机
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请去-> [设置 - 隐私 - 相机 - SGQRCodeExample] 打开访问开关" preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alertC addAction:alertA];
            [self presentViewController:alertC animated:YES completion:nil];
            
        } else if (status == AVAuthorizationStatusRestricted) {
            NSLog(@"因为系统原因, 无法访问相册");
        }
    } else {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"未检测到您的摄像头" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alertC addAction:alertA];
        [self presentViewController:alertC animated:YES completion:nil];
    }

}

- (void)touchWorkOrNotSegmentControlWithIndex:(NSInteger)selectedIndex {
    NSLog(@"selectedIndex = %zd", selectedIndex);
    
    if (![[TXUserModel defaultUser] userLoginStatus]) {
        [ShowMessage showMessage:@"请登录"];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
    [[RCHttpHelper sharedHelper] getUrl:[httpHost stringByAppendingPathComponent:storeWorkOrNot] headParams:@{@"token": [TXModelAchivar getUserModel].token} bodyParams:nil success:^(AFHTTPSessionManager *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view];
        if ([responseObject[@"status"] integerValue] == 1) {
            if ([TXModelAchivar getUserModel].shopStatus == 1) {
                [TXModelAchivar updateUserModelWithKey:@"shopStatus" value:@"2"];
                [ShowMessage showMessage:@"停止营业"];
            } else {
                [TXModelAchivar updateUserModelWithKey:@"shopStatus" value:@"1"];
                [ShowMessage showMessage:@"开始营业"];
            }
        } else {
            [ShowMessage showMessage:responseObject[@"msg"]];
        }
    } failure:^(AFHTTPSessionManager *operation, NSError *error) {
        [ShowMessage showMessage:error.description];
        [MBProgressHUD hideHUDForView:self.view];
    }];
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

#pragma mark - setters

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
