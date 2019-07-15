//
//  BaseWKWebController.m
//  CLTravel
//
//  Created by MOOSON_ on 2018/11/28.
//  Copyright © 2018年 MOOSON_. All rights reserved.
//

#import "BaseWKWebController.h"
#import <WebKit/WebKit.h>

#define onShareClick @"onShareClick"
#define onSubmitPacketOrderSuccess @"onSubmitPacketOrderSuccess"//包时成功
#define onSelectStartLocation @"onSelectStartLocation"//选择地点

@interface BaseWKWebController ()<WKScriptMessageHandler,WKNavigationDelegate>
@property(nonatomic,strong)WKWebView *wkWebView;
@property (nonatomic, strong) UIProgressView *progressView;//进度条

@end

@implementation BaseWKWebController
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.barTintColor = NavColor;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.hidden = NO;
    QuNavigationBar *bar = [QuNavigationBar showQuNavigationBarWithController:self offset:NO];
    self.clNavBar = bar;
    self.clNavBar.titleColor =  navTitleColor;
    self.clNavBar.title = @"加载中";
   
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(20, 0, 44, 44);
    [backBtn setImage:[UIImage imageNamed:@"Back_icon"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    self.clNavBar.leftView = backBtn;
//    //进度条初始化
    CGFloat progressBarHeight = 2.f;
    CGRect barFrame = CGRectMake(0, self.clNavBar.frame.size.height - progressBarHeight, self.clNavBar.frame.size.width, progressBarHeight);
    self.progressView = [[UIProgressView alloc]initWithFrame:barFrame];
    self.progressView.progressTintColor = [UIColor blueColor];
    self.progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [self.clNavBar addSubview:self.progressView];
    
    //1 遵循WKScriptMessageHandler协议
    //2 初始化
    WKWebViewConfiguration * config = [[WKWebViewConfiguration alloc]init];
    
    CGRect webframe = self.view.frame;
    if (IS_iPhoneX || IS_iPhoneXMax) {
        webframe  = CGRectMake(0,  88, SCREEN_WIDTH, SCREEN_HEIGHT - 88);
    }else{
        webframe  = CGRectMake(0,  64, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
    }
//    NSString*jSString = [NSString stringWithFormat:@"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content','width=device-width','user-scalable=no'); document.getElementsByTagName('head')[0].appendChild(meta);"];
//
//    WKUserScript * wkUserScript = [[WKUserScript alloc]initWithSource:jSString injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
//    WKUserContentController* userContent = [[WKUserContentController alloc]init];
//
//    [userContent addUserScript:wkUserScript];
//
//    config.userContentController= userContent;
    self.wkWebView  = [[WKWebView alloc]initWithFrame:webframe configuration:config];
    self.wkWebView.navigationDelegate = self;
   
  
    
    [self.view addSubview:self.wkWebView];
    
    //加载地址
    if (_url) {
        [self loadWebViewUrl];
        
    }
    if (_content) {
        [self.wkWebView loadHTMLString:_content baseURL:nil];
        
        NSLog(@"_content:%@",_content);
    }
    //此处相当于监听了JS中onShareClick这个方法
    [self.wkWebView.configuration.userContentController addScriptMessageHandler:self name:onShareClick];
    [self.wkWebView.configuration.userContentController addScriptMessageHandler:self name:onSubmitPacketOrderSuccess];
    [self.wkWebView.configuration.userContentController addScriptMessageHandler:self name:onSelectStartLocation];
    [self.wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];

}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)loadWebViewUrl
{
    
    NSString *encodeUrlString = [self.url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];  //Encode编码
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:encodeUrlString]];
    [self.wkWebView loadRequest:request];
    NSString *decodeUrlString = [encodeUrlString stringByRemovingPercentEncoding];  //解码
    NSLog(@"webView loadUrl:%@",decodeUrlString);
    //    NSString* htmlPath = [[NSBundle mainBundle] pathForResource:@"ExampleApp" ofType:@"html"];
    //    NSString* appHtml = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    //    NSURL *baseURL = [NSURL fileURLWithPath:htmlPath];
    //    [self.webView loadHTMLString:appHtml baseURL:baseURL];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqual:@"estimatedProgress"] && object == self.wkWebView) {
        [self.progressView setAlpha:1.0f];
        [self.progressView setProgress:self.wkWebView.estimatedProgress animated:YES];
        if (self.wkWebView.estimatedProgress  >= 1.0f) {
            [UIView animateWithDuration:0.3 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self.progressView setAlpha:0.0f];
            } completion:^(BOOL finished) {
                [self.progressView setProgress:0.0f animated:YES];
            }];
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

//加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    
    if (_titleStr) {
        self.clNavBar.title = _titleStr;
        
    }else{
        [webView evaluateJavaScript:@"document.title" completionHandler:^(id object, NSError * error) {
            [self.clNavBar setTitle:object];
        }];
    }
    self.progressView.hidden = YES;
}

//加载失败
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {

    self.progressView.hidden = YES;
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return nil;
}
#pragma mark  WKScriptMessageHandler delegate
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    
}
- (void)loadAppShareWithModel:(QuShareModel *)model
{
    
//    NSMutableArray *array = [[NSMutableArray alloc]init];
//    [array addObject:@(SSDKPlatformSubTypeWechatTimeline)];
//    [array addObject:@(SSDKPlatformSubTypeWechatSession)];
//    [array addObject:@(SSDKPlatformSubTypeQQFriend)];
//    
//    model.platforms = [NSArray arrayWithArray:array];
//    
//    [QuShareView showShareWithModel:model success:^{
//        
//        [QuHudHelper qu_showMessage:@"分享成功"];
//        //暂时不用告知H5
//        //        [weakSelf.ocjsWebBridge callHandler:@"shareComplete" data:@{ @"code":@"1" }];
//        
//    } fail:^{
//        
//        [QuHudHelper qu_showMessage:@"分享失败"];
//    }];
}

//VC销毁的时候把handler移除
-(void)dealloc
{
    [self.wkWebView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.wkWebView.configuration.userContentController removeScriptMessageHandlerForName:onShareClick];
    [self.wkWebView.configuration.userContentController removeScriptMessageHandlerForName:onSubmitPacketOrderSuccess];
    [self.wkWebView.configuration.userContentController removeScriptMessageHandlerForName:onSelectStartLocation];
    
}

@end
