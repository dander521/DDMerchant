//
//  RCCustomAlertView.h
//  RCCustomAlertView
//
//  Created by RogerChen on 15/11/25.
//  Copyright (c) 2015年 聊天SDK服务供应商. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIBorderButton.h"
/**
 * @brief 多人语音会议室状态码值定义 (暂未实现)
 */
typedef NS_ENUM(NSUInteger, MultiAlertViewMode)
{
    MULTI_ALERTVIEW_MODE_MODIFY_MOBILE = 0, /**< 0：验证手机号弹窗 */
    MULTI_ALERTVIEW_MODE_BUTTONS = 1, /**< 1：双按钮弹窗 */
    MULTI_ALERTVIEW_MODE_CREATE_GROUP = 2, /**< 2：创建群弹窗 */
    MULTI_ALERTVIEW_MODE_MUTIL_ONE_BUTTON = 3, /**< 3：单按钮提示弹窗 */
    MULTI_ALERTVIEW_MODE_MUTIL_TWO_BUTTONS = 4, /**< 4：双按钮提示弹窗 */
    MULTI_ALERTVIEW_MODE_INPUT_SCHOOL_NAME = 5, /**< 5：输入学校名称 */
    MULTI_ALERTVIEW_MODE_INPUT_CLASS_CNAME = 6, /**< 6：输入班级昵称 */
    MULTI_ALERTVIEW_MODE_CREATE_GROUP_SUCCESS = 7, /**< 7 创建群成功*/
    MULTI_ALERTVIEW_MODE_MUTIL_TWO_BUTTONS_TRANSFRE_CLASS = 8, /**< 8 转移班主任提示弹窗 */
    MULTI_ALERTVIEW_MODE_INPUT_REMARK = 9,  /**<9  修改好友的备注弹框**/
    MULTI_ALERTVIEW_MODE_CHANGE_GROUP_NAME = 10, /**<10  群主修改群名称  **/
};

@protocol AlertViewSelectorViewDelegate <NSObject>

// 点击的哪个按钮代理方法
- (void)touchSelectButtonAction:(NSInteger)buttonTitleArrayIndex andMultiAlertViewMode:(MultiAlertViewMode)multiAlertViewMode;

@end

@interface RCCustomAlertView : UIView

@property (nonatomic, assign) id <AlertViewSelectorViewDelegate> delegate;
@property (nonatomic, assign) NSInteger multiAlertViewMode; // 弹窗类型
@property (nonatomic, strong) UITextField *inputGroupNameOrSchoolNameTextField; // 输入群名称
@property (nonatomic, strong) UITextField *inputMobileNumTextField; // 输入手机号
@property (nonatomic, strong) UITextField *inputPincodeTextField; // 输入验证码
@property (nonatomic, strong) UIBorderButton *getPincodeButton; // 获取pincode按钮

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


/**
 *  注册验证手机号弹窗
 *
 *  @param delegate 代理指针
 *  @param multiAlertViewMode 弹窗类型
 *
 *  @return 弹窗对象
 */
- (id)initModifyMobileAlertViewWithDelegate:(id)delegate
                     withMultiAlertViewMode:(MultiAlertViewMode)multiAlertViewMode;

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
                                     withMultiAlertViewMode:(MultiAlertViewMode)multiAlertViewMode;

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
              withMultiAlertViewMode:(MultiAlertViewMode)multiAlertViewMode;


#pragma mark - Show/cancel Modal View

// 选择取消按钮
- (void)cancelAction;
// 显示模态视图
- (void)show;

@end
