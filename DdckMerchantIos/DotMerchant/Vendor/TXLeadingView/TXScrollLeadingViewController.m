//
//  TXScrollLeadingViewController.m
//  TailorX
//
//  Created by 程荣刚 on 2017/6/5.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXScrollLeadingViewController.h"
#import "TXGuideView.h"
#import "TXLeadingView.h"
#import "SMPageControl.h"

@interface TXScrollLeadingViewController ()<TXGuideViewDelegate, TXGuideViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *backGuideView;
@property (strong, nonatomic) TXGuideView *customGuideView;
@property (weak, nonatomic) IBOutlet UILabel *mainLabel;
@property (weak, nonatomic) IBOutlet UILabel *subLabel;
/** 分页指示器*/
@property (nonatomic, strong) SMPageControl *pageController;
@property (nonatomic, strong) NSMutableArray *dataSourceImages;
@property (weak, nonatomic) IBOutlet UIImageView *scaleImageView;
@property (weak, nonatomic) IBOutlet UIButton *experienceButton;
@property (weak, nonatomic) IBOutlet UIImageView *animationImageView;


@end

@implementation TXScrollLeadingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showGuideView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showGuideView {

    self.customGuideView = [[TXGuideView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-LayoutH(295))];
    self.customGuideView.backgroundColor = [UIColor whiteColor];
    self.customGuideView.delegate = self;
    self.customGuideView.dataSource = self;
    self.customGuideView.minimumPageAlpha = 1.0;
    self.customGuideView.minimumPageScale = 0.88;
    self.customGuideView.orientation = TXGuideViewOrientationHorizontal;
    self.customGuideView.isOpenAutoScroll = NO;
    
    self.pageController.numberOfPages = self.dataSourceImages.count;
    self.pageController.indicatorMargin = 5;
    self.pageController.currentPage = 0;
    self.pageController.userInteractionEnabled = NO;
    self.pageController.pageIndicatorImage  = [UIImage imageNamed:@"shuffling_round2"];
    self.pageController.currentPageIndicatorImage = [UIImage imageNamed:@"shuffling_round1"];;
    self.pageController.backgroundColor = [UIColor clearColor];

    [self.customGuideView reloadData];
    
    [self.backGuideView addSubview:self.customGuideView];
    
    [self.view addSubview:self.pageController];
    [self.pageController mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view).offset(-40);
        make.width.mas_equalTo(@(SCREEN_WIDTH));
        make.right.mas_equalTo(self.view.mas_right);
        make.height.mas_equalTo(@(20));
    }];
    
    CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    popAnimation.duration = 0.25;
    popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DIdentity]];
    popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [self.customGuideView.layer addAnimation:popAnimation forKey:nil];
    [UIView animateWithDuration:0.2 animations:^{
        self.customGuideView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    }];
    
    [self.experienceButton addTarget:self action:@selector(btnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    self.mainLabel.text = @"廓形大衣";
    self.subLabel.text = @"秀场十里不如场外的你";
    
    self.animationImageView.animationImages = @[[UIImage imageNamed:@"arrow_001"], [UIImage imageNamed:@"arrow_00"], [UIImage imageNamed:@"arrow_01"], [UIImage imageNamed:@"arrow_02"]];
    self.animationImageView.animationDuration = 1.1;
    self.animationImageView.animationRepeatCount = 0;
    [self.animationImageView startAnimating];
}

- (void)hideGuideView {
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        CGAffineTransform trans = self.customGuideView.transform;
        CGAffineTransform t = CGAffineTransformScale(trans, 0.01, 0.01);
        self.customGuideView.transform = t;
        self.customGuideView.alpha = 0;
        self.customGuideView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        self.customGuideView.superview.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        [_pageController removeFromSuperview];
    } completion:^(BOOL finished) {
        [self.customGuideView.superview removeFromSuperview];
        
        [self.customGuideView removeFromSuperview];
        self.customGuideView = nil;
    }];
}

#pragma mark NewPagedFlowView Delegate

- (CGSize)sizeForPageInFlowView:(TXGuideView *)flowView {
    
    return CGSizeMake(SCREEN_WIDTH-100, SCREEN_HEIGHT-LayoutH(295));
}

- (void)didSelectCell:(UIView *)subView withSubViewIndex:(NSInteger)subIndex {
    NSLog(@"点击了第%ld张图",(long)subIndex + 1);
}

/**
 *  滚动到了某一列
 *
 *  @param pageNumber
 *  @param flowView
 */
- (void)didScrollToPage:(NSInteger)pageNumber inFlowView:(TXGuideView *)flowView {
    NSLog(@"滑动了第%ld张图",(long)pageNumber + 1);
    
    self.pageController.currentPage = pageNumber;
    
    if (pageNumber == 0) {
        self.mainLabel.text = @"廓形大衣";
        self.subLabel.text = @"秀场十里不如场外的你";
    } else if (pageNumber == 1) {
        self.mainLabel.text = @"典雅套装";
        self.subLabel.text = @"打造高级质感的必备套装";
    } else if (pageNumber == 2) {
        self.mainLabel.text = @"条纹西服";
        self.subLabel.text = @"TailorX是您独家记忆";
        self.customGuideView.scrollView.userInteractionEnabled = false;
        self.customGuideView.scrollView.scrollEnabled = false;
        
        [self.scaleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        
        [UIView animateWithDuration:0.3 delay:1.0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.scaleImageView.hidden = false;
            self.backGuideView.alpha = 0.0;
            self.scaleImageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            [self.scaleImageView updateConstraints];
        } completion:^(BOOL finished) {
            self.animationImageView.hidden = false;
            self.experienceButton.hidden = false;
            self.backGuideView.hidden = true;
            self.pageController.hidden = true;
            self.mainLabel.hidden = true;
            self.subLabel.hidden = true;
        }];
    }
}


#pragma mark NewPagedFlowView Datasource

- (NSInteger)numberOfPagesInFlowView:(TXGuideView *)flowView {
    
    return self.dataSourceImages.count;
}

- (UIView *)flowView:(TXGuideView *)flowView cellForPageAtIndex:(NSInteger)index{
    TXLeadingView *itemView = (TXLeadingView *)[flowView dequeueReusableCell];
    if (!itemView) {
        itemView = [TXLeadingView instanceView];
        itemView.backgroundColor = [UIColor whiteColor];
        itemView.tag = index;
        itemView.layer.cornerRadius = 5;
        itemView.layer.masksToBounds = YES;
    }
    itemView.backImageView.image = _dataSourceImages[index];
    
    return itemView;
}

- (NSMutableArray *)dataSourceImages {
    if (!_dataSourceImages) {
        _dataSourceImages = [NSMutableArray new];
        [_dataSourceImages addObject:[UIImage imageNamed:@"pic1"]];
        [_dataSourceImages addObject:[UIImage imageNamed:@"pic2"]];
        [_dataSourceImages addObject:[UIImage imageNamed:@"pic3"]];
    }
    
    return _dataSourceImages;
}

- (SMPageControl*)pageController {
    if (!_pageController) {
        _pageController = [[SMPageControl alloc]init];
    }
    return _pageController;
}

- (void)btnClicked {
    [[UIApplication sharedApplication] delegate].window.rootViewController = self.tabBarController;
}
@end
