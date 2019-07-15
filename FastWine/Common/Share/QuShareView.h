//
//  QuShareView.h
//  QuPassenger
//
//  Created by Zhuqing on 2017/11/27.
//  Copyright © 2017年 com.Qyueche. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QuShareShowView.h"

@interface QuShareView : NSObject <UICollectionViewDelegate,UICollectionViewDataSource,UIGestureRecognizerDelegate>
{
    UIView *backgroundView;
    
    NSMutableArray *alertViewQueue;
}

@property (strong, nonatomic) QuShareModel *shareModel;
@property (strong, nonatomic) QuShareShowView *showView;
@property (copy, nonatomic) void (^shareSuccessBlock)(void);
@property (copy, nonatomic) void (^shareFailBlock)(void);

//- (id)initWithShareModel:(QuShareModel *)shareModel;
//- (void)show;

+ (QuShareView *)showShareWithModel:(QuShareModel *)shareModel success:(void (^)(void))shareSuccessBlock fail:(void (^)(void))shareFailBlock;

@end
