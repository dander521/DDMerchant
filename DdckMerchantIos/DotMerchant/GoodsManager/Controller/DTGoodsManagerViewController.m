//
//  DTGoodsManagerViewController.m
//  DotMerchant
//
//  Created by 倩倩 on 2017/9/14.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTGoodsManagerViewController.h"
#import "DTEditGoodsViewController.h"
#import "DTGoodsModel.h"
#import "DTCouponModel.h"
#import "DTVoucherViewController.h"

@interface DTGoodsManagerViewController () <UITableViewDelegate, UITableViewDataSource, DTGoodsTableViewCellDelegate, NetErrorViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *goodsTableView;

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

@implementation DTGoodsManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // tableView 设置
    self.goodsTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.goodsTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.goodsTableView.mj_footer.automaticallyHidden = true;
    self.isGoods = true;
    // 初始化数据
    _page = 0;
    _pageSize = 10;
    _dataCount = 0;
    self.sourceArray = [NSMutableArray new];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addGoodsSuccess) name:kNotificationAddGoodsSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess) name:kNotificationLoginSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginOutSuccess) name:kNotificationLoginOutSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccess) name:kNotificationGoodsOperateSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeType:) name:kNSNotificationChangeGoodsOrCouponSuccess object:nil];
    // 请求数据
    if (![[TXUserModel defaultUser] userLoginStatus]) {
        [ShowMessage showMessage:@"请登录"];
        return;
    }
    
    [self.netView showAddedTo:self.view isClearBgc:false];
}

- (void)changeType:(NSNotification *)noti {
    _page = 0;
    _pageSize = 10;
    _dataCount = 0;
    
    NSDictionary *dic = noti.userInfo;
    if ([dic[@"type"] isEqualToString:@"0"]) {
        self.isGoods = false;
    } else {
        self.isGoods = true;
    }
    [self loadNewData];
}

- (void)addGoodsSuccess {
    [self loadNewData];
}

- (void)loginSuccess {
    [self loadNewData];
}

