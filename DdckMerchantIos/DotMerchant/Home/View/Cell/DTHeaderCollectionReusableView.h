//
//  DTHeaderCollectionReusableView.h
//  DotMerchant
//
//  Created by 倩倩 on 2017/9/13.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DTHeaderCollectionReusableViewDelegate <NSObject>

- (void)touchTicketVerifyButton;

- (void)touchQRCodeVerifyButton;

- (void)touchWorkOrNotSegmentControlWithIndex:(NSInteger)selectedIndex;

@end

@interface DTHeaderCollectionReusableView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;

@property (nonatomic, assign) id<DTHeaderCollectionReusableViewDelegate>delegate;

@end
