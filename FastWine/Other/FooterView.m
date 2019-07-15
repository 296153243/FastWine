//
//  FooterView.m
//  YYMei
//
//  Created by 那道 on 2017/6/29.
//  Copyright © 2017年 Nado. All rights reserved.
//

#import "FooterView.h"

@interface FooterView()

@property (nonatomic, strong) UILabel  *titleLbl;

@property (nonatomic, strong) UIView  *leftLine;

@property (nonatomic, strong) UIView  *rightLine;

@end

@implementation FooterView

- (instancetype)init
{
    if (self = [super init]) {
        
        self.qu_h = 30;
        
        [self titleLbl];
        [self leftLine];
        [self rightLine];
        
    }
    return self;
}


- (void)setFooterTip:(NSString *)footerTip
{
    _footerTip = footerTip;
    
    self.titleLbl.text = footerTip;
}

- (UILabel *)titleLbl
{
    if (!_titleLbl) {
        
        _titleLbl = [UILabel labelWithText:@"我是有底线的" font:kFont(11) textColor:RGBCOLOR(160, 160, 160) backGroundColor:ClearColor superView:self];
        
        _titleLbl.textAlignment = NSTextAlignmentCenter;
        
        [_titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.mas_equalTo(0);
            make.height.mas_equalTo(20);
        }];
        
    }
    return _titleLbl;
}

- (UIView *)leftLine
{
    if (!_leftLine) {
        
        _leftLine = [UIView viewWithBackgroundColor:RGBCOLOR(218, 217, 218) superView:self];
        
        [_leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(1);
            make.centerY.mas_equalTo(0);
            make.left.mas_equalTo(10);
            make.right.mas_equalTo(self.titleLbl.mas_left).mas_equalTo(-10);
        }];
        
    }
    return _leftLine;
}

- (UIView *)rightLine
{
    if (!_rightLine) {
        
        _rightLine = [UIView viewWithBackgroundColor:RGBCOLOR(218, 217, 218) superView:self];
        
        [_rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(1);
            make.centerY.mas_equalTo(0);
            make.right.mas_equalTo(-10);
            make.left.mas_equalTo(self.titleLbl.mas_right).mas_equalTo(10);
        }];

    }
    return _rightLine;
}

@end
