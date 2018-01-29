//
//  DTCommentedViewController.m
//  DotCustomer
//
//  Created by 倩倩 on 2017/9/29.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTCommentedViewController.h"
#import "DTCommentTableViewCell.h"
#import "DTCommentModel.h"
#import "DTCommentReplyTableViewCell.h"
#import "DTFeedBackViewController.h"

@interface DTCommentedViewController () <UITableViewDelegate, UITableViewDataSource, DTCommentTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation DTCommentedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"查看评价";
    self.tableView.estimatedSectionFooterHeight = 0.0;
    self.tableView.estimatedSectionHeaderHeight = 0.0;
    self.tableView.estimatedRowHeight = 202.0;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1 + self.model.replyList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        DTCommentTableViewCell *cell = [DTCommentTableViewCell cellWithTableView:tableView];
        cell.cellLineType = TXCellSeperateLinePositionType_None;
        cell.delegate = self;
        cell.isDetail = true;
        cell.commentModel = self.model;
        return cell;
    } else {
        DTCommentReplyTableViewCell *cell = [DTCommentReplyTableViewCell cellWithTableView:tableView];
        cell.commentName = self.model.name;
        if (self.model.replyList.count >= indexPath.row - 1) {
            cell.replyModel = self.model.replyList[indexPath.row - 1];
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 200;
    }
    return UITableViewAutomaticDimension;
}

#pragma mark - DTCommentTableViewCellDelegate

- (void)touchImageViewWithIndex:(NSInteger)index array:(NSArray *)imgArray cell:(DTCommentTableViewCell *)cell {
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
    DTFeedBackViewController *vwcFeed = [[DTFeedBackViewController alloc] initWithNibName:NSStringFromClass([DTFeedBackViewController class]) bundle:[NSBundle mainBundle]];
    vwcFeed.commenId = model.idField;
    [self.navigationController pushViewController:vwcFeed animated:true];
}

@end
