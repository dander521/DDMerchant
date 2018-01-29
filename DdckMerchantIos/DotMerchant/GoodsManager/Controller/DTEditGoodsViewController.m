//
//  DTEditGoodsViewController.m
//  DotMerchant
//
//  Created by 倩倩 on 2017/9/17.
//  Copyright © 2017年 RogerChen. All rights reserved.
//

#import "DTEditGoodsViewController.h"
#import "DTStoreNameTableViewCell.h"
#import "DTEditGoodsTableViewCell.h"
#import "DTGoodsCategoryModel.h"
#import "DTGoodsInfoModel.h"
#import "TXPhotoTableViewCell.h"
#import "DTGoodsDescTableViewCell.h"
#import "DTGoodsInfoModel.h"
#import "DTShopTypeModel.h"
#import "DTGoodsDetailTableViewCell.h"

@interface DTEditGoodsViewController () <UITableViewDelegate, UITableViewDataSource, DTEditGoodsTableViewCellDelegate, AlertViewSelectorViewDelegate, UITextFieldDelegate, TXPhotoTableViewCellDelegate, QBImagePickerControllerDelegate, DTGoodsDescTableViewCellDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *secondCategoryArray;

@property (nonatomic, strong) RCCustomAlertView *alert;

@property (nonatomic, strong) UITextField *goodsNameTF;
@property (nonatomic, strong) UITextField *goodsDesTF;
@property (nonatomic, strong) UITextField *storePriceTF;
@property (nonatomic, strong) UITextField *groupPriceTF;
@property (nonatomic, strong) UITextView *detailsTV;

@property (nonatomic, strong) UIButton *commitButton;

/** 服务器返回图片路径 */
@property (nonatomic, strong) NSString *imageUrl;

@property (nonatomic, strong) NSMutableArray <DTGoodsCategoryModel *>*categoryArray;

/** 商品信息 */
@property (nonatomic, strong) DTGoodsInfoModel *goodsInfoModel;

@property (nonatomic, strong) NSMutableArray *commentPictures;

@property (nonatomic, strong) NSMutableArray *downloadArray;
@property (nonatomic, strong) NSMutableArray <DTGoodsDesModel *>*goodsDescArray;
@property (nonatomic, strong) NSMutableArray *shopTypeArray;

@end

@implementation DTEditGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"商品管理";
    self.tableView.tableFooterView = [self tableFooterView];
    self.categoryArray = [NSMutableArray new];
    self.secondCategoryArray = [NSMutableArray new];
    self.goodsInfoModel = [DTGoodsInfoModel new];
    self.downloadArray = [NSMutableArray new];
    self.commentPictures = [NSMutableArray new];
    self.goodsDescArray = [NSMutableArray new];
    self.shopTypeArray = [NSMutableArray new];
    [self.commentPictures addObject:[UIImage imageNamed:@"ic_camera"]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidChanged:) name:UITextViewTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
    
    [self getGoodsCategory];
    [self loadShopType];
    if (![NSString isTextEmpty:self.goodsId]) {
        self.commitButton.enabled = true;
        [self.commitButton setBackgroundColor:RGB(246, 30, 46)];
        [self getGoodsInfo];
    }
}

- (void)textViewDidChanged:(NSNotification *)noti {
    if (self.goodsNameTF.text.length != 0 &&
        self.goodsDesTF.text.length != 0 &&
        self.storePriceTF.text.length != 0 &&
        self.detailsTV.text.length != 0 &&
        self.groupPriceTF.text.length != 0) {
        self.commitButton.enabled = true;
        [self.commitButton setBackgroundColor:RGB(246, 30, 46)];
    } else {
        self.commitButton.enabled = false;
        [self.commitButton setBackgroundColor:RGB(153, 153, 153)];
    }
}

