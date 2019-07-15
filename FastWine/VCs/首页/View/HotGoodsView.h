//
//  HotGoodsView.h
//  FastWine
//
//  Created by MOOSON_ on 2019/6/5.
//  Copyright © 2019 MOOSON_. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HotGoodsView : UIView
@property(nonatomic,strong)MainCategoryModel *dataModel;

@property (weak, nonatomic) IBOutlet UIImageView *ibImg;
@property (weak, nonatomic) IBOutlet UILabel *ibName;
@property (weak, nonatomic) IBOutlet UILabel *ibPic;
@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) UIView *topView;
@property (nonatomic,strong) UIView *bottomView;
@property (nonatomic,strong) UIButton *imageBtn;
@property (nonatomic,strong) UILabel *namelabel;
@property (nonatomic,strong) UILabel *piclabel;
@property (nonatomic,strong) UIButton *clickbtn;
@property(nonatomic,copy)void(^itemClickBlock)(MainCategoryModel *model);

@end

NS_ASSUME_NONNULL_END
