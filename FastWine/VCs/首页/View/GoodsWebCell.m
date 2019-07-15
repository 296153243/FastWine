//
//  GoodsWebCell.m
//  FastWine
//
//  Created by MOOSON_ on 2019/3/28.
//  Copyright © 2019年 MOOSON_. All rights reserved.
//

#import "GoodsWebCell.h"
@interface GoodsWebCell()<WKNavigationDelegate>
@property(nonatomic,strong)UIScrollView *scollView;
@property(nonatomic)CGFloat webHH;
@end
@implementation GoodsWebCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    //    _ibScollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 60, SCREEN_WIDTH, 300)];
    WKWebViewConfiguration * config = [[WKWebViewConfiguration alloc]init];
    NSString*jSString = [NSString stringWithFormat:@"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content','width=device-width','user-scalable=no'); document.getElementsByTagName('head')[0].appendChild(meta);"];
    WKUserScript * wkUserScript = [[WKUserScript alloc]initWithSource:jSString injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    WKUserContentController* userContent = [[WKUserContentController alloc]init];
    [userContent addUserScript:wkUserScript];
    config.userContentController= userContent;
    
    //
    WKWebView *wkwebView = [[WKWebView alloc] init];
    wkwebView.frame = _ibScollView.bounds;
    wkwebView.backgroundColor = [UIColor redColor];
    wkwebView.navigationDelegate = self;
    wkwebView.scrollView.scrollEnabled = YES;
    wkwebView.scrollView.userInteractionEnabled = NO;
    [wkwebView sizeToFit];
   
    _wkWebView = wkwebView;
    
    //添加监听获取到的
//    [self.wkWebView addObserver:self forKeyPath:@"scrollView.contentSize" options:NSKeyValueObservingOptionNew context:nil];
}
-(void)setViewModel:(GoodsDetalisModel *)viewModel{
    _viewModel = viewModel;
    if (_viewModel) {
        if (_viewModel.des) {
            [_ibScollView addSubview:self.wkWebView];

            [self.wkWebView loadHTMLString:[NSString adaptWebViewForHtml:_viewModel.des] baseURL:nil];
//            [self.wkWebView loadHTMLString:_viewModel.des baseURL:nil];
           
            //    NSLog(@"description:%@",[NSString adaptWebViewForHtml:_goodsDetalisModel.des]);
        }
    }
}
//MARK:--------WKNavigationDelegate
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    
    // 不执行前段界面弹出列表的JS代码，关闭系统的长按保存图片
    [self.wkWebView evaluateJavaScript:@"document.documentElement.style.webkitTouchCallout='none';" completionHandler:nil];
    //    document.body.scrollHeight（不准）   document.body.offsetHeight;(好)
 
    [self.wkWebView evaluateJavaScript:@"document.body.offsetHeight;" completionHandler:^(id Result, NSError * error) {
        NSString *heightStr = [NSString stringWithFormat:@"%@",Result];
        
        //加上一点
        CGFloat height = heightStr.floatValue + 100;

        self.ibScollView.frame = CGRectMake(0, 44, SCREEN_WIDTH, height);
        self.wkWebView.frame = CGRectMake(0, 0, SCREEN_WIDTH, height);
        //
        NSLog(@"----webH:%f",height);
        if (self->_webViewLoadFinish) {
            self->_webViewLoadFinish(height);
        }
        
    }];
    
}
// 使用kvo监听到的contensize变化，之所以在这里设置，因为webview加载的内容多的时候 是一段一段加载初开的，所以webview的contensize是实时变化的，所以在这里监听到可以以达到实时改变，不至于页面卡顿
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (object == self.wkWebView && [keyPath isEqual:@"scrollView.contentSize"]) {
        UIScrollView *scrollView = self.wkWebView.scrollView;
        CGSize size = CGSizeMake(SCREEN_WIDTH, scrollView.contentSize.height);
//         NSLog(@"+========:%f",scrollView.contentSize.height);
        
        CGFloat height = scrollView.contentSize.height;
        
        self.ibScollView.frame = CGRectMake(0, 44, SCREEN_WIDTH, height);
        self.wkWebView.frame = CGRectMake(0, 0, SCREEN_WIDTH, height);
        if (_webHH == height) {
//            NSLog(@"*****webH:%f",height);
            if (self->_webViewLoadFinish) {
                self->_webViewLoadFinish(height);
            }
           
        }
         _webHH = height;
        //
        NSLog(@"----webH:%f",height);

//        self.wkWebView.frame = CGRectMake(0, MaxY(self.midView)+7+40, SCREEN_WIDTH, size.height);
//        self.scrollview.contentSize = CGSizeMake(SCREEN_WIDTH, ScaleHeight(296)+size.height);
    }
    
}

@end
