//
//  QuNavigationBar.m
//  QuPassenger
//
//  Created by 朱青 on 2017/9/26.
//  Copyright © 2017年 com.Qyueche. All rights reserved.
//

#import "QuNavigationBar.h"

#define Qu_Nav_Title_Color [UIColor colorWithHexString:@"404040"]
#define Qu_Nav_Title_Font [UIFont fontWithName:@"PingFangSC-Medium" size:16.0f]

#define Qu_Nav_Height ([[UIScreen mainScreen] bounds].size.height == 812.0 ? 88 : 64)
#define Qu_Nav_Content_top ([[UIScreen mainScreen] bounds].size.height == 812.0 ? 44 : 20)

@interface QuNavigationBar ()

@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UILabel *titleLabel;

@end

@implementation QuNavigationBar

+ (QuNavigationBar *)showQuNavigationBarWithController:(UIViewController *)controller
{
    return [QuNavigationBar showQuNavigationBarWithController:controller offset:YES];
}

+ (QuNavigationBar *)showQuNavigationBarWithController:(UIViewController *)controller offset:(BOOL)offset
{
    QuNavigationBar *bar;
    if (controller) {
        
        //隐藏系统navigationbar
        [controller.navigationController setNavigationBarHidden:YES];
        
        if (offset) {
            
            for (NSLayoutConstraint *layout in controller.view.constraints) {
                
                if ([layout.secondItem isEqual:controller.view] && layout.secondAttribute == NSLayoutAttributeTop) {
                    CGFloat contant = layout.constant;
                    layout.constant = contant + Qu_Nav_Height;
                }
            }
        }
        
        
        bar = [[QuNavigationBar alloc]init];
        [bar setBackgroundColor:[UIColor whiteColor]];
        [controller.view addSubview:bar];
        [bar.contentView setHidden:NO];
        
        [bar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(controller.view);
            make.height.mas_equalTo(Qu_Nav_Height);
        }];
        
        if ([controller.navigationController.viewControllers indexOfObject:controller] > 0) {
            
            UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
            [leftBtn setImage:[UIImage imageNamed:@"base_back_icon"] forState:UIControlStateNormal];
            [leftBtn addTarget:bar action:@selector(leftBarButtonItemAction:) forControlEvents:UIControlEventTouchUpInside];
            bar.leftView = leftBtn;
        }
        
    }
    return bar;
}

#pragma mark btnClickAction
- (void)leftBarButtonItemAction:(UIButton *)sender
{
    [self.qu_viewController.navigationController popViewControllerAnimated:YES];
}

#pragma mark getter
- (UIView *)contentView
{
    if (!_contentView) {
        
        _contentView = [[UIView alloc]init];
        [_contentView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_contentView];
        
        [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.top.equalTo(self).offset(Qu_Nav_Content_top);
        }];
    }
    return _contentView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        
        _titleLabel = [[UILabel alloc]init];
        [_titleLabel setTextColor:Qu_Nav_Title_Color];
        [_titleLabel setFont:Qu_Nav_Title_Font];
        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
        
        self.titleView = _titleLabel;
        
    }
    return _titleLabel;
}

#pragma mark setter
- (void)setBarTintColor:(UIColor *)barTintColor
{
    _barTintColor = barTintColor;
    self.backgroundColor = barTintColor;
}

- (void)setTitleColor:(UIColor *)titleColor
{
    _titleColor = titleColor;
    [self.titleLabel setTextColor:titleColor];
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    [self.titleLabel setText:title];
}

- (void)setLeftView:(UIView *)leftView
{
    if (leftView) {
        [_leftView removeFromSuperview];
        _leftView = nil;
        _leftView = leftView;
   
        [self.contentView addSubview:_leftView];
        
        [_leftView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView);
            make.centerY.equalTo(self.contentView);
            make.width.mas_equalTo(leftView.qu_w);
            make.height.mas_equalTo(leftView.qu_h);
        }];
        
        if (_titleView) {
            [_titleView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(self.contentView);
     
                make.left.equalTo(self->_leftView.mas_right).offset(5);
       
                
            }];
        }
        
    }
    
}

- (void)setRightView:(UIView *)rightView
{
    if (rightView) {
        [_rightView removeFromSuperview];
        _rightView = nil;
        _rightView = rightView;
        
        [self.contentView addSubview:_rightView];
        
        [_rightView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView);
            make.centerY.equalTo(self.contentView);
            make.width.mas_equalTo(_rightView.qu_w);
            make.height.mas_equalTo(_rightView.qu_h);
        }];
        if (_titleView) {
            [_titleView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.center.equalTo(self.contentView);
                
                make.right.equalTo(self->_rightView.mas_left).offset(-5);
                
                
            }];
        }
    }
}

- (void)setTitleView:(UIView *)titleView
{
    if (titleView) {
        [_titleView removeFromSuperview];
        _titleView = nil;
        _titleView = titleView;
        
        [self.contentView addSubview:_titleView];
        
        [_titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.contentView);
            
            if (self->_leftView) {
                if (self->_rightView) {
                    
                    if (self->_leftView.qu_w > self->_rightView.qu_w) {
                        make.left.equalTo(self->_leftView.mas_right).offset(5);
                        
                    }
                    else{
                        make.right.equalTo(self->_rightView.mas_left).offset(-5);
                    }
                }
                else{
                    
                    make.left.equalTo(self->_leftView.mas_right).offset(5);
                }
            }
            else{
                
                if (self->_rightView) {
                    
          
                    make.right.equalTo(self->_rightView.mas_left).offset(-5);
                    
                }
                
            }
            

            
        }];

    }
}

@end
