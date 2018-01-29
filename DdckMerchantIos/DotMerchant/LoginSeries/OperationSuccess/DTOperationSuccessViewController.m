//
//  DTOperationSuccessViewController.m
//  DotMerchant
//
//  Created by 倩倩 on 2017/9/14.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTOperationSuccessViewController.h"

@interface DTOperationSuccessViewController ()

@property (weak, nonatomic) IBOutlet UIButton *doneBtn;

@end

@implementation DTOperationSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"操作成功";
    self.doneBtn.layer.borderWidth = 1;
    self.doneBtn.layer.borderColor = RGB(246, 30, 46).CGColor;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)touchDoneBtn:(id)sender {
    CATransition *transition = [CATransition animation];
    transition.duration = 0.25f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionReveal;
    transition.subtype = kCATransitionFromBottom;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController popToRootViewControllerAnimated:true];
}


@end
