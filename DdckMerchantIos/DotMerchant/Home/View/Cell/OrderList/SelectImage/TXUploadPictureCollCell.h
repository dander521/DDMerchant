//
//  TXUploadPictureCollCell.h
//  TailorX
//
//  Created by Qian Shen on 20/3/17.
//  Copyright © 2017年 utouu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TXUploadPictureCollCell;

@protocol TXUploadPictureCollCellDelegate <NSObject>

@required

/** 
 * 删除对应Index的图片
 */

- (void)uploadPictureCollCell:(TXUploadPictureCollCell*)pictureCell didSelectItemOfIndex:(NSInteger)index;

@end

@interface TXUploadPictureCollCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
/** 删除图片按钮*/
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
/** 删除按钮的下标*/
@property (nonatomic, assign) NSInteger index;

/** 代理*/
@property (nonatomic, weak) id<TXUploadPictureCollCellDelegate> delegate;



@end
