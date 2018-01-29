//
//  TXGuidePage.m
//  TailorX
//
//  Created by Qian Shen on 12/5/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXGuidePage.h"
#import "TXGuideView.h"
#import "TXGuideItemView.h"
#import "SMPageControl.h"

@interface TXGuidePage ()<TXGuideViewDelegate, TXGuideViewDataSource>

/** 引导页*/
@property (nonatomic, strong) TXGuideView *guideView;
/** 引导页面的滚动图*/
@property (nonatomic, strong) UIScrollView *bottomScrollView;
/** 分页指示器*/
@property (nonatomic, strong) SMPageControl *pageController;
/** 引导图*/
@property (nonatomic, strong) NSMutableArray *imageArray;

@end

@implementation TXGuidePage

singleton_implementation(TXGuidePage)

- (void)showGuideView {
    
    self.guideView = [[TXGuideView alloc] initWithFrame:CGRectMake(0, 80, SCREEN_WIDTH, SCREEN_HEIGHT-195)];
    
    self.guideView.backgroundColor = [UIColor whiteColor];
    self.guideView.delegate = self;
    self.guideView.dataSource = self;
    self.guideView.minimumPageAlpha = 1.0;
    self.guideView.minimumPageScale = 0.85;
    self.guideView.isCarousel = NO;
    self.guideView.orientation = TXGuideViewOrientationHorizontal;
    
    self.guideView.isOpenAutoScroll = NO;
    
    self.pageController.numberOfPages = self.imageArray.count;
    self.pageController.currentPage = 0;
    self.pageController.indicatorMargin = 0;
    self.pageController.userInteractionEnabled = NO;
    self.pageController.pageIndicatorImage  = [UIImage imageNamed:@"ic_main_by_switching_circle.png"];
    self.pageController.currentPageIndicatorImage = [UIImage imageNamed:@"tabbar_home_s"];
    self.pageController.backgroundColor = [UIColor clearColor];
    
    [self.guideView reloadData];
    
    UIView *shadeView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [[UIApplication sharedApplication].keyWindow addSubview:shadeView];
    [shadeView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideGuideView)]];
    
    [shadeView addSubview:self.guideView];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.pageController];
    [self.pageController mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo([UIApplication sharedApplication].keyWindow.mas_bottom).offset(-95);
        make.width.mas_equalTo(@(SCREEN_WIDTH));
        make.right.mas_equalTo([UIApplication sharedApplication].keyWindow.mas_right);
        make.height.mas_equalTo(@(20));
    }];
    
    shadeView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    popAnimation.duration = 0.25;
    popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DIdentity]];
    popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [self.guideView.layer addAnimation:popAnimation forKey:nil];
    [UIView animateWithDuration:0.2 animations:^{
        self.guideView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    }];
}

- (void)hideGuideView {
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        CGAffineTransform trans = self.guideView.transform;
        CGAffineTransform t = CGAffineTransformScale(trans, 0.01, 0.01);
        self.guideView.transform = t;
        self.guideView.alpha = 0;
        self.guideView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        _guideView.superview.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        [_pageController removeFromSuperview];
    } completion:^(BOOL finished) {
        [_guideView.superview removeFromSuperview];
        
        [_guideView removeFromSuperview];
        _guideView = nil;
    }];
}

#pragma mark NewPagedFlowView Delegate

- (CGSize)sizeForPageInFlowView:(TXGuideView *)flowView {
    
    return CGSizeMake(SCREEN_WIDTH-50, SCREEN_HEIGHT-195);
}

- (void)didSelectCell:(UIView *)subView withSubViewIndex:(NSInteger)subIndex {
    NSLog(@"点击了第%ld张图",(long)subIndex + 1);
}

#pragma mark NewPagedFlowView Datasource

- (NSInteger)numberOfPagesInFlowView:(TXGuideView *)flowView {
    
    return self.imageArray.count;
}

- (UIView *)flowView:(TXGuideView *)flowView cellForPageAtIndex:(NSInteger)index{
    TXGuideItemView *itemView = (TXGuideItemView *)[flowView dequeueReusableCell];
    if (!itemView) {
        itemView = [[TXGuideItemView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 50, SCREEN_HEIGHT-95)];
        itemView.backgroundColor = [UIColor whiteColor];
        itemView.tag = index;
        itemView.layer.cornerRadius = 5;
        itemView.layer.masksToBounds = YES;
    }
    itemView.coverImgView.image = self.imageArray[index][@"img"];
    itemView.titleLabel.text = self.imageArray[index][@"title"];
    itemView.subTitleLabel.text = self.imageArray[index][@"subTitle"];
    
    return itemView;
}

- (void)didScrollToPage:(NSInteger)pageNumber inFlowView:(TXGuideView *)flowView {
    
    self.pageController.currentPage = pageNumber;
}

#pragma mark - getters

- (NSMutableArray *)imageArray {
    if (!_imageArray) {
        
        _imageArray = [NSMutableArray array];
        [_imageArray addObject:@{@"title":@"预约",
                                 @"subTitle":@"在线预约，时间自由选择",
                                 @"img":[UIImage imageNamed:@"img_subscribe"]}];
        [_imageArray addObject:@{@"title":@"店内洽谈",
                                 @"subTitle":@"到店交流，需求一步到位",
                                 @"img":[UIImage imageNamed:@"img_talk"]}];
        [_imageArray addObject:@{@"title":@"免费量体",
                                 @"subTitle":@"量体裁衣，数据精准保留",
                                 @"img":[UIImage imageNamed:@"img_free"]}];
        [_imageArray addObject:@{@"title":@"线上付款",
                                 @"subTitle":@"订单生成，线上一键付款",
                                 @"img":[UIImage imageNamed:@"img_payment"]}];
        [_imageArray addObject:@{@"title":@"到店试衣",
                                 @"subTitle":@"到店试衣，精致细节调整",
                                 @"img":[UIImage imageNamed:@"img_fitting"]}];
        [_imageArray addObject:@{@"title":@"取衣",
                                 @"subTitle":@"取衣便捷，到店快递任选",
                                 @"img":[UIImage imageNamed:@"img_take_clothes"]}];
    }
    return _imageArray;
}

- (SMPageControl*)pageController {
    if (!_pageController) {
        _pageController = [[SMPageControl alloc]init];
    }
    return _pageController;
}

@end
