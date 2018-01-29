//
//  DTSettingViewController.m
//  DotMerchant
//
//  Created by 倩倩 on 2017/9/14.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTSettingViewController.h"
#import "DTAboutViewController.h"
#import "DTFeedBackViewController.h"
#import "UMessage.h"
#import "DTRetrieveViewController.h"

@interface DTSettingViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UISwitch *cusSwitch;
@property (strong, nonatomic) UILabel *cacheLabel;

@end

@implementation DTSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"设置";
    self.tableView.tableFooterView = [self tableFooterView];

    if([TXModelAchivar getUserModel].pushMsg == 1){
        [UMessage registerForRemoteNotifications];
    }else{
        [UMessage unregisterForRemoteNotifications];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"defaultCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"修改密码";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"消息提醒";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryView = self.cusSwitch;
    } else if (indexPath.row == 2) {
        cell.textLabel.text = @"清除缓存";
        [self setUpCacheSize:cell];
    } else if (indexPath.row == 3) {
        cell.textLabel.text = @"意见反馈";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    } else {
        cell.textLabel.text = @"关于";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 58;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    if (indexPath.row == 0) {
        // 请求数据
        if (![[TXUserModel defaultUser] userLoginStatus]) {
            [ShowMessage showMessage:@"请登录"];
            return;
        }
        DTRetrieveViewController *vwcFeed = [[DTRetrieveViewController alloc] initWithNibName:NSStringFromClass([DTRetrieveViewController class]) bundle:[NSBundle mainBundle]];
        vwcFeed.isSetSecret = true;
        [self.navigationController pushViewController:vwcFeed animated:true];
    } else if (indexPath.row == 2) {
        [self cleanCache];
    } else if (indexPath.row == 3) {
        DTFeedBackViewController *vwcFeed = [[DTFeedBackViewController alloc] initWithNibName:NSStringFromClass([DTFeedBackViewController class]) bundle:[NSBundle mainBundle]];
        vwcFeed.isFeedBack = true;
        [self.navigationController pushViewController:vwcFeed animated:true];
    } else if (indexPath.row == 4) {
        DTAboutViewController *vwcFeed = [[DTAboutViewController alloc] initWithNibName:NSStringFromClass([DTAboutViewController class]) bundle:[NSBundle mainBundle]];
        [self.navigationController pushViewController:vwcFeed animated:true];
    }
}

#pragma mark - Custom Method

- (UIView *)tableFooterView {
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 150)];
    footer.backgroundColor = [UIColor clearColor];
    
    UIButton *commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    commitButton.frame = CGRectMake(42, 62, SCREEN_WIDTH - 84, 49);
    commitButton.titleLabel.font = FONT(18);
    [commitButton setTitle:@"退出登录" forState:UIControlStateNormal];
    commitButton.backgroundColor = RGB(246, 30, 46);
    [commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    commitButton.layer.cornerRadius = 24.5;
    commitButton.layer.masksToBounds = true;
    [commitButton addTarget:self action:@selector(touchCommitBtn) forControlEvents:UIControlEventTouchUpInside];
    [footer addSubview:commitButton];
    return footer;
}

// 退出登录
- (void)touchCommitBtn {
    [UMessage removeAlias:[TXModelAchivar getUserModel].account type:@"ddmerchant" response:^(id responseObject, NSError *error) {
    }];
    [[TXUserModel defaultUser] resetModelData];
    [TXModelAchivar achiveUserModel];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationLoginOutSuccess object:nil userInfo:nil];
    [self.navigationController popViewControllerAnimated:true];
}

- (UISwitch *)cusSwitch {
    if (!_cusSwitch) {
        _cusSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];
        _cusSwitch.onTintColor = RGB(246, 30, 46);
        [_cusSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        if([TXModelAchivar getUserModel].pushMsg == 1) {
            [_cusSwitch setOn:true];
        } else {
            [_cusSwitch setOn:false];
        }
    }
    return _cusSwitch;
}

- (void)switchAction:(UISwitch *)sender {
    if(sender.isOn){
        [UMessage registerForRemoteNotifications];
        [TXModelAchivar updateUserModelWithKey:@"pushMsg" value:@"1"];
    }else{
        [UMessage unregisterForRemoteNotifications];
        [TXModelAchivar updateUserModelWithKey:@"pushMsg" value:@"0"];
    }
    [self.cusSwitch setOn:sender.isOn];
}

// 缓存
-(void)setUpCacheSize:(UITableViewCell *)cell {
    
    _cacheLabel = [[UILabel alloc] init];
    _cacheLabel.textAlignment = NSTextAlignmentRight;
    NSUInteger size = 0;
    size = [[SDImageCache sharedImageCache] getSize];

    if (size < 1024 * 1024) {
        _cacheLabel.text = [NSString stringWithFormat:@"%.2f KB", size/1024.0];
    } else {
        _cacheLabel.text = [NSString stringWithFormat:@"%.2f MB", size/1024.0/1024.0];
    }
    _cacheLabel.font = [UIFont systemFontOfSize:14.0];
    _cacheLabel.textColor = RGB(189, 190, 192);
    [cell.contentView addSubview:_cacheLabel];
    [_cacheLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}


- (void)cleanCache {
    
    NSString *homeDir = NSHomeDirectory();
    
    //图片缓存的路径
    NSString *cachePath = nil;
    cachePath = @"Library/Caches/default/com.hackemist.SDWebImageCache.default";
    //完整的路径
    //拼接路径
    NSString *fullPath = [homeDir stringByAppendingPathComponent:cachePath];
    //使用文件管家，删除路径下的缓存文件
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isSuccess = [fileManager removeItemAtPath:fullPath error:nil];
    
    if (isSuccess) {
        self.cacheLabel.text = @"0.00M";
        [[SDImageCache sharedImageCache] clearMemory];
        [ShowMessage showMessage:@"清理缓存成功！" withCenter:self.view.center];
    } else {
        [ShowMessage showMessage:@"清理缓存失败！" withCenter:self.view.center];
    }
}
@end