- (void)textFieldDidChange:(NSNotification *)noti {
    if (self.goodsNameTF.text.length != 0 &&
        self.goodsDesTF.text.length != 0 &&
        self.storePriceTF.text.length != 0 &&
        self.detailsTV.text.length != 0 &&
        self.groupPriceTF.text.length != 0) {
        self.commitButton.enabled = true;
        [self.commitButton setBackgroundColor:RGB(246, 30, 46)];
    } else {
        self.commitButton.enabled = false;
        [self.commitButton setBackgroundColor:RGB(153, 153, 153)];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:true];
    return true;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.goodsNameTF) {
        self.goodsInfoModel.name = textField.text;
    } else if (textField == self.goodsDesTF) {
        self.goodsInfoModel.title = textField.text;
    } else if (textField == self.groupPriceTF) {
        self.goodsInfoModel.curPrice = textField.text;
    } else if (textField == self.storePriceTF) {
        self.goodsInfoModel.price = textField.text;
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    self.goodsInfoModel.details = textView.text;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [self.detailsTV resignFirstResponder];
        return false;
    }
    return true;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Data Request

/**
 商品信息
 */
- (void)getGoodsInfo {
    if (![[TXUserModel defaultUser] userLoginStatus]) {
        [ShowMessage showMessage:@"请登录"];
        return;
    }
    
    if ([NSString isTextEmpty:self.goodsId]) {
        [ShowMessage showMessage:@"商品不存在"];
        return;
    }
    
    [[RCHttpHelper sharedHelper] getUrl:[httpHost stringByAppendingPathComponent:goodsInfo] headParams:@{@"token" : [TXModelAchivar getUserModel].token} bodyParams:@{@"id":self.goodsId} success:^(AFHTTPSessionManager *operation, id responseObject) {
        [ShowMessage showMessage:responseObject[@"msg"]];
        if ([responseObject[@"status"] integerValue] == 1) {
            self.goodsInfoModel = [DTGoodsInfoModel mj_objectWithKeyValues:responseObject[@"data"]];
            [self.goodsDescArray addObjectsFromArray:self.goodsInfoModel.descs];
            
            [self.tableView reloadData];
            
            [self downloadImagesWithArray:[self.goodsInfoModel.img componentsSeparatedByString:@","]];
        }
    } failure:^(AFHTTPSessionManager *operation, NSError *error) {
        [ShowMessage showMessage:error.description];
        [MBProgressHUD hideHUDForView:self.view];
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

- (void)loadShopType {
    [[RCHttpHelper sharedHelper] getUrl:[httpHost stringByAppendingPathComponent:shopType] headParams:@{@"token" : [TXModelAchivar getUserModel].token} bodyParams:nil success:^(AFHTTPSessionManager *operation, id responseObject) {
        
        if ([responseObject[@"status"] integerValue] == 1) {
            DTShopTypeCollectionModel *collection = [DTShopTypeCollectionModel mj_objectWithKeyValues:responseObject];
            self.shopTypeArray = [NSMutableArray arrayWithArray:collection.data];
            [self.tableView reloadData];
        } else {
            [ShowMessage showMessage:responseObject[@"msg"]];
        }
    } failure:^(AFHTTPSessionManager *operation, NSError *error) {
        [ShowMessage showMessage:error.description];
        
    }];
}


/**
 商品分类
 */
- (void)getGoodsCategory {
    
    if (![[TXUserModel defaultUser] userLoginStatus]) {
        [ShowMessage showMessage:@"请登录"];
        return;
    }
    
    [[RCHttpHelper sharedHelper] getUrl:[httpHost stringByAppendingPathComponent:goodsCategoryInfo] headParams:@{@"token" : [TXModelAchivar getUserModel].token} bodyParams:nil success:^(AFHTTPSessionManager *operation, id responseObject) {
        [ShowMessage showMessage:responseObject[@"msg"]];
        if ([responseObject[@"status"] integerValue] == 1) {
            
            DTGoodsCategoryCollectionModel *colloectionModel = [DTGoodsCategoryCollectionModel mj_objectWithKeyValues:responseObject];
            [self.categoryArray removeAllObjects];
            [self.categoryArray addObjectsFromArray:colloectionModel.data];
            [self.secondCategoryArray removeAllObjects];
            for (DTGoodsCategoryModel *model in self.categoryArray) {
                [self.secondCategoryArray addObject:model.name];
            }
        }
    } failure:^(AFHTTPSessionManager *operation, NSError *error) {
        [ShowMessage showMessage:error.description];
        [MBProgressHUD hideHUDForView:self.view];
    }];
}

/**
 添加商品分类

 @param categoryName 分类名
 */
- (void)addCategoryWithName:(NSString *)categoryName {
    if ([NSString isTextEmpty:categoryName]) {
        [ShowMessage showMessage:@"分类名不能为空"];
        return;
    }
    
    if (![[TXUserModel defaultUser] userLoginStatus]) {
        [ShowMessage showMessage:@"请登录"];
        return;
    }
    
    [[RCHttpHelper sharedHelper] postUrl:[httpHost stringByAppendingPathComponent:addGoodsCategory] headParams:@{@"token" : [TXModelAchivar getUserModel].token} bodyParams:@{@"name" : categoryName} success:^(AFHTTPSessionManager *operation, id responseObject) {
        if ([responseObject[@"status"] integerValue] == 1) {
            [ShowMessage showMessage:@"添加成功"];
            [self getGoodsCategory];
        }
        [ShowMessage showMessage:responseObject[@"msg"]];
    } failure:^(AFHTTPSessionManager *operation, NSError *error) {
        [ShowMessage showMessage:error.description];
        [MBProgressHUD hideHUDForView:self.view];
    }];
}

/**
 删除分类

 @param categoryId 分类id
 */
- (void)deleteCategoryWithId:(NSString *)categoryId {
    if ([NSString isTextEmpty:categoryId]) {
        [ShowMessage showMessage:@"删除分类不存在"];
        return;
    }
    
    if (![[TXUserModel defaultUser] userLoginStatus]) {
        [ShowMessage showMessage:@"请登录"];
        return;
    }
    
    [[RCHttpHelper sharedHelper] getUrl:[httpHost stringByAppendingPathComponent:deleteGoodsCategory] headParams:@{@"token" : [TXModelAchivar getUserModel].token} bodyParams:@{@"typeId" : categoryId} success:^(AFHTTPSessionManager *operation, id responseObject) {
        if ([responseObject[@"status"] integerValue] == 1) {
            [ShowMessage showMessage:@"删除成功"];
            [self getGoodsCategory];
        }
        [ShowMessage showMessage:responseObject[@"msg"]];
    } failure:^(AFHTTPSessionManager *operation, NSError *error) {
        [ShowMessage showMessage:error.description];
        [MBProgressHUD hideHUDForView:self.view];
    }];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 8;
    } else {
        return self.goodsDescArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TXSeperateLineCell *cellDefault = nil;
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                DTStoreNameTableViewCell *cell = [DTStoreNameTableViewCell cellWithTableView:tableView];
                cell.nameLabel.text = @"商品名:";
                self.goodsNameTF = cell.contentTF;
                self.goodsNameTF.delegate = self;
                self.goodsNameTF.text = self.goodsInfoModel.name;
                cellDefault = cell;
            }
                break;
                
            case 1:
            {
                DTStoreNameTableViewCell *cell = [DTStoreNameTableViewCell cellWithTableView:tableView];
                cell.nameLabel.text = @"商品简介:";
                self.goodsDesTF = cell.contentTF;
                self.goodsDesTF.delegate = self;
                self.goodsDesTF.text = self.goodsInfoModel.title;
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
                cell.descriptionLabel.text = @"商品图片:";
                cellDefault = cell;
            }
                break;
                
            case 3:
            {
                DTStoreNameTableViewCell *cell = [DTStoreNameTableViewCell cellWithTableView:tableView];
                cell.nameLabel.text = @"店铺价格:";
                self.storePriceTF = cell.contentTF;
                self.storePriceTF.delegate = self;
                self.storePriceTF.text = self.goodsInfoModel.price;
                self.storePriceTF.keyboardType = UIKeyboardTypeNumberPad;
                cellDefault = cell;
            }
                break;
                
            case 4:
            {
                DTStoreNameTableViewCell *cell = [DTStoreNameTableViewCell cellWithTableView:tableView];
                cell.nameLabel.text = @"团购价格:";
                self.groupPriceTF = cell.contentTF;
                self.groupPriceTF.delegate = self;
                self.groupPriceTF.text = self.goodsInfoModel.curPrice;
                self.groupPriceTF.keyboardType = UIKeyboardTypeNumberPad;
                cellDefault = cell;
            }
                break;
                
            case 5:
            {
                // 入驻分类
                DTEditGoodsTableViewCell *cell = [DTEditGoodsTableViewCell cellWithTableView:tableView];
                
                for (DTShopTypeModel *model in self.shopTypeArray) {
                    if ([model.firstTypeId isEqualToString:self.goodsInfoModel.firstTypeId]) {
                        cell.categoryLabel.text = model.firstName;
                    }
                }
                cell.descLabel.text = @"入驻分类:";
                cell.delegate = self;
                cell.isStoreType = true;
                cellDefault = cell;
            }
                break;
                
            case 6:
            {
                // 商品分类
                DTEditGoodsTableViewCell *cell = [DTEditGoodsTableViewCell cellWithTableView:tableView];
                cell.descLabel.text = @"所属分类:";
                cell.categoryLabel.text = self.goodsInfoModel.typeName;
                cell.delegate = self;
                cell.isStoreType = false;
                cellDefault = cell;
            }
                break;
                
            case 7:
            {
                DTGoodsDetailTableViewCell *cell = [DTGoodsDetailTableViewCell cellWithTableView:tableView];
                self.detailsTV = cell.contentTextView;
                self.detailsTV.delegate = self;
                self.detailsTV.text = self.goodsInfoModel.details;
                cellDefault = cell;
            }
                break;
                
            default:
                break;
        }
    } else {
        DTGoodsDescTableViewCell *cell = [DTGoodsDescTableViewCell cellWithTableView:tableView];
        cell.delegate = self;
        if (self.goodsDescArray.count >= indexPath.row) {
            cell.model = self.goodsDescArray[indexPath.row];
        }
        cell.indexRow = indexPath.row;
        cellDefault = cell;
    }
    
    cellDefault.cellLineType = TXCellSeperateLinePositionType_Single;
    cellDefault.cellLineRightMargin = TXCellRightMarginType0;
    
    return cellDefault;
}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 1) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = [UIColor whiteColor];
        btn.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
        [btn setTitle:@"添加输入框" forState:UIControlStateNormal];
        [btn setTitleColor:RGB(246, 30, 46) forState:UIControlStateNormal];
        btn.titleLabel.font = FONT(16);
        [btn addTarget:self action:@selector(touchAddInputButton) forControlEvents:UIControlEventTouchUpInside];
        return btn;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        
        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        header.backgroundColor = [UIColor whiteColor];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 20)];
        label.text = @"商品详情:";
        label.textAlignment = NSTextAlignmentLeft;
        label.textColor = RGB(46, 46, 46);
        label.font = FONT(16);
        
        [header addSubview:label];
        return header;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 40;
    }
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 1) {
        return 40;
    }
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat rowHeight = 0.0;
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                rowHeight = 50.0;
            }
                break;
                
            case 1:
            {
                rowHeight = 50.0;
            }
                break;
                
            case 2:
            {
                rowHeight = 90.0;
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
                rowHeight = 120.0;
            }
                break;
                
            default:
                break;
        }
    } else {
        rowHeight = 50.0;
    }
    
    return rowHeight;
}

