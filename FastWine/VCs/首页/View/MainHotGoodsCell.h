//
//  MainHotGoodsCell.h
//  FastWine
//
//  Created by MOOSON_ on 2019/6/13.
//  Copyright © 2019 MOOSON_. All rights reserved.
//

#import <UIKit/UIKit.h>
static NSString * MainHotGoodsCellID = @"MainHotGoodsCell";
NS_ASSUME_NONNULL_BEGIN

@interface MainHotGoodsCell : UICollectionViewCell
@property(nonatomic,strong)NSArray *dataArr;
@property (weak, nonatomic) IBOutlet UIView *ibBtnbgView;
@property (weak, nonatomic) IBOutlet UIImageView *ibImageView;
@property(nonatomic,copy)void(^itemClickBlock)(MainCategoryModel *model);
@property(nonatomic,copy)void(^newsClickBlock)();
@end

NS_ASSUME_NONNULL_END
