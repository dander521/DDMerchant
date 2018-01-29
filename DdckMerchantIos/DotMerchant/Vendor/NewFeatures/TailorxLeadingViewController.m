//
//  TailorxLeadingViewController.m
//  Tailorx
//
//  Created by 高习泰 on 16/8/24.
//  Copyright © 2016年   徐安超. All rights reserved.
//  引导页

#import "TailorxLeadingViewController.h"
#import "TailorxLeadingCollectionViewCell.h"
#import "SMPageControl.h"

@interface TailorxLeadingViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic,strong) UICollectionView * backgroundCollectionView; // 底部滑动的collectionView

@property (nonatomic,strong) SMPageControl * pageControl;
@end

@implementation TailorxLeadingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUI];
}

- (BOOL)prefersStatusBarHidden {
    return true;
}

- (void)setUI {
    //
    UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.backgroundCollectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];

    [self.view addSubview:self.backgroundCollectionView];
    [self.backgroundCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    self.backgroundCollectionView.pagingEnabled = YES;
    self.backgroundCollectionView.delegate = self;
    self.backgroundCollectionView.dataSource = self;
    self.backgroundCollectionView.showsHorizontalScrollIndicator = NO;
    self.backgroundCollectionView.backgroundColor = [UIColor whiteColor];
    self.backgroundCollectionView.bounces = NO;
    [self.backgroundCollectionView registerClass:[TailorxLeadingCollectionViewCell class] forCellWithReuseIdentifier:@"myCell"];
    // pagecontrol
    _pageControl = [[SMPageControl alloc] init];
    _pageControl.numberOfPages = 3;
    _pageControl.currentPage = 0;
    _pageControl.pageIndicatorImage = [UIImage imageNamed:@"ic_shuffling"];
    _pageControl.currentPageIndicatorImage = [UIImage imageNamed:@"ic_shuffling_star"];
    [self.view addSubview:_pageControl];
    [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.bottom.mas_equalTo(-20);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - 100, 30));
    }];
    
    
}


#pragma mark colletionView的代理方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    TailorxLeadingCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"myCell" forIndexPath:indexPath];
    cell.leadingImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"pic%d",(int)indexPath.row + 1]];
    
    if (indexPath.row == 2) {
        cell.btn.hidden = NO;
        [cell.btn addTarget:self action:@selector(btnClicked) forControlEvents:UIControlEventTouchUpInside];
        [cell.animationImgView startAnimating];
    } else {
        cell.btn.hidden = YES;
    }
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 将collectionView在控制器view的中心点转化成collectionView上的坐标
    CGPoint pInView = [self.view convertPoint:self.backgroundCollectionView.center toView:self.backgroundCollectionView];
    // 获取这一点的indexPath
    NSIndexPath *indexPathNow = [self.backgroundCollectionView indexPathForItemAtPoint:pInView];
    _pageControl.currentPage = indexPathNow.row;
}

- (void)btnClicked {
    [[UIApplication sharedApplication] delegate].window.rootViewController = self.tabBarController;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