- (void)loginOutSuccess {
    [self.sourceArray removeAllObjects];
    [self.goodsTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Data Request

- (void)loadData {
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:[TXModelAchivar getUserModel].token forKey:@"token"];
    
    NSString *urlStr = self.isGoods ? goodsList : couponList;
    
    [[RCHttpHelper sharedHelper] getUrl:[httpHost stringByAppendingPathComponent:urlStr] headParams:params bodyParams:@{@"status":[NSString stringWithFormat:@"%zd", self.cellType], @"page": [NSString stringWithFormat:@"%zd", self.page], @"pageSize": [NSString stringWithFormat:@"%zd", self.pageSize]} success:^(AFHTTPSessionManager *operation, id responseObject) {
        if ([responseObject[@"status"] integerValue] == 1) {
            _page += 1;
            [ShowMessage showMessage:responseObject[@"msg"]];
            [self.netView stopNetViewLoadingFail:false error:false];
            if (self.isGoods) {
                DTGoodsCollectionModel *colloectionModel = [DTGoodsCollectionModel mj_objectWithKeyValues:responseObject];
                _dataCount = colloectionModel.data.count;
                if (_dataCount > 0) {
                    [self.sourceArray addObjectsFromArray:colloectionModel.data];
                }
                if (self.sourceArray.count == 0) {
                    [self showBlankView];
                } else {
                    [self.blankView removeFromSuperview];
                    if (_dataCount < _pageSize) {
                        [self.goodsTableView.mj_footer setState:MJRefreshStateNoMoreData];
                    }
                }
            } else {
                DTCouponCollectionModel *colloectionModel = [DTCouponCollectionModel mj_objectWithKeyValues:responseObject];
                _dataCount = colloectionModel.data.count;
                if (_dataCount > 0) {
                    [self.sourceArray addObjectsFromArray:colloectionModel.data];
                }
                if (self.sourceArray.count == 0) {
                    [self showBlankView];
                } else {
                    [self.blankView removeFromSuperview];
                    if (_dataCount < _pageSize) {
                        [self.goodsTableView.mj_footer setState:MJRefreshStateNoMoreData];
                    }
                }
            }
            
            [self.goodsTableView reloadData];
        } else {
            [self.netView stopNetViewLoadingFail:false error:true];
            [ShowMessage showMessage:responseObject[@"msg"]];
        }
        [_goodsTableView.mj_header endRefreshing];
        [_goodsTableView.mj_footer endRefreshing];
    } failure:^(AFHTTPSessionManager *operation, NSError *error) {
        [_goodsTableView.mj_header endRefreshing];
        [_goodsTableView.mj_footer endRefreshing];
        [self.netView stopNetViewLoadingFail:true error:false];
        [ShowMessage showMessage:error.description];
    }];
}

- (void)loadMoreData {
    if (_dataCount < _pageSize) {
        [_goodsTableView.mj_footer setState:MJRefreshStateNoMoreData];
    } else {
        [self loadData];
    }
}

- (void)loadNewData {
    [self.sourceArray removeAllObjects];
    _page = 0;
    [self loadData];
    [_goodsTableView.mj_header endRefreshing];
    [_goodsTableView.mj_footer endRefreshing];
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
    DTGoodsTableViewCell *cell = [DTGoodsTableViewCell cellWithTableView:tableView];
    cell.cellType = self.cellType;
    cell.delegate = self;
    cell.cellLineType = TXCellSeperateLinePositionType_Single;
    cell.cellLineRightMargin = TXCellRightMarginType0;
    cell.isGoods = self.isGoods;
    if (self.sourceArray.count >= indexPath.row) {
        if (self.isGoods) {
            cell.goodsModel = self.sourceArray[indexPath.row];
        } else {
            cell.couponModel = self.sourceArray[indexPath.row];
        }
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 118;
}

#pragma mark - DTGoodsTableViewCellDelegate

- (void)touchDeleteButtonWithModel:(id)model {
    // 请求数据
    if (![[TXUserModel defaultUser] userLoginStatus]) {
        [ShowMessage showMessage:@"请登录"];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
    
    if (self.isGoods) {
        DTGoodsModel *goodsModel = (DTGoodsModel *)model;
        [[RCHttpHelper sharedHelper] getUrl:[httpHost stringByAppendingPathComponent:deleteGoods] headParams:@{@"token" : [TXModelAchivar getUserModel].token} bodyParams:@{@"id": goodsModel.idField} success:^(AFHTTPSessionManager *operation, id responseObject) {
            [MBProgressHUD hideHUDForView:self.view];
            if ([responseObject[@"status"] integerValue] == 1) {
                [ShowMessage showMessage:@"删除成功"];
                [self loadNewData];
            } else {
                [ShowMessage showMessage:responseObject[@"msg"]];
            }
        } failure:^(AFHTTPSessionManager *operation, NSError *error) {
            [ShowMessage showMessage:error.description];
            [MBProgressHUD hideHUDForView:self.view];
        }];
    } else {
        DTCouponModel *couponModel = (DTCouponModel *)model;
        [[RCHttpHelper sharedHelper] getUrl:[httpHost stringByAppendingPathComponent:couponDelete] headParams:@{@"token" : [TXModelAchivar getUserModel].token} bodyParams:@{@"id": couponModel.idField} success:^(AFHTTPSessionManager *operation, id responseObject) {
            [MBProgressHUD hideHUDForView:self.view];
            if ([responseObject[@"status"] integerValue] == 1) {
                [ShowMessage showMessage:@"删除成功"];
                [self loadNewData];
            } else {
                [ShowMessage showMessage:responseObject[@"msg"]];
            }
        } failure:^(AFHTTPSessionManager *operation, NSError *error) {
            [ShowMessage showMessage:error.description];
            [MBProgressHUD hideHUDForView:self.view];
        }];
    }
}

- (void)touchEditButtonWithModel:(id)model {
    NSLog(@"touchEditButton");
    if (self.isGoods) {
        DTGoodsModel *goodsModel = (DTGoodsModel *)model;
        DTEditGoodsViewController *vwcEdit = [[DTEditGoodsViewController alloc] initWithNibName:NSStringFromClass([DTEditGoodsViewController class]) bundle:[NSBundle mainBundle]];
        vwcEdit.goodsId = goodsModel.idField;
        [self.navigationController pushViewController:vwcEdit animated:true];
    } else {
        DTCouponModel *couponModel = (DTCouponModel *)model;
        DTVoucherViewController *vwcEdit = [[DTVoucherViewController alloc] initWithNibName:NSStringFromClass([DTVoucherViewController class]) bundle:[NSBundle mainBundle]];
        vwcEdit.model = couponModel;
        [self.navigationController pushViewController:vwcEdit animated:true];
    }
}

- (void)touchActionButtonWithModel:(id)model {
    NSLog(@"touchActionButton");
    NSString *status = nil;
    // 已上架
    if (self.cellType == DTGoodsTableViewCellTypeUp) {
        // 下架操作
        status = @"2";
    } else {
        // 上架操作
        status = @"1";
    }
    
    // 请求数据
    if (![[TXUserModel defaultUser] userLoginStatus]) {
        [ShowMessage showMessage:@"请登录"];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
    
    if (self.isGoods) {
        DTGoodsModel *goodsModel = (DTGoodsModel *)model;
        [[RCHttpHelper sharedHelper] getUrl:[httpHost stringByAppendingPathComponent:goodsUpOrDown] headParams:@{@"token" : [TXModelAchivar getUserModel].token} bodyParams:@{@"id": goodsModel.idField,@"status":status} success:^(AFHTTPSessionManager *operation, id responseObject) {
            [MBProgressHUD hideHUDForView:self.view];
            if ([responseObject[@"status"] integerValue] == 1) {
                [ShowMessage showMessage:@"操作成功"];
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationGoodsOperateSuccess object:nil userInfo:nil];
            } else {
                [ShowMessage showMessage:responseObject[@"msg"]];
            }
        } failure:^(AFHTTPSessionManager *operation, NSError *error) {
            [ShowMessage showMessage:error.description];
            [MBProgressHUD hideHUDForView:self.view];
        }];
    } else {
        DTCouponModel *couponModel = (DTCouponModel *)model;
        [[RCHttpHelper sharedHelper] getUrl:[httpHost stringByAppendingPathComponent:couponStatus] headParams:@{@"token" : [TXModelAchivar getUserModel].token} bodyParams:@{@"id": couponModel.idField,@"status":status} success:^(AFHTTPSessionManager *operation, id responseObject) {
            [MBProgressHUD hideHUDForView:self.view];
            if ([responseObject[@"status"] integerValue] == 1) {
                [ShowMessage showMessage:@"操作成功"];
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationGoodsOperateSuccess object:nil userInfo:nil];
            } else {
                [ShowMessage showMessage:responseObject[@"msg"]];
            }
        } failure:^(AFHTTPSessionManager *operation, NSError *error) {
            [ShowMessage showMessage:error.description];
            [MBProgressHUD hideHUDForView:self.view];
        }];
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
        [self.blankView createBlankViewWithImage:@"wudingdan"
                                           title:@"您还没有商品或代金券，请添加"
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
