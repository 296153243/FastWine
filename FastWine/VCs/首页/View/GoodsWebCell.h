//
//  GoodsWebCell.h
//  FastWine
//
//  Created by MOOSON_ on 2019/3/28.
//  Copyright © 2019年 MOOSON_. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface GoodsWebCell : UITableViewCell
@property(nonatomic,strong)GoodsDetalisModel *viewModel;
@property(nonatomic,strong)WKWebView *wkWebView;
@property (weak, nonatomic) IBOutlet UIScrollView *ibScollView;

@property(nonatomic,copy)void(^webViewLoadFinish)(CGFloat webH);
@end

NS_ASSUME_NONNULL_END
