//
//  HHWZWebView.m
//  Honghai
//
//  Created by 班文政 on 2017/4/11.
//  Copyright © 2017年 Nado. All rights reserved.
//

#import "HHWZWebView.h"
#import "HHWEPickerViewController.h"

@interface HHWZWebView ()<UIWebViewDelegate>
{
    UIView *bgView;
    UIImageView *imgView;
    
    NSInteger _loadNum;//每次请求两次
}

@property (nonatomic, strong) NSMutableArray *mUrlArray;


@end

@implementation HHWZWebView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
       
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
}

- (void)webViewWithHtmlString:(NSString *)htmlStr superController:(UIViewController *)viewController
{
    self.htmlStr = htmlStr;
    
    self.viewController = viewController;
    
    self.delegate = self;
    
    self.frame = CGRectMake(0, 0, kWindowW, 60);
    
    _loadNum = 0;
    
    [self changeWebContent];
}

- (void)changeWebContent
{
    
    //获取temp文件的路径
    NSString *tempPath = [[NSBundle mainBundle]pathForResource:@"temp" ofType:@"html"];
    
    //加载temp内容为字符串
    NSString *tempHtml = [NSString stringWithContentsOfFile:tempPath encoding:NSUTF8StringEncoding error:nil];
    
    //替换temp内的占位符{{Content_holder}}为需要加载的HTML代码
    tempHtml = [tempHtml stringByReplacingOccurrencesOfString:@"{{Content_holder}}" withString:self.htmlStr];
    
    //Temp目录下的js文件在根路径，因此需要在加载HTMLString时指定根路径
    NSString *basePath = [[NSBundle mainBundle] bundlePath];
    
    NSURL *baseURL = [NSURL fileURLWithPath:basePath];
    
    [self loadHTMLString:[self handleStringWithString:tempHtml] baseURL:baseURL];
    
    
    [self setScalesPageToFit:NO];
    
//    self.scrollView.bounces = NO;
    
    UIScrollView *tempView = (UIScrollView *)[self.subviews objectAtIndex:0];
    
    tempView.scrollEnabled = NO;

}

- (void)setHtmlStr:(NSString *)htmlStr
{
    _htmlStr = htmlStr;
    self.frame = CGRectMake(0, 0, kWindowW, 60);
    _loadNum = 0;
    [self changeWebContent];
    
}


- (NSString *)handleStringWithString:(NSString *)str{
    
    NSString *text1= [str stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    
    NSString *text2= [text1 stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    
    NSString *text3 = [text2 stringByReplacingOccurrencesOfString:@"&quot;" withString:@"'"];
    
    return text3;
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    //这里是js，主要目的实现对url的获取
    static  NSString * const jsGetImages =
    @"function getImages(){\
    var objs = document.getElementsByTagName(\"img\");\
    var imgScr = '';\
    for(var i=0;i<objs.length;i++){\
    imgScr = imgScr + objs[i].src + '+';\
    };\
    return imgScr;\
    };";
    
    [webView stringByEvaluatingJavaScriptFromString:jsGetImages];//注入js方法
    NSString *urlResurlt = [webView stringByEvaluatingJavaScriptFromString:@"getImages()"];
    self.mUrlArray = [NSMutableArray arrayWithArray:[urlResurlt componentsSeparatedByString:@"+"]];
    
    [self.mUrlArray removeLastObject];
    
    //添加图片可点击js
    [webView stringByEvaluatingJavaScriptFromString:@"function registerImageClickAction(){\
     var imgs=document.getElementsByTagName('img');\
     var length=imgs.length;\
     for(var i=0;i<length;i++){\
     img=imgs[i];\
     img.onclick=function(){\
     window.location.href='image-preview:'+this.src}\
     }\
     }"];
    
    [webView stringByEvaluatingJavaScriptFromString:@"registerImageClickAction();"];
    
    
    //计算高度
    
    CGRect frame = CGRectZero;//webView.frame;
    frame.size.width = kWindowW;
    
    frame.size.height = [[webView stringByEvaluatingJavaScriptFromString: @"document.body.scrollHeight"]floatValue];//webView.scrollView.contentSize.height;
    
    webView.scrollView.contentSize = frame.size;
    
    self.scrollView.contentSize = frame.size;
    
    if (_loadNum < 2) {
        
        [self changeWebContent];
    }
    
    
    if (_loadNum==2) {
        if ([self.wzDelegate respondsToSelector:@selector(wzWebViewDidFinishLoad:)]) {
            [self.wzDelegate wzWebViewDidFinishLoad:webView];
        }
    }
    _loadNum++;
    
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    //将url转换为string
    NSString *requestString = [[request URL] absoluteString];
    //    NSLog(@"requestString is %@",requestString);
    
    //hasPrefix 判断创建的字符串内容是否以pic:字符开始
    if ([requestString hasPrefix:@"image-preview:"]) {
        
        NSString *imageUrl = [requestString substringFromIndex:@"image-preview:".length];
        
        
        HHWEPickerViewController *QWNVC = [[HHWEPickerViewController alloc]init];
        QWNVC.imagesArr = self.mUrlArray;
        QWNVC.index = [NSString stringWithFormat:@"%lu",(unsigned long)[self.mUrlArray indexOfObject:imageUrl]];
        
        [self.viewController presentViewController:QWNVC animated:YES completion:nil];
        
        
        return NO;
    }
    return YES;
}

#pragma mark 显示大图片
-(void)showBigImage:(NSString *)imageUrl{
    //创建灰色透明背景，使其背后内容不可操作
    bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowW, kWindowH)];
    [bgView setBackgroundColor:[UIColor colorWithRed:0.3
                                               green:0.3
                                                blue:0.3
                                               alpha:0.7]];
    [self addSubview:bgView];
    
    //创建边框视图
    UIView *borderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowW-20, 240)];
    //将图层的边框设置为圆脚
    borderView.layer.cornerRadius = 8;
    borderView.layer.masksToBounds = YES;
    //给图层添加一个有色边框
    borderView.layer.borderWidth = 8;
    borderView.layer.borderColor = [[UIColor colorWithRed:0.9
                                                    green:0.9
                                                     blue:0.9
                                                    alpha:0.7] CGColor];
    [borderView setCenter:bgView.center];
    [bgView addSubview:borderView];
    
    //创建关闭按钮
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [closeBtn setImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
    closeBtn.backgroundColor = [UIColor redColor];
    [closeBtn addTarget:self action:@selector(removeBigImage) forControlEvents:UIControlEventTouchUpInside];
    [closeBtn setFrame:CGRectMake(borderView.frame.origin.x+borderView.frame.size.width-20, borderView.frame.origin.y-6, 26, 27)];
    [bgView addSubview:closeBtn];
    
    //创建显示图像视图
    imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, CGRectGetWidth(borderView.frame)-20, CGRectGetHeight(borderView.frame)-20)];
    imgView.userInteractionEnabled = YES;
    [imgView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"holder.jpg"]];
    
    [borderView addSubview:imgView];
    
    //添加捏合手势
    [imgView addGestureRecognizer:[[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(handlePinch:)]];
    
}


//关闭按钮
-(void)removeBigImage
{
    bgView.hidden = YES;
}

- (void) handlePinch:(UIPinchGestureRecognizer*) recognizer
{
    //缩放:设置缩放比例
    recognizer.view.transform = CGAffineTransformScale(recognizer.view.transform, recognizer.scale, recognizer.scale);
    recognizer.scale = 1;
}


@end
