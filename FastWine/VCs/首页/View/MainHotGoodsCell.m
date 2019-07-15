//
//  MainHotGoodsCell.m
//  FastWine
//
//  Created by MOOSON_ on 2019/6/13.
//  Copyright © 2019 MOOSON_. All rights reserved.
//

#import "MainHotGoodsCell.h"
#import "FLAnimatedImage.h"
@implementation MainHotGoodsCell

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
            
            if (idx == 0) {
                FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:[NSData dataWithContentsOfURL:[NSURL URLWithString:model.pic]]];
                
                FLAnimatedImageView *imageView = [[FLAnimatedImageView alloc] init];
                imageView.animatedImage = image;
                imageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, btn.frame.size.height + 3);
                [self.ibBtnbgView insertSubview:imageView atIndex:1];
//                [self.ibBtnbgView addSubview:imageView];
//                [self.ibBtnbgView sendSubviewToBack:imageView];
                imageView.userInteractionEnabled = YES;
                UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
                [imageView addGestureRecognizer:tapGesture];
                [btn removeFromSuperview];
            }
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
-(void)tapClick:(UITapGestureRecognizer *)tap{

    if (_newsClickBlock) {
        _newsClickBlock();
    }
    
}
- (IBAction)ibBtnAction:(UIButton *)sender {
    MainCategoryModel *model = _dataArr[sender.tag - 70];
    
    if (_itemClickBlock) {
        _itemClickBlock(model);
    }
}

@end
