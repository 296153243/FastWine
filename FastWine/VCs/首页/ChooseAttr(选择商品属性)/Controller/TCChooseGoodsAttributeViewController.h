//
//  TCChooseGoodsAttributeViewController.h
//  TCMall
//
//  Created by Huazhixi on 2018/3/14.
//  Copyright © 2018年 HJB. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "TCConfirmOrderModel.h"

@interface TCChooseGoodsAttributeViewController : UIViewController
/**   */
@property (nonatomic, copy) NSString *goods_id;
/** 是否从购物车弹出  */
@property (nonatomic, assign) BOOL isFromBuyCart;

@property (nonatomic,strong)UIViewController *fatherVC;
/**     */
//@property (strong, nonatomic) GoodsDetalisRsp *goodsModel;
@property (strong, nonatomic) NSDictionary *dataDic;

/**   */
@property (nonatomic, copy) NSString *goods_img;
/**     */
@property (nonatomic, assign) NSInteger store_id;

@property (nonatomic, assign) BOOL fromBuyNowBtn;
- (void)dismissViewBtnClick;

@property(nonatomic,copy)void(^goBuyBlok)(UIViewController *vc,NSString *unqi,NSInteger goodsNum);
@end
