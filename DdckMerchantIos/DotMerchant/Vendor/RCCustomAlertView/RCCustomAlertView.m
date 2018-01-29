//
//  RCCustomAlertView.m
//  RCCustomAlertView
//
//  Created by RogerChen on 15/6/25.
//  Copyright (c) 2015年 聊天SDK服务供应商. All rights reserved.
//

#import "RCCustomAlertView.h"

// AlertView 中控件之间的距离限制
static const float ViewRadius = 8.0; // 弹窗圆角
static const int LabelHeight = 42; // 标题控件高度
static const int ButtonOrTextFieldHeight = 50; // 按钮高度
static const int LeftRightMargin = 30.0; // 左右边距
static const int TopMargin = 25; // 上边距
static const int DistanceBetweenUIControl = 21; // 控件间距
static const int DisplayImageWidth = 92; // 图片宽
static const int DisplayImageHeight = 63; // 图片高

static const int DisplayImageSize = 64; // 图片宽高相同
// AlertView 尺寸大小
#define ALERTVIEW_HEIGHT_TWO_BUTTONS    [self.buttonTitleArray count] * ButtonOrTextFieldHeight // 双按钮弹窗
#define ALERTVIEW_HEIGHT_CREATE_GROUP           230.0 // 创建群组弹窗
#define ALERTVIEW_HEIGHT_INPUT_SCHOOL_NAME      146.0 // 创建群组弹窗
#define ALERTVIEW_HEIGHT_MODIFY_MOBILE          217.0 // 验证手机弹窗
#define ALERTVIEW_HEIGHT_MULTI_VIEW             222.0 // 功能弹窗

//#define ALERTVIEW_UP_DISTANCE           125.0 // 弹窗上偏移距离

// AlertView 中控件颜色
#define COLOR_MASKING_VIEW_BACKGROUND                   [UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:0.7]
#define COLOR_ALERTVIEW_SELECTOR_VIEW_BACKGROUND        [UIColor whiteColor]
#define COLOR_ALERTVIEW_BUTTON_TITLE_CANCEL             [UIColor colorWithRed:127.0/255.0 green:127.0/255.0 blue:127.0/255.0 alpha:1.0]
#define COLOR_ALERTVIEW_BUTTON_TITLE_CONFIRM            [UIColor colorWithRed:78.0/255.0 green:78.0/255.0 blue:78.0/255.0 alpha:1.0]
#define COLOR_ALERTVIEW_BUTTON_BACKGROUND               [UIColor colorWithRed:241.0/255.0 green:241.0/255.0 blue:241.0/255.0 alpha:1.0]
#define COLOR_ALERTVIEW_GETPINCODE_BUTTON_BACKGROUND    [UIColor colorWithRed:110.0/255.0 green:180.0/255.0 blue:250.0/255.0 alpha:1.0]
#define COLOR_ALERTVIEW_TEXTFIELD_BACKGROUND            [UIColor whiteColor]
#define COLOR_ALERTVIEW_SEPORATE_LABEL_BACKGROUND       [UIColor colorWithRed:213.0/255.0 green:213.0/255.0 blue:213.0/255.0 alpha:1.0]

// AlertView 中控件字体大小

#define FONT_TEXT_18    [UIFont boldSystemFontOfSize:16]

@interface RCCustomAlertView ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSArray *buttonImageNameArray; // 图标名字数组
@property (nonatomic, strong) NSArray *buttonTitleArray; // 图标名字数组
@property (nonatomic, strong) UIImage *statusImage; // 显示的图片
@property (nonatomic, strong) NSString *promptLabelText; // 文字
@property (nonatomic, strong) UIView *selectorView; // 选择的模态窗口

@property (assign, nonatomic) CGRect rect; //窗口初始位置

@end

@implementation RCCustomAlertView

#pragma mark - View Init

/**
 *  双按钮弹窗
 *
 *  @param delegate             代理指针
 *  @param arrayButtonImageName 按钮图片名数组
 *  @param arrayButtonTitle     按钮文字数组
 *  @param multiAlertViewMode   弹窗类型
 *
 *  @return 弹窗对象
 */
- (id)initTwoButtonsAlertViewWithDelegate:(id)delegate
                      withButtonImageName:(NSArray *)arrayButtonImageName
                          withButtonTitle:(NSArray *)arrayButtonTitle
                   withMultiAlertViewMode:(MultiAlertViewMode)multiAlertViewMode;
{
    self = [self init];
    if (self)
    {
        self.multiAlertViewMode = multiAlertViewMode;
        self.delegate = delegate;
        self.buttonImageNameArray = arrayButtonImageName;
        self.buttonTitleArray = arrayButtonTitle;
        
        // 设置遮罩层和选择视图
        [self setMaskingViewAndSelectorViewWithMultiAlertViewMode:multiAlertViewMode];
    }
    return self;
}

