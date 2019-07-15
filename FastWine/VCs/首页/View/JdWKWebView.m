//
//  JdWKWebView.m
//  FastWine
//
//  Created by MOOSON_ on 2019/3/28.
//  Copyright © 2019年 MOOSON_. All rights reserved.
//

#import "JdWKWebView.h"

@implementation JdWKWebView
- (instancetype)initWithCoder:(NSCoder *)coder{
    
    CGRect frame = [[UIScreen mainScreen] bounds];
    WKWebViewConfiguration *myConfiguration = [WKWebViewConfiguration new];
    
    self = [super initWithFrame:frame configuration:myConfiguration];
    
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    return self;
}
@end
