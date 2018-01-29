//
//  DTStoreWorkViewController.m
//  DotMerchant
//
//  Created by 倩倩 on 2017/9/13.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTStoreWorkViewController.h"
#import "DTStoreNameTableViewCell.h"
#import "DTStoreSignTableViewCell.h"
#import "DTWorkTimeTableViewCell.h"
#import "TXPhotoTableViewCell.h"
#import "DTStoreCategoryTableViewCell.h"
#import "DTStoreModel.h"
#import <CoreLocation/CoreLocation.h>
#import "DTFirstCategoryModel.h"


@interface DTStoreWorkViewController () <UITableViewDataSource, UITableViewDelegate, TXPhotoTableViewCellDelegate, DTWorkTimeTableViewCellDelegate, DTStoreSignTableViewCellDelegate, DTStoreCategoryTableViewCellDelegate, QBImagePickerControllerDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** 图片数组*/
@property (nonatomic, strong) NSMutableArray *commentPictures;
@property (nonatomic, strong) UIImage *storeSignImage;

@property (nonatomic, strong) NSMutableArray *hourArray;
@property (nonatomic, strong) NSMutableArray *minuteArray;

@property (nonatomic, strong) NSMutableArray <DTFirstCategoryModel *>*firstCategoryArray;
@property (nonatomic, strong) NSMutableArray *secondCategoryArray;

@property (nonatomic, strong) UITextField *nameTF;
@property (nonatomic, strong) UITextField *phoneTF;
@property (nonatomic, strong) UITextField *descTF;
@property (nonatomic, strong) UITextField *addressTF;

@property (nonatomic, strong) DTStoreModel *storeModel;


@property (nonatomic, strong) UIButton *commitButton;

@property (nonatomic, strong) NSString *firstOneStr;
@property (nonatomic, strong) NSString *firstTwoStr;
@property (nonatomic, strong) NSString *secondOneStr;
@property (nonatomic, strong) NSString *secondTwoStr;
@property (nonatomic, strong) NSString *firstTypeId;
@property (nonatomic, strong) NSString *secondTypeId;

@property (nonatomic, strong) NSMutableArray *downloadArray;


@end

@implementation DTStoreWorkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"店铺运营";
    self.firstTypeId = @"0";
    self.secondTypeId = @"0";
    self.storeModel = [DTStoreModel new];
    [self initializeDataSource];
    self.tableView.tableFooterView = [self tableFooterView];
    self.downloadArray = [NSMutableArray new];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    
    [self loadData];
    [self loadFirstCategoryData];
    
}