#pragma mark - DTGoodsDescTableViewCellDelegate

- (void)inputGoodsDescriptionEndWithModel:(DTGoodsDesModel *)model row:(NSInteger)row {
    if (self.goodsDescArray.count - 1 >= row) {
        [self.goodsDescArray replaceObjectAtIndex:row withObject:model];
    } else {
        [self.goodsDescArray addObject:model];
    }
}

#pragma mark - DTEditGoodsTableViewCellDelegate

- (void)touchSelecteButtonWithLabel:(UILabel *)label storeType:(BOOL)storeType {
    [self.view endEditing:true];
    if (!storeType) {
        [CDZPicker showPickerInView:self.view showCancel:true withStrings:self.secondCategoryArray confirm:^(NSArray<NSString *> *stringArray) {
            label.text = stringArray[0];
            self.goodsInfoModel.typeName = stringArray[0];
            for (DTGoodsCategoryModel *model in self.categoryArray) {
                if ([model.name isEqualToString:stringArray[0]]) {
                    self.goodsInfoModel.type = model.idField;
                    break;
                }
            }
        } cancel:^(NSArray<NSString *> *stringArray) {
            NSLog(@"string = %@", stringArray[0]);
            for (DTGoodsCategoryModel *model in self.categoryArray) {
                if ([model.name isEqualToString:stringArray[0]]) {
                    [self deleteCategoryWithId:model.idField];
                    break;
                }
            }
        }];
    } else {
        if (self.shopTypeArray.count == 0) {
            return;
        }
        
        NSMutableArray *typeArray = [NSMutableArray new];
        for (DTShopTypeModel *model in self.shopTypeArray) {
            [typeArray addObject:model.firstName];
        }
        
        [CDZPicker showPickerInView:self.view showCancel:false withStrings:typeArray confirm:^(NSArray<NSString *> *stringArray) {
            label.text = stringArray[0];
            self.goodsInfoModel.firstTypeName = stringArray[0];
            for (DTShopTypeModel *model in self.shopTypeArray) {
                if ([model.firstName isEqualToString:stringArray[0]]) {
                    self.goodsInfoModel.firstTypeId = model.firstTypeId;
                    break;
                }
            }
        } cancel:^(NSArray<NSString *> *stringArray) {
            
        }];
    }
}

