//
//  TXPhotoTableViewCell.m
//  TailorX
//
//  Created by 程荣刚 on 2017/6/6.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import "TXPhotoTableViewCell.h"
#import "TXUploadPictureCollCell.h"
#import "NSString+Extension.h"

static NSString *cellID = @"TXUploadPictureCollCell";

@interface TXPhotoTableViewCell ()<UICollectionViewDataSource, UICollectionViewDelegate, TXUploadPictureCollCellDelegate>

@property (weak, nonatomic) IBOutlet UILabel *imageCountLabel;
@end

@implementation TXPhotoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initializeInterface];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/**
 *  cell 实例方法
 */
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *cellID = @"TXPhotoTableViewCell";
    TXPhotoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] lastObject];
    }
    
    return cell;
}

#pragma mark - init

- (void)initializeInterface {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    self.commentCollectionView.collectionViewLayout = flowLayout;
    //设置最小间距
    flowLayout.minimumInteritemSpacing = 10;
    //设置组边界（格子的四周边界）
    flowLayout.sectionInset = UIEdgeInsetsMake(5, 10, 5, 10);
    //设置格子大小
    CGFloat itemWH = 70;
    flowLayout.itemSize = CGSizeMake(itemWH, itemWH);
    self.commentCollectionView.dataSource = self;
    self.commentCollectionView.scrollEnabled = false;
    self.commentCollectionView.delegate = self;
    [self.commentCollectionView registerNib:[UINib nibWithNibName:cellID bundle:nil] forCellWithReuseIdentifier:cellID];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TXUploadPictureCollCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.photoImageView.image = self.dataSource[indexPath.item];
    cell.deleteBtn.hidden = self.dataSource.count == indexPath.item + 1 ? true : false;
    cell.delegate = self;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataSource.count > 3) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(uploadCommentPictureTabCell:didSelectPictureOfindex:)]) {
            [self.delegate uploadCommentPictureTabCell:self didSelectPictureOfindex:indexPath.row];
        }
    }else{
        if (indexPath.item != self.dataSource.count - 1) {
            // 查看
            if (self.delegate && [self.delegate respondsToSelector:@selector(uploadCommentPictureTabCell:didSelectPictureOfindex:)]) {
                [self.delegate uploadCommentPictureTabCell:self didSelectPictureOfindex:indexPath.row];
            }
        } else {
            // 上传
            if (self.delegate && [self.delegate respondsToSelector:@selector(uploadCommentPicture:)]) {
                [self.delegate uploadCommentPicture:self];
            }
            
        }
    }
}

#pragma mark - setters

- (void)setDataSource:(NSArray *)dataSource {
    _dataSource = dataSource;
    NSRange range = [_imageCountLabel.text rangeOfString:@"/"];
    NSRange resultRange = NSMakeRange(0, range.location);
    _imageCountLabel.attributedText = [NSString setAttributedString:[NSString stringWithFormat:@"%zd/3",dataSource.count-1] color:RGB(135, 135, 135) rang:resultRange font:FONT(8)];
    [self.commentCollectionView reloadData];
}

#pragma mark - TXUploadPictureCollCellDelegate

/**
 * 删除对应Index的图片
 */
- (void)uploadPictureCollCell:(TXUploadPictureCollCell*)pictureCell didSelectItemOfIndex:(NSInteger)index {
    if ([self.delegate respondsToSelector:@selector(deletePictureWithIndex:)]) {
        [self.delegate deletePictureWithIndex:index];
    }
}

- (void)setCellType:(TXPhotoTableViewCellType)cellType {
    _cellType = cellType;
    
    if (cellType == TXPhotoTableViewCellTypeNoText) {
        [self.descriptionLabel removeFromSuperview];
    }
}

@end
