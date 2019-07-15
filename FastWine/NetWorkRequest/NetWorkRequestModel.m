//
//  NetWorkRequestModel.m
//  GuangYiGuang_App
//
//  Created by Zhuqing on 16/7/3.
//  Copyright © 2016年 Zhuqing. All rights reserved.
//

#import "NetWorkRequestModel.h"
#import <objc/runtime.h>


@implementation NetWorkRequestModel

@end

@implementation BaseRequest

- (id)init
{
    if (self = [super init]) {

//        self.versionNo = CLIENT_VERSION;
//        self.channelNo = @"iOS";
//        self.device = [PublicManager getDeviceId];

    }
    return self;
    
}
//2、/* 获取对象的所有属性 以及属性值 */

- (NSDictionary *)properties_aps

{
    
    NSMutableDictionary *props = [NSMutableDictionary dictionary];
    
    unsigned int outCount, i;
    
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    
    for (i = 0; i<outCount; i++)
        
    {
        
        objc_property_t property = properties[i];
        
        const char* char_f =property_getName(property);
        
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        
        id propertyValue = [self valueForKey:(NSString *)propertyName];
        
        if (propertyValue) [props setObject:propertyValue forKey:propertyName];
        
    }
    
    free(properties);
    
    return props;
    
}
@end

@implementation BaseResponse

@end
@implementation BasePageResponse



@end
@implementation PageResponse

@end

@implementation OrderNumRsp

@end

@implementation OrderDetailsReq

@end
@implementation OrderDetailsModel

@end
@implementation QuUserInfo


@end

@implementation CheckCodeRsp


@end
@implementation RegistReq


@end
@implementation GetCodeReq


@end
@implementation WarningListReq


@end

@implementation WarningModel

@end

@implementation WarningRsp

-(id)init{
    
    if (self == [super init]) {
        [WarningRsp mj_setupObjectClassInArray:^NSDictionary *{
            return @{@"data":@"WarningModel"};
        }];
    }
    return self;
}

@end

@implementation PhoneOrderListModel

@end

@implementation PhoneOrderListRsp

-(id)init{
    
    if (self == [super init]) {
        [PhoneOrderListRsp mj_setupObjectClassInArray:^NSDictionary *{
            return @{@"data":@"PhoneOrderListModel"};
        }];
    }
    return self;
}

@end
@implementation AddShoppingCarModel

@end

@implementation AddShoppingCarRsp

-(id)init{
    
    if (self == [super init]) {
        [AddShoppingCarRsp mj_setupObjectClassInArray:^NSDictionary *{
            return @{@"valid":@"AddShoppingCarModel"};
        }];
    }
    return self;
}

@end
@implementation AddShoppingReq

@end
@implementation PlaceOrderModel

@end
@implementation PriceGroupModel

@end

@implementation PlaceOrderRsp

-(id)init{
    
    if (self == [super init]) {
        [PlaceOrderRsp mj_setupObjectClassInArray:^NSDictionary *{
            return @{@"cartInfo":@"PlaceOrderModel"};
        }];
    }
    return self;
}

@end
@implementation WarningDetalisModel

@end

@implementation DeleteAddressReq

@end
@implementation AddMyAddressReq


@end


@implementation LoginReq


@end
@implementation LoginOutReq


@end

@implementation UserInfoUploadImgReq

@end
@implementation EvaluationReq

@end

@implementation getInformationReq


@end

@implementation BindWeChatReq


@end

@implementation BindWeChatRsp


@end

@implementation CheckWeChatCodeReq


@end
@implementation AgentModel


@end
@implementation getInformationRsp


@end
@implementation CheckWeChatCodeRsp


@end

@implementation AutoLoginReq


@end

@implementation AutoLoginRsp


@end

@implementation GetPersonalInformationReq


@end

@implementation GetPersonalInformationRsp


@end

@implementation GetCityReq


@end

@implementation GetCityRsp

- (id)init{
    if (self = [super init]) {
        [GetCityRsp mj_setupObjectClassInArray:^NSDictionary *{
            return @{@"data" : @"QuCityModel",
                     @"data1" : @"QuCityModel"};
        }];
    }
    return self;
}
@end


@implementation StopCarReq

@end

@implementation ParkListReq

@end
@implementation CheckPayReq

@end

@implementation MainBannerModel


@end
@implementation AttrInfoModel

@end
@implementation MainGoodsModel

@end
@implementation MainGoodsRsp

-(id)init{
    
    if (self == [super init]) {
        [MainGoodsRsp mj_setupObjectClassInArray:^NSDictionary *{
            return @{@"data":@"MainGoodsModel"};
        }];
    }
    return self;
}

@end

@implementation VipGoodsRsp

-(id)init{
    
    if (self == [super init]) {
        [VipGoodsRsp mj_setupObjectClassInArray:^NSDictionary *{
            return @{@"list":@"MainGoodsModel",
                     @"list2":@"MainGoodsModel",
                     @"list3":@"MainGoodsModel"
                     };
        }];
    }
    return self;
}

@end
@implementation GoodsDetalisModel

@end
@implementation ReplyModel


@end
@implementation ReplyListRsp

