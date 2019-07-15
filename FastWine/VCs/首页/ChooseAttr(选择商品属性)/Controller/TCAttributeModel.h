//
//  TCAttributeModel.h
//  TCMall
//
//  Created by Huazhixi on 2018/4/14.
//  Copyright © 2018年 HJB. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AttributeInfo : NSObject
@property (nonatomic , copy) NSString              * tabName;
@property (nonatomic , copy) NSString              * tabValue;
@end

@interface Attribute : NSObject
@property (nonatomic , assign) NSInteger              product_id;
@property (nonatomic , assign) NSInteger              spec_id;
@property (nonatomic , copy) NSString              * spec_1;
@property (nonatomic , copy) NSString              * sales;
@property (nonatomic , copy) NSString              * cost;
@property (nonatomic , copy) NSString              * unique;
//@property (nonatomic)double               price;
@property (nonatomic , copy) NSString              * price;
@property (nonatomic , copy) NSString              * vip_price;
@property (nonatomic , copy) NSString              * stock;
@property (nonatomic , copy) NSString              * suk;
@property (nonatomic , copy) NSString              * image;
@property (nonatomic , copy) NSArray<AttributeInfo *>              * info;

@property (nonatomic , copy) NSString              * attr_name;
@property (nonatomic , copy) NSArray              * attr_values;
@end

@interface AttributeCategery : NSObject
@property (nonatomic , copy) NSString              * product_id;
@property (nonatomic , copy) NSString              * attr_name;

@property (nonatomic , copy) NSArray<NSString *>              * attr_values;
@end

@interface TCAttributeModel : NSObject

@property (nonatomic , copy) NSArray<AttributeCategery *>              * productAttr;
@property (strong, nonatomic)NSDictionary *productValue;

@property (strong, nonatomic)NSMutableArray *productValues;
@end