/**
 *  注册验证手机号弹窗
 *
 *  @param delegate 代理指针
 *  @param multiAlertViewMode 弹窗类型
 *
 *  @return 弹窗对象
 */
- (id)initModifyMobileAlertViewWithDelegate:(id)delegate
                     withMultiAlertViewMode:(MultiAlertViewMode)multiAlertViewMode
{
    self = [self init];
    if (self)
    {
        self.multiAlertViewMode = multiAlertViewMode;
        self.delegate = delegate;
        
        // 设置遮罩层和选择视图
        [self setMaskingViewAndSelectorViewWithMultiAlertViewMode:multiAlertViewMode];
    }
    return self;
}

/**
 *  创建群/输入学校名弹窗
 *
 *  @param delegate           代理指针
 *  @param statusImage        显示图片
 *  @param multiAlertViewMode 弹窗类型
 *
 *  @return 弹窗对象
 */
- (id)initCreateGroupOrInputSchoolNameAlertViewWithDelegate:(id)delegate
                                            withStatusImage:(UIImage *)statusImage
                                     withMultiAlertViewMode:(MultiAlertViewMode)multiAlertViewMode
{
    self = [self init];
    if (self)
    {
        self.multiAlertViewMode = multiAlertViewMode;
        self.delegate = delegate;
        self.statusImage = statusImage;
        // 设置遮罩层和选择视图
        [self setMaskingViewAndSelectorViewWithMultiAlertViewMode:multiAlertViewMode];
    }
    return self;
}

/**
 *  功能提示弹窗
 *
 *  @param delegate           代理指针
 *  @param statusImage        显示图片
 *  @param promptText         显示文字
 *  @param multiAlertViewMode 弹窗类型
 *
 *  @return 弹窗对象
 */
- (id)initMutilAlertViewWithDelegate:(id)delegate
                     withStatusImage:(UIImage *)statusImage
                      withPromptText:(NSString *)promptText
              withMultiAlertViewMode:(MultiAlertViewMode)multiAlertViewMode
{
    self = [self init];
    if (self)
    {
        self.multiAlertViewMode = multiAlertViewMode;
        self.delegate = delegate;
        self.promptLabelText = promptText;
        self.statusImage = statusImage;
        
        // 设置遮罩层和选择视图
        [self setMaskingViewAndSelectorViewWithMultiAlertViewMode:multiAlertViewMode];
    }
    return self;
}


#pragma mark - Touch Button Action

// 选择不同的按钮
- (void)touchSelectButtonAction:(id)sender
{
    UIButton *buttonSelect = (UIButton *)sender;
    if (self.delegate && [self.delegate respondsToSelector:@selector(touchSelectButtonAction:andMultiAlertViewMode:)]) {
        [self.delegate touchSelectButtonAction:buttonSelect.tag andMultiAlertViewMode:self.multiAlertViewMode];
    }
}