- (void)textFieldDidChange:(NSNotification *)noti {
    if (self.nameTF.text.length != 0 &&
        self.phoneTF.text.length != 0 &&
        self.phoneTF.text.length != 0 &&
        self.descTF.text.length != 0 &&
        self.addressTF.text.length != 0) {
        self.commitButton.enabled = true;
        [self.commitButton setBackgroundColor:RGB(246, 30, 46)];
    } else {
        self.commitButton.enabled = false;
        [self.commitButton setBackgroundColor:RGB(153, 153, 153)];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.addressTF && textField.text.length > 0) {
        [self accordingToTheCityToGetgoldLatitude:textField.text];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Data Request

- (void)downloadStoreImageWithString:(NSString *)imageString {
    if ([NSString isTextEmpty:imageString]) {
        return;
    }
    
    NSString *url = [imageHost stringByAppendingPathComponent:imageString];
    [[RCHttpHelper sharedHelper] downloadImageWithUrl:url success:^(NSString *filePath) {
        UIImage *image = [UIImage imageWithContentsOfFile:filePath];
        if (image) {
            self.storeSignImage = image;
        }
    }];
}

- (void)downloadImagesWithArray:(NSArray *)imageArray {
    if (imageArray.count == 0) {
        return;
    }
    
    for (NSString *imageUrl in imageArray) {
        if ([NSString isTextEmpty:imageUrl]) {
            continue;
        }
        
        NSString *url = [imageHost stringByAppendingPathComponent:imageUrl];
        [[RCHttpHelper sharedHelper] downloadImageWithUrl:url success:^(NSString *filePath) {
            UIImage *image = [UIImage imageWithContentsOfFile:filePath];
            if (image) {
                [self.commentPictures insertObject:image atIndex:self.commentPictures.count - 1];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            }
        }];
    }
}

- (void)loadData {
    // 请求数据
    if (![[TXUserModel defaultUser] userLoginStatus]) {
        [ShowMessage showMessage:@"请登录"];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
    [[RCHttpHelper sharedHelper] getUrl:[httpHost stringByAppendingPathComponent:shopInfo] headParams:@{@"token" : [TXModelAchivar getUserModel].token} bodyParams:nil success:^(AFHTTPSessionManager *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:true];
        if ([responseObject[@"status"] integerValue] == 1) {
            self.storeModel = [DTStoreModel mj_objectWithKeyValues:responseObject[@"data"]];
            
            if (self.storeModel.type.count == 1) {
                self.firstOneStr = ((DTStoreType *)self.storeModel.type.firstObject).firstTypeId;
                self.firstTwoStr = ((DTStoreType *)self.storeModel.type.firstObject).twoTypeId;
                self.firstTypeId = ((DTStoreType *)self.storeModel.type.firstObject).idField;
            } else if (self.storeModel.type.count >= 2) {
                self.firstOneStr = ((DTStoreType *)self.storeModel.type.firstObject).firstTypeId;
                self.firstTwoStr = ((DTStoreType *)self.storeModel.type.firstObject).twoTypeId;
                self.firstTypeId = ((DTStoreType *)self.storeModel.type.firstObject).idField;
                self.secondOneStr = ((DTStoreType *)self.storeModel.type.lastObject).firstTypeId;
                self.secondTwoStr = ((DTStoreType *)self.storeModel.type.lastObject).twoTypeId;
                self.secondTypeId = ((DTStoreType *)self.storeModel.type.lastObject).idField;
            }
            
            [self.tableView reloadData];
            
            [self downloadImagesWithArray:[self.storeModel.maxIcon componentsSeparatedByString:@","]];
            
            [self downloadStoreImageWithString:self.storeModel.minIcon];
            
        } else {
            [ShowMessage showMessage:responseObject[@"msg"]];
        }
    } failure:^(AFHTTPSessionManager *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:true];
        [ShowMessage showMessage:error.description];
    }];
}


- (void)loadFirstCategoryData {
    
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setValue:[TXModelAchivar getUserModel].token forKey:@"token"];
    
    [[RCHttpHelper sharedHelper] getUrl:[httpHost stringByAppendingPathComponent:firstCategory] headParams:param bodyParams:nil success:^(AFHTTPSessionManager *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:true];
        if ([responseObject[@"status"] integerValue] == 1) {
            DTFirstCategoryCollectionModel *collectionModel = [DTFirstCategoryCollectionModel mj_objectWithKeyValues:responseObject];
            [self.firstCategoryArray addObjectsFromArray:collectionModel.data];
        } else {
            [ShowMessage showMessage:responseObject[@"msg"]];
        }
    } failure:^(AFHTTPSessionManager *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:true];
        [ShowMessage showMessage:error.description];
    }];
}

- (void)loadSecondCategoryDataWithId:(NSString *)firstId {
    if ([NSString isTextEmpty:firstId]) {
        [ShowMessage showMessage:@"id错误"];
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
    [[RCHttpHelper sharedHelper] getUrl:[httpHost stringByAppendingPathComponent:secondCategory] headParams:@{@"token" : [TXModelAchivar getUserModel].token} bodyParams:@{@"typeId" :firstId} success:^(AFHTTPSessionManager *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:true];
        if ([responseObject[@"status"] integerValue] == 1) {
            DTFirstCategoryCollectionModel *collectionModel = [DTFirstCategoryCollectionModel mj_objectWithKeyValues:responseObject];
            [self.secondCategoryArray removeAllObjects];
            [self.secondCategoryArray addObjectsFromArray:collectionModel.data];
        } else {
            [ShowMessage showMessage:responseObject[@"msg"]];
        }
    } failure:^(AFHTTPSessionManager *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:true];
        [ShowMessage showMessage:error.description];
    }];
}

#pragma mark - Initial

/**
 * 初始化 评论图
 */
