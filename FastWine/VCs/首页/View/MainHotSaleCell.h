//
//  MainHotSaleCell.h
//  FastWine
//
//  Created by MOOSON_ on 2019/6/4.
//  Copyright © 2019 MOOSON_. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
static NSString *MainHotSaleCellID = @"MainHotSaleCell";

@interface MainHotSaleCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *ibImg;
@property(nonatomic,strong)NSArray *dataArr;
@property (weak, nonatomic) IBOutlet UIView *ibBtnbgView;
@property(nonatomic,copy)void(^itemClickBlock)(MainCategoryModel *model);
@end

NS_ASSUME_NONNULL_END