- (void)touchCategoryButton {
    _alert = [[RCCustomAlertView alloc] initCreateGroupOrInputSchoolNameAlertViewWithDelegate:self withStatusImage:[UIImage imageNamed:@"ic_delete"] withMultiAlertViewMode:MULTI_ALERTVIEW_MODE_CREATE_GROUP];
    [_alert show];
}

#pragma mark - AlertViewSelectorViewDelegate

// 点击的哪个按钮代理方法
- (void)touchSelectButtonAction:(NSInteger)buttonTitleArrayIndex andMultiAlertViewMode:(MultiAlertViewMode)multiAlertViewMode {
    [_alert cancelAction];
    
    NSLog(@"%zd %zd text = %@", buttonTitleArrayIndex, multiAlertViewMode, _alert.inputGroupNameOrSchoolNameTextField.text);
    
    if (buttonTitleArrayIndex == 1) {
        [self addCategoryWithName:_alert.inputGroupNameOrSchoolNameTextField.text];
    }
}

- (UIView *)tableFooterView {
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 150)];
    footer.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.commitButton.frame = CGRectMake(42, 32, SCREEN_WIDTH - 84, 49);
    self.commitButton.titleLabel.font = FONT(18);
    [self.commitButton setTitle:@"确认修改" forState:UIControlStateNormal];
    self.commitButton.backgroundColor = RGB(153, 153, 153);
    [self.commitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.commitButton.layer.cornerRadius = 24.5;
    self.commitButton.enabled = false;
    self.commitButton.layer.masksToBounds = true;
    [self.commitButton addTarget:self action:@selector(touchCommitBtn) forControlEvents:UIControlEventTouchUpInside];
    [footer addSubview:self.commitButton];
    return footer;
}