// 选择取消按钮
- (void)cancelAction
{
    [self removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


#pragma mark - Show Modal View
// 显示模态视图
- (void)show
{
    // 注册键盘显示事件
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShowNotification:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    // 注册键盘隐藏事件
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHideNotification:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    // 获取当前window
    UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    [window addSubview:self];
}


#pragma mark - Custom

// 隐藏模态视图
- (void)hideCustomAlertView:(UITapGestureRecognizer *)tapGestureRecognizer
{
    [self cancelAction];
    
}

- (void)initSeletorViewWithMultiAlertViewMode:(MultiAlertViewMode)multiAlertViewMode
{
    float heightView = 0.0;
    
    switch (multiAlertViewMode) {
        case MULTI_ALERTVIEW_MODE_MODIFY_MOBILE:
        {
            heightView = ALERTVIEW_HEIGHT_MODIFY_MOBILE;
            
            // 增加选择的窗口
            self.selectorView = [[UIView alloc] initWithFrame:CGRectMake(LeftRightMargin, self.center.y - heightView/2, [UIScreen mainScreen].bounds.size.width - LeftRightMargin*2, heightView)];
        }
            break;
            
        case MULTI_ALERTVIEW_MODE_CREATE_GROUP:
        case MULTI_ALERTVIEW_MODE_CHANGE_GROUP_NAME:
        case MULTI_ALERTVIEW_MODE_INPUT_CLASS_CNAME:
        {
            heightView = ALERTVIEW_HEIGHT_CREATE_GROUP;
            
            // 增加选择的窗口
            self.selectorView = [[UIView alloc] initWithFrame:CGRectMake(LeftRightMargin, self.center.y - heightView/2, [UIScreen mainScreen].bounds.size.width - LeftRightMargin*2, heightView)];
        }
            break;
        case MULTI_ALERTVIEW_MODE_INPUT_REMARK:
        case MULTI_ALERTVIEW_MODE_INPUT_SCHOOL_NAME:
        {
            heightView = ALERTVIEW_HEIGHT_INPUT_SCHOOL_NAME;
            
            // 增加选择的窗口
            self.selectorView = [[UIView alloc] initWithFrame:CGRectMake(LeftRightMargin, self.center.y - heightView/2, [UIScreen mainScreen].bounds.size.width - LeftRightMargin*2, heightView)];
        }
            break;
            
        case MULTI_ALERTVIEW_MODE_BUTTONS:
        {
            heightView = ALERTVIEW_HEIGHT_TWO_BUTTONS;
            
            // 增加选择的窗口
            self.selectorView = [[UIView alloc] initWithFrame:CGRectMake(LeftRightMargin, 0.0, [UIScreen mainScreen].bounds.size.width - LeftRightMargin*2, heightView)];
            self.selectorView.center = self.center;
            break;
        }
            break;
            
        default:
        {
            heightView = ALERTVIEW_HEIGHT_MULTI_VIEW;
            
            // 增加选择的窗口
            self.selectorView = [[UIView alloc] initWithFrame:CGRectMake(LeftRightMargin, 0.0, [UIScreen mainScreen].bounds.size.width - LeftRightMargin*2, heightView)];
            self.selectorView.center = self.center;
        }
            break;
    }
    
    self.rect = self.selectorView.frame;
    // 设置矩形四个圆角半径
    [self.selectorView.layer setCornerRadius:ViewRadius];
    self.selectorView.layer.masksToBounds = YES;
    [self.selectorView setBackgroundColor:COLOR_ALERTVIEW_SELECTOR_VIEW_BACKGROUND];
//    点击背景取消模态窗
    if (multiAlertViewMode == MULTI_ALERTVIEW_MODE_BUTTONS || multiAlertViewMode == MULTI_ALERTVIEW_MODE_MUTIL_TWO_BUTTONS_TRANSFRE_CLASS) {
        UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideCustomAlertView:)];
        [gestureRecognizer setDelegate:self];
        [self addGestureRecognizer:gestureRecognizer];
    }
    [self addSubview:self.selectorView];
}

#pragma mark - TwoButtons Init

/**
 *  初始化内部按钮
 */
- (void)initTwoButtons
{
    // 增加选择的按钮
    for (int i = 0; i < [self.buttonTitleArray count]; i++)
    {
        NSString *buttonTitle = [self.buttonTitleArray objectAtIndex:i];
        
        UIButton *buttonSelect = [[UIButton alloc] initWithFrame:CGRectMake(0, i * ButtonOrTextFieldHeight, CGRectGetWidth(self.selectorView.frame), ButtonOrTextFieldHeight)];
        [buttonSelect setTitle:buttonTitle forState:UIControlStateNormal];
        [buttonSelect setTitleColor:COLOR_ALERTVIEW_BUTTON_TITLE_CONFIRM forState:UIControlStateNormal];
        [buttonSelect setTag:i];
        
        [buttonSelect.titleLabel setFont:FONT_TEXT_18];
        
        // 垂直向左对齐
        buttonSelect.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        
        // 将文本向左移动
        [buttonSelect setTitleEdgeInsets:UIEdgeInsetsMake(0, 40, 0, 0)];
        
        if (i < [self.buttonImageNameArray count]) {
            NSString *buttonImageName = [self.buttonImageNameArray objectAtIndex:i];
            [buttonSelect setImage:[UIImage imageNamed:buttonImageName] forState:UIControlStateNormal];
            // 将图标向左移动
            [buttonSelect setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 40)];
        }
        
        [buttonSelect addTarget:self action:@selector(touchSelectButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.selectorView addSubview:buttonSelect];
        
        // 增加一条分割线
        UILabel *labelLine = [[UILabel alloc] initWithFrame:CGRectMake(10, (i+1) * ButtonOrTextFieldHeight - 0.5, CGRectGetWidth(self.selectorView.frame) - 20, 0.5)];
        [labelLine setBackgroundColor:COLOR_ALERTVIEW_SEPORATE_LABEL_BACKGROUND];
        [self.selectorView addSubview:labelLine];
    }
}

#pragma mark - ModifyMobile Init

