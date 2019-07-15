//
//  AddressModel.m
//  EricProject
//
//  Created by boosal on 17/3/18.
//  Copyright © 2017年 enzuo. All rights reserved.
//

#import "AddressModel.h"

@implementation AddressModel

-(id)copyWithZone:(NSZone *)zone{
    AddressModel *model = [[AddressModel alloc] init];
    
    u_int count;
    objc_property_t *propertyList = class_copyPropertyList([self class], &count);
    
    for (int index = 0; index < count; index++) {
        objc_property_t property = propertyList[index];
        NSString *str = [NSString stringWithUTF8String:property_getName(property)];
        
        id value = [self valueForKey:str];
        [model setValue:value forKey:str];
    }
    
    free(propertyList);
    return model;
}

@end
