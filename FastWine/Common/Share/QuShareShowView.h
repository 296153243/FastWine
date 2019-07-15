//
//  QuShareShowView.h
//  QuPassenger
//
//  Created by Zhuqing on 2017/11/27.
//  Copyright © 2017年 com.Qyueche. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuShareShowView : UIView

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UICollectionView *shareCollectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cancelBottomConstraint;

@end
