//
//  MainHotCakesCell.m
//  FastWine
//
//  Created by MOOSON_ on 2019/6/4.
//  Copyright © 2019 MOOSON_. All rights reserved.
//

#import "MainHotCakesCell.h"
#import "HotGoodsView.h"
@implementation MainHotCakesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setDataArr:(NSArray *)dataArr{
    _dataArr = dataArr;
    if (_dataArr != nil) {
        
        _ibScrollView.contentSize = CGSizeMake((SCREEN_WIDTH /4) * _dataArr.count, 100);
        _ibBgvW.constant = (SCREEN_WIDTH/4) * _dataArr.count;
        [self layoutIfNeeded];
//        NSLog(@"_ibBgvW:%@",NSStringFromCGRect(_ibBtnbgView.frame));
        [dataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

            CGFloat itemW = (SCREEN_WIDTH - 70)/4;
             MainCategoryModel *model = obj;
            HotGoodsView *goodsView = [[HotGoodsView alloc]initWithFrame:CGRectMake(((itemW + 10) * idx) + 20, 0, itemW, 120)];
            goodsView.itemClickBlock = ^(MainCategoryModel * _Nonnull model) {
                if (self.itemClickBlock) {
                    self.itemClickBlock(model);
                }
            };
            goodsView.dataModel = model;
            [self.ibBtnbgView addSubview:goodsView];
//            self.ibBtnbgView.backgroundColor = [UIColor grayColor];
         
        }];
    }
}
- (void)ibBtnAction:(UIButton *)sender {
    MainCategoryModel *model = _dataArr[sender.tag - 80];
    
  
}

@end