-(id)init{
    
    if (self == [super init]) {
        [ReplyListRsp mj_setupObjectClassInArray:^NSDictionary *{
            return @{@"data":@"ReplyModel"
                     };
        }];
    }
    return self;
}

@end
@implementation GoodsDetalisRsp

-(id)init{
    
    if (self == [super init]) {
        [GoodsDetalisRsp mj_setupObjectClassInArray:^NSDictionary *{
            return @{@"storeInfo":@"GoodsDetalisModel"
                     };
        }];
    }
    return self;
}

@end

@implementation PlaceOrderReq


@end

@implementation AddCarReq


@end


@implementation OrderModelRsp
-(id)init{
    
    if (self == [super init]) {
        [OrderModelRsp mj_setupObjectClassInArray:^NSDictionary *{
            return @{@"data":@"OrderModel"};
        }];
    }
    return self;
}

@end

@implementation OrderModel

@end
@implementation CancelOrderReq


@end

@implementation DeleteMyCarReq

@end

@implementation AddMyCarReq

@end
@implementation BindingObdReq

@end
@implementation DeviceInfoKey


@end
@implementation GetDeviceLocationReq
- (NSArray *)getAllProperties
{
    
    u_int count;
    
    objc_property_t *properties  =class_copyPropertyList([self class], &count);
    
    NSMutableArray *propertiesArray = [NSMutableArray arrayWithCapacity:count];
    
    for (int i = 0; i<count; i++)
        
    {
        
        const char* propertyName =property_getName(properties[i]);
        
        [propertiesArray addObject: [NSString stringWithUTF8String: propertyName]];
        
    }
    
    free(properties);
    
    return propertiesArray;
    
}
//2、/* 获取对象的所有属性 以及属性值 */

- (NSDictionary *)properties_aps

{
    
    NSMutableDictionary *props = [NSMutableDictionary dictionary];
    
    unsigned int outCount, i;
    
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    
    for (i = 0; i<outCount; i++)
        
    {
        
        objc_property_t property = properties[i];
        
        const char* char_f =property_getName(property);
        
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        
        id propertyValue = [self valueForKey:(NSString *)propertyName];
        
        if (propertyValue) [props setObject:propertyValue forKey:propertyName];
        
    }
    
    free(properties);
    
    return props;
    
}
@end
@implementation ExpressInfoReq

@end
@implementation ExpressInfoModel



@end
@implementation ExpressInfoRsp
- (id)init{
    if (self == [super init]) {
        [ExpressInfoRsp mj_setupObjectClassInArray:^NSDictionary *{
            return @{@"data":@"ExpressInfoModel"};
        }];
    }
    return self;
}
@end
@implementation TripListModel



@end
@implementation TripListRsp
- (id)init{
    if (self == [super init]) {
        [TripListRsp mj_setupObjectClassInArray:^NSDictionary *{
            return @{@"rows":@"TripListModel"};
        }];
    }
    return self;
}
@end

@implementation OrderListReq

@end
@implementation OrderListModel
-(void)setCartInfo:(NSDictionary *)cartInfo{
    _cartInfo = cartInfo;
    if (_cartInfo) {
        NSMutableArray *dicToArray = [NSMutableArray array];
        [_cartInfo enumerateKeysAndObjectsUsingBlock:^(id _Nonnull key, id _Nonnull obj, BOOL * _Nonnull stop) {
            
            PlaceOrderModel *model = [PlaceOrderModel mj_objectWithKeyValues:obj];
            [dicToArray addObject:model];
      
            
        }];
    _cartInfos = dicToArray;
//    NSLog(@"dicToArray====%@",_cartInfos);
    }
}
@end
@implementation OrderStatusModel


@end
@implementation OrderListRsp
-(id)init{
    
    if (self == [super init]) {
        [OrderListRsp mj_setupObjectClassInArray:^NSDictionary *{
            return @{@"data":@"OrderListModel"};
        }];
    }
    return self;
}

@end


@implementation AfenceModel

@end
@implementation AfencetListRsp
-(id)init{
    
    if (self == [super init]) {
        [AfencetListRsp mj_setupObjectClassInArray:^NSDictionary *{
            return @{@"data":@"AfenceModel"};
        }];
    }
    return self;
}
@end

@implementation UpdateRailReq

@end

@implementation OBDDataModel

@end
@implementation OBDDataModelRsp
-(id)init{
    
    if (self == [super init]) {
        [OBDDataModelRsp mj_setupObjectClassInArray:^NSDictionary *{
            return @{@"data":@"OBDDataModel"};
        }];
    }
    return self;
}
@end
@implementation CarInfoModel

@end
@implementation CarInfoRsp
-(id)init{
    
    if (self == [super init]) {
        [CarInfoRsp mj_setupObjectClassInArray:^NSDictionary *{
            return @{@"data":@"CarInfoModel"};
        }];
    }
    return self;
}
@end
@implementation CarCodeModel

@end
@implementation CarCodeRsp
-(id)init{
    
    if (self == [super init]) {
        [CarCodeRsp mj_setupObjectClassInArray:^NSDictionary *{
            return @{@"obdSys":@"CarCodeModel"};
        }];
    }
    return self;
}
@end

