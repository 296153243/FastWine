//
//  KanListTableCell.h
//  FastWine
//
//  Created by MOOSON_ on 2019/7/18.
//  Copyright © 2019 MOOSON_. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KanListTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *ibUserImg;
@property (weak, nonatomic) IBOutlet UILabel *ibUserName;
@property (weak, nonatomic) IBOutlet UILabel *ibPicLab;

@end

NS_ASSUME_NONNULL_END
