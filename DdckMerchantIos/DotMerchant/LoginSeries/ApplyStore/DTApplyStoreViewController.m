//
//  DTApplyStoreViewController.m
//  DotMerchant
//
//  Created by 倩倩 on 2017/9/14.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTApplyStoreViewController.h"
#import "DTOperationSuccessViewController.h"

@interface DTApplyStoreViewController ()
@property (weak, nonatomic) IBOutlet UITextField *storeNameTF;
@property (weak, nonatomic) IBOutlet UITextField *contactTF;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *licenseTF;

@property (weak, nonatomic) IBOutlet UIButton *uploadBtn;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;

@property (nonatomic, strong) UIImage *storeImage;
/** 图片地址 */
@property (nonatomic, strong) NSString *imageUrl;
@end

@implementation DTApplyStoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"开店申请";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)textFieldDidChange:(NSNotification *)noti {
    if (self.storeNameTF.text.length != 0 &&
        self.contactTF.text.length != 0 &&
        self.phoneTF.text.length != 0 &&
        self.licenseTF.text.length != 0) {
        self.commitBtn.enabled = true;
        [self.commitBtn setBackgroundColor:RGB(246, 30, 46)];
    } else {
        self.commitBtn.enabled = false;
        [self.commitBtn setBackgroundColor:RGB(153, 153, 153)];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)touchUploadBtn:(id)sender {
    [self touchStoreSignImage];
}

- (IBAction)touchCommitTF:(id)sender {
    
    if (![NSString checkUserName:self.storeNameTF.text]) {
        [ShowMessage showMessage:@"请输入正确的店铺名"];
        return;
    }
    
    if (![NSString checkUserName:self.contactTF.text]) {
        [ShowMessage showMessage:@"请输入正确的联系人"];
        return;
    }
    
    if (![NSString isPhoneNumCorrectPhoneNum:self.phoneTF.text]) {
        [ShowMessage showMessage:@"请输入正确的手机号"];
        return;
    }
    
    if (self.licenseTF.text.length <= 0) {
        [ShowMessage showMessage:@"请输入正确的营业执照"];
        return;
    }
    
    if (!self.storeImage) {
        [ShowMessage showMessage:@"请上传营业执照"];
        return;
    }
    
    NSData *imageData = UIImageJPEGRepresentation(self.storeImage, 0.9);
    if (imageData.length/1024/1024 > 0.9) {
        imageData = UIImageJPEGRepresentation(self.storeImage, 0.4);
    }
    // 上传图片 完成后 拿到地址 上传其他参数
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[RCHttpHelper sharedHelper] uploadPicWithPostUrl:[httpHost stringByAppendingPathComponent:orderCommentPicUp] headParams:nil bodyParams:nil imageKeys:@[@"file"] images:@[imageData] progress:nil success:^(AFHTTPSessionManager *operation, id responseObject) {
        
        if ([responseObject[@"status"] integerValue] == 1) {
            self.imageUrl = responseObject[@"data"];
            [self postApplyStore];
        } else {
            [MBProgressHUD hideHUDForView:self.view];
            [ShowMessage showMessage:responseObject[@"msg"]];
        }
    } failure:^(AFHTTPSessionManager *operation, NSError *error) {
        [ShowMessage showMessage:error.description];
        [MBProgressHUD hideHUDForView:self.view];
    }];
}

- (void)postApplyStore {
    if (![[TXUserModel defaultUser] userLoginStatus]) {
        [ShowMessage showMessage:@"请登录"];
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:self.storeNameTF.text forKey: @"shopName"];
    [params setValue:self.contactTF.text forKey: @"contacts"];
    [params setValue:self.phoneTF.text forKey: @"phone"];
    [params setValue:self.licenseTF.text forKey: @"licence"];
    [params setValue:self.userName forKey: @"name"];
    [params setValue:self.cardNo forKey: @"card"];
    [params setValue:self.imageUrl forKey: @"img"];
    
    [[RCHttpHelper sharedHelper] postUrl:[httpHost stringByAppendingPathComponent:applyShop] headParams:@{@"token" : [TXModelAchivar getUserModel].token} bodyParams:params success:^(AFHTTPSessionManager *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view];
        if ([responseObject[@"status"] integerValue] == 1) {
            DTOperationSuccessViewController *vwcSuccess = [[DTOperationSuccessViewController alloc] initWithNibName:NSStringFromClass([DTOperationSuccessViewController class]) bundle:[NSBundle mainBundle]];
            [self.navigationController pushViewController:vwcSuccess animated:true];
        }
        [ShowMessage showMessage:responseObject[@"msg"]];
        if ([responseObject[@"msg"] isEqualToString:@"已实名认证过了！"]) {
            [self.navigationController popToRootViewControllerAnimated:true];
        }
    } failure:^(AFHTTPSessionManager *operation, NSError *error) {
        [ShowMessage showMessage:error.description];
        [MBProgressHUD hideHUDForView:self.view];
    }];
}

/**
 *  选择图片
 */
- (void)touchStoreSignImage {
    UIAlertController *avatarAlert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    __weak __typeof(&*avatarAlert)weakAvatarAlert = avatarAlert;
    weakSelf(self);
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[CMImagePickerManager sharedCMImagePickerManager] showCameraWithViewController:weakSelf handler:^(UIImage *image) {
            weakSelf.storeImage = image;
            [weakSelf.uploadBtn setBackgroundImage:image forState:UIControlStateNormal];
        }];
    }];
    
    UIAlertAction *albumAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            UIAlertView *alert= [[UIAlertView alloc] initWithTitle:nil message:@"该设备不支持从相册选取文件" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:NULL];
            [alert show];
        }else{
            [[CMImagePickerManager sharedCMImagePickerManager] showPhotoLibraryWithViewController:weakSelf handler:^(UIImage *image) {
                weakSelf.storeImage = image;
                [weakSelf.uploadBtn setBackgroundImage:image forState:UIControlStateNormal];
            }];
        }
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [weakAvatarAlert dismissViewControllerAnimated:true completion:nil];
    }];
    
    [TXCustomTools setActionTitleTextColor:RGB(46, 46, 46) action:cameraAction];
    [TXCustomTools setActionTitleTextColor:RGB(46, 46, 46) action:albumAction];
    [TXCustomTools setActionTitleTextColor:RGB(246, 47, 94) action:cancelAction];
    
    [avatarAlert addAction:cameraAction];
    [avatarAlert addAction:albumAction];
    [avatarAlert addAction:cancelAction];
    
    [self presentViewController:avatarAlert animated:true completion:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
