//
//  OBDCollectionCell.h
//  FastWine
//
//  Created by MOOSON_ on 2019/3/12.
//  Copyright © 2019年 MOOSON_. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
static NSString * OBDCollectionCellID = @"OBDCollectionCell";
@interface OBDCollectionCell : UICollectionViewCell
@property(nonatomic,strong)MainGoodsModel *viewModel;
@end

NS_ASSUME_NONNULL_END