// 设置验证手机号弹窗内容
- (void)initModifyMobileViewContent
{
    self.inputMobileNumTextField = [[UITextField alloc] initWithFrame:CGRectMake(DistanceBetweenUIControl/2, TopMargin, CGRectGetWidth(self.selectorView.frame) - DistanceBetweenUIControl, ButtonOrTextFieldHeight)];
    self.inputMobileNumTextField.placeholder = @"输入手机号";
    [self.inputMobileNumTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    self.inputMobileNumTextField.font = FONT_TEXT_18;
    self.inputMobileNumTextField.backgroundColor = COLOR_ALERTVIEW_TEXTFIELD_BACKGROUND;
    self.inputMobileNumTextField.borderStyle = UITextBorderStyleRoundedRect;
    [self.inputMobileNumTextField setKeyboardType:UIKeyboardTypeNumberPad];
    
    self.inputPincodeTextField = [[UITextField alloc] initWithFrame:CGRectMake(DistanceBetweenUIControl/2, CGRectGetMaxY(self.inputMobileNumTextField.frame) + DistanceBetweenUIControl, CGRectGetWidth(self.selectorView.frame)/2 - DistanceBetweenUIControl, ButtonOrTextFieldHeight)];
    self.inputPincodeTextField.placeholder = @"输入验证码";
    self.inputPincodeTextField.font = FONT_TEXT_18;
    self.inputPincodeTextField.backgroundColor = COLOR_ALERTVIEW_TEXTFIELD_BACKGROUND;
    self.inputPincodeTextField.borderStyle = UITextBorderStyleRoundedRect;
    [self.inputPincodeTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    [self.inputPincodeTextField setKeyboardType:UIKeyboardTypeNumberPad];
    
    self.getPincodeButton = [[UIBorderButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.inputPincodeTextField.frame) + DistanceBetweenUIControl/2, CGRectGetMaxY(self.inputMobileNumTextField.frame) + DistanceBetweenUIControl, CGRectGetWidth(self.selectorView.frame)/2 - DistanceBetweenUIControl/2, ButtonOrTextFieldHeight)];
    self.getPincodeButton.enabled = NO;//刚开始进入时，按钮设置为不可点击
    [self.getPincodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.getPincodeButton setTitleColor:/*COLOR_ALERTVIEW_BUTTON_TITLE_CONFIRM*/COLOR_ALERTVIEW_TEXTFIELD_BACKGROUND forState:UIControlStateNormal];
    //  设置
//    [ToolsFunction setBorderColorAndBlueBackGroundColorFor:self.getPincodeButton];
    //self.getPincodeButton.backgroundColor = COLOR_ALERTVIEW_GETPINCODE_BUTTON_BACKGROUND;
    self.getPincodeButton.titleLabel.font = FONT_TEXT_18;
    self.getPincodeButton.tag = 3;
    self.getPincodeButton.layer.cornerRadius = ViewRadius;
    self.getPincodeButton.layer.masksToBounds = YES;
    [self.getPincodeButton addTarget:self action:@selector(touchSelectButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
   UIButton *buttonCancel = [[UIButton alloc]initWithFrame:CGRectMake(0.0, CGRectGetMaxY(self.getPincodeButton.frame) + DistanceBetweenUIControl, CGRectGetWidth(self.selectorView.frame)/2 - 0.5, ButtonOrTextFieldHeight)];
    [buttonCancel setBackgroundImage:[UIImage imageNamed:@"left_BgLine"] forState:UIControlStateNormal];
    [buttonCancel setBackgroundImage:[UIImage imageNamed:@"left_BgLinePress"] forState:UIControlStateHighlighted];
    [buttonCancel setTitle:@"取消" forState:UIControlStateNormal];
    [buttonCancel setTitleColor:COLOR_ALERTVIEW_BUTTON_TITLE_CONFIRM forState:UIControlStateNormal];
//    buttonCancel.backgroundColor = COLOR_ALERTVIEW_BUTTON_BACKGROUND;
    buttonCancel.titleLabel.font = FONT_TEXT_18;
    buttonCancel.tag = 1;
//    buttonCancel.layer.cornerRadius = ViewRadius;
//    buttonCancel.layer.masksToBounds = YES;
    [buttonCancel addTarget:self action:@selector(touchSelectButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *buttonSure = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(buttonCancel.frame) + 1, CGRectGetMaxY(self.getPincodeButton.frame) + DistanceBetweenUIControl, CGRectGetWidth(self.selectorView.frame)/2 - 0.5, ButtonOrTextFieldHeight)];
    [buttonSure setBackgroundImage:[UIImage imageNamed:@"reight_BgLine"] forState:UIControlStateNormal];
    [buttonSure setBackgroundImage:[UIImage imageNamed:@"reight_BgLinePress"] forState:UIControlStateHighlighted];
    [buttonSure setTitle:@"确定" forState:UIControlStateNormal];
    [buttonSure setTitleColor:COLOR_ALERTVIEW_BUTTON_TITLE_CONFIRM forState:UIControlStateNormal];
//    buttonSure.backgroundColor = COLOR_ALERTVIEW_BUTTON_BACKGROUND;
    buttonSure.titleLabel.font = FONT_TEXT_18;
    buttonSure.tag = 2;
//    buttonSure.layer.cornerRadius = ViewRadius;
//    buttonSure.layer.masksToBounds = YES;
    [buttonSure addTarget:self action:@selector(touchSelectButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *labelSeperator = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(buttonCancel.frame), CGRectGetMinY(buttonCancel.frame) /*+ ViewRadius*/, 1.0, CGRectGetHeight(buttonCancel.frame) /*- 2*ViewRadius*/)];
    labelSeperator.backgroundColor = COLOR_ALERTVIEW_SEPORATE_LABEL_BACKGROUND;
    
    [self.selectorView addSubview:self.inputMobileNumTextField];
    [self.selectorView addSubview:self.inputPincodeTextField];
    [self.selectorView addSubview:self.getPincodeButton];
    [self.selectorView addSubview:buttonCancel];
    [self.selectorView addSubview:buttonSure];
    [self.selectorView addSubview:labelSeperator];
    
    // 设置第一响应
    [self.inputMobileNumTextField becomeFirstResponder];
}


#pragma mark - CreateGroup Init

- (void)initCreateGroupOrInputSchoolNameAlertViewContentView
{
    UIImageView *imageViewStatus = nil;
    if (self.multiAlertViewMode == MULTI_ALERTVIEW_MODE_CREATE_GROUP || self.multiAlertViewMode == MULTI_ALERTVIEW_MODE_INPUT_CLASS_CNAME || self.multiAlertViewMode == MULTI_ALERTVIEW_MODE_CHANGE_GROUP_NAME)
    {
        imageViewStatus = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.selectorView.frame)/2 - DisplayImageWidth/2, TopMargin, DisplayImageWidth, DisplayImageHeight)];
        imageViewStatus.image = self.statusImage;
        
        self.inputGroupNameOrSchoolNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(DistanceBetweenUIControl/2, CGRectGetMaxY(imageViewStatus.frame) + DistanceBetweenUIControl, CGRectGetWidth(self.selectorView.frame) - DistanceBetweenUIControl, ButtonOrTextFieldHeight)];
    } else if (self.multiAlertViewMode == MULTI_ALERTVIEW_MODE_INPUT_SCHOOL_NAME || self.multiAlertViewMode == MULTI_ALERTVIEW_MODE_INPUT_REMARK)
    {
        self.inputGroupNameOrSchoolNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(DistanceBetweenUIControl/2, TopMargin, CGRectGetWidth(self.selectorView.frame) - DistanceBetweenUIControl, ButtonOrTextFieldHeight)];
    }
    
    self.inputGroupNameOrSchoolNameTextField.backgroundColor = COLOR_ALERTVIEW_TEXTFIELD_BACKGROUND;
    
    switch (self.multiAlertViewMode) {
        case MULTI_ALERTVIEW_MODE_CHANGE_GROUP_NAME:
        {
            self.inputGroupNameOrSchoolNameTextField.placeholder = @"输入新名称";
        }
            break;
        case MULTI_ALERTVIEW_MODE_CREATE_GROUP:
        {
//            self.inputGroupNameOrSchoolNameTextField.placeholder = @"输入群名称";
            self.inputGroupNameOrSchoolNameTextField.placeholder = @"请填写分类名称";
        }
            break;
        case MULTI_ALERTVIEW_MODE_INPUT_SCHOOL_NAME:
        {
            self.inputGroupNameOrSchoolNameTextField.placeholder = @"输入学校名称";
        }
            break;
        case MULTI_ALERTVIEW_MODE_INPUT_CLASS_CNAME:
        {
            self.inputGroupNameOrSchoolNameTextField.placeholder = @"输入班级昵称";
        }
            break;
            case MULTI_ALERTVIEW_MODE_INPUT_REMARK:
        {
            self.inputGroupNameOrSchoolNameTextField.placeholder = @"输入备注";
        }
            break;
        default:
            break;
    }
    [self.inputGroupNameOrSchoolNameTextField setClearButtonMode:UITextFieldViewModeWhileEditing];
    self.inputGroupNameOrSchoolNameTextField.textAlignment = NSTextAlignmentCenter;
    self.inputGroupNameOrSchoolNameTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.inputGroupNameOrSchoolNameTextField.returnKeyType = UIReturnKeyDone;
    
    UIButton *buttonCancel = [[UIButton alloc] initWithFrame:CGRectMake(0.0, CGRectGetMaxY(self.inputGroupNameOrSchoolNameTextField.frame) + DistanceBetweenUIControl, CGRectGetWidth(self.selectorView.frame)/2 - 0.5, ButtonOrTextFieldHeight)];
    [buttonCancel setBackgroundImage:[UIImage imageNamed:@"left_BgLine"] forState:UIControlStateNormal];
    [buttonCancel setBackgroundImage:[UIImage imageNamed:@"left_BgLinePress"] forState:UIControlStateHighlighted];
    [buttonCancel setTitle:@"取消" forState:UIControlStateNormal];
    [buttonCancel setTitleColor:COLOR_ALERTVIEW_BUTTON_TITLE_CONFIRM forState:UIControlStateNormal];
