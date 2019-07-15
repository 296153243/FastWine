//
//  SecondskillCell.h
//  FastWine
//
//  Created by MOOSON_ on 2019/6/18.
//  Copyright © 2019 MOOSON_. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SecondskillCell : UITableViewCell

@property(nonatomic,strong)NSArray *dataArr;
@property(nonatomic)NSInteger viewStatus;
@property (weak, nonatomic) IBOutlet UIButton *ibCellBtn;
@property(nonatomic,copy)void(^btnClickBlock)(NSInteger btnTag);
@end

NS_ASSUME_NONNULL_END
