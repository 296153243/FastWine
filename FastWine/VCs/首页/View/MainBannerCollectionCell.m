//
//  MainBannerCollectionCell.m
//  FastWine
//
//  Created by MOOSON_ on 2019/3/12.
//  Copyright © 2019年 MOOSON_. All rights reserved.
//

#import "MainBannerCollectionCell.h"
@interface MainBannerCollectionCell()<SDCycleScrollViewDelegate>

@end
@implementation MainBannerCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    SDCycleScrollView *cycleScrollView = [[SDCycleScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_SIZE.width, ScreenWidthRatio * 188)];
    _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 170) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
    _cycleScrollView.backgroundColor = [UIColor whiteColor];
    _cycleScrollView.delegate = self;
    _cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
    _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    _cycleScrollView.autoScrollTimeInterval = 3;
    _cycleScrollView.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
    _cycleScrollView.placeholderImage = [UIImage imageNamed:@"main_banner_default"];
    
    [self.contentView addSubview:_cycleScrollView];
    
//    self.cycleScrollView = cycleScrollView;
    
}


#pragma mark SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    if (self.mainBannerBlock) {
        self.mainBannerBlock(index);
      
    }
}

@end
