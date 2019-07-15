//
//  MainBannerCollectionCell.h
//  FastWine
//
//  Created by MOOSON_ on 2019/3/12.
//  Copyright © 2019年 MOOSON_. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCycleScrollView.h"
static NSString * MainBannerCollectionCellID = @"MainBannerCollectionCell";

@interface MainBannerCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet SDCycleScrollView *ibCycleScroollView;
@property (strong, nonatomic) SDCycleScrollView *cycleScrollView;
@property (copy, nonatomic) void (^mainBannerBlock)(NSInteger idx);

@end
