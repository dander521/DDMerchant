//
//  DTOrderListCollectionViewController.m
//  DotMerchant
//
//  Created by 倩倩 on 2017/9/16.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTOrderListCollectionViewController.h"
#import "DTOrderListViewController.h"

@interface DTOrderListCollectionViewController ()<ZJScrollPageViewDelegate>

@end

@implementation DTOrderListCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"订单列表";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupscrollPageView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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
    self.scrollPageView = [[ZJScrollPageView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, SCREEN_HEIGHT - 64) segmentStyle:style titles:@[@"新订单",@"已处理", @"历史单"] parentViewController:self delegate:self];
    
    // self.scrollPageView.isShow = true;
    [self.view addSubview:self.scrollPageView];
}

- (NSInteger)numberOfChildViewControllers {
    return 3;
}

- (UIViewController<ZJScrollPageViewChildVcDelegate> *)childViewController:(UIViewController<ZJScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index {
    
    if (index == 0) {
        DTOrderListViewController *childVc = (DTOrderListViewController *)reuseViewController;
        if (childVc == nil) {
            childVc = [[DTOrderListViewController alloc] initWithNibName:NSStringFromClass([DTOrderListViewController class]) bundle:[NSBundle mainBundle]];
        }
        childVc.cellType = 1;
        return childVc;
    } else if (index == 1) {
        DTOrderListViewController *childVc = (DTOrderListViewController *)reuseViewController;
        if (childVc == nil) {
            childVc = [[DTOrderListViewController alloc] initWithNibName:NSStringFromClass([DTOrderListViewController class]) bundle:[NSBundle mainBundle]];
        }
        childVc.cellType = 2;
        return childVc;
    } else if (index == 2) {
        DTOrderListViewController *childVc = (DTOrderListViewController *)reuseViewController;
        if (childVc == nil) {
            childVc =[[DTOrderListViewController alloc] initWithNibName:NSStringFromClass([DTOrderListViewController class]) bundle:[NSBundle mainBundle]];
        }
        childVc.cellType = 3;
        return childVc;
    }
    return nil;
}

- (void)scrollPageController:(UIViewController *)scrollPageController childViewControllWillAppear:(UIViewController *)childViewController forIndex:(NSInteger)index {
    
}

- (BOOL)shouldAutomaticallyForwardAppearanceMethods {
    return NO;
}


@end