- (void)touchCommitBtn {
    if (self.commentPictures.count <= 1) {
        [ShowMessage showMessage:@"请上传商品图片"];
        return;
    }
    
    if ([NSString isTextEmpty:self.goodsInfoModel.name]) {
        [ShowMessage showMessage:@"请填写商品名"];
        return;
    }
    
    if ([NSString isTextEmpty:self.goodsInfoModel.title]) {
        [ShowMessage showMessage:@"请填写商品简介"];
        return;
    }
    
    if ([NSString isTextEmpty:self.goodsInfoModel.price]) {
        [ShowMessage showMessage:@"请填写商品店铺价格"];
        return;
    }
    
    if ([NSString isTextEmpty:self.goodsInfoModel.curPrice]) {
        [ShowMessage showMessage:@"请填写商品团购价格"];
        return;
    }
    
    if ([NSString isTextEmpty:self.goodsInfoModel.type]) {
        [ShowMessage showMessage:@"请选择商品分类"];
        return;
    }
    
    if ([NSString isTextEmpty:self.goodsInfoModel.details]) {
        [ShowMessage showMessage:@"请填写商品描述"];
        return;
    }
    
    if (![[TXUserModel defaultUser] userLoginStatus]) {
        [ShowMessage showMessage:@"请登录"];
        return;
    }
    
    if (self.commentPictures.count == 1) {
        [ShowMessage showMessage:@"请上传店铺介绍图片"];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
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
                        self.imageUrl = [imageArray componentsJoinedByString:@","];
                        [self commitData];
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

- (void)commitData {
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:self.goodsInfoModel.name forKey:@"name"];
    [params setValue:self.goodsInfoModel.title forKey:@"title"];
    [params setValue:self.imageUrl forKey:@"imgs"];
    [params setValue:self.goodsInfoModel.price forKey:@"price"];
    [params setValue:self.goodsInfoModel.curPrice forKey:@"curPrice"];
    [params setValue:self.goodsInfoModel.type forKey:@"type"];
    [params setValue:self.goodsInfoModel.firstTypeId forKey:@"fType"];
    [params setValue:self.goodsInfoModel.details forKey:@"details"];
    
    NSMutableArray *temp = [NSMutableArray new];
    for (DTGoodsDesModel *model in self.goodsDescArray) {
        if (!([NSString isTextEmpty:model.firstParam] &&
            [NSString isTextEmpty:model.twoParam] &&
            [NSString isTextEmpty:model.threeParam])) {
            [temp addObject:model];
        }
    }
    
    NSMutableArray *temp1 = [NSMutableArray new];
    NSMutableArray *temp2 = [NSMutableArray new];
    NSMutableArray *temp3 = [NSMutableArray new];
    
    for (DTGoodsDesModel *model in temp) {
        [temp1 addObject:model.firstParam];
        [temp2 addObject:model.twoParam];
        [temp3 addObject:model.threeParam];
    }
    
    [params setValue:temp1 forKey:@"firstParams"];
    [params setValue:temp2 forKey:@"twoParams"];
    [params setValue:temp3 forKey:@"threeParams"];
    
    if (self.goodsId) {
        [params setValue:self.goodsId forKey:@"id"];
    }
    
    [[RCHttpHelper sharedHelper] postUrl:[httpHost stringByAppendingPathComponent:addGoods] headParams:@{@"token" : [TXModelAchivar getUserModel].token} bodyParams:params success:^(AFHTTPSessionManager *operation, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view];
        if ([responseObject[@"status"] integerValue] == 1) {
            [MBProgressHUD hideHUDForView:self.view];
            [ShowMessage showMessage:@"添加成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationAddGoodsSuccess object:nil userInfo:nil];
            [self.navigationController popViewControllerAnimated:true];
        } else {
            [ShowMessage showMessage:responseObject[@"msg"]];
        }
    } failure:^(AFHTTPSessionManager *operation, NSError *error) {
        [ShowMessage showMessage:error.description];
        [MBProgressHUD hideHUDForView:self.view];
    }];
}

- (NSString *)arrayToJsonString:(NSArray *)array {
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONReadingMutableLeaves | NSJSONReadingAllowFragments error:nil];

    if (jsonData == nil) {
        return nil;
    }
    
    NSString *string = [[NSString alloc] initWithData:jsonData
                                             encoding:NSUTF8StringEncoding];
    return string;
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

- (void)touchAddInputButton {
    DTGoodsDesModel *model = [DTGoodsDesModel new];
    model.firstParam = @"";
    model.twoParam = @"";
    model.threeParam = @"";
    [self.goodsDescArray addObject:model];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
}

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

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
