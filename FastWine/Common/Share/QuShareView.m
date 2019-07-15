//
//  QuShareView.m
//  QuPassenger
//
//  Created by Zhuqing on 2017/11/27.
//  Copyright © 2017年 com.Qyueche. All rights reserved.
//

#import "QuShareView.h"
#import "QuShareCell.h"
#import "WXApi.h"
#import <TencentOpenAPI/QQApiInterface.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <ShareSDKUI/ShareSDKUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>

@implementation QuShareView

-(id)init{
    self = [super init];
    if (self) {
        alertViewQueue = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id)initWithShareModel:(QuShareModel *)shareModel
{
    self = [self init];
    if (self) {
        
        _shareModel = shareModel;

        [self prepareAlertToDisplay];
        
    }
    return self;
}

+ (QuShareView *)showShareWithModel:(QuShareModel *)shareModel success:(void (^)(void))shareSuccessBlock fail:(void (^)(void))shareFailBlock
{
    QuShareView *bar = [[QuShareView alloc]initWithShareModel:shareModel];
    
    bar.shareSuccessBlock = shareSuccessBlock;
    bar.shareFailBlock = shareFailBlock;
    
    return bar;
}


-(void)prepareAlertToDisplay
{
    //灰色背景
    if (!backgroundView) {
        backgroundView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        [backgroundView setBackgroundColor:RGBACOLOR(0.3, 0.3, 0.3, 0.3)];
 
    }
    [backgroundView.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
    }];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:backgroundView.frame];
    [button setBackgroundColor:[UIColor clearColor]];
    [button addTarget:self action:@selector(dismissAlertShow) forControlEvents:UIControlEventTouchUpInside];
    [backgroundView addSubview:button];
    

    _showView = (QuShareShowView *)[[[NSBundle mainBundle] loadNibNamed:@"QuShareShowView" owner:self options:nil] firstObject];
    [_showView.shareCollectionView registerNib:[UINib nibWithNibName:@"QuShareCell" bundle:nil] forCellWithReuseIdentifier:@"QuShareCell"];
    [_showView.shareCollectionView setDelegate:self];
    [_showView.shareCollectionView setDataSource:self];

    if (self.shareModel.platforms.count < 5) {
        
        [_showView setFrame:CGRectMake(0,SCREEN_SIZE.height, SCREEN_WIDTH, _showView.frame.size.height - 100  + SCREEN_BOTTOM_MARGIN)];
    }
    else{
        [_showView setFrame:CGRectMake(0,SCREEN_SIZE.height, SCREEN_WIDTH, _showView.frame.size.height + SCREEN_BOTTOM_MARGIN)];
    }
  
    
    [backgroundView addSubview:_showView];
    [alertViewQueue addObject:self];
    
    [self show];
}

- (void)show
{
    [self.showView.shareCollectionView reloadData];
    [[[UIApplication sharedApplication]keyWindow]addSubview:backgroundView];
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        [_showView setFrame:CGRectMake(0, SCREEN_SIZE.height - _showView.frame.size.height, SCREEN_WIDTH, _showView.frame.size.height)];
    }completion:^(BOOL finished) {
        
    }];
}

- (void)dismissAlertShow
{
    
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        [_showView setFrame:CGRectMake(0, SCREEN_SIZE.height, SCREEN_WIDTH, _showView.frame.size.height)];
    }completion:^(BOOL finished) {
        [backgroundView removeFromSuperview];
        [alertViewQueue removeLastObject];
    }];
 
}

#pragma mark UICollectionViewDatasource/UICollectionViewDelegate
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.shareModel.platforms.count;
}

//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    
    return 1;
}