@implementation ChargPicListModel

@end
@implementation ChargPicListRsp
-(id)init{
    
    if (self == [super init]) {
        [ChargPicListRsp mj_setupObjectClassInArray:^NSDictionary *{
            return @{@"data":@"ChargPicListModel"};
        }];
    }
    return self;
}
@end

@implementation AliPreOrderReq

@end
@implementation AliPreOrderRsp

@end
@implementation AliPreOrderModel

@end

@implementation WXPayModel
@end
@implementation WXPayRsp

@end

@implementation MessageListReq

@end
@implementation MessageListModel


@end
@implementation MessageListRsp

-(id)init{
    
    if (self == [super init]) {
        [MessageListRsp mj_setupObjectClassInArray:^NSDictionary *{
            return @{@"list":@"MessageListModel"};
        }];
    }
    return self;
}

@end
@implementation MessageDetalisReq


@end
@implementation GetWalletReq
@end

@implementation GetWalletModel
-(id)init{
    
    if (self == [super init]) {
        [GetWalletModel mj_setupObjectClassInArray:^NSDictionary *{
            return @{@"list":@"MainGoodsModel",
                     @"promotion_product":@"MainGoodsModel"
                     };
        }];
    }
    return self;
}
@end

@implementation GetWalletRsp


@end

@implementation AccountRecordReq

@end
@implementation AccountRecordModel

@end
@implementation AccountRecordRsp
-(id)init{
    if (self == [super init]) {
        [AccountRecordRsp mj_setupObjectClassInArray:^NSDictionary *{
            return @{@"data":@"AccountRecordModel"};
        }];
    }
    return self;
}
@end
@implementation UploadImgModel

@end
@implementation UploadImgRsp
-(id)init{
    if (self == [super init]) {
        [UploadImgRsp mj_setupObjectClassInArray:^NSDictionary *{
            return @{@"data":@"UploadImgModel"};
        }];
    }
    return self;
}
@end


@implementation QuShareModel
@end

@implementation ShareThemeRsp
@end

@implementation RechargeReq
@end

@implementation AlipayModel
@end

@implementation PayMoneyReq
@end

@implementation PayMoneyRsp
@end

@implementation PhoneCheckReq

@end


@implementation CityListRsp
-(id)init{
    if (self == [super init]) {
        [CityListRsp mj_setupObjectClassInArray:^NSDictionary *{
            return @{@"data":@"QuCityModel"};
        }];
        
    }
    return self;
}

@end

@implementation GetCompanyReq

@end
@implementation WaterCardListModel

@end

@implementation WaterCardListRsp

-(id)init{
    
    if (self == [super init]) {
        [WaterCardListRsp mj_setupObjectClassInArray:^NSDictionary *{
            return @{@"info":@"WaterCardListModel"};
        }];
    }
    return self;
}
@end
@implementation AddWaterCardReq


@end
@implementation WaterBillsModel


@end
@implementation WaterPlaceOrderReq


@end
@implementation CouponListReq

@end
@implementation CouponListModel


@end

@implementation CouponListRsp
- (instancetype)init{
    if (self == [super init]) {
        [CouponListRsp mj_setupObjectClassInArray:^NSDictionary *{
            return @{@"couponList":@"CouponListModel"};
        }];
    }
    return self;
}
@end
@implementation CouponRsp
- (instancetype)init{
    if (self == [super init]) {
        [CouponRsp mj_setupObjectClassInArray:^NSDictionary *{
            return @{@"data":@"CouponListModel"};
        }];
    }
    return self;
}
@end
@implementation BalanceListModel


@end

@implementation BalanceListRsp
- (instancetype)init{
    if (self == [super init]) {
        [BalanceListRsp mj_setupObjectClassInArray:^NSDictionary *{
            return @{@"list":@"BalanceListModel"};
        }];
    }
    return self;
}
@end
@implementation PromoterListModel


@end

@implementation PromoterListRsp
- (instancetype)init{
    if (self == [super init]) {
        [PromoterListRsp mj_setupObjectClassInArray:^NSDictionary *{
            return @{@"info":@"PromoterListModel"};
        }];
    }
    return self;
}
@end
@implementation CollectListModel


@end

@implementation CollectListRsp
- (instancetype)init{
    if (self == [super init]) {
        [CollectListRsp mj_setupObjectClassInArray:^NSDictionary *{
            return @{@"data":@"CollectListModel"};
        }];
    }
    return self;
}
@end
@implementation WithdrawalReq

@end
@implementation WithdrawalModel

@end
@implementation WithdrawalRsp

@end
@implementation GoodsSearchReq


@end
@implementation PSSlideModel

@end
@implementation MainCategoryModel

@end
@implementation GoodsClassModel

@end

@implementation GoodsClassRsp

-(id)init{
    
    if (self == [super init]) {
        [GoodsClassRsp mj_setupObjectClassInArray:^NSDictionary *{
            return @{@"data":@"GoodsClassModel"};
        }];
    }
    return self;
}

@end

@implementation MainFictitious

@end

@implementation KillReq


@end

@implementation IhavegoodsReq


@end
