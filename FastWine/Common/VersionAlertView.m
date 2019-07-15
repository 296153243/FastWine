//
//  VersionAlertView.m
//  QuPassenger
//
//  Created by 朱青 on 2018/2/9.
//  Copyright © 2018年 com.Qyueche. All rights reserved.
//

#import "VersionAlertView.h"

@implementation VersionAlertView

- (id)init{
    self = [super init];
    if (self) {
        alertViewQueue = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id)initWithAlertTitle:(NSString *)title message:(NSString *)message cancelHandler:(VersionAlertBlockHandler)cancelHandler confirmHandler:(VersionAlertBlockHandler)confirmHandler
{
    self = [self init];
    if (self) {

        _title = title;
        _mesage = message;
        _selectBlock = confirmHandler;
        _dismissBlock = cancelHandler;
        [self prepareAlertToDisplay];
        
    }
    return self;
}


-(void)prepareAlertToDisplay
{
    //灰色背景
    if (!backgroundView) {
        backgroundView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        [backgroundView setBackgroundColor:RGBACOLOR(0.0, 0.0, 0.0, 0.5)];
    }
    [backgroundView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
    }];

    _showView = (VersionContentView *)[[[NSBundle mainBundle] loadNibNamed:@"VersionContentView" owner:self options:nil] firstObject];
    [_showView.titleLabel setText:_title];

    [_showView.contentTextView setText:_mesage];
    [_showView.cancelBtn addTarget:self action:@selector(dismissAlertShow) forControlEvents:UIControlEventTouchUpInside];
    
    [_showView.comfirmBtn addTarget:self action:@selector(confirmClickAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [_showView setCornerRadius:4.0f AndBorder:0.0f borderColor:nil];
    [_showView.messageView setCornerRadius:4.0f AndBorder:0.0f borderColor:nil];

    CGSize sizeToFit = [_showView.contentTextView sizeThatFits:CGSizeMake(_showView.frame.size.width - 50, MAXFLOAT)];
    [_showView setFrame:CGRectMake(SCREEN_SIZE.width/2 - _showView.frame.size.width/2,SCREEN_SIZE.height/2 - _showView.frame.size.height/2, _showView.frame.size.width, ceil(sizeToFit.height) + 213)];

    _showView.center = CGPointMake(SCREEN_SIZE.width/2, SCREEN_SIZE.height/2);
    [backgroundView addSubview:_showView];
    [alertViewQueue addObject:self];
}

- (void)show
{
    [[[UIApplication sharedApplication]keyWindow]addSubview:backgroundView];
    CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    popAnimation.duration = 0.2;
    popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.001f, 0.001f, 1.0f)],[NSValue valueWithCATransform3D:CATransform3DIdentity]];
    
    [_showView.layer addAnimation:popAnimation forKey:nil];
}

- (void)dismissAlertShow
{
    
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CATransform3D transform = CATransform3DMakeScale(0.01, 0.01, 1);
        _showView.layer.transform = transform;
    }completion:^(BOOL finished) {
        [backgroundView removeFromSuperview];
        [alertViewQueue removeLastObject];
    }];
    
    if (self.dismissBlock) {
        self.dismissBlock();
    }
    
    
}

- (void)confirmClickAction:(UIButton *)sender
{

    if (self.selectBlock) {
        self.selectBlock();
    }
    
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CATransform3D transform = CATransform3DMakeScale(0.01, 0.01, 1);
        _showView.layer.transform = transform;
    }completion:^(BOOL finished) {
        [backgroundView removeFromSuperview];
        [alertViewQueue removeLastObject];
    }];
    
    
    
}


@end
