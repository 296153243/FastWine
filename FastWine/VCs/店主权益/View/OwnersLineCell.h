//
//  OwnersLineCell.h
//  FastWine
//
//  Created by MOOSON_ on 2019/7/11.
//  Copyright © 2019 MOOSON_. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
static NSString * OwnersLineCellID = @"OwnersLineCell";

@interface OwnersLineCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIButton *ibTitleLab;

@end

NS_ASSUME_NONNULL_END
