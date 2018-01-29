//
//  DTGoodsCollectViewController.m
//  DotMerchant
//
//  Created by 倩倩 on 2017/9/14.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTGoodsCollectViewController.h"
#import "DTGoodsManagerViewController.h"
#import "ZJScrollPageView.h"
#import "PopoverView.h"
#import "DTEditGoodsViewController.h"
#import "DTVoucherViewController.h"

@interface DTGoodsCollectViewController () <ZJScrollPageViewDelegate>

@property (nonatomic, strong) ZJScrollPageView *scrollPageView;
/** <#description#> */
@property (nonatomic, strong) UIButton *titleButton;

/** <#description#> */
@property (nonatomic, assign) BOOL isGoods;

@end

@implementation DTGoodsCollectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isGoods = true;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupscrollPageView];
    
    [self setUpRightButton];
    
    [self setNavigationTitleView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@""]
                                                                         style:UIBarButtonItemStylePlain
                                                                        target:self
                                                                        action:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupscrollPageView {
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    ZJSegmentStyle *style = [[ZJSegmentStyle alloc] init];
    style.titleBigScale = 1.f;;
    style.segmentHeight = 49;
    style.gradualChangeTitleColor = true;
    style.autoAdjustTitlesWidth = true;
    style.showLine = true;
    style.adjustCoverOrLineWidth = true;
    style.scrollLineColor = RGB(246, 30, 46);
    style.scrollTitle = false;
    style.titleFont = [UIFont fontWithName:@"Helvetica-Light" size:17];
    style.normalTitleColor = RGB(204, 204, 204);
    style.selectedTitleColor = RGB(246, 30, 46);
    
    // 初始化
    self.scrollPageView = [[ZJScrollPageView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, SCREEN_HEIGHT - 64 - 49) segmentStyle:style titles:@[@"已上架",@"已下架"] parentViewController:self delegate:self];
    
    // self.scrollPageView.isShow = true;
    [self.view addSubview:self.scrollPageView];
}

/**
 * 设置明细按钮
 */
- (void)setUpRightButton {
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 80, 40);
    [rightBtn setTitle:@"添加" forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:16];
    [rightBtn setTitleColor:RGB(246, 30, 46) forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBarButtonItemAction:) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:rightBtn];
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_add"]];
    imgView.frame = CGRectMake(64, 16, 16, 8);
    imgView.userInteractionEnabled = false;
    [rightView addSubview:imgView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
}

- (void)setNavigationTitleView {
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
    
    self.titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.titleButton.frame = CGRectMake(0, 0, 80, 40);
    [self.titleButton setTitle:@"商品" forState:UIControlStateNormal];
    self.titleButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:16];
    [self.titleButton setTitleColor:RGB(46, 46, 46) forState:UIControlStateNormal];
    [self.titleButton addTarget:self action:@selector(touchNavigationTitleView:) forControlEvents:UIControlEventTouchUpInside];
    [rightView addSubview:self.titleButton];
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_xiala"]];
    imgView.frame = CGRectMake(64, 16, 16, 8);
    imgView.userInteractionEnabled = false;
    [rightView addSubview:imgView];
    
    self.navigationItem.titleView = rightView;
}

- (void)touchNavigationTitleView:(id)sender {
    weakSelf(self);
    PopoverAction *action1 = [PopoverAction actionWithTitle:@"代金券" handler:^(PopoverAction *action) {
        if (![[TXUserModel defaultUser] userLoginStatus]) {
            [ShowMessage showMessage:@"请登录"];
            return;
        }
        weakSelf.isGoods = false;
        [weakSelf.titleButton setTitle:@"代金券" forState:UIControlStateNormal];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationChangeGoodsOrCouponSuccess object:nil userInfo:@{@"type" : @"0"}];
    }];
    
    PopoverAction *action2 = [PopoverAction actionWithTitle:@"商品" handler:^(PopoverAction *action) {
        if (![[TXUserModel defaultUser] userLoginStatus]) {
            [ShowMessage showMessage:@"请登录"];
            return;
        }
        weakSelf.isGoods = true;
        [weakSelf.titleButton setTitle:@"商品" forState:UIControlStateNormal];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationChangeGoodsOrCouponSuccess object:nil userInfo:@{@"type" : @"1"}];
    }];
    PopoverView *popoverView = [PopoverView popoverView];
    popoverView.style = PopoverViewStyleRed;
    [popoverView showToView:sender withActions:@[action1, action2]];
}

- (void)rightBarButtonItemAction:(id)sender {
    PopoverAction *action1 = [PopoverAction actionWithTitle:@"代金券" handler:^(PopoverAction *action) {
        if (![[TXUserModel defaultUser] userLoginStatus]) {
            [ShowMessage showMessage:@"请登录"];
            return;
        }
        DTVoucherViewController *vwcVoucher = [[DTVoucherViewController alloc] initWithNibName:NSStringFromClass([DTVoucherViewController class]) bundle:[NSBundle mainBundle]];
        [self.navigationController pushViewController:vwcVoucher animated:true];
    }];
    
    PopoverAction *action2 = [PopoverAction actionWithTitle:@"商品" handler:^(PopoverAction *action) {
        if (![[TXUserModel defaultUser] userLoginStatus]) {
            [ShowMessage showMessage:@"请登录"];
            return;
        }
        DTEditGoodsViewController *vwcEdit = [[DTEditGoodsViewController alloc] initWithNibName:NSStringFromClass([DTEditGoodsViewController class]) bundle:[NSBundle mainBundle]];
        [self.navigationController pushViewController:vwcEdit animated:true];
    }];
    PopoverView *popoverView = [PopoverView popoverView];
    popoverView.style = PopoverViewStyleRed;
    [popoverView showToView:sender withActions:@[action1, action2]];
}


- (NSInteger)numberOfChildViewControllers {
    return 2;
}

- (UIViewController<ZJScrollPageViewChildVcDelegate> *)childViewController:(UIViewController<ZJScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index {
    
    if (index == 0) {
        DTGoodsManagerViewController *childVc = (DTGoodsManagerViewController *)reuseViewController;
        if (childVc == nil) {
            childVc = [[DTGoodsManagerViewController alloc] init];
        }
        childVc.isGoods = self.isGoods;
        childVc.cellType = 1;
        return childVc;
    } else if (index == 1) {
        DTGoodsManagerViewController *childVc = (DTGoodsManagerViewController *)reuseViewController;
        if (childVc == nil) {
            childVc = [[DTGoodsManagerViewController alloc] init];
        }
        childVc.isGoods = self.isGoods;
        childVc.cellType = 2;
        return childVc;
    }
    return nil;
}

- (void)scrollPageController:(UIViewController *)scrollPageController childViewControllWillAppear:(UIViewController *)childViewController forIndex:(NSInteger)index {
    
}

- (void)scrollPageController:(UIViewController *)scrollPageController childViewControllDidAppear:(UIViewController *)childViewController forIndex:(NSInteger)index {
    if (self.isGoods) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationChangeGoodsOrCouponSuccess object:nil userInfo:@{@"type" : @"1"}];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationChangeGoodsOrCouponSuccess object:nil userInfo:@{@"type" : @"0"}];
    }
}

- (BOOL)shouldAutomaticallyForwardAppearanceMethods {
    return NO;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