- (void)initializeDataSource {
    self.commentPictures = [NSMutableArray new];
    [self.commentPictures addObject:[UIImage imageNamed:@"ic_camera"]];
    
    self.firstCategoryArray = [NSMutableArray new];
    self.secondCategoryArray = [NSMutableArray new];
    self.hourArray = [NSMutableArray new];
    self.minuteArray = [NSMutableArray new];
    
    for (int i = 0; i < 24; i++) {
        if (i < 10) {
            [self.hourArray addObject:[NSString stringWithFormat:@"0%d", i]];
        } else {
            [self.hourArray addObject:[NSString stringWithFormat:@"%d", i]];
        }
    }
    
    for (int i = 0; i < 60; i++) {
        if (i < 10) {
            [self.minuteArray addObject:[NSString stringWithFormat:@"0%d", i]];
        } else {
            [self.minuteArray addObject:[NSString stringWithFormat:@"%d", i]];
        }
    }
}

- (UIView *)tableFooterView {
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 150)];
    footer.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.commitButton.frame = CGRectMake(42, 32, SCREEN_WIDTH - 84, 49);
    self.commitButton.titleLabel.font = FONT(18);
    [self.commitButton setTitle:@"保存并提交" forState:UIControlStateNormal];
    self.commitButton.backgroundColor = RGB(246, 30, 46);
    [self.commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.commitButton.layer.cornerRadius = 24.5;
    self.commitButton.layer.masksToBounds = true;
    [self.commitButton addTarget:self action:@selector(touchCommitBtn) forControlEvents:UIControlEventTouchUpInside];
    [footer addSubview:self.commitButton];
    return footer;
}

- (void)touchCommitBtn {
    NSLog(@"%@ %@ %@", _nameTF.text, _phoneTF.text, _addressTF.text);
    [self uploadShopLogoImage];
}

- (void)uploadShopLogoImage {
    // 上传图片
    if (!self.storeSignImage) {
        [ShowMessage showMessage:@"请上传店铺图标"];
        return;
    }
    NSData *imageData = UIImageJPEGRepresentation(self.storeSignImage, 0.9);
    if (imageData.length/1024/1024 > 0.9) {
        imageData = UIImageJPEGRepresentation(self.storeSignImage, 0.4);
    }
    [[RCHttpHelper sharedHelper] uploadPicWithPostUrl:[httpHost stringByAppendingPathComponent:orderCommentPicUp] headParams:nil bodyParams:nil imageKeys:@[@"file"] images:@[imageData] progress:nil success:^(AFHTTPSessionManager *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view];
        if ([responseObject[@"status"] integerValue] == 1) {
            self.storeModel.minIcon = responseObject[@"data"];
            
            [self uploadShopDiscriptionImage];
        } else {
            [MBProgressHUD hideHUDForView:self.view];
            [ShowMessage showMessage:responseObject[@"msg"]];
        }
    } failure:^(AFHTTPSessionManager *operation, NSError *error) {
        [ShowMessage showMessage:error.description];
        [MBProgressHUD hideHUDForView:self.view];
    }];
}

- (void)uploadShopDiscriptionImage {
    if (self.commentPictures.count == 1) {
        [ShowMessage showMessage:@"请上传店铺介绍图片"];
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
                        self.storeModel.maxIcon = [imageArray componentsJoinedByString:@","];
                        [self uploadParamsToServer];
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
    }
}

