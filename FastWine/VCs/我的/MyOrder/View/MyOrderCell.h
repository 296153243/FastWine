//
//  MyOrderCell.h
//  FastWine
//
//  Created by MOOSON_ on 2019/3/20.
//  Copyright © 2019年 MOOSON_. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyOrderCell : UITableViewCell
@property(nonatomic,strong)OrderListModel *viewModel;
@property(nonatomic,strong)PlaceOrderModel *goodsModel;

@property (weak, nonatomic) IBOutlet UILabel *ibOrderNumberLab;
@property (weak, nonatomic) IBOutlet UILabel *ibOrderStatusLab;
@property (weak, nonatomic) IBOutlet UIImageView *IBGoodsImg;
@property (weak, nonatomic) IBOutlet UILabel *ibFootName;
@property (weak, nonatomic) IBOutlet UILabel *ibFootNum;
@property (weak, nonatomic) IBOutlet UILabel *ibFootPic;
@property (weak, nonatomic) IBOutlet UILabel *ibBuyTime;
@property (weak, nonatomic) IBOutlet UILabel *ibLineLab;
@property (weak, nonatomic) IBOutlet UIButton *ibCnacelBtn;
@property (weak, nonatomic) IBOutlet UIButton *ibPayBtn;
@property (weak, nonatomic) IBOutlet UIView *ibBootomView;
@property (weak, nonatomic) IBOutlet UIButton *ibPingJIaBtn;

@property(nonatomic,copy)void(^PayClick)(NSString *btnTitleStr);
@property(nonatomic,copy)void(^CancelClick)(NSString *btnTitleStr);
@property(nonatomic,copy)void(^EvaluationClick)(PlaceOrderModel *goodsModel);

@end

NS_ASSUME_NONNULL_END
