//
//  TCAttributeModel.m
//  TCMall
//
//  Created by Huazhixi on 2018/4/14.
//  Copyright © 2018年 HJB. All rights reserved.
//

#import "TCAttributeModel.h"

@implementation AttributeInfo

@end

@implementation Attribute

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"info": @"AttributeInfo"
             };
}
@end

@implementation AttributeCategery

@end

@implementation TCAttributeModel

+ (NSDictionary *)mj_objectClassInArray
{
    return @{@"productAttr": @"AttributeCategery"
             
             };
}
-(void)setProductValue:(NSDictionary *)productValue{
    _productValue = productValue;
    if (_productValue) {
        NSMutableArray *dicToArray = [NSMutableArray array];
        [_productValue enumerateKeysAndObjectsUsingBlock:^(id _Nonnull key, id _Nonnull obj, BOOL * _Nonnull stop) {
            
            MainGoodsModel *model = [MainGoodsModel mj_objectWithKeyValues:obj];
            [dicToArray addObject:model];
            
            
        }];
        _productValues = dicToArray;
        //    NSLog(@"dicToArray====%@",_cartInfos);
    }
}
@end
