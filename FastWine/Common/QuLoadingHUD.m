//
//  QuLoadingHUD.m
//  QuPassenger
//
//  Created by Zhuqing on 2017/12/1.
//  Copyright © 2017年 com.Qyueche. All rights reserved.
//

#import "QuLoadingHUD.h"

#define VIEW_SIZE_WIDTH 100
#define VIEW_SIZE_HEIGHT 100

@interface QuLoadingHUD ()

@property (strong, nonatomic) UIImageView *loadImageView;

@end

@implementation QuLoadingHUD

+ (QuLoadingHUD *)sharedView {
    static dispatch_once_t once;
    static QuLoadingHUD *sharedView;
    dispatch_once(&once, ^ {
        sharedView = [[self alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    });
    return sharedView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setUpViewWithFrame:frame];
        
    }
    return self;
}

- (void)setUpViewWithFrame:(CGRect)aFrame
{

    self.backgroundColor = [UIColor clearColor];
    
    UIView *contentView = [[UIView alloc]init];
    [contentView setBackgroundColor:[UIColor whiteColor]];
    [contentView setCornerRadius:50.0f AndBorder:0.0f borderColor:nil];
    [self addSubview:contentView];
    [contentView showShadowColor];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.mas_equalTo(VIEW_SIZE_WIDTH);
        make.height.mas_equalTo(VIEW_SIZE_HEIGHT);
        make.center.equalTo(self);
    }];
    
    NSArray *myImages = [NSArray arrayWithObjects:
                         [UIImage imageNamed:@"main_refresh1"],
                         [UIImage imageNamed:@"main_refresh2"],
                         [UIImage imageNamed:@"main_refresh3"],
                         nil];
    
    UIImageView *myAnimatedView = [[UIImageView alloc]init];

    myAnimatedView.animationImages = myImages;//将序列帧数组赋给UIImageView的animationImages属性
    myAnimatedView.animationDuration = 1;//设置动画时间
    myAnimatedView.animationRepeatCount = 0;//设置动画次数 0 表示无限
    
    [contentView addSubview:myAnimatedView];
    self.loadImageView = myAnimatedView;
    
    [myAnimatedView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(80);
        make.centerX.equalTo(contentView.mas_centerX);
        make.centerY.equalTo(contentView.mas_centerY).offset(-5);
    }];
    
    UILabel *label = [[UILabel alloc]init];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setText:@"加载中"];
    [label setFont:SYSTEMFONT(12.0f)];
    [label setTextColor:HEXCOLOR(@"777777")];
    [contentView addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {

        make.centerX.equalTo(contentView.mas_centerX);
        make.centerY.equalTo(contentView.mas_centerY).offset(30);
    }];
    
}

- (void)startAnimation
{
    [self.loadImageView startAnimating];
}

- (void)stopAnimating
{
    [self.loadImageView stopAnimating];
}


+ (void)loading
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    
    [window addSubview:[self sharedView]];
    
    [[self sharedView] setAlpha:1];
    
    [[self sharedView] startAnimation];
}

+ (void)dismiss
{
    [QuLoadingHUD dismiss:@""];
}

+ (void)dismiss:(NSString *)msg
{
    
    [UIView animateWithDuration:0.2 animations:^{
   
        [[self sharedView] setAlpha:0];
        
    } completion:^(BOOL finished) {
        
        [[self sharedView] stopAnimating];
        [[self sharedView] removeFromSuperview];
    }];

    if (msg.trim.length > 0) {
        
        [QuHudHelper qu_showMessage:msg];
    }
}

@end
