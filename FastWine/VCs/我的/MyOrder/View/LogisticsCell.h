//
//  LogisticsCell.h
//  FastWine
//
//  Created by MOOSON_ on 2019/4/4.
//  Copyright © 2019年 MOOSON_. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LogisticsCell : UITableViewCell

@property(nonatomic,strong)ExpressInfoModel *viewModel;
@property(nonatomic,strong)OrderListModel *goodsModel;
@property (weak, nonatomic) IBOutlet UIImageView *ibGoodsImg;
@property (weak, nonatomic) IBOutlet UILabel *ibgoodsNum;
@property (weak, nonatomic) IBOutlet UILabel *ibOrderNumber;
@property (weak, nonatomic) IBOutlet UIImageView *ibWuliuICon;
@property (weak, nonatomic) IBOutlet UILabel *iBWuliu;
@property (weak, nonatomic) IBOutlet UILabel *ibTime;
@property (weak, nonatomic) IBOutlet UILabel *ibTitle;
@property (weak, nonatomic) IBOutlet UILabel *ibContent;
@property (weak, nonatomic) IBOutlet UIImageView *ibIcon;

@end

NS_ASSUME_NONNULL_END
