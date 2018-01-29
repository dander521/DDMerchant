//
//  DTAppealViewController.m
//  DotMerchant
//
//  Created by 倩倩 on 2017/9/16.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTAppealViewController.h"
#import "DTTitleTableViewCell.h"
#import "DTOrderListTableViewCell.h"
#import "DTInputAppealTableViewCell.h"
#import "TXPhotoTableViewCell.h"

@interface DTAppealViewController () <UITableViewDataSource, UITableViewDelegate, TXPhotoTableViewCellDelegate, QBImagePickerControllerDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** 图片数组*/
@property (nonatomic, strong) NSMutableArray *commentPictures;
@property (nonatomic, strong) UIButton *commitButton;
@property (nonatomic, strong) UITextView *inputTF;
@property (nonatomic, strong) NSString *imgsStr;

@end

@implementation DTAppealViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"申诉";
    self.tableView.estimatedRowHeight = 202.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self initializeDataSource];
    self.tableView.tableFooterView = [self tableFooterView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidChanged:) name:UITextViewTextDidChangeNotification object:nil];
}

- (void)textViewDidChanged:(NSNotification *)noti {
    if (self.inputTF.text.length != 0) {
        self.commitButton.enabled = true;
        [self.commitButton setBackgroundColor:RGB(246, 30, 46)];
    } else {
        self.commitButton.enabled = false;
        [self.commitButton setBackgroundColor:RGB(153, 153, 153)];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TXSeperateLineCell *cellDefault = nil;
    if (indexPath.row == 0) {
        DTTitleTableViewCell *cell = [DTTitleTableViewCell cellWithTableView:tableView];
        cell.cellLineType = TXCellSeperateLinePositionType_Single;
        cellDefault = cell;
    } else if (indexPath.row == 1) {
        DTOrderListTableViewCell *cell = [DTOrderListTableViewCell cellWithTableView:tableView];
        cell.cellLineType = TXCellSeperateLinePositionType_None;
        cell.cellType = DTOrderListTableViewCellTypeAppeal;
        cell.listModel = self.model;
        cellDefault = cell;
    } else if (indexPath.row == 2) {
        DTInputAppealTableViewCell *cell = [DTInputAppealTableViewCell cellWithTableView:tableView];
        [cell.contentTextView addPlaceholderWithText:@"请输入您的申诉内容" textColor:RGB(153, 153, 153) font:[UIFont fontWithName:@"Helvetica-Light" size:16]];
        cell.cellLineType = TXCellSeperateLinePositionType_None;
        self.inputTF = cell.contentTextView;
        self.inputTF.delegate = self;
        cellDefault = cell;
    } else {
        TXPhotoTableViewCell *cell = [TXPhotoTableViewCell cellWithTableView:tableView];
        cell.cellLineType = TXCellSeperateLinePositionType_None;
        cell.dataSource = self.commentPictures;
        cell.delegate = self;
        cell.descriptionLabel.text = @"申诉图片";
        cell.cellType = TXPhotoTableViewCellTypeNoText;
        cellDefault = cell;
    }
    
    return cellDefault;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) return 44;
    if (indexPath.row == 2) return 198;
    if (indexPath.row == 3) return 80;
    return UITableViewAutomaticDimension;
}

#pragma mark - TXPhotoTableViewCellDelegate

/**
 * 查看图片
 */
- (void)uploadCommentPictureTabCell:(TXPhotoTableViewCell *)commentCell
            didSelectPictureOfindex:(NSInteger)index {
    // 加载本地图片
    NSMutableArray *showArray = [self.commentPictures mutableCopy];
    [showArray removeLastObject];
    
    NSMutableArray *browseItemArray = [[NSMutableArray alloc] init];
    for(int i = 0;i < [showArray count]; i++)
    {
        MSSBrowseModel *browseItem = [[MSSBrowseModel alloc]init];
        browseItem.bigImage = self.commentPictures[i];// 大图赋值
        [browseItemArray addObject:browseItem];
    }
    MSSBrowseLocalViewController *bvc = [[MSSBrowseLocalViewController alloc]initWithBrowseItemArray:browseItemArray currentIndex:index];
    bvc.deleteBlock = ^(NSInteger index) {
        [self.commentPictures removeObjectAtIndex:index];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
        TXPhotoTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        cell.dataSource = self.commentPictures;
        [cell.commentCollectionView reloadData];
    };
    [bvc showBrowseViewController];
}

/**
 * 上传图片
 */
- (void)uploadCommentPicture:(TXPhotoTableViewCell *)commentCell {
    [self touchUploadImage];
}

/**
 删除对应位置的图片
 
 @param index 索引
 */
- (void)deletePictureWithIndex:(NSInteger)index {
    [self.commentPictures removeObjectAtIndex:index];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
    TXPhotoTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.dataSource = self.commentPictures;
    [cell.commentCollectionView reloadData];
}

#pragma mark QBImagePickerControllerDelegate
//相册回调
- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController didFinishPickingAssets:(NSArray *)assets {
    weakSelf(self);
    [self dismissViewControllerAnimated:YES completion:nil];
    for (int i = 0; i < assets.count; i++) {
        PHAsset *asset = assets[i];
        
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        options.networkAccessAllowed = YES;
        options.synchronous = false;
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:[UIScreen mainScreen].bounds.size contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage *result, NSDictionary *info) {
            //设置图片
            if (result) {
                [weakSelf.commentPictures insertObject:result atIndex:self.commentPictures.count - 1];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
                TXPhotoTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
                cell.dataSource = self.commentPictures;
                [cell.commentCollectionView reloadData];
            }
        }];
    }
    
}
- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Custom Method