//    buttonCancel.backgroundColor =  COLOR_ALERTVIEW_BUTTON_BACKGROUND;
    buttonCancel.titleLabel.font = FONT_TEXT_18;
    buttonCancel.tag = 0;
//    buttonCancel.layer.cornerRadius = ViewRadius;
//    buttonCancel.layer.masksToBounds = YES;
    [buttonCancel addTarget:self action:@selector(touchSelectButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *buttonSure= [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(buttonCancel.frame) + 1, CGRectGetMaxY(self.inputGroupNameOrSchoolNameTextField.frame) + DistanceBetweenUIControl, CGRectGetWidth(self.selectorView.frame)/2 - 0.5, ButtonOrTextFieldHeight)];
    [buttonSure setBackgroundImage:[UIImage imageNamed:@"reight_BgLine"] forState:UIControlStateNormal];
    [buttonSure setBackgroundImage:[UIImage imageNamed:@"reight_BgLinePress"] forState:UIControlStateHighlighted];
    
    if (self.multiAlertViewMode == MULTI_ALERTVIEW_MODE_INPUT_CLASS_CNAME || self.multiAlertViewMode == MULTI_ALERTVIEW_MODE_INPUT_REMARK || self.multiAlertViewMode == MULTI_ALERTVIEW_MODE_CREATE_GROUP) {
        [buttonSure setTitle:@"确定" forState:UIControlStateNormal];
    }else{
        [buttonSure setTitle:@"提交" forState:UIControlStateNormal];
    }
    [buttonSure setTitleColor:COLOR_ALERTVIEW_BUTTON_TITLE_CONFIRM forState:UIControlStateNormal];
//    buttonSure.backgroundColor = COLOR_ALERTVIEW_BUTTON_BACKGROUND;
    buttonSure.titleLabel.font = FONT_TEXT_18;
    buttonSure.tag = 1;
//    buttonSure.layer.cornerRadius = ViewRadius;
//    buttonSure.layer.masksToBounds = YES;
    [buttonSure addTarget:self action:@selector(touchSelectButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *labelSeperator = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(buttonCancel.frame), CGRectGetMinY(buttonCancel.frame) /*+ ViewRadius*/, 1.0, CGRectGetHeight(buttonCancel.frame)/* - 2*ViewRadius*/)];
    labelSeperator.backgroundColor = COLOR_ALERTVIEW_SEPORATE_LABEL_BACKGROUND;
    
    if (self.multiAlertViewMode == MULTI_ALERTVIEW_MODE_CREATE_GROUP || self.multiAlertViewMode == MULTI_ALERTVIEW_MODE_INPUT_CLASS_CNAME || self.multiAlertViewMode == MULTI_ALERTVIEW_MODE_CHANGE_GROUP_NAME)
    {
        [self.selectorView addSubview:imageViewStatus];
    }
    
    if (self.multiAlertViewMode == MULTI_ALERTVIEW_MODE_CREATE_GROUP) {
        imageViewStatus.hidden = true;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, self.selectorView.frame.size.width, 20)];
        label.text = @"添加分类";
        label.font = FONT(18);
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor blackColor];
        label.backgroundColor = [UIColor clearColor];
        [self.selectorView addSubview:label];
    }
    
    [self.selectorView addSubview:self.inputGroupNameOrSchoolNameTextField];
    [self.selectorView addSubview:buttonCancel];
    [self.selectorView addSubview:buttonSure];
    [self.selectorView addSubview:labelSeperator];
    
    // 设置第一响应
    [self.inputGroupNameOrSchoolNameTextField becomeFirstResponder];
}


