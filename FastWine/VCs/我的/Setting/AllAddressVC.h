//
//  AllAddressVC.h
//  FastWine
//
//  Created by MOOSON_ on 2019/5/14.
//  Copyright © 2019年 MOOSON_. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class EPAddressModel;
typedef void(^ChangeReceiceAddress)(EPAddressModel *newAddress);
@interface AllAddressVC : UIViewController{
    ChangeReceiceAddress _receiveAddress;
}
@property (nonatomic, assign) BOOL isFeedUp;

-(void)setAddressBlock:(ChangeReceiceAddress)block;

-(ChangeReceiceAddress)addressBlock;
@end

NS_ASSUME_NONNULL_END
