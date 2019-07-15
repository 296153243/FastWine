//
//  ShoppingCarCell.h
//  FastWine
//
//  Created by MOOSON_ on 2019/4/28.
//  Copyright © 2019年 MOOSON_. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
//添加代理，用于按钮加减的实现
@protocol ShopCartCellDelegate <NSObject>
-(void)btnClick:(UITableViewCell *)cell andFlag:(int)flag;
@end
@interface ShoppingCarCell : UITableViewCell
@property (weak,nonatomic)IBOutlet UIButton *ibselectBtn;
@property (weak, nonatomic) IBOutlet UIImageView *ibGoodsImg;
@property (weak, nonatomic) IBOutlet UILabel *ibGoodsName;
@property (weak, nonatomic) IBOutlet UILabel *ibGoodsAttribute;
@property (weak, nonatomic) IBOutlet UILabel *ibGoodsPic;
@property (weak, nonatomic) IBOutlet UITextField *ibGoodsNumTF;
@property (weak, nonatomic) IBOutlet UIButton *ibAddBtn;
@property (weak, nonatomic) IBOutlet UIButton *ibMinusBtn;


@property(assign,nonatomic)BOOL selectState;//选中状态

//赋值
-(void)addTheValue:(AddShoppingCarModel *)goodsModel;
@property(assign,nonatomic)id<ShopCartCellDelegate>delegate;
@end

NS_ASSUME_NONNULL_END
