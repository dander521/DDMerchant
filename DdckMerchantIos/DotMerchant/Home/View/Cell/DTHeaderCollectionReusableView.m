//
//  DTHeaderCollectionReusableView.m
//  DotMerchant
//
//  Created by 倩倩 on 2017/9/13.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTHeaderCollectionReusableView.h"

@implementation DTHeaderCollectionReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)touchTicketVerifyBtn:(id)sender {
    if ([self.delegate respondsToSelector:@selector(touchTicketVerifyButton)]) {
        [self.delegate touchTicketVerifyButton];
    }
}

- (IBAction)touchQRCodeBtn:(id)sender {
    if ([self.delegate respondsToSelector:@selector(touchQRCodeVerifyButton)]) {
        [self.delegate touchQRCodeVerifyButton];
    }
}
- (IBAction)touchWorkOrNotSegmentControl:(UISegmentedControl *)sender {
    if ([self.delegate respondsToSelector:@selector(touchWorkOrNotSegmentControlWithIndex:)]) {
        [self.delegate touchWorkOrNotSegmentControlWithIndex:sender.selectedSegmentIndex];
    }
}


@end
