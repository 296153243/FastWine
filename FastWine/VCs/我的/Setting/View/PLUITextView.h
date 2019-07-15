//
//  PLUITextView.h
//  FastWine
//
//  Created by MOOSON_ on 2019/3/25.
//  Copyright © 2019年 MOOSON_. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PLUITextView : UITextView
/** 占位文字 /
 / 占位文字颜色 */
@property(nonatomic, copy) NSString *placeholder;

@property(nonatomic, strong) UIColor *placeholderColor;

@property(nonatomic,copy)void(^textViewTextBlock)(NSString *textViewtextStr);
@end

NS_ASSUME_NONNULL_END
