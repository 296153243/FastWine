//
//  HHWZWebView.h
//  Honghai
//
//  Created by 班文政 on 2017/4/11.
//  Copyright © 2017年 Nado. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HHWZWebViewDelegate <NSObject>

- (void)wzWebViewDidFinishLoad:(UIWebView *)webView;

@end

@interface HHWZWebView : UIWebView


- (void)webViewWithHtmlString:(NSString *)htmlStr superController:(UIViewController *)viewController;

@property (nonatomic, copy) NSString *htmlStr;
@property (nonatomic, strong) UIViewController *viewController;


@property(nonatomic,weak) id<HHWZWebViewDelegate>wzDelegate;

@end
