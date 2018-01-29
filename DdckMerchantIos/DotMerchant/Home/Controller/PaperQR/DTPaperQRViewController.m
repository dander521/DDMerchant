//
//  DTPaperQRViewController.m
//  DotMerchant
//
//  Created by 倩倩 on 2017/9/13.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTPaperQRViewController.h"
#import "SGQRCode.h"

@interface DTPaperQRViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *qrcodeImageView;

@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

@property (strong, nonatomic) UIImage *qrImage;

@end

@implementation DTPaperQRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"纸巾二维码";
    
    self.qrImage = [SGQRCodeGenerateManager generateWithDefaultQRCodeData:[NSString stringWithFormat:@"paper=%zd", [TXModelAchivar getUserModel].shopId] imageViewWidth:200];
    self.qrcodeImageView.image = self.qrImage;
    
    self.saveBtn.layer.cornerRadius = 24.5;
    self.saveBtn.layer.masksToBounds = true;
    self.saveBtn.layer.borderColor = RGB(246, 30, 46).CGColor;
    self.saveBtn.layer.borderWidth = 1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)touchSavaBtn:(id)sender {
    [self loadImageFinished:self.qrImage];
}

- (void)loadImageFinished:(UIImage *)image
{
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (!error) {
        [MBProgressHUD showSuccess:@"保存成功"];
    } else {
        [MBProgressHUD showError:@"保存失败"];
    }
    NSLog(@"image = %@, error = %@, contextInfo = %@", image, error, contextInfo);
}


@end
