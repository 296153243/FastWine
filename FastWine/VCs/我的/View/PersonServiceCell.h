//
//  PersonServiceCell.h
//  FastWine
//
//  Created by MOOSON_ on 2019/6/10.
//  Copyright © 2019 MOOSON_. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AllAddressVC.h"
NS_ASSUME_NONNULL_BEGIN
static NSString * PersonServiceCellID = @"PersonServiceCell";

@interface PersonServiceCell : UICollectionViewCell
@property(nonatomic,strong)JDBaseVC *controller;
@property (weak, nonatomic) IBOutlet UIButton *ibDianzhuqianyiBtn;

@end

NS_ASSUME_NONNULL_END
