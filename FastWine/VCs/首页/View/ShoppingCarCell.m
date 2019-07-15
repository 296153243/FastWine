//
//  ShoppingCarCell.m
//  FastWine
//
//  Created by MOOSON_ on 2019/4/28.
//  Copyright © 2019年 MOOSON_. All rights reserved.
//

#import "ShoppingCarCell.h"

@implementation ShoppingCarCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)addTheValue:(AddShoppingCarModel *)goodsModel
{
    [self.ibGoodsImg sd_setImageWithURL:[NSURL URLWithString:goodsModel.productInfo.image] placeholderImage:[UIImage imageNamed:@"goods_noImage"]];
    self.ibGoodsName.text = goodsModel.productInfo.store_name;
    self.ibGoodsAttribute.text = goodsModel.productInfo.attrInfo.suk;
   
    self.ibGoodsNumTF.text=[NSString stringWithFormat:@"%ld",(long)goodsModel.cart_num];
    self.ibGoodsPic.text = [NSString stringWithFormat:@"¥ %@",goodsModel.truePrice];
    
    if (goodsModel.selectState){
        self.selectState = YES;
//        [self.ibselectBtn setImage:[UIImage imageNamed:@"5"] forState:UIControlStateNormal];
        self.ibselectBtn.selected = YES;
    }else{
        
        self.selectState = NO;
         self.ibselectBtn.selected = NO;
    }
    
    if (goodsModel.cart_num > 1) {
        [_ibMinusBtn setImage:[UIImage imageNamed:@"jianhao_black"] forState:UIControlStateNormal];
    }else{
         [_ibMinusBtn setImage:[UIImage imageNamed:@"jianhao"] forState:UIControlStateNormal];
    }
    
}
//
-(IBAction)selectBtnAction:(UIButton *)sender{
    
    [self.delegate btnClick:self andFlag:(int)sender.tag];

}
//
//减号
- (IBAction)ibDeleteBtnClick:(UIButton *)sender {
//    NSInteger goodsNum=[self.ibGoodsNumTF.text integerValue];
//    if (goodsNum>1) {
//        goodsNum-=1;
//        self.ibGoodsNumTF.text=[NSString stringWithFormat:@"%ld",(long)goodsNum];
////        NSInteger remianedNum=[self.remianedNumLab.text integerValue]+1;
////        self.remianedNumLab.text=[NSString stringWithFormat:@"%ld",(long)remianedNum];
//
//
//    }
    [self.delegate btnClick:self andFlag:(int)sender.tag];

    ////////
    //判断是否选中，选中才能点击
//    if (self.selectState == YES)
//    {
//        //调用代理
//    }
}
//加号
- (IBAction)ibAddBtnClick:(UIButton *)sender {
    //    NSInteger goodsNum=[self.goodsNumTF.text integerValue];
    //    if ([self.remianedNumLab.text integerValue]>0) {
    //        goodsNum+=1;
    //        self.goodsNumTF.text=[NSString stringWithFormat:@"%ld",(long)goodsNum];
    //        NSInteger remianedNum=[self.remianedNumLab.text integerValue]-1;
    //        self.remianedNumLab.text=[NSString stringWithFormat:@"%ld",(long)remianedNum];
    //    }
    ///////
    //调用代理
    [self.delegate btnClick:self andFlag:(int)sender.tag];
    
    if (self.selectState == YES)
    {
       
    }
}

@end
