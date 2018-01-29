//
//  DTTabBarViewController.m
//  DotMerchant
//
//  Created by 倩倩 on 2017/9/12.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTTabBarViewController.h"
#import "DTNavigationViewController.h"
#import "DTHomeViewController.h"
#import "DTGoodsCollectViewController.h"
#import "DTPersonalCenterViewController.h"
#import "ScrollTabBarDelegate.h"

@interface DTTabBarViewController ()

@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, assign) NSInteger subViewControllerCount;
@property (nonatomic, strong) ScrollTabBarDelegate *tabBarDelegate;

@end

@implementation DTTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSDictionary *dictTitle = [NSDictionary dictionaryWithObject:RGB(246, 30, 46) forKey:NSForegroundColorAttributeName];
    
    // 首页
    DTHomeViewController *vwcHome = [[DTHomeViewController alloc] init];
    vwcHome.title = @"首页";
    DTNavigationViewController *vwcNavHome = [[DTNavigationViewController alloc] initWithRootViewController:vwcHome];
    vwcNavHome.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"首页"
                                                           image:[UIImage imageNamed:@"tabbar_home_n"]
                                                   selectedImage:[UIImage imageNamed:@"tabbar_home_s"]];
    [vwcNavHome.tabBarItem setTitleTextAttributes:dictTitle forState:UIControlStateSelected];
    
    // 商品管理
    DTGoodsCollectViewController *vwcManager = [[DTGoodsCollectViewController alloc] init];
    vwcManager.title = @"商品管理";
    DTNavigationViewController *vwcNavManager = [[DTNavigationViewController alloc] initWithRootViewController:vwcManager];
    vwcNavManager.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"商品管理"
                                                          image:[UIImage imageNamed:@"tabbar_goods_n"]
                                                  selectedImage:[UIImage imageNamed:@"tabbar_goods_s"]];
    [vwcNavManager.tabBarItem setTitleTextAttributes:dictTitle forState:UIControlStateSelected];
    
    // 个人中心
    DTPersonalCenterViewController *vwcCenter = [[DTPersonalCenterViewController alloc] init];
    vwcCenter.title = @"个人中心";
    DTNavigationViewController *vwcNavCenter = [[DTNavigationViewController alloc] initWithRootViewController:vwcCenter];
    vwcNavCenter.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"个人中心"
                                                          image:[UIImage imageNamed:@"tabbar_center_n"]
                                                  selectedImage:[UIImage imageNamed:@"tabbar_center_s"]];
   [vwcNavCenter.tabBarItem setTitleTextAttributes:dictTitle forState:UIControlStateSelected];
    
    
    self.viewControllers = @[vwcNavHome, vwcNavManager, vwcNavCenter];
//    [self addScrollTabBar];
}

/**
 添加滑动逻辑
 */
- (void)addScrollTabBar {
    // 正确的给予 count
    self.subViewControllerCount = self.viewControllers ? self.viewControllers.count : 0;
    // 代理
    self.tabBarDelegate = [[ScrollTabBarDelegate alloc] init];
    self.delegate = self.tabBarDelegate;
    // 增加滑动手势
    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panHandle:)];
    [self.view addGestureRecognizer:self.panGesture];
}

- (void)panHandle:(UIPanGestureRecognizer *)panGesture {
    // 获取滑动点
    CGFloat translationX = [panGesture translationInView:self.view].x;
    CGFloat progress = fabs(translationX)/self.view.frame.size.width;
    
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            self.tabBarDelegate.interactive = YES;
            CGFloat velocityX = [panGesture velocityInView:self.view].x;
            if (velocityX < 0) {
                if (self.selectedIndex < self.subViewControllerCount - 1) {
                    self.selectedIndex += 1;
                }
            }
            else {
                if (self.selectedIndex > 0) {
                    self.selectedIndex -= 1;
                }
            }
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            [self.tabBarDelegate.interactionController updateInteractiveTransition:progress];
        }
            
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateFailed:
        case UIGestureRecognizerStateCancelled:
        {
            if (progress > 0.3) {
                self.tabBarDelegate.interactionController.completionSpeed = 0.99;
                [self.tabBarDelegate.interactionController finishInteractiveTransition];
            }else{
                //转场取消后，UITabBarController 自动恢复了 selectedIndex 的值，不需要我们手动恢复。
                self.tabBarDelegate.interactionController.completionSpeed = 0.99;
                [self.tabBarDelegate.interactionController cancelInteractiveTransition];
            }
            self.tabBarDelegate.interactive = NO;
        }
            break;
        default:
            break;
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