#pragma mark - MultiAlertView Init

- (void)initMultiAlertViewContentView
{
    UIImageView *imageViewStatus = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.selectorView.frame)/2 - DisplayImageWidth/2, TopMargin, DisplayImageWidth, DisplayImageHeight)];
    imageViewStatus.image = self.statusImage;
    
    //增加标题Label
    UILabel *labelPrompt = [[UILabel alloc] initWithFrame:CGRectMake(DistanceBetweenUIControl/2, CGRectGetMaxY(imageViewStatus.frame) + DistanceBetweenUIControl, CGRectGetWidth(self.selectorView.frame) - DistanceBetweenUIControl, LabelHeight)];
    
    labelPrompt.text = self.promptLabelText;
    labelPrompt.textAlignment = NSTextAlignmentCenter;
    labelPrompt.numberOfLines = 0;
    [labelPrompt setFont:FONT_TEXT_18];
    
    [self.selectorView addSubview:imageViewStatus];
    [self.selectorView addSubview:labelPrompt];
    
    if (self.multiAlertViewMode == MULTI_ALERTVIEW_MODE_MUTIL_ONE_BUTTON)
    {
        imageViewStatus.frame = CGRectMake(CGRectGetWidth(self.selectorView.frame)/2 - DisplayImageSize/2, TopMargin, DisplayImageSize, DisplayImageSize);
        
        UIButton *buttonCancel = [[UIButton alloc] initWithFrame:CGRectMake(0.0, CGRectGetMaxY(labelPrompt.frame) + DistanceBetweenUIControl, CGRectGetWidth(self.selectorView.frame), ButtonOrTextFieldHeight)];
        [buttonCancel setTitle:@"知道了" forState:UIControlStateNormal];
        [buttonCancel setTitleColor:COLOR_ALERTVIEW_BUTTON_TITLE_CONFIRM forState:UIControlStateNormal];
        buttonCancel.backgroundColor = COLOR_ALERTVIEW_BUTTON_BACKGROUND;
//        buttonCancel.titleLabel.font = FONT_TEXT_18;
        [buttonCancel.titleLabel setFont:[UIFont boldSystemFontOfSize:15.0]];
        buttonCancel.tag = 0;
        buttonCancel.layer.cornerRadius = ViewRadius;
        buttonCancel.layer.masksToBounds = YES;
        [buttonCancel addTarget:self action:@selector(touchSelectButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.selectorView addSubview:buttonCancel];
        
    } else if (self.multiAlertViewMode == MULTI_ALERTVIEW_MODE_MUTIL_TWO_BUTTONS || self.multiAlertViewMode == MULTI_ALERTVIEW_MODE_CREATE_GROUP_SUCCESS  || self.multiAlertViewMode == MULTI_ALERTVIEW_MODE_MUTIL_TWO_BUTTONS_TRANSFRE_CLASS)
    {
        if (self.multiAlertViewMode == MULTI_ALERTVIEW_MODE_CREATE_GROUP_SUCCESS) {
           imageViewStatus.frame = CGRectMake(CGRectGetWidth(self.selectorView.frame)/2 - DisplayImageSize/2, TopMargin, DisplayImageSize, DisplayImageSize);
        }

        UIButton *buttonCancel = [[UIButton alloc] initWithFrame:CGRectMake(0.0, CGRectGetMaxY(labelPrompt.frame) + DistanceBetweenUIControl, CGRectGetWidth(self.selectorView.frame)/2 - 0.5, ButtonOrTextFieldHeight)];
        [buttonCancel setBackgroundImage:[UIImage imageNamed:@"left_BgLine"] forState:UIControlStateNormal];
        [buttonCancel setBackgroundImage:[UIImage imageNamed:@"left_BgLinePress"] forState:UIControlStateHighlighted];
        [buttonCancel setTitle:@"取消" forState:UIControlStateNormal];
        if (self.multiAlertViewMode == MULTI_ALERTVIEW_MODE_MUTIL_TWO_BUTTONS_TRANSFRE_CLASS) {
            [buttonCancel setTitle:@"暂不退出" forState:UIControlStateNormal];
        }
        [buttonCancel setTitleColor:COLOR_ALERTVIEW_BUTTON_TITLE_CONFIRM forState:UIControlStateNormal];
        buttonCancel.backgroundColor = COLOR_ALERTVIEW_BUTTON_BACKGROUND;
        buttonCancel.titleLabel.font = FONT_TEXT_18;
        buttonCancel.tag = 0;
        
//        buttonCancel.layer.cornerRadius = ViewRadius;
//        buttonCancel.layer.masksToBounds = YES;
        [buttonCancel addTarget:self action:@selector(touchSelectButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *buttonSure = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(buttonCancel.frame) + 1, CGRectGetMaxY(labelPrompt.frame) + DistanceBetweenUIControl, CGRectGetWidth(self.selectorView.frame)/2 - 0.5, ButtonOrTextFieldHeight)];
        [buttonSure setBackgroundImage:[UIImage imageNamed:@"reight_BgLine"] forState:UIControlStateNormal];
        [buttonSure setBackgroundImage:[UIImage imageNamed:@"reight_BgLinePress"] forState:UIControlStateHighlighted];
        [buttonSure setTitle:@"确定" forState:UIControlStateNormal];
        if (self.multiAlertViewMode == MULTI_ALERTVIEW_MODE_MUTIL_TWO_BUTTONS_TRANSFRE_CLASS) {
            [buttonSure setTitle:@"退出班级" forState:UIControlStateNormal];
        }
        [buttonSure setTitleColor:COLOR_ALERTVIEW_BUTTON_TITLE_CONFIRM forState:UIControlStateNormal];
        buttonSure.backgroundColor = COLOR_ALERTVIEW_BUTTON_BACKGROUND;
        buttonSure.titleLabel.font = FONT_TEXT_18;
        buttonSure.tag = 1;
       
//        buttonSure.layer.cornerRadius = ViewRadius;
//        buttonSure.layer.masksToBounds = YES;
        [buttonSure addTarget:self action:@selector(touchSelectButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *labelSeperator = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(buttonCancel.frame), CGRectGetMinY(buttonCancel.frame), 1.0, ButtonOrTextFieldHeight)];
        labelSeperator.backgroundColor = COLOR_ALERTVIEW_SEPORATE_LABEL_BACKGROUND;
        
        [self.selectorView addSubview:buttonCancel];
        [self.selectorView addSubview:buttonSure];
        [self.selectorView addSubview:labelSeperator];
    }
}

