//
//  BargainHeardCell.m
//  FastWine
//
//  Created by MOOSON_ on 2019/7/17.
//  Copyright © 2019 MOOSON_. All rights reserved.
//

#import "BargainHeardCell.h"
#define degreesToRadians(x) (M_PI * x / 180.0)
@implementation BargainHeardCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.ibLineImg.transform = CGAffineTransformRotate(self.ibLineImg.transform, M_PI);//控件旋转180

}

@end
