//
//  MainCollectionCell.h
//  FastWine
//
//  Created by MOOSON_ on 2019/3/12.
//  Copyright © 2019年 MOOSON_. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * MainCollectionCellID = @"MainCollectionCell";
NS_ASSUME_NONNULL_BEGIN

@interface MainCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *ibIconImg;
@property (weak, nonatomic) IBOutlet UILabel *ibTitleLab;

@end

NS_ASSUME_NONNULL_END
