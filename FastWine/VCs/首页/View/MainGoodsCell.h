//
//  MainGoodsCell.h
//  FastWine
//
//  Created by MOOSON_ on 2019/6/13.
//  Copyright © 2019 MOOSON_. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
static NSString * MainGoodsCellID = @"MainGoodsCell";

@interface MainGoodsCell : UICollectionViewCell
@property(nonatomic,strong)MainGoodsModel *viewModel;
@property(nonatomic,copy)void(^buyBtnCickBlock)(MainGoodsModel *goodsmodel);
@end

NS_ASSUME_NONNULL_END
