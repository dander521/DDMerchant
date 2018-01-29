//
//  DTOrderListViewController.m
//  DotMerchant
//
//  Created by 倩倩 on 2017/9/13.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTOrderListViewController.h"
#import "DTOrderListTableViewCell.h"
#import "DTTicketVerifyViewController.h"
#import "SGQRCodeScanningVC.h"
#import <AVFoundation/AVFoundation.h>
#import "DTAppealViewController.h"
#import "DTOrderListModel.h"

@interface DTOrderListViewController () <UITableViewDelegate, UITableViewDataSource, DTOrderListTableViewCellDelegate, NetErrorViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** 加载页面 */
@property (strong, nonatomic) NetErrorView *netView;
/** 无数据提示页面 */
@property (nonatomic, strong) TXBlankView *blankView;
/** 分页数 */
@property (nonatomic, assign) NSInteger page;
/** 分页请求条数 */
@property (nonatomic, assign) NSInteger pageSize;
/** 返回数据条数 */
@property (nonatomic, assign) NSInteger dataCount;
/** 数据源集合 */
@property (nonatomic, strong) NSMutableArray *sourceArray;
@end

@implementation DTOrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.estimatedRowHeight = 260.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;

    // tableView 设置
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.tableView.mj_footer.automaticallyHidden = true;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkSuccess) name:kNSNotificationCheckSuccess object:nil];
    
    // 初始化数据
    _page = 0;
    _pageSize = 10;
    _dataCount = 0;
    self.sourceArray = [NSMutableArray new];
    
    // 请求数据
    if (![[TXUserModel defaultUser] userLoginStatus]) {
        [ShowMessage showMessage:@"请登录"];
        return;
    }
    
    [self.netView showAddedTo:self.view isClearBgc:false];
    
    [self loadData];
}


- (void)checkSuccess {
    [self loadNewData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Data Request

- (void)loadData {
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:[TXModelAchivar getUserModel].token forKey:@"token"];
    
    NSMutableDictionary *paramsBody = [NSMutableDictionary new];
    if (self.cellType == 1) {
        [paramsBody setValue:@"1" forKey:@"status"];
    } else if (self.cellType == 2) {
        [paramsBody setValue:@"2" forKey:@"status"];
    } else {
        [paramsBody setValue:@"3" forKey:@"status"];
    }
    
    [paramsBody setValue:[NSString stringWithFormat:@"%zd", self.page] forKey:@"page"];
    [paramsBody setValue:[NSString stringWithFormat:@"%zd", self.pageSize] forKey:@"pageSize"];
    
    [[RCHttpHelper sharedHelper] getUrl:[httpHost stringByAppendingPathComponent:orderList] headParams:params bodyParams:paramsBody success:^(AFHTTPSessionManager *operation, id responseObject) {
        if ([responseObject[@"status"] integerValue] == 1) {
            _page += 1;
            [ShowMessage showMessage:responseObject[@"msg"]];
            [self.netView stopNetViewLoadingFail:false error:false];
            DTOrderListCollectionModel *colloectionModel = [DTOrderListCollectionModel mj_objectWithKeyValues:responseObject];
            _dataCount = colloectionModel.data.count;
            if (_dataCount > 0) {
                [self.sourceArray addObjectsFromArray:colloectionModel.data];
            }
            if (self.sourceArray.count == 0) {
                [self showBlankView];
            } else {
                [self.blankView removeFromSuperview];
                if (_dataCount < _pageSize) {
                    [self.tableView.mj_footer setState:MJRefreshStateNoMoreData];
                }
            }
            [self.tableView reloadData];
        } else {
            [self.netView stopNetViewLoadingFail:false error:true];
            [ShowMessage showMessage:responseObject[@"msg"]];
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    } failure:^(AFHTTPSessionManager *operation, NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self.netView stopNetViewLoadingFail:true error:false];
        [ShowMessage showMessage:error.description];
    }];
}

- (void)loadMoreData {
    if (_dataCount < _pageSize) {
        [self.tableView.mj_footer setState:MJRefreshStateNoMoreData];
    } else {
        [self loadData];
    }
}

- (void)loadNewData {
    [self.sourceArray removeAllObjects];
    _page = 0;
    [self loadData];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

#pragma mark - Custom

- (void)showBlankView {
    [self.view addSubview:self.blankView];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DTOrderListTableViewCell *cell = [DTOrderListTableViewCell cellWithTableView:tableView];
    cell.cellLineType = TXCellSeperateLinePositionType_Single;
    cell.cellLineRightMargin = TXCellRightMarginType0;
    cell.cellType = self.cellType;
    cell.delegate = self;
    if (indexPath.row <= self.sourceArray.count) {
        cell.listModel = self.sourceArray[indexPath.row];
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

#pragma mark - DTOrderListTableViewCellDelegate

- (void)touchTicketVerifyButtonWithModel:(DTOrderListModel *)model {
    NSLog(@"touchTicketVerifyButton");
    // 密码核销
    DTTicketVerifyViewController *vwcTicket = [[DTTicketVerifyViewController alloc] initWithNibName:NSStringFromClass([DTTicketVerifyViewController class]) bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:vwcTicket animated:true];
}

- (void)touchActionButtonWithModel:(DTOrderListModel *)model {
    NSLog(@"touchActionButton");
    if (self.cellType == 1) {
        // 扫码核销
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

    } else {
        // 申诉
        DTAppealViewController *vwcAppeal = [[DTAppealViewController alloc] initWithNibName:NSStringFromClass([DTAppealViewController class]) bundle:[NSBundle mainBundle]];
        vwcAppeal.orderId = model.idField;
        vwcAppeal.model = model;
        [self.navigationController pushViewController:vwcAppeal animated:true];
    }
}

#pragma mark - NetErrorViewDelegate

- (void)reloadDataNetErrorView:(NetErrorView *)errorView {
    [self loadNewData];
}

#pragma mark - Lazy

/**
 空白页
 */
- (UIView *)blankView {
    if (nil == _blankView) {
        _blankView = [[TXBlankView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64)];
        _blankView.backgroundColor = RGB(255, 255, 255);
        [_blankView createBlankViewWithImage:@"wudingdan"
                                       title:@"暂无订单"
                                    subTitle:nil];
        
        _blankView.isFull = YES;
    }
    
    return _blankView;
}

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
