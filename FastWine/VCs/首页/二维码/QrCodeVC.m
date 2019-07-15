//
//  QrCodeVC.m
//  FastWine
//
//  Created by MOOSON_ on 2019/4/29.
//  Copyright © 2019年 MOOSON_. All rights reserved.
//

#import "QrCodeVC.h"
#import "QuShareView.h"
#import <ShareSDK/ShareSDK.h>
@interface QrCodeVC ()
@property (weak, nonatomic) IBOutlet UIImageView *ibCodeImg;
@property(nonatomic,strong)NSString *urlStr;
@end

@implementation QrCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"二维码";
    // Do any additional setup after loading the view from its nib.
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    // 3. 给过滤器添加数据
    _urlStr = [NSString stringWithFormat:@"http://wine.jiudicar.com/wap/index/index/spuid/%@",[Save userID]];
    NSLog(@"CodeurlStr:-----%@",_urlStr);
//    if ([urlStr rangeOfString:@"?"].location == NSNotFound) {
//        urlStr = [NSString stringWithFormat:@"%@?userId=%@",urlStr,[PublicManager getLocalUserId]];
//    }
//    else{
//        urlStr = [NSString stringWithFormat:@"%@&userId=%@",urlStr,[PublicManager getLocalUserId]];
//
//    }
    NSString *dataString = _urlStr;
    NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKeyPath:@"inputMessage"];
    CIImage *outputImage = [filter outputImage];
    // 显示二维码
    _ibCodeImg.image = [UIImage creatNonInterpolatedUIImageFormCIImage:outputImage withSize:170];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(rightBarButtonItemAction:) image:@"share_dian"];
}
-(void)rightBarButtonItemAction:(UIButton *)sender{
    
    QuShareModel *model = [QuShareModel new];
    model.title = @"同城快酒";
    model.content = @"汇集各类酒水网上直供平台，提供质优价低的酒水与全面贴心的服务";
    model.imageUrl = [UIImage imageNamed:@"share_ic"];
    model.targetUrl = _urlStr;
    [self loadAppShareWithModel:model];
}
- (void)loadAppShareWithModel:(QuShareModel *)model
{
    
    NSMutableArray *array = [[NSMutableArray alloc]init];
    [array addObject:@(SSDKPlatformSubTypeWechatTimeline)];
    [array addObject:@(SSDKPlatformSubTypeWechatSession)];
    [array addObject:@(SSDKPlatformSubTypeQQFriend)];
    
    model.platforms = [NSArray arrayWithArray:array];
    
    [QuShareView showShareWithModel:model success:^{
        
        [QuHudHelper qu_showMessage:@"分享成功"];
        //暂时不用告知H5
        //        [weakSelf.ocjsWebBridge callHandler:@"shareComplete" data:@{ @"code":@"1" }];
        
    } fail:^{
        
        [QuHudHelper qu_showMessage:@"分享失败"];
    }];
}
@end