/**
 *  选择图片
 */
- (void)touchUploadImage {
    UIAlertController *avatarAlert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    __weak __typeof(&*avatarAlert)weakAvatarAlert = avatarAlert;
    weakSelf(self);
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[CMImagePickerManager sharedCMImagePickerManager] showCameraWithViewController:weakSelf handler:^(UIImage *image) {
            [self.commentPictures insertObject:image atIndex:0];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:0];
            TXPhotoTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            cell.dataSource = self.commentPictures;
            [cell.commentCollectionView reloadData];
        }];
    }];
    
    UIAlertAction *albumAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            UIAlertView *alert= [[UIAlertView alloc] initWithTitle:nil message:@"该设备不支持从相册选取文件" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:NULL];
            [alert show];
        }else{
            QBImagePickerController *_imagePickerController = [[QBImagePickerController alloc] init];
            _imagePickerController.mediaType = QBImagePickerMediaTypeImage;
            _imagePickerController.delegate = self;
            _imagePickerController.allowsMultipleSelection = YES;
            _imagePickerController.maximumNumberOfSelection = 4 - self.commentPictures.count;
            [self presentViewController:_imagePickerController animated:YES completion:NULL];
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

/**
 * 初始化 评论图
 */
- (void)initializeDataSource {
    self.commentPictures = [NSMutableArray new];
    [self.commentPictures addObject:[UIImage imageNamed:@"ic_camera"]];
}

- (UIView *)tableFooterView {
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 150)];
    footer.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.commitButton.frame = CGRectMake(42, 32, SCREEN_WIDTH - 84, 49);
    self.commitButton.titleLabel.font = FONT(18);
    [self.commitButton setTitle:@"确认申诉" forState:UIControlStateNormal];
    self.commitButton.backgroundColor = RGB(246, 30, 46);
    [self.commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.commitButton.layer.cornerRadius = 24.5;
    self.commitButton.layer.masksToBounds = true;
    self.commitButton.enabled = false;
    [self.commitButton addTarget:self action:@selector(touchCommitBtn) forControlEvents:UIControlEventTouchUpInside];
    [footer addSubview:self.commitButton];
    return footer;
}

- (void)touchCommitBtn {
    // 请求数据
    if (![[TXUserModel defaultUser] userLoginStatus]) {
        [ShowMessage showMessage:@"请登录"];
        return;
    }
    
    if (self.commentPictures.count == 1) {
        [ShowMessage showMessage:@"请选择图片"];
        return;
    }
    
    NSMutableArray *imageArray = [NSMutableArray new];
    
    if (self.commentPictures.count > 1) {
        for (int i = 0; i < self.commentPictures.count - 1; i++) {
            UIImage *image = self.commentPictures[i];
            NSData *imageData = UIImageJPEGRepresentation(image, 0.9);
            if (imageData.length/1024/1024 > 0.9) {
                imageData = UIImageJPEGRepresentation(image, 0.4);
            }
            [[RCHttpHelper sharedHelper] uploadPicWithPostUrl:[httpHost stringByAppendingPathComponent:orderCommentPicUp] headParams:nil bodyParams:nil imageKeys:@[@"file"] images:@[imageData] progress:nil success:^(AFHTTPSessionManager *operation, id responseObject) {
                [MBProgressHUD hideHUDForView:self.view];
                if ([responseObject[@"status"] integerValue] == 1) {
                    [imageArray addObject:responseObject[@"data"]];
                    if (imageArray.count == self.commentPictures.count - 1) {
                        self.imgsStr = [imageArray componentsJoinedByString:@","];
                        [self appealOrderWithImgs:true];
                    }
                } else {
                    [MBProgressHUD hideHUDForView:self.view];
                    [ShowMessage showMessage:responseObject[@"msg"]];
                }
            } failure:^(AFHTTPSessionManager *operation, NSError *error) {
                [ShowMessage showMessage:error.description];
                [MBProgressHUD hideHUDForView:self.view];
            }];
        }
    } else {
        [self appealOrderWithImgs:false];
    }
}

- (void)appealOrderWithImgs:(BOOL)hasImages {
    if (!hasImages) {
        [MBProgressHUD hideHUDForView:self.view];
    }
    
    
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:self.imgsStr forKey:@"imgs"];
    [params setValue:self.inputTF.text forKey:@"content"];
    [params setObject:self.orderId forKey:@"orderId"];
    
    [[RCHttpHelper sharedHelper] postUrl:[httpHost stringByAppendingPathComponent:orderAppeal] headParams:@{@"token" : [TXModelAchivar getUserModel].token} bodyParams:params success:^(AFHTTPSessionManager *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view];
        if ([responseObject[@"status"] integerValue] == 1) {
            [ShowMessage showMessage:@"申诉成功"];
            [self.navigationController popViewControllerAnimated:true];
        } else {
            [ShowMessage showMessage:responseObject[@"msg"]];
        }
    } failure:^(AFHTTPSessionManager *operation, NSError *error) {
        [ShowMessage showMessage:error.description];
        [MBProgressHUD hideHUDForView:self.view];
    }];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
