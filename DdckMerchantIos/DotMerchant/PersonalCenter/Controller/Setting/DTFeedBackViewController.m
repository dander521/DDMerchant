//
//  DTFeedBackViewController.m
//  DotMerchant
//
//  Created by 倩倩 on 2017/9/18.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTFeedBackViewController.h"
#import "DTGoodsDetailTableViewCell.h"

@interface DTFeedBackViewController () <UITableViewDataSource, UITableViewDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) UITextView *feedTV;
@property (nonatomic, strong) UIButton *commitButton;

@end

@implementation DTFeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.isFeedBack ? @"意见反馈" : @"回复";
    self.tableView.tableFooterView = [self tableFooterView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidChanged:) name:UITextViewTextDidChangeNotification object:nil];
}

- (void)textViewDidChanged:(NSNotification *)noti {
    if (self.feedTV.text.length != 0) {
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
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DTGoodsDetailTableViewCell *cell = [DTGoodsDetailTableViewCell cellWithTableView:tableView];
    cell.desLabel.text = @"";
    NSString *placeholder = self.isFeedBack ? @"请输入您要反馈的问题" : @"请输入您的回复";
    [cell.contentTextView addPlaceholderWithText:placeholder textColor:RGB(153, 153, 153) font:[UIFont fontWithName:@"Helvetica-Light" size:16]];
    self.feedTV = cell.contentTextView;
    cell.cellLineType = TXCellSeperateLinePositionType_None;
//    cell.cellLineRightMargin = TXCellRightMarginType0;
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 140;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

#pragma mark - Custom 

- (UIView *)tableFooterView {
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 150)];
    footer.backgroundColor = [UIColor clearColor];
    
    _commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _commitButton.frame = CGRectMake(42, 82, SCREEN_WIDTH - 84, 49);
    _commitButton.titleLabel.font = FONT(18);
    [_commitButton setTitle:@"提交" forState:UIControlStateNormal];
    _commitButton.backgroundColor = RGB(153, 153, 153);
    [_commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _commitButton.layer.cornerRadius = 24.5;
    _commitButton.layer.masksToBounds = true;
    [_commitButton addTarget:self action:@selector(touchCommitBtn) forControlEvents:UIControlEventTouchUpInside];
    [footer addSubview:_commitButton];
    return footer;
}

- (void)touchCommitBtn {
    NSString *postUrl = self.isFeedBack ? [httpHost stringByAppendingPathComponent:feedback] : [httpHost stringByAppendingPathComponent:commentReply];
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    if (self.isFeedBack) {
        [params setValue:self.feedTV.text forKey:@"content"];
    } else {
        [params setValue:self.feedTV.text forKey:@"content"];
        [params setValue:self.commenId forKey:@"commenId"];
    }
    
    NSMutableDictionary *headerParams = [NSMutableDictionary new];
    if (self.isFeedBack) {
        headerParams = nil;
    } else {
        if (![[TXUserModel defaultUser] userLoginStatus]) {
            [ShowMessage showMessage:@"请登录"];
            return;
        }
        [headerParams setValue:[TXModelAchivar getUserModel].token forKey:@"token"];
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
    [[RCHttpHelper sharedHelper] postUrl:postUrl headParams:headerParams bodyParams:params success:^(AFHTTPSessionManager *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:true];
        if ([responseObject[@"status"] integerValue] == 1) {
            if (self.isFeedBack) {
                [ShowMessage showMessage:@"反馈成功"];
            } else {
                [ShowMessage showMessage:@"回复成功"];
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationReplySuccess object:nil userInfo:nil];
            }
            [self.navigationController popViewControllerAnimated:true];
        } else {
            [ShowMessage showMessage:responseObject[@"msg"]];
        }
    } failure:^(AFHTTPSessionManager *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:true];
        [ShowMessage showMessage:error.description];
    }];
    
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}




@end
