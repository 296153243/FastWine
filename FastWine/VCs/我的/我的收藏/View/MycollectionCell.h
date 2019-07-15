//
//  MycollectionCell.h
//  FastWine
//
//  Created by MOOSON_ on 2019/5/5.
//  Copyright © 2019年 MOOSON_. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MycollectionCell : UITableViewCell
@property(nonatomic,strong)CollectListModel *viewModel;
@property (weak, nonatomic) IBOutlet UIImageView *ibIcon;
@property (weak, nonatomic) IBOutlet UILabel *ibName;
@property (weak, nonatomic) IBOutlet UILabel *ibPic;
@property (weak, nonatomic) IBOutlet UILabel *ibNum;
@property (weak, nonatomic) IBOutlet UIButton *ibDelectBtn;
@property(nonatomic,copy)void(^clickDelectBlock)(CollectListModel *model);
@end

NS_ASSUME_NONNULL_END