//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cIdentifier = @"QuShareCell";
    QuShareCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cIdentifier forIndexPath:indexPath];

    NSNumber *number = self.shareModel.platforms[indexPath.item];

    switch ([number integerValue]) {
        case SSDKPlatformTypeSinaWeibo:{
            
            [cell.iconImageView setImage:[UIImage imageNamed:@"share_sina"]];
            [cell.nameLabel setText:@"微博"];
        }
            break;
            
        case SSDKPlatformSubTypeWechatSession:{
            [cell.iconImageView setImage:[UIImage imageNamed:@"icon-wx"]];
            [cell.nameLabel setText:@"微信好友"];
        }
            break;
            
        case SSDKPlatformSubTypeWechatTimeline:{
            [cell.iconImageView setImage:[UIImage imageNamed:@"icon-pyq"]];
            [cell.nameLabel setText:@"朋友圈"];
        }
            break;
            
        case SSDKPlatformSubTypeQQFriend:{
            [cell.iconImageView setImage:[UIImage imageNamed:@"icon-qq"]];
            [cell.nameLabel setText:@"QQ好友"];
        }
            break;
            
        case SSDKPlatformSubTypeQZone:{
            [cell.iconImageView setImage:[UIImage imageNamed:@"share_qqzone"]];
            [cell.nameLabel setText:@"QQ空间"];
        }
            break;
            
        case SSDKPlatformTypeSMS:{
            [cell.iconImageView setImage:[UIImage imageNamed:@"share_sms"]];
            [cell.nameLabel setText:@"短信"];
        }
            break;
            
        default:
            break;
    }
    
    return cell;

   
}

//pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{

    return CGSizeMake(SCREEN_SIZE.width/3, 100);
    
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
    
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{

    return 0;
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{

    return 0;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

    NSNumber *number = self.shareModel.platforms[indexPath.item];
    
    if ([number integerValue] == SSDKPlatformSubTypeWechatSession || [number integerValue] == SSDKPlatformSubTypeWechatTimeline) {
        
        if (![WXApi isWXAppInstalled]) {
            
            [QuHudHelper qu_showMessage:@"请安装微信客户端"];
            return;
        }
        
    }
    else if ([number integerValue] == SSDKPlatformSubTypeQQFriend || [number integerValue] == SSDKPlatformSubTypeQZone){
        
        if (![QQApiInterface isQQInstalled]) {
            
            [QuHudHelper qu_showMessage:@"请安装QQ客户端"];
            return;
        }
    }
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    
    if ([number integerValue] == SSDKPlatformTypeSinaWeibo) {
        
        [shareParams SSDKSetupShareParamsByText:self.shareModel.content
                                         images:self.shareModel.imageUrl
                                            url:[NSURL URLWithString:self.shareModel.targetUrl]
                                          title:self.shareModel.title
                                           type:SSDKContentTypeAuto];
    }
    else if([number integerValue] == SSDKPlatformTypeSMS) {
        
        [shareParams SSDKSetupShareParamsByText:self.shareModel.content
                                         images:nil
                                            url:[NSURL URLWithString:self.shareModel.targetUrl]
                                          title:self.shareModel.title
                                           type:SSDKContentTypeAuto];
    }
    else{
        
        [shareParams SSDKSetupShareParamsByText:self.shareModel.content
                                         images:self.shareModel.imageUrl
                                            url:[NSURL URLWithString:self.shareModel.targetUrl]
                                          title:self.shareModel.title
                                           type:SSDKContentTypeAuto];
    }

    //进行分享
    [ShareSDK share:[number integerValue]
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
         switch (state) {
                 
             case SSDKResponseStateBegin:
             {
                 //设置UI等操作
                 break;
             }
             case SSDKResponseStateSuccess:
             {
                 if (self.shareSuccessBlock) {
                     self.shareSuccessBlock();
                 }
                 break;
             }
             case SSDKResponseStateFail:
             {
                 NSLog(@"%@",error);
                 if (self.shareFailBlock) {
                     self.shareFailBlock();
                 }
                 break;
             }
             case SSDKResponseStateCancel:
             {
                 
                 break;
             }
             default:
                 break;
         }

     }];
    
    [self dismissAlertShow];
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

#pragma mark tapGestureRecgnizerdelegate 解决手势冲突
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[UICollectionView class]]){
        return NO;
    }

    return YES;
}

@end
