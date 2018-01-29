//
//  ZJScrollPageView.m
//  ZJScrollPageView
//
//  Created by jasnig on 16/5/6.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

#import "ZJScrollPageView.h"

@interface ZJScrollPageView ()
@property (strong, nonatomic) ZJSegmentStyle *segmentStyle;
@property (weak, nonatomic) ZJScrollSegmentView *segmentView;
@property (weak, nonatomic) ZJContentView *contentView;
/** 阴影*/
@property (nonatomic, strong) UIView *shadowView;

@property (weak, nonatomic) UIViewController *parentViewController;
@property (strong, nonatomic) NSArray *childVcs;
@property (strong, nonatomic) NSArray *titlesArray;

@end
@implementation ZJScrollPageView

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame segmentStyle:(ZJSegmentStyle *)segmentStyle titles:(NSArray<NSString *> *)titles parentViewController:(UIViewController *)parentViewController delegate:(id<ZJScrollPageViewDelegate>) delegate {
    if (self = [super initWithFrame:frame]) {
        self.segmentStyle = segmentStyle;
        self.delegate = delegate;
        self.parentViewController = parentViewController;
        self.titlesArray = titles.copy;
        
        [self commonInit];
        
        weakSelf(self);
        self.titleBadgeNumber = ^(NSInteger badgeNum, NSInteger index) {
            weakSelf.segmentView.titleBadgeNumber(badgeNum, index);
        };
    }
    return self;
}


- (void)commonInit {
    
    // 触发懒加载
    self.segmentView.backgroundColor = [UIColor whiteColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
}

- (void)dealloc {
    NSLog(@"ZJScrollPageView--销毁");
}

#pragma mark - public helper

/** 给外界设置选中的下标的方法 */
- (void)setSelectedIndex:(NSInteger)selectedIndex animated:(BOOL)animated {
    [self.segmentView setSelectedIndex:selectedIndex animated:animated];
}

/**  给外界重新设置视图内容的标题的方法 */
- (void)reloadWithNewTitles:(NSArray<NSString *> *)newTitles {
    
    self.titlesArray = nil;
    self.titlesArray = newTitles.copy;
    
    [self.segmentView reloadTitlesWithNewTitles:self.titlesArray];
    [self.contentView reload];
}

- (void)setIsShow:(BOOL)isShow {
    _isShow = isShow;
    if (_isShow) {
        [self insertSubview:self.shadowView aboveSubview:self.contentView];
        [self insertSubview:self.segmentView aboveSubview:self.shadowView];
    }else {
        return;
    }
}


#pragma mark - getter ---- setter

- (ZJContentView *)contentView {
    if (!_contentView) {
        ZJContentView *content = [[ZJContentView alloc] initWithFrame:CGRectMake(0.0, CGRectGetMaxY(self.segmentView.frame), self.bounds.size.width, self.bounds.size.height - CGRectGetMaxY(self.segmentView.frame)) segmentView:self.segmentView parentViewController:self.parentViewController delegate:self.delegate];
        [self addSubview:content];
        
        _contentView = content;
    }
    
    return  _contentView;
}


- (ZJScrollSegmentView *)segmentView {
    if (!_segmentView) {
        __weak typeof(self) weakSelf = self;
        ZJScrollSegmentView *segment = [[ZJScrollSegmentView alloc] initWithFrame:self.segmentStyle.styleFrame segmentStyle:self.segmentStyle delegate:self.delegate titles:self.titlesArray titleDidClick:^(ZJTitleView *titleView, NSInteger index) {
            
            [weakSelf.contentView setContentOffSet:CGPointMake(weakSelf.contentView.bounds.size.width * index, 0.0) animated:weakSelf.segmentStyle.isAnimatedContentViewWhenTitleClicked];
            
        }];
        [self addSubview:segment];
        _segmentView = segment;
    }
    return _segmentView;
}

- (UIView *)shadowView {
    if (!_shadowView) {
        _shadowView = [[UIView alloc]initWithFrame:CGRectMake(-2, -2, SCREEN_WIDTH+4, 66)];
        _shadowView.layer.shadowOffset = CGSizeMake(1, 1);
        _shadowView.layer.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2].CGColor;
        _shadowView.layer.shadowOpacity = 0.5;
        _shadowView.backgroundColor = [UIColor whiteColor];
    }
    return _shadowView;
}

- (NSArray *)childVcs {
    if (!_childVcs) {
        _childVcs = [NSArray array];
    }
    return _childVcs;
}

- (NSArray *)titlesArray {
    if (!_titlesArray) {
        _titlesArray = [NSArray array];
    }
    return _titlesArray;
}

- (void)setExtraBtnOnClick:(ExtraBtnOnClick)extraBtnOnClick {
    _extraBtnOnClick = extraBtnOnClick;
    self.segmentView.extraBtnOnClick = extraBtnOnClick;
}

@end
