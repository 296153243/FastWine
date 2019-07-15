//
//  GoodsImgCollectionCell.h
//  FastWine
//
//  Created by MOOSON_ on 2019/5/30.
//  Copyright © 2019 MOOSON_. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GoodsImgCollectionCell : UICollectionViewCell
@property(nonatomic,strong)NSString *imageUrl;
@property (weak, nonatomic) IBOutlet UIImageView *ibImgView;

@end

NS_ASSUME_NONNULL_END