- (void)uploadParamsToServer {
    
    if ([NSString isTextEmpty:self.nameTF.text]) {
        [ShowMessage showMessage:@"请输入店铺名"];
        return;
    }
    
    if ([NSString isTextEmpty:self.addressTF.text]) {
        [ShowMessage showMessage:@"请输入地址"];
        return;
    }
    
    if ([NSString isTextEmpty:self.descTF.text]) {
        [ShowMessage showMessage:@"请输入店铺描述"];
        return;
    }
    
    if ([NSString isTextEmpty:self.phoneTF.text]) {
        [ShowMessage showMessage:@"请输入电话号码"];
        return;
    }
    
    if ([NSString isTextEmpty:self.storeModel.startTime]) {
        [ShowMessage showMessage:@"请选择营业时间"];
        return;
    }
    
    if ([NSString isTextEmpty:self.storeModel.endTime]) {
        [ShowMessage showMessage:@"请选择停业时间"];
        return;
    }
    
    if ([NSString isTextEmpty:self.firstOneStr]) {
        [ShowMessage showMessage:@"请选择一级分类"];
        return;
    }
    
    if ([NSString isTextEmpty:self.firstTwoStr]) {
        [ShowMessage showMessage:@"请选择一级分类子分类"];
        return;
    }
    
    if ([NSString isTextEmpty:self.secondOneStr]) {
        [ShowMessage showMessage:@"请选择二级分类"];
        return;
    }
    
    if ([NSString isTextEmpty:self.secondTwoStr]) {
        [ShowMessage showMessage:@"请选择二级分类子分类"];
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:self.nameTF.text forKey:@"shopName"];
    [params setValue:self.storeModel.minIcon forKey:@"minIcon"];
    [params setValue:self.storeModel.maxIcon forKey:@"maxIcon"];
    [params setValue:self.phoneTF.text forKey:@"phone"];
    [params setValue:self.addressTF.text forKey:@"address"];
    [params setValue:self.storeModel.lon forKey:@"lon"];
    [params setValue:self.storeModel.lat forKey:@"lat"];
    [params setValue:self.storeModel.startTime forKey:@"startTime"];
    [params setValue:self.storeModel.endTime forKey:@"endTime"];
    [params setValue:[NSString stringWithFormat:@"%@,%@,%@;%@,%@,%@", self.firstOneStr, self.firstTwoStr, self.firstTypeId, self.secondOneStr, self.secondTwoStr, self.secondTypeId] forKey:@"type"];
    [params setValue:self.storeModel.province forKey:@"province"];
    [params setValue:self.storeModel.city forKey:@"city"];
    [params setValue:self.storeModel.area forKey:@"area"];
    [params setValue:self.storeModel.street forKey:@"street"];
    [params setValue:self.descTF.text forKey:@"noticeStr"];
    
    
    [MBProgressHUD hideHUDForView:self.view];
    [[RCHttpHelper sharedHelper] postUrl:[httpHost stringByAppendingPathComponent:saveShopInfo] headParams:@{@"token" : [TXModelAchivar getUserModel].token} bodyParams:params success:^(AFHTTPSessionManager *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view];
        if ([responseObject[@"status"] integerValue] == 1) {
            [ShowMessage showMessage:@"保存成功"];
            [TXModelAchivar updateUserModelWithKey:@"face" value:self.storeModel.minIcon];
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationLoginSuccess object:nil userInfo:nil];
            [self.navigationController popViewControllerAnimated:true];
        } else {
            [ShowMessage showMessage:responseObject[@"msg"]];
        }
    } failure:^(AFHTTPSessionManager *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
        [ShowMessage showMessage:error.description];
    }];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 8;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TXSeperateLineCell *cellDefault = nil;
    switch (indexPath.row) {
        case 0:
        {
            DTStoreNameTableViewCell *cell = [DTStoreNameTableViewCell cellWithTableView:tableView];
            cell.cellLineType = TXCellSeperateLinePositionType_Single;
            cell.cellLineRightMargin = TXCellRightMarginType0;
            cell.nameLabel.text = @"店铺名:";
            self.nameTF = cell.contentTF;
            self.nameTF.delegate = self;
            self.nameTF.text = self.storeModel.name;
            cellDefault = cell;
        }
            break;
            
        case 1:
        {
            DTStoreSignTableViewCell *cell = [DTStoreSignTableViewCell cellWithTableView:tableView];
            cell.cellLineType = TXCellSeperateLinePositionType_Single;
            cell.cellLineRightMargin = TXCellRightMarginType0;
            cell.delegate = self;
            [cell.goodsImageView sd_setImageWithURL:[NSURL URLWithString:[imageHost stringByAppendingPathComponent:self.storeModel.minIcon]] placeholderImage:[UIImage imageNamed:@"ic_camera"]];
            cellDefault = cell;
        }
            break;
            
        case 2:
        {
            TXPhotoTableViewCell *cell = [TXPhotoTableViewCell cellWithTableView:tableView];
            cell.cellLineType = TXCellSeperateLinePositionType_Single;
            cell.cellLineRightMargin = TXCellRightMarginType0;
            cell.dataSource = self.commentPictures;
            cell.delegate = self;
            cell.descriptionLabel.text = @"店铺图片:";
            cellDefault = cell;
        }
            break;
            
        case 3:
        {
            DTStoreNameTableViewCell *cell = [DTStoreNameTableViewCell cellWithTableView:tableView];
            cell.cellLineType = TXCellSeperateLinePositionType_Single;
            cell.cellLineRightMargin = TXCellRightMarginType0;
            cell.nameLabel.text = @"联系电话:";
            self.phoneTF = cell.contentTF;
            self.phoneTF.delegate = self;
            self.phoneTF.text = self.storeModel.phone;
            cellDefault = cell;
        }
            break;
            
        case 4:
        {
            DTStoreNameTableViewCell *cell = [DTStoreNameTableViewCell cellWithTableView:tableView];
            cell.cellLineType = TXCellSeperateLinePositionType_Single;
            cell.cellLineRightMargin = TXCellRightMarginType0;
            cell.nameLabel.text = @"店铺描述:";
            self.descTF = cell.contentTF;
            self.descTF.delegate = self;
            self.descTF.text = self.storeModel.noticeStr;
            cellDefault = cell;
        }
            break;
            
        case 5:
        {
            DTStoreNameTableViewCell *cell = [DTStoreNameTableViewCell cellWithTableView:tableView];
            cell.cellLineType = TXCellSeperateLinePositionType_Single;
            cell.cellLineRightMargin = TXCellRightMarginType0;
            cell.nameLabel.text = @"店铺地址:";
            self.addressTF = cell.contentTF;
            self.addressTF.delegate = self;
            self.addressTF.text = self.storeModel.address;
            cellDefault = cell;
        }
            break;
            
        case 6:
        {
            DTWorkTimeTableViewCell *cell = [DTWorkTimeTableViewCell cellWithTableView:tableView];
            cell.cellLineType = TXCellSeperateLinePositionType_Single;
            cell.cellLineRightMargin = TXCellRightMarginType0;
            cell.delegate = self;
            [cell.fromBtn setTitle:self.storeModel.startTime forState:UIControlStateNormal];
            [cell.toBtn setTitle:self.storeModel.endTime forState:UIControlStateNormal];
            cellDefault = cell;
        }
            break;
            
        case 7:
        {
            DTStoreCategoryTableViewCell *cell = [DTStoreCategoryTableViewCell cellWithTableView:tableView];
            cell.cellLineType = TXCellSeperateLinePositionType_Single;
            cell.cellLineRightMargin = TXCellRightMarginType0;
            cell.delegate = self;
            cell.typeArray = self.storeModel.type;
            cellDefault = cell;
        }
            break;
            
        default:
            break;
    }
    
    return cellDefault;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat rowHeight = 0.0;
    switch (indexPath.row) {
        case 0:
        {
            rowHeight = 50.0;
        }
            break;
            
        case 1:
        {
            rowHeight = 90;
        }
            break;
            
        case 2:
        {
            rowHeight = 80;
        }
            break;
            
        case 3:
        {
            rowHeight = 50.0;
        }
            break;
            
        case 4:
        {
            rowHeight = 50.0;
        }
            break;
            
        case 5:
        {
            rowHeight = 50.0;
        }
            break;
            
        case 6:
        {
            rowHeight = 50.0;
        }
            break;
            
        case 7:
        {
            rowHeight = 170.0;
        }
            break;
            
        default:
            break;
    }
    
    return rowHeight;
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
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
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
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
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
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
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
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:2 inSection:0];
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
 *  选择图片
 */
