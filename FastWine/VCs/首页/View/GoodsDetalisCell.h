//
//  GoodsDetalisCell.h
//  FastWine
//
//  Created by MOOSON_ on 2019/3/28.
//  Copyright © 2019年 MOOSON_. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCycleScrollView.h"
#import "JdWKWebView.h"
NS_ASSUME_NONNULL_BEGIN

@interface GoodsDetalisCell : UITableViewCell
@property(nonatomic,strong)GoodsDetalisModel *viewModel;
@property(nonatomic,strong)GoodsDetalisModel *killgoodsViewModel;
@property(nonatomic,strong)ReplyModel *replyModel;

@property (weak, nonatomic) IBOutlet SDCycleScrollView *ibGoodsImgView;
@property (weak, nonatomic) IBOutlet UILabel *ibGoodsPic;
@property (weak, nonatomic) IBOutlet UILabel *ibOtPicLab;
@property (weak, nonatomic) IBOutlet UILabel *ibGoodsOldPic;
@property (weak, nonatomic) IBOutlet UILabel *ibGoodsName;
@property (weak, nonatomic) IBOutlet UILabel *ibimgsNumberLab;
@property (weak, nonatomic) IBOutlet UILabel *ibGoodsSales;//销量
@property (weak, nonatomic) IBOutlet UIView *ibWebViewBgV;

@property(nonatomic,strong)WKWebView *wkWebView;

@property (weak, nonatomic) IBOutlet UILabel *ibHaopingLab;
@property (weak, nonatomic) IBOutlet UILabel *ibReplyNumLab;
@property (weak, nonatomic) IBOutlet UIImageView *ibIconLab;
@property (weak, nonatomic) IBOutlet UILabel *ibNameLab;
@property (weak, nonatomic) IBOutlet UILabel *ibVipLab;
@property (weak, nonatomic) IBOutlet UIView *ibStarView;
@property (weak, nonatomic) IBOutlet UILabel *ibTime;
@property (weak, nonatomic) IBOutlet UILabel *ibContentLab;
@property (weak, nonatomic) IBOutlet UIImageView *ibImageOne;
@property (weak, nonatomic) IBOutlet UIImageView *ibImageTwo;
@property (weak, nonatomic) IBOutlet UIImageView *ibImagethree;
@property (weak, nonatomic) IBOutlet UIView *ibImagesView;
@property (weak, nonatomic) IBOutlet UILabel *ibStockLab;
@property (weak, nonatomic) IBOutlet UICollectionView *ibImgCollectionView;
@property(nonatomic,copy)void(^collectionViewLoadFinish)(CGFloat webH);


@property (weak, nonatomic) IBOutlet UILabel *ibPic;
@property (weak, nonatomic) IBOutlet UILabel *ibXInagliang;
@property (weak, nonatomic) IBOutlet UILabel *ibKucun;
@property (weak, nonatomic) IBOutlet UILabel *ibDaojishi;
@property (weak, nonatomic) IBOutlet UIView *ibMiaoshaView;

@property (weak, nonatomic) IBOutlet UILabel *ibXiangxingLab;
@property (weak, nonatomic) IBOutlet UILabel *ibShengchandizhiLab;
@property (weak, nonatomic) IBOutlet UILabel *ibBaozhuangguigeLab;
@property (weak, nonatomic) IBOutlet UILabel *ibJInghanliangLab;
@property (weak, nonatomic) IBOutlet UILabel *ibCunachutiaojianLab;
@property (weak, nonatomic) IBOutlet UILabel *ibJiujingduLab;

@property (weak, nonatomic) IBOutlet UIView *ibShuxingView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ibImgCollectionTop;

@end

NS_ASSUME_NONNULL_END
