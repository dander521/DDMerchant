//
//  DTCommentManagerViewController.m
//  DotMerchant
//
//  Created by 倩倩 on 2017/9/13.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTCommentManagerViewController.h"
#import "DTCommentTableViewCell.h"
#import "UITextView+TXPlaceholder.h"
#import "DTFeedBackViewController.h"
#import "DTCommentModel.h"
#import "DTCommentedViewController.h"

@interface DTCommentManagerViewController () <UITableViewDelegate, UITableViewDataSource, DTCommentTableViewCellDelegate, UITextViewDelegate, NetErrorViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) UITextView *textView;

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

@implementation DTCommentManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.navigationItem.title = @"评价管理";
    self.tableView.estimatedRowHeight = 202.0;
    
    [self initialInterface];
    
    // tableView 设置
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.tableView.mj_footer.automaticallyHidden = true;
    
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadNewData) name:kNotificationReplySuccess object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Custom Method

- (void)initialInterface {
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-100, SCREEN_WIDTH, 100)];
    self.textView.backgroundColor = [UIColor whiteColor];
    self.textView.font = FONT(16);
    [self.textView addPlaceholderWithText:@"请输入您的回复内容" textColor:RGB(153, 153, 153) font:[UIFont fontWithName:@"Helvetica-Light" size:16]];
    self.textView.hidden = true;
    self.textView.delegate = self;
//    [self.view addSubview:self.textView];
}


#pragma mark - Data Request

- (void)loadData {
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:[TXModelAchivar getUserModel].token forKey:@"token"];
    
    [[RCHttpHelper sharedHelper] getUrl:[httpHost stringByAppendingPathComponent:commentList] headParams:params bodyParams:@{@"page": [NSString stringWithFormat:@"%zd", self.page], @"pageSize": [NSString stringWithFormat:@"%zd", self.pageSize]} success:^(AFHTTPSessionManager *operation, id responseObject) {
        if ([responseObject[@"status"] integerValue] == 1) {
            _page += 1;
            [ShowMessage showMessage:responseObject[@"msg"]];
            [self.netView stopNetViewLoadingFail:false error:false];
            DTCommentCollectionModel *colloectionModel = [DTCommentCollectionModel mj_objectWithKeyValues:responseObject];
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
    DTCommentTableViewCell *cell = [DTCommentTableViewCell cellWithTableView:tableView];
    cell.cellLineType = TXCellSeperateLinePositionType_Single;
    cell.cellLineRightMargin = TXCellRightMarginType0;
    cell.delegate = self;
    cell.isDetail = false;
    if (self.sourceArray.count - 1 >= indexPath.row) {
        cell.commentModel = self.sourceArray[indexPath.row];
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DTCommentModel *model = [DTCommentModel new];
    if (self.sourceArray.count - 1 >= indexPath.row) {
        model = self.sourceArray[indexPath.row];
    }
    DTCommentedViewController *vwcComment = [[DTCommentedViewController alloc] initWithNibName:NSStringFromClass([DTCommentedViewController class]) bundle:[NSBundle mainBundle]];
    vwcComment.model = model;
    [self.navigationController pushViewController:vwcComment animated:true];
}

#pragma mark - DTCommentTableViewCellDelegate

- (void)touchImageViewWithIndex:(NSInteger)index array:(NSArray *)imgArray cell:(DTCommentTableViewCell *)cell {
    NSLog(@"index = %zd", index);
    NSMutableArray *browseItemArray = [[NSMutableArray alloc]init];
    for(int i = 0;i < [imgArray count];i++) {
        NSString *imagePath = imgArray[i];
        MSSBrowseModel *browseItem = [[MSSBrowseModel alloc]init];
        browseItem.bigImageUrl = [imageHost stringByAppendingPathComponent:imagePath];// 加载网络图片大图地址
        
        if (i == 0) {
            browseItem.smallImageView = cell.firstCommentImageView;
        } else if (i == 1) {
            browseItem.smallImageView = cell.secondCommentImageView;
        } else {
            browseItem.smallImageView = cell.thirdCommentImageView;
        }
        
        [browseItemArray addObject:browseItem];
    }
    MSSBrowseNetworkViewController *vwcBrowse = [[MSSBrowseNetworkViewController alloc] initWithBrowseItemArray:browseItemArray currentIndex:index];
    [vwcBrowse showBrowseViewController];
}

- (void)touchReplyButtonWithModel:(DTCommentModel *)model {
//    self.textView.hidden = false;
//    [self.textView becomeFirstResponder];
    
    DTFeedBackViewController *vwcFeed = [[DTFeedBackViewController alloc] initWithNibName:NSStringFromClass([DTFeedBackViewController class]) bundle:[NSBundle mainBundle]];
    vwcFeed.commenId = model.idField;
    [self.navigationController pushViewController:vwcFeed animated:true];
}


#pragma mark - UITextViewDelegate

- (void)textViewDidEndEditing:(UITextView *)textView {
    self.textView.hidden = true;
    
    NSLog(@"textView.text = %@", textView.text);
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
                                       title:@"暂无评价"
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
