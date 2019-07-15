//
//  HotGoodsView.m
//  FastWine
//
//  Created by MOOSON_ on 2019/6/5.
//  Copyright © 2019 MOOSON_. All rights reserved.
//

#import "HotGoodsView.h"

@implementation HotGoodsView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
      
      
    }
    return self;
}
#pragma mark- 懒加载
-(UIView *)topView{
    if (_topView == nil) {
        UIView *view = [[UIView alloc]init];
//        view.backgroundColor = RGBACOLOR(244, 238, 238, 1);
//        view.clipsToBounds= YES;
//        view.layer.cornerRadius = 15;
    
        [self.bgView addSubview:view];
     
        _topView = view;
    }
    return _topView;
}
-(UIView *)bottomView{
    if (_bottomView == nil) {
        UIView *view = [[UIView alloc]init];
//         view.backgroundColor = RGBACOLOR(238, 217, 217, 1);
        [self.bgView addSubview:view];
        _bottomView = view;
    }
    return _bottomView;
}
-(UIView *)bgView{
    if (_bgView == nil) {
        UIView *view = [[UIView alloc]init];
        [self addSubview:view];
         _bgView = view;
       
    }
    return _bgView;
}
-(UIButton *)clickbtn{
    if (_clickbtn == nil) {
        UIButton *btn =[UIButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        [self bringSubviewToFront:btn];
        _clickbtn = btn;
    }
    return _clickbtn;
}
- (UIButton *)imageBtn{
    if (_imageBtn == nil) {
        UIButton *imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.topView addSubview:imageBtn];
        _imageBtn = imageBtn;
    }
    return _imageBtn;
}
- (UILabel *)namelabel{
    if (_namelabel == nil) {
        UILabel *label = [[UILabel alloc]init];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:10];
        [self.bottomView addSubview:label];
        _namelabel = label;
    }
    return _namelabel;
}
- (UILabel *)piclabel{
    if (_piclabel == nil) {
        UILabel *label = [[UILabel alloc]init];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:10];
        label.textColor = HEXCOLOR(@"#FFE41C3D");
        label.backgroundColor = HEXCOLOR(@"#FFFDEDEF");
        label.layer.masksToBounds = YES;
        label.layer.cornerRadius = 8;
        [self.bottomView addSubview:label];
        _piclabel = label;
    }
    return _piclabel;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat personW = self.frame.size.width;
    CGFloat personH = self.frame.size.height;
    self.bgView.frame =  CGRectMake(0, 0, personW, personH);
    self.clickbtn.frame =  CGRectMake(0, 0, personW, personH);
    self.topView.frame = CGRectMake(0, 0, personW, 70);
    self.bottomView.frame = CGRectMake(0, 60, personW, 30);
//    self.imageBtn.frame = CGRectMake(0, 0, 50, 50);
//    self.namelabel.frame = CGRectMake(0, 5, personW, 15);
    self.piclabel.frame = CGRectMake(0, 5, (int)personW, 25);
//    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_bottomView.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(5, 5)];
//            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//            maskLayer.frame = _bottomView.bounds;
//            maskLayer.path = maskPath.CGPath;
//            _bottomView.layer.mask = maskLayer;
//
//    UIBezierPath *maskPath1 = [UIBezierPath bezierPathWithRoundedRect:_topView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(15, 15)];
//    CAShapeLayer *maskLayer1 = [[CAShapeLayer alloc] init];
//    maskLayer1.frame = _topView.bounds;
//    maskLayer1.path = maskPath1.CGPath;
//    _topView.layer.mask = maskLayer1;
  
    [self.imageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.topView.mas_top);
            make.centerX.mas_equalTo(self.topView.mas_centerX);
            make.width.mas_equalTo(50);
            make.height.mas_equalTo(50);

     }];
//    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(HScale(10));
//        make.centerX.mas_equalTo(self.bgView.mas_centerX);
//
//    }];
//    self.label.frame = CGRectMake(0, personH-20, personW, 20);
//    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.mas_equalTo(HScale(45));
//        make.left.mas_equalTo(leftImg.mas_right).mas_equalTo(WScale(10));
//        make.bottom.right.mas_equalTo(0);
//    }];
//
//    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(0);
//        make.centerY.mas_equalTo(field.mas_centerY);
//        make.size.mas_equalTo(leftImg.image.size);
//    }];
    
}

-(void)setDataModel:(MainCategoryModel *)dataModel{
    _dataModel = dataModel;
    if (_dataModel) {
    
//        [self.clickbtn sd_setBackgroundImageWithURL:[NSURL URLWithString:_dataModel.pic] forState:UIControlStateNormal];
        [self.imageBtn sd_setImageWithURL:[NSURL URLWithString:_dataModel.pic] forState:UIControlStateNormal completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            CGFloat imageScale = image.size.height/image.size.width;
            CGFloat newImageWidth = image.size.width;
            CGFloat newImageHeight = imageScale * newImageWidth;
//        NSLog(@"newImageWidth:%f----newImageHeight:%f---imageScale:%f",newImageWidth,newImageHeight,imageScale);
        }];
//        [self.imageBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:_dataModel.pic] forState:UIControlStateNormal];
        
        self.namelabel.text = dataModel.title;
        
        if ([ACCOUNTINFO.userInfo.is_promoter integerValue] == 1) {
            self.piclabel.text = [NSString stringWithFormat:@"¥%@",_dataModel.vip_price];
            
        }else{
            self.piclabel.text = [NSString stringWithFormat:@"¥%@",_dataModel.price];
        }
    }
}
-(void)btnAction:(UIButton *)sender{
    
    if (_itemClickBlock) {
        _itemClickBlock(_dataModel);
    }
}
@end