/**
 *  设置遮罩层和选择视图
 */
- (void)setMaskingViewAndSelectorViewWithMultiAlertViewMode:(MultiAlertViewMode)multiAlertViewMode
{
    // 设置模态遮罩层的背景色
    [self setBackgroundColor:COLOR_MASKING_VIEW_BACKGROUND];
    
    // 设置模态遮罩层的大小
    self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    
    // 初始化选择框
    [self initSeletorViewWithMultiAlertViewMode:multiAlertViewMode];
    
    switch (multiAlertViewMode) {
        case MULTI_ALERTVIEW_MODE_MODIFY_MOBILE:
        {
            // 初始化验证手机内容
            [self initModifyMobileViewContent];
        }
            break;
            
        case MULTI_ALERTVIEW_MODE_BUTTONS:
        {
            // 初始化两个按钮
            [self initTwoButtons];
            break;
        }
            break;
            
        case MULTI_ALERTVIEW_MODE_CREATE_GROUP:
        case MULTI_ALERTVIEW_MODE_CHANGE_GROUP_NAME:
        
        case MULTI_ALERTVIEW_MODE_INPUT_CLASS_CNAME:
        {
            // 初始化内容
            [self initCreateGroupOrInputSchoolNameAlertViewContentView];
        }
            break;
        case MULTI_ALERTVIEW_MODE_INPUT_REMARK:
        case MULTI_ALERTVIEW_MODE_INPUT_SCHOOL_NAME:
        {
            // 初始化内容
            [self initCreateGroupOrInputSchoolNameAlertViewContentView];
        }
            break;
            
        default:
        {
            // 初始化内容
            [self initMultiAlertViewContentView];
        }
            break;
    }
}


