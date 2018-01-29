//
//  DTPaperManagerViewController.m
//  DotMerchant
//
//  Created by 倩倩 on 2017/9/13.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTPaperManagerViewController.h"
#import "DTPaperManagerTableViewCell.h"
#import "DTPaperHeaderView.h"
#import "DTPaperListModel.h"

@interface DTPaperManagerViewController () <UITableViewDelegate, UITableViewDataSource, NetErrorViewDelegate>

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
/** <#description#> */
@property (nonatomic, strong) DTPaperListModel *colloectionModel;
/** <#description#> */
@property (nonatomic, strong) DTPaperHeaderView *header;

/** 数据源集合 */
@property (nonatomic, strong) NSMutableArray *sourceArray;

@end

@implementation DTPaperManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"纸巾管理";
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    
    self.tableView.tableFooterView = [self tableFooterView];
    self.tableView.tableHeaderView = [self tableHeaderView];
    // tableView 设置
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.tableView.mj_footer.automaticallyHidden = true;
    adjustsScrollViewInsets_NO(self.tableView, self);
    // 初始化数据
    _page = 0;
    _pageSize = 10;
    _dataCount = 0;
    self.sourceArray = [NSMutableArray new];
    
    [self.netView showAddedTo:self.view isClearBgc:false];
    
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Data Request

- (void)loadData {
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:[TXModelAchivar getUserModel].token forKey:@"token"];
    
    [[RCHttpHelper sharedHelper] getUrl:[httpHost stringByAppendingPathComponent:paperManager] headParams:params bodyParams:@{@"page": [NSString stringWithFormat:@"%zd", self.page], @"pageSize": [NSString stringWithFormat:@"%zd", self.pageSize]} success:^(AFHTTPSessionManager *operation, id responseObject) {
        if ([responseObject[@"status"] integerValue] == 1) {
            _page += 1;
            [ShowMessage showMessage:responseObject[@"msg"]];
            [self.netView stopNetViewLoadingFail:false error:false];
            DTPaperListModel *colloectionModel = [DTPaperListModel mj_objectWithKeyValues:responseObject[@"data"]];

            self.header.paperTodayLabel.text = [NSString stringWithFormat:@"(%@)", colloectionModel.curNum];
            self.header.lastPaperLabel.text = [NSString stringWithFormat:@"(%@)", colloectionModel.num];
            self.header.rewardLabel.text = [NSString stringWithFormat:@"%@元", colloectionModel.deduct];
            
            _dataCount = colloectionModel.paperList.count;
            if (_dataCount > 0) {
                [self.sourceArray addObjectsFromArray:colloectionModel.paperList];
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
    return self.sourceArray.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DTPaperManagerTableViewCell *cell = [DTPaperManagerTableViewCell cellWithTableView:tableView];
    if (indexPath.row == 0) {
        cell.cellType = DTPaperManagerTableViewCellTypeTitle;
    } else {
        cell.cellType = DTPaperManagerTableViewCellTypeContent;
        cell.listModel = self.sourceArray[indexPath.row - 1];
    }
    
    cell.cellLineType = TXCellSeperateLinePositionType_Single;
    cell.cellLineRightMargin = TXCellRightMarginType0;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (UIView *)tableHeaderView {
    _header = [DTPaperHeaderView instanceView];
    _header.frame = CGRectMake(0, 0, SCREEN_WIDTH, 190);
    return _header;
}

- (UIView *)tableFooterView {
    UILabel *footer = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
    footer.backgroundColor = [UIColor groupTableViewBackgroundColor];
    footer.textColor = RGB(153, 153, 153);
    footer.font = FONT(14);
    footer.textAlignment = NSTextAlignmentCenter;
    footer.text = @"库存低于200包将自动提示后台补货";
    
    return footer;
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
                                       title:@"暂无纸巾"
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

@end
