//
//  DTLoginViewController.m
//  DotMerchant
//
//  Created by 倩倩 on 2017/9/14.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTLoginViewController.h"
#import "DTRetrieveViewController.h"
#import "DTVerifyNameViewController.h"

@interface DTLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation DTLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"登录";
    
    [self addLeftBarButtonItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)touchLoginBtn:(id)sender {
    DTVerifyNameViewController *vwcVerify = [[DTVerifyNameViewController alloc] initWithNibName:NSStringFromClass([DTVerifyNameViewController class]) bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:vwcVerify animated:true];
}

- (IBAction)touchRetrieveBtn:(id)sender {
    DTRetrieveViewController *vwcRetrieve = [[DTRetrieveViewController alloc] initWithNibName:NSStringFromClass([DTRetrieveViewController class]) bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:vwcRetrieve animated:true];
}

- (void)addLeftBarButtonItem {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_nav_arrow"]
                                                                                       style:UIBarButtonItemStylePlain
                                                                                      target:self
                                                                                      action:@selector(backAction)];
}

- (void)backAction {
    CATransition *transition = [CATransition animation];
    transition.duration = 0.25f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionReveal;
    transition.subtype = kCATransitionFromBottom;
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController popViewControllerAnimated:NO];
}

@end