#pragma mark -
#pragma mark NotificationCenter

- (void)keyboardWillShowNotification:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    // Get the origin of the keyboard when it's displayed.
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    // Get the top of the keyboard as the y coordinate of its origin in self's view's coordinate system. The bottom of the text view's frame should align with the top of the keyboard's final position.
    CGRect keyboardRect = [aValue CGRectValue];
    //keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    //     Restore the size of the text view (fill self's view).
    //     Animate the resize so that it's in sync with the disappearance of the keyboard.
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration = 0.0;
    [animationDurationValue getValue:&animationDuration];
    
    // 得到键盘的高度
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self cache:YES];

    self.selectorView.frame = CGRectMake(self.rect.origin.x, self.rect.origin.y - keyboardRect.size.height/2, self.rect.size.width, self.rect.size.height);
    
    [UIView commitAnimations];
}

- (void)keyboardWillHideNotification:(NSNotification *)notification
{
    //NSLog(@"DEBUG: keyboardWillHideNotification");
    NSDictionary* userInfo = [notification userInfo];
    
    //     Restore the size of the text view (fill self's view).
    //     Animate the resize so that it's in sync with the disappearance of the keyboard.
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration = 0.0;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:animationDuration];
    
    self.selectorView.frame = self.rect;
    
    [UIView commitAnimations];
}



@end
