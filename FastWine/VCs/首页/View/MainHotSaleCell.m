//
//  MainHotSaleCell.m
//  FastWine
//
//  Created by MOOSON_ on 2019/6/4.
//  Copyright © 2019 MOOSON_. All rights reserved.
//

#import "MainHotSaleCell.h"

@implementation MainHotSaleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setDataArr:(NSArray *)dataArr{
    _dataArr = dataArr;
    if (_dataArr != nil) {
        [dataArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            UIButton *btn = [self.ibBtnbgView viewWithTag:idx + 70];
            btn.adjustsImageWhenHighlighted = NO;
            MainCategoryModel *model = obj;
//            [btn sd_setImageWithURL:[NSURL URLWithString:model.pic] forState:UIControlStateNormal];
//            [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:model.pic] forState:UIControlStateNormal];
            [btn sd_setBackgroundImageWithURL:[NSURL URLWithString:model.pic] forState:UIControlStateNormal completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                UIImage *refined = [UIImage imageWithCGImage:image.CGImage scale:2 orientation:image.imageOrientation];
//                [btn setImage:refined forState:UIControlStateNormal];
                [btn setBackgroundImage:refined forState:UIControlStateNormal ];
            }];
         
        }];
    }
}
- (IBAction)ibBtnAction:(UIButton *)sender {
    MainCategoryModel *model = _dataArr[sender.tag - 70];
    
    if (_itemClickBlock) {
        _itemClickBlock(model);
    }
}

@end
