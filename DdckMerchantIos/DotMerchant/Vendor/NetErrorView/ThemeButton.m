//
//  ThemeButton.m
//  ThemeManager
//
//  Created by   徐安超 on 16/8/18.
//  Copyright © 2016年   徐安超. All rights reserved.
//

#import "ThemeButton.h"
//#import "UIImage+Extension.h"

@implementation ThemeButton

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(instancetype)init{
    return [self initWithFrame:CGRectZero];
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
//        [self setupConfig];
    }
    return self;
}

+(id)buttonWithType:(UIButtonType)buttonType{
    ThemeButton *themeButton = [super buttonWithType:buttonType];
    if (!themeButton) {
        themeButton = [[ThemeButton alloc]init];
    }
//    [themeButton setupConfig];
    return themeButton;
}

-(void)awakeFromNib{
    [super awakeFromNib];
//    [self setupConfig];
}

-(void)setCloNameN:(NSString *)cloNameN{
    if (_cloNameN != cloNameN) {
        _cloNameN = [cloNameN copy];
//        [self themeChangeAction];
    }
}

-(void)setCloNameH:(NSString *)cloNameH{
    if (_cloNameH != cloNameH) {
        _cloNameH = [cloNameH copy];
//        [self themeChangeAction];
    }
}

-(void)setTitleCloNameH:(NSString *)titleCloNameH{
    if (_titleCloNameH != titleCloNameH) {
        _titleCloNameH = [titleCloNameH copy];
//        [self themeChangeAction];
    }
}

-(void)setImgNameN:(NSString *)imgNameN{
    if (_imgNameN != imgNameN) {
        _imgNameN = [imgNameN copy];
//        [self themeChangeAction];
    }
}

-(void)setImgNameH:(NSString *)imgNameH{
    if (_imgNameH != imgNameH) {
        _imgNameH = [imgNameH copy];
//        [self themeChangeAction];
    }
}

-(void)setTitleCloNameN:(NSString *)titleCloNameN{
    if (_titleCloNameN != titleCloNameN) {
        _titleCloNameN = [titleCloNameN copy];
//        [self themeChangeAction];
    }
}

-(void)setTitleCloNameS:(NSString *)titleCloNameS{
    if (_titleCloNameS != titleCloNameS) {
        _titleCloNameS = [titleCloNameS copy];
//        [self themeChangeAction];
    }
}

- (void)setBorderColor:(NSString *)borderColor {
    if (_borderColor != borderColor) {
        _borderColor = [borderColor copy];
//        [self themeChangeAction];
    }
}
/*
-(void)setupConfig{
    self.backgroundColor = [UIColor clearColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeChangeAction) name:kThemeDidChangeNotifation object:nil];
}

-(void)themeChangeAction{
    if (_imgNameN != nil) {
        UIImage *imgN = [[ThemeManager shareManager]loadThemeImageWithName:_imgNameN];
        [self setImage:imgN forState:UIControlStateNormal];
    }
    
    if (_imgNameH != nil) {
        UIImage *imgH = [[ThemeManager shareManager]loadThemeImageWithName:_imgNameH];
        [self setImage:imgH forState:UIControlStateHighlighted];
    }
    
    
    UIColor *colorN = [[ThemeManager shareManager]loadThemeColorWithName:_cloNameN];
    UIColor *colorH = [[ThemeManager shareManager]loadThemeColorWithName:_cloNameH];
    UIColor *titleColorH = [[ThemeManager shareManager]loadThemeColorWithName:_titleCloNameH];
    UIColor *titleColorN = [[ThemeManager shareManager]loadThemeColorWithName:_titleCloNameN];
    UIColor *titleColoeS = [[ThemeManager shareManager]loadThemeColorWithName:_titleCloNameS];

    
    
    [self setBackgroundImage:[UIImage imageWithColor:colorN] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage imageWithColor:colorH] forState:UIControlStateHighlighted];
    [self setTitleColor:titleColorH forState:UIControlStateHighlighted];
    [self setTitleColor:titleColorN forState:UIControlStateNormal];
    [self setTitleColor:titleColoeS forState:UIControlStateSelected];
    
    self.layer.borderColor = colorN.CGColor;
}
*/
@end
