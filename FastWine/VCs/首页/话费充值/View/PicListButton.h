//
//  PicListButton.h
//  FastWine
//
//  Created by MOOSON_ on 2019/4/17.
//  Copyright © 2019年 MOOSON_. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PicListButton : UIButton
@property(nonatomic,strong)UILabel *subTitleLab;
@property(nonatomic,strong)UILabel *titleLab;
@property(nonatomic,strong)NSString *titleStr;
@property(nonatomic,strong)NSString *subtitleStr;


@end

NS_ASSUME_NONNULL_END