- (void)touchStoreSignImage {
    UIAlertController *avatarAlert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    __weak __typeof(&*avatarAlert)weakAvatarAlert = avatarAlert;
    weakSelf(self);
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[CMImagePickerManager sharedCMImagePickerManager] showCameraWithViewController:weakSelf handler:^(UIImage *image) {
            weakSelf.storeSignImage = image;
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
            DTStoreSignTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            [cell.addSignBtn setBackgroundImage:image forState:UIControlStateNormal];
        }];
    }];
    
    UIAlertAction *albumAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            UIAlertView *alert= [[UIAlertView alloc] initWithTitle:nil message:@"该设备不支持从相册选取文件" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:NULL];
            [alert show];
        }else{
            [[CMImagePickerManager sharedCMImagePickerManager] showPhotoLibraryWithViewController:weakSelf handler:^(UIImage *image) {
                weakSelf.storeSignImage = image;
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
                DTStoreSignTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
                [cell.addSignBtn setBackgroundImage:image forState:UIControlStateNormal];
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


#pragma mark - DTWorkTimeTableViewCellDelegate 

- (void)touchFromButtonWithButton:(UIButton *)btn {
    [CDZPicker showPickerInView:self.view showCancel:false withStringArrays:@[self.hourArray, self.minuteArray] confirm:^(NSArray<NSString *> *stringArray) {
        NSLog(@"%@ %@", stringArray[0], stringArray[1]);
        [btn setTitle:[NSString stringWithFormat:@"%@:%@", stringArray[0], stringArray[1]] forState:UIControlStateNormal];
        self.storeModel.startTime = [NSString stringWithFormat:@"%@:%@", stringArray[0], stringArray[1]];
    } cancel:^(NSArray<NSString *> *stringArray) {
        
    }];
}

- (void)touchToButtonWithButton:(UIButton *)btn {
    [CDZPicker showPickerInView:self.view showCancel:false withStringArrays:@[self.hourArray, self.minuteArray] confirm:^(NSArray<NSString *> *stringArray) {
        NSLog(@"%@ %@", stringArray[0], stringArray[1]);
        [btn setTitle:[NSString stringWithFormat:@"%@:%@", stringArray[0], stringArray[1]] forState:UIControlStateNormal];
        self.storeModel.endTime = [NSString stringWithFormat:@"%@:%@", stringArray[0], stringArray[1]];
    } cancel:^(NSArray<NSString *> *stringArray) {
        
    }];
}

#pragma mark - DTStoreSignTableViewCellDelegate

- (void)touchAddSignButton {
    [self touchStoreSignImage];
}

#pragma mark - DTStoreCategoryTableViewCellDelegate

- (void)touchFirstOneButtonWithLabel:(UILabel *)label {
    if (self.firstCategoryArray.count == 0) {
        [ShowMessage showMessage:@"暂无分类数据"];
        return;
    }
    NSMutableArray *tempArray = [NSMutableArray new];
    for (DTFirstCategoryModel *model in self.firstCategoryArray) {
        [tempArray addObject:model.name];
    }
    
    [CDZPicker showPickerInView:self.view showCancel:false withStrings:tempArray confirm:^(NSArray<NSString *> *stringArray) {
        label.text = stringArray[0];
        
        for (DTFirstCategoryModel *model in self.firstCategoryArray) {
            if ([model.name isEqualToString:stringArray[0]]) {
                self.firstOneStr = model.idField;
                [self loadSecondCategoryDataWithId:model.idField];
                break;
            }
        }
        
    } cancel:^(NSArray<NSString *> *stringArray) {
        
    }];
}

- (void)touchFirstTwoButtonWithLabel:(UILabel *)label {
    if (self.secondCategoryArray.count == 0) {
        [ShowMessage showMessage:@"暂无分类数据"];
        return;
    }
    NSMutableArray *tempArray = [NSMutableArray new];
    for (DTFirstCategoryModel *model in self.secondCategoryArray) {
        [tempArray addObject:model.name];
    }
    [CDZPicker showPickerInView:self.view showCancel:false withStrings:tempArray confirm:^(NSArray<NSString *> *stringArray) {
        label.text = stringArray[0];
        for (DTFirstCategoryModel *model in self.secondCategoryArray) {
            if ([model.name isEqualToString:stringArray[0]]) {
                self.firstTwoStr = model.idField;
                break;
            }
        }
    } cancel:^(NSArray<NSString *> *stringArray) {
        
    }];
}

- (void)touchSecondOneButtonWithLabel:(UILabel *)label {
    if (self.firstCategoryArray.count == 0) {
        [ShowMessage showMessage:@"暂无分类数据"];
        return;
    }
    NSMutableArray *tempArray = [NSMutableArray new];
    for (DTFirstCategoryModel *model in self.firstCategoryArray) {
        [tempArray addObject:model.name];
    }
    [CDZPicker showPickerInView:self.view showCancel:false withStrings:tempArray confirm:^(NSArray<NSString *> *stringArray) {
        label.text = stringArray[0];
        for (DTFirstCategoryModel *model in self.firstCategoryArray) {
            if ([model.name isEqualToString:stringArray[0]]) {
                self.secondOneStr = model.idField;
                [self loadSecondCategoryDataWithId:model.idField];
                break;
            }
        }
    } cancel:^(NSArray<NSString *> *stringArray) {
        
    }];
}

- (void)touchSecondTwoButtonWithLabel:(UILabel *)label {
    if (self.secondCategoryArray.count == 0) {
        [ShowMessage showMessage:@"暂无分类数据"];
        return;
    }
    NSMutableArray *tempArray = [NSMutableArray new];
    for (DTFirstCategoryModel *model in self.secondCategoryArray) {
        [tempArray addObject:model.name];
    }
    [CDZPicker showPickerInView:self.view showCancel:false withStrings:tempArray confirm:^(NSArray<NSString *> *stringArray) {
        label.text = stringArray[0];
        for (DTFirstCategoryModel *model in self.secondCategoryArray) {
            if ([model.name isEqualToString:stringArray[0]]) {
                self.secondTwoStr = model.idField;
                break;
            }
        }
    } cancel:^(NSArray<NSString *> *stringArray) {
        NSLog(@"string = %@", stringArray[0]);
    }];
}

#pragma mark - CLGeocoder

/**
 * 根据地名获取经纬度
 */
- (void)accordingToTheCityToGetgoldLatitude:(NSString*)addressName {
    CLGeocoder *myGeocoder = [[CLGeocoder alloc] init];
    [myGeocoder geocodeAddressString:addressName completionHandler:^(NSArray *placemarks, NSError *error) {
        if ([placemarks count] > 0 && error == nil) {
            CLPlacemark *firstPlacemark = [placemarks objectAtIndex:0];
            NSString *longitude = [NSString stringWithFormat:@"%f",firstPlacemark.location.coordinate.longitude];
            NSString *latitude = [NSString stringWithFormat:@"%f",firstPlacemark.location.coordinate.latitude];
            
            self.storeModel.lon = longitude;
            self.storeModel.lat = latitude;
            
            [self accordingWithLatitude:latitude longitude:longitude];
        }
        else if ([placemarks count] == 0 && error == nil) {
            self.storeModel.lon = @"104.064095";
            self.storeModel.lat = @"30.551882";
            [self accordingWithLatitude:self.storeModel.lat longitude:self.storeModel.lon];
        } else if (error != nil) {
            self.storeModel.lon = @"104.064095";
            self.storeModel.lat = @"30.551882";
            [self accordingWithLatitude:self.storeModel.lat longitude:self.storeModel.lon];
        }
    }];
}

- (void)accordingWithLatitude:(NSString *)lat longitude:(NSString *)lon {
    CLLocationCoordinate2D coor;
    coor.latitude = [lat doubleValue];
    coor.longitude = [lon doubleValue];
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:coor.latitude longitude:coor.longitude];
    
    NSLog(@"latitude === %g  longitude === %g",location.coordinate.latitude, location.coordinate.longitude);
    
    //反向地理编码
    
    CLGeocoder *clGeoCoder = [[CLGeocoder alloc] init];
    
    CLLocation *cl = [[CLLocation alloc] initWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
    
    [clGeoCoder reverseGeocodeLocation:cl completionHandler: ^(NSArray *placemarks,NSError *error) {
        
        for (CLPlacemark *placeMark in placemarks) {
            
            NSDictionary *addressDic = placeMark.addressDictionary;
            
            NSString *state=[addressDic objectForKey:@"State"];
            
            NSString *city=[addressDic objectForKey:@"City"];
            
            NSString *subLocality=[addressDic objectForKey:@"SubLocality"];
            
            NSString *street=[addressDic objectForKey:@"Street"];
            NSLog(@"所在城市====%@ %@ %@ %@", state, city, subLocality, street);
            self.storeModel.province = state;
            self.storeModel.city = city;
            self.storeModel.area = subLocality;
            self.storeModel.street = street;
        }
        
    }];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
