//
//  ZFEmptyView.m
//  ZuFang
//
//  Created by 那道 on 2017/12/6.
//  Copyright © 2017年 解辉. All rights reserved.
//

#import "ZFEmptyView.h"

@interface ZFEmptyView()
{
    NSString *_imageName;
    NSString *_emptyTip;
    CGFloat _topMargin;
}
@property (nonatomic, strong) UIImageView  *emptyImgView;

@property (nonatomic, strong) UILabel  *emptyLbl;

@end

@implementation ZFEmptyView

- (instancetype)initWithImage:(NSString *)imageName emptyTip:(NSString *)tip showHeight:(CGFloat)height topMargin:(CGFloat)topMargin
{
    if (self = [super init]) {
        _topMargin = topMargin;
        _imageName = imageName;
        _emptyTip = tip;
        self.qu_h = height;
        
        self.backgroundColor = WhiteColor;
        
        self.emptyLbl.text = tip;
    }
    return self;
}

- (void)changeTipColor:(UIColor *)tipColor
{
    self.emptyLbl.textColor = tipColor;
}

- (UIImageView *)emptyImgView
{
    if (!_emptyImgView) {
        
        _emptyImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:_imageName]];
        _emptyImgView.contentMode = UIViewContentModeCenter;
        [self addSubview:_emptyImgView];
        [_emptyImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.size.mas_equalTo(_emptyImgView.image.size);
            make.top.mas_equalTo(_topMargin);
        }];
        
    }
    return _emptyImgView;
}

- (UILabel *)emptyLbl
{
    if (!_emptyLbl) {
        
        _emptyLbl = [UILabel labelWithText:_emptyTip font:ZF_FONT(14) textColor:RGBCOLOR(187, 187, 187) backGroundColor:ClearColor superView:self];
        _emptyLbl.textAlignment = NSTextAlignmentCenter;
        [_emptyLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.top.mas_equalTo(self.emptyImgView.mas_bottom).mas_equalTo(HScale(18));
        }];
        
    }
    return _emptyLbl;
}

@end
