//
//  NetWorkRequestModel.h
//  GuangYiGuang_App
//
//  Created by Zhuqing on 16/7/3.
//  Copyright © 2016年 Zhuqing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetWorkRequestModel : NSObject

@end

@interface BaseRequest : NSObject

//@property (strong, nonatomic) NSString *versionNo;
//@property (strong, nonatomic) NSString *channelNo;
//@property (strong, nonatomic) NSString *device;
@property (strong, nonatomic) NSString *first;
@property (strong, nonatomic) NSString *page;
@property (strong, nonatomic) NSString *limit;
@property (strong, nonatomic) NSString *cId;
@property (strong, nonatomic) NSString *productId;

@property (strong, nonatomic)NSString *customer_id;
@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic)NSString *userid;
@property (strong, nonatomic)NSString *type;
@property (strong, nonatomic)NSString *status;

- (NSDictionary *)properties_aps;

@end

@interface PageResponse : NSObject

@property (assign, nonatomic) NSInteger begin;
@property (assign, nonatomic) NSInteger pageSize;
@property (assign, nonatomic) NSInteger totalRows;
@property (assign, nonatomic) NSInteger pageCount;
@property(strong,nonatomic) NSArray *itemPage;
@end

@interface BaseResponse : NSObject

//@property (strong, nonatomic) NSString *info;
@property (assign, nonatomic) NSInteger code;
@property (strong, nonatomic) NSString *msg;
@property (strong, nonatomic) NSString *date;
@end


@interface BasePageResponse : BaseResponse

@property (strong, nonatomic)PageResponse *data;
@end

//注册
@interface RegistReq : BaseRequest

@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSString *passwd;
@property (strong, nonatomic) NSString *pwd;
@property (strong, nonatomic) NSString *code;
@property (strong, nonatomic) NSString *client;
@property (strong, nonatomic) NSString *jpush_id;
@property (strong, nonatomic) NSString *invite_code;
@end
@interface GetCodeReq : BaseRequest
@property (strong, nonatomic) NSString *phone;

@end

//登录
@interface LoginReq : BaseRequest

@property (strong, nonatomic) NSString *account;
@property (strong, nonatomic) NSString *tel;
@property (strong, nonatomic) NSString *passwd;
@property (strong, nonatomic) NSString *code;

@property (strong, nonatomic) NSString *flag;//1-》手机密码 2-》手机验证码 3-》第三方
@property (strong, nonatomic) NSString *wx_code;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *province;
@property (strong, nonatomic) NSString *country;

@end
//退出登录
@interface LoginOutReq : BaseRequest

@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSString *token;

@end
//获取个人信息
@interface getInformationReq : BaseRequest

@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) NSString *token;

@end
//MARK:-------个人信息修改
@interface UserInfoUploadImgReq : BaseRequest

@property (strong, nonatomic) NSString *avatar;
@property (strong, nonatomic) NSString *nickname;
@property (nonatomic,strong) NSString *type;//1->头像 2->昵称


@end
//MARK:-------评论
@interface EvaluationReq : BaseRequest

@property (strong, nonatomic) NSString *unique;
@property (strong, nonatomic) NSString *comment;
@property (nonatomic,strong) NSArray *pics;
@property (nonatomic,strong) NSString *product_score;
@property (nonatomic,strong) NSString *service_score;


@end
@interface QuUserInfo : NSObject

@property (nonatomic , copy) NSString  * uid;//
@property (nonatomic , copy) NSString  * phone;//用户电话号码
@property (nonatomic , copy) NSString  * account;//用户电话号码
@property (nonatomic , copy) NSString  * pwd;
@property (nonatomic , copy) NSString  * nickname;//用户昵称（微信名）
@property (nonatomic , copy) NSString  * avatar;//用户头像地址
@property (nonatomic , copy) NSNumber  * add_time;
@property (nonatomic , copy) NSString  * add_ip;
@property (nonatomic , copy) NSString  * last_time;
@property (nonatomic , copy) NSString  * last_ip;
@property (nonatomic , copy) NSString  * now_money;
@property (nonatomic , copy) NSString  * number;
@property (nonatomic , copy) NSString  * integral;
@property (nonatomic , copy) NSString  * status;
@property (nonatomic , copy) NSString  * level;
@property (nonatomic , copy) NSString  * spread_uid;
@property (nonatomic)NSInteger   agent_id;
@property (nonatomic , copy) NSString  * user_type;
@property (nonatomic , copy) NSString  * is_promoter;//1是会员
@property (nonatomic , copy) NSString  * pay_count;
@property (nonatomic , copy) NSString  * direct_num;
@property (nonatomic , copy) NSString  * teamNum;
@property (nonatomic , copy) NSString  * spread_name;
@property (nonatomic , copy) NSString  * team_num;
@property (nonatomic , copy) NSString  * is_reward;
@property (nonatomic , copy) NSString  * allowance_number;
@end

@interface AgentModel : NSObject

@property (nonatomic , copy) NSString  * agent_id;//
@property (nonatomic , copy) NSString  * name;//
@property (nonatomic , copy) NSString  * level;
@property (nonatomic , copy) NSString  * direct;
@property (nonatomic , copy) NSString  * subsidy;
@property (nonatomic , copy) NSString  * team;
@property (nonatomic , copy) NSString  * bonus;
@property (nonatomic , copy) NSString  * month_bonus;
@property (nonatomic , copy) NSString  * add_time;
@property (nonatomic , copy) NSString  * state;
@property (nonatomic , copy) NSString  * introduce;
@property (nonatomic , copy) NSString  * promotion_text;



@end
@interface getInformationRsp : BaseResponse

@property (strong, nonatomic) QuUserInfo *information;
@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSString *token;
@property (strong, nonatomic) NSString *userId;

@end


@interface CheckCodeRsp : BaseResponse

@property (strong, nonatomic) QuUserInfo *data;

@end


//微信登录
@interface BindWeChatReq : BaseRequest

@property (strong, nonatomic) NSString *winXinKey;
@property (strong, nonatomic) NSString *phone;

@end

@interface BindWeChatRsp : BaseResponse

@property (strong, nonatomic)QuUserInfo *data;

@end

//微信绑定手机号
@interface CheckWeChatCodeReq : BaseRequest

@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSString *winXinKey;
@property (strong, nonatomic) NSString *nick;
@property (strong, nonatomic) NSString *headImage;
@property (strong, nonatomic) NSString *code;

@end

@interface CheckWeChatCodeRsp : BaseResponse

@property (strong, nonatomic) QuUserInfo *data;

@end

//自动登录
@interface AutoLoginReq : BaseRequest

@property (strong, nonatomic) NSString *userId;

@end

@interface AutoLoginRsp : BaseResponse

@property (strong, nonatomic) QuUserInfo *data;

@end

//获取用户信息
@interface GetPersonalInformationReq : BaseRequest

@property (strong, nonatomic) NSString *userId;

@end

@interface GetPersonalInformationRsp : BaseResponse

@property (strong, nonatomic) QuUserInfo *data;

@end

//获取城市
@interface GetCityReq : BaseRequest

@end

@interface GetCityRsp : BaseResponse

@property (strong, nonatomic) NSArray *data;
@property (strong, nonatomic) NSArray *data1;

@end

@interface StopCarReq : BaseRequest

@property (strong, nonatomic) NSString *customer_id;
@property (strong, nonatomic) NSString *park_id;

@end


@interface ParkListReq : BaseRequest

@property (strong, nonatomic) NSString *customer_id;
@property (strong, nonatomic) NSString *lng;
@property (strong, nonatomic) NSString *lat;


@end

@interface CheckPayReq : BaseRequest

@property (strong, nonatomic) NSString *customer_id;
@property (strong, nonatomic) NSString *unid;//订单编号
@property (strong, nonatomic) NSString *paytype;//1支付宝 2微信
@end

@interface MainBannerModel : NSObject

@property (strong, nonatomic) NSString *imageUrl;
@property (strong, nonatomic) NSString *targetType;
@property (strong, nonatomic) NSString *targetUrl;

@end
@interface AttrInfoModel : NSObject


@property(strong,nonatomic)NSString *product_id;//
@property(strong,nonatomic)NSString *stock;//
@property(strong,nonatomic)NSString *suk;//
@property(strong,nonatomic)NSString *unique;//

@property(strong,nonatomic)NSString *price;//
@property(strong,nonatomic)NSString *vip_price;//
@property(strong,nonatomic)NSString *image;//
@property(strong,nonatomic)NSString *cost;//
@property(assign,nonatomic)BOOL selectState;//是否选中状态
@property(assign,nonatomic)NSInteger goodsNum;//商品个数
@property(assign,nonatomic)NSInteger allNum;//全部个数
@property(assign,nonatomic)NSInteger remainedNum;//还需个数

@end

@interface MainGoodsModel : NSObject

@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) NSString *image;//商品图片
@property (strong, nonatomic) NSString *transverse_image;//商品chang图片

@property (strong, nonatomic) NSString *store_name;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *info;
@property (strong, nonatomic) NSString *keyword;
@property(strong,nonatomic)NSString *sales;//销量
@property(strong,nonatomic)NSString *ficti;//x虚拟销量
@property(strong,nonatomic)NSString *vip_price;//商品标题
@property(strong,nonatomic)NSString *ot_price;//原价
@property(strong,nonatomic)NSString *price;//商品单价
@property(strong,nonatomic)NSString *unit_name;//计件单位

@property(strong,nonatomic)NSString *stock;//库存
@property(strong,nonatomic)NSString *product_id;//
@property(strong,nonatomic)NSString *suk;//
@property(strong,nonatomic)NSString *unique;//
@property(strong,nonatomic)NSString *cate_id;//

@property(strong,nonatomic)AttrInfoModel *attrInfo;

@property(assign,nonatomic)BOOL selectState;//是否选中状态
@property(assign,nonatomic)NSInteger goodsNum;//商品个数
@property(assign,nonatomic)NSInteger allNum;//全部个数
@property(assign,nonatomic)NSInteger remainedNum;//还需个数

@end
@interface MainGoodsRsp : BaseResponse

@property (strong, nonatomic) NSArray *data;


@end

@interface VipGoodsRsp : BaseResponse

@property (strong, nonatomic) NSArray *list;
@property (strong, nonatomic) NSArray *list2;
@property (strong, nonatomic) NSArray *list3;
@property (strong, nonatomic) NSDictionary *artics;
@property (strong, nonatomic) NSDictionary *promotion_text;

@end

@interface GoodsDetalisModel : NSObject

@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) NSString *mer_id;
@property (strong, nonatomic) NSString *image;
@property (strong, nonatomic) NSString *urlShare;
@property (strong, nonatomic) NSArray *images;
@property (strong, nonatomic) NSArray *slider_image;
@property (strong, nonatomic) NSString *store_name;
@property (strong, nonatomic) NSString *store_info;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *info;
@property (strong, nonatomic) NSString *keyword;
@property (strong, nonatomic) NSString *cate_id;
@property (strong, nonatomic) NSString *price;
@property (strong, nonatomic) NSString *vip_price;
@property (strong, nonatomic) NSString *ot_price;
@property (strong, nonatomic) NSString *desc;
@property (strong, nonatomic) NSString *des;

@property (strong, nonatomic) NSString *pro_address;
@property (strong, nonatomic) NSString *pack_nomals;
@property (strong, nonatomic) NSString *nw;
@property (strong, nonatomic) NSString *save_condition;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *wine_tech;
@property (strong, nonatomic) NSString *materials;
@property (strong, nonatomic) NSString *centigrade;//酒精度
@property (strong, nonatomic) NSArray *basics_commission;//基础返佣
@property (strong, nonatomic) NSString *parent_commission;//二级反佣
@property (strong, nonatomic) NSDictionary *unit_name;
@property (strong, nonatomic) NSString *ficti;//虚拟销量

@property(strong,nonatomic)NSString *sales;//销量
@property (strong, nonatomic) NSString *stock;//虚拟销量is_special
@property (nonatomic) NSInteger is_special;//1.是会员礼包des
@property (nonatomic) NSInteger is_integral;//1.只能直接购买
@property (nonatomic) NSInteger is_agent;//1.只能直接购买

@property (strong, nonatomic) NSString *userCollect;// false意思是没有收藏的意思
@property (strong, nonatomic) NSString *start_time;//
@property (strong, nonatomic) NSString *stop_time;//



@end
@interface ReplyModel : NSObject

@property (strong, nonatomic) NSString *product_score;
@property (strong, nonatomic) NSString *service_score;
@property (strong, nonatomic) NSString *comment;
@property (strong, nonatomic) NSArray *pics;
@property (strong, nonatomic) NSString *add_time;
@property (strong, nonatomic) NSString *nickname;
@property (strong, nonatomic) NSString *avatar;
@property (strong, nonatomic) NSString *suk;
@property (strong, nonatomic) NSString *star;

@end
@interface ReplyListRsp : NSObject

@property (strong, nonatomic) NSArray *data;


@end
@interface GoodsDetalisRsp : NSObject

@property (strong, nonatomic) NSString *urlShare;
@property (strong, nonatomic) GoodsDetalisModel *storeInfo;
@property (strong, nonatomic) NSArray *reply;
@property (strong, nonatomic) NSArray *productAttr;
@property (strong, nonatomic) NSDictionary *productValue;

@property (strong, nonatomic) NSString *replyCount;
@property (strong, nonatomic) NSString *mer_id;


@end
@interface AddCarReq : BaseRequest

@property (strong, nonatomic) NSString *productId;
@property(strong,nonatomic)NSString *cartNum;
@property (strong, nonatomic) NSString *uniqueId;
@property(strong,nonatomic)NSString *combinationId;
@property (strong, nonatomic) NSString *secKillId;
@property(strong,nonatomic)NSString *bargainId;

@end
@interface PlaceOrderReq : BaseRequest

//@property (strong, nonatomic) NSString *goods_id;
//@property(strong,nonatomic)NSString *goods_number;
//@property (strong, nonatomic) NSString *goods_price;
@property(strong,nonatomic)NSString *addressId;
@property (strong, nonatomic) NSString *format_id;
@property(strong,nonatomic)NSString *mark;
@property(strong,nonatomic)NSString *bargainId;
@property (strong, nonatomic) NSString *couponId;
@property(strong,nonatomic)NSString *payType;
@property(strong,nonatomic)NSString *seckill_id;
@property(strong,nonatomic)NSString *useIntegral;//是否使余额  传值就代表使用 不传值就代表不用
@property (strong, nonatomic) NSString *combinationId;
@property(strong,nonatomic)NSString *pinkId;
@property(strong,nonatomic)NSString *key;
@end

@interface OrderModelRsp : BaseResponse
@property (strong, nonatomic) NSArray *data;
@end

@interface OrderModel: NSObject
@property (strong, nonatomic) NSString *date;
@property (strong, nonatomic) NSString *orderId;
@property(strong,nonatomic)NSString *orderGroupId;
@end

@interface CancelOrderReq : BaseRequest
@property (strong, nonatomic) NSArray *orderId;
@property(strong,nonatomic)NSString *cancelReasonText;

@end
@interface DeleteMyCarReq : BaseRequest
@property (nonatomic,strong)NSString *car_id;

@end
@interface BindingObdReq : BaseRequest
@property (nonatomic,strong)NSString *obd_macid;


@end
@interface GetDeviceLocationReq : NSObject
@property (nonatomic,strong)NSString *method;
@property (nonatomic,strong)NSString *mapType;
@property (nonatomic,strong)NSString *macid;
@property (nonatomic,strong)NSString *user_id;
@property (nonatomic,strong)NSString *mds;
@property (nonatomic,strong)NSString *from;
@property (nonatomic,strong)NSString *to;
@property (nonatomic,strong)NSString *playLBS;

@property (nonatomic,strong)NSString *beginTime;
@property (nonatomic,strong)NSString *endTime;

@property (nonatomic,strong)NSString *info;
@property (nonatomic,strong)NSString *sex;
@property (nonatomic,strong)NSString *owner;
@property (nonatomic,strong)NSString *user_name;
@property (nonatomic,strong)NSString *remark;
@property (nonatomic,strong)NSString *tel;
@property (nonatomic,strong)NSString *phone;
@property (nonatomic,strong)NSString *out_time;
@property (nonatomic,strong)NSString *alarm;
@property (nonatomic,strong)NSString *sudu;
@property (nonatomic,strong)NSString *iconType;
@property (nonatomic,strong)NSString *HighTempAlarm;
@property (nonatomic,strong)NSString *LowTempAlarm;
- (NSArray *)getAllProperties;
- (NSDictionary *)properties_aps;
@end
@interface DeviceInfoKey : NSObject
//“sys_time”: 0, //设备定位时间
//“user_name”: 1, //设备名称
//“jingdu”: 2, //经度
//“weidu”: 3, //纬度
//“ljingdu”: 4, //基站经度（基站定位）
//“lweidu”: 5, //基站纬度
//“datetime”: 6, //数据更新时间（服务器接收时间）
//“heart_time”: 7, //设备心跳时间（信号时间）
//“su”: 8, //速度
//“status”: 9, //状态组【如下表status】
//“hangxiang”: 10, //方向
//“sim_id”: 11, //设备编号
//“user_id”: 12, //设备id
//“sale_type”: 13, //销售类型-无用途
//“iconType”: 14, //图标
//“server_time”: 15, //系统时间（当前时间）
//“product_type”: 16, //设备类型
//“expire_date”: 17, //到期时间
//“group_id”: 18, //监控组ID
//“statenumber”: 19, //信息组【如下表status】
//“electric”: 20,
//“describe”: 21, //设备描述信息（通常存放一些设备上传的运行参数）
//“sim”: 22, //sim卡
//“precision”: 23 //精度（Lbs/WiFi）
@property (nonatomic)NSInteger sys_time;
@property (nonatomic)NSInteger user_name;
@property (nonatomic)NSInteger jingdu;
@property (nonatomic)NSInteger weidu;
@property (nonatomic)NSInteger ljingdu;
@property (nonatomic)NSInteger lweidu;
@property (nonatomic)NSInteger datetime;
@property (nonatomic)NSInteger heart_time;
@property (nonatomic)NSInteger su;
@property (nonatomic)NSInteger status;
@property (nonatomic)NSInteger hangxiang;
@property (nonatomic)NSInteger sim_id;
@property (nonatomic)NSInteger user_id;
@property (nonatomic)NSInteger sale_type;
@property (nonatomic)NSInteger iconType;
@property (nonatomic)NSInteger server_time;
@property (nonatomic)NSInteger product_type;
@property (nonatomic)NSInteger expire_date;
@property (nonatomic)NSInteger group_id;
@property (nonatomic)NSInteger statenumber;
@property (nonatomic)NSInteger electric;
@property (nonatomic)NSInteger describe;
@property (nonatomic)NSInteger sim;
@property (nonatomic)NSInteger precision;

@end

@interface AddMyCarReq : BaseRequest
@property (nonatomic,strong)NSString *plate;

@end

@interface DeleteAddressReq : BaseRequest
@property (nonatomic,strong)NSString *addressId;
@end

@interface AddMyAddressReq : BaseRequest
@property (nonatomic,strong)NSString *real_name;
@property (nonatomic,strong)NSString *phone;
@property (nonatomic,strong)NSString *detail;
@property (nonatomic,strong)NSString *region;
@property (nonatomic,strong)NSString *is_default;
@property (nonatomic,strong)NSString *post_code;
@property (nonatomic,strong)NSString *city;
@property (nonatomic,strong)NSString *district;
//customer_id用户id[string] 查看
//2 必填receiver_name收货人姓名[string] 查看
//3 必填receiver_mobile收货人手机号[string] 查看
//4 必填region地区[string] 查看
//5 必填detailed_address详细地址[string] 查看
//6 必填is_default默认地址（0：不是 1：是）

@end

@interface OrderListReq : BaseRequest
@property (nonatomic,strong)NSString *type;//订单状态  全部 0代付款 1代发货 2待收货 3代评

@end

@interface WarningListReq : BaseRequest
@property (nonatomic,strong)NSString *obd_macid;

@end

@interface WarningModel : NSObject
@property (strong, nonatomic)NSString *id;
@property (strong, nonatomic)NSString *classify;
@property (strong, nonatomic)NSString *pt_time;
@property (strong, nonatomic)NSString *phone;

@end

@interface WarningRsp : BaseResponse
@property (strong, nonatomic)NSArray *data;

@end
@interface PhoneOrderListModel : NSObject
@property (strong, nonatomic)NSString *id;
@property (strong, nonatomic)NSString *user_id;
@property (strong, nonatomic)NSString *telephone;
@property (strong, nonatomic)NSString *create_time;
@property (strong, nonatomic)NSString *telephone_money;
@property (strong, nonatomic)NSString *orderid;
@property (strong, nonatomic)NSString *status;

@end

@interface PhoneOrderListRsp: BaseResponse
@property (strong, nonatomic)NSArray *data;

@end

@interface AddShoppingCarModel : NSObject
@property (strong, nonatomic)NSString *store_name;
@property (strong, nonatomic)MainGoodsModel *productInfo;

@property (strong, nonatomic)NSString *price;
@property (strong, nonatomic)NSString *truePrice;
@property ( nonatomic)NSInteger cart_num;
@property (strong, nonatomic)NSString *image;
@property (strong, nonatomic)NSString *id;
@property(assign,nonatomic)BOOL selectState;//是否选中状态
@property(nonatomic)NSInteger goodsNum;//商品个数
@property(assign,nonatomic)NSInteger allNum;//全部个数
//@property(assign,nonatomic)NSInteger remainedNum;//还需个数
@property(assign,nonatomic)NSInteger trueStock;//

@end

@interface AddShoppingCarRsp: BaseResponse
@property (strong, nonatomic)NSArray *valid;

@end
@interface AddShoppingReq: BaseRequest

@property (strong, nonatomic)NSString *cartId;
@property (strong, nonatomic)NSString *cartNum;
@property(strong,nonatomic)NSArray *ids;
@end

@interface PlaceOrderModel : NSObject
@property (strong, nonatomic)NSString *store_name;
@property (strong, nonatomic)MainGoodsModel *productInfo;

@property (strong, nonatomic)NSString *price;
@property (strong, nonatomic)NSString *vip_price;
@property (strong, nonatomic)NSString *truePrice;
@property (strong, nonatomic)NSString *unique;

@property ( nonatomic)NSInteger cart_num;
@property (strong, nonatomic)NSString *image;
@property (strong, nonatomic)NSString *id;
@property (nonatomic,copy)NSNumber *add_time;

@property(assign,nonatomic)BOOL selectState;//是否选中状态
@property(nonatomic)NSInteger goodsNum;//商品个数
@property(assign,nonatomic)NSInteger allNum;//全部个数
//@property(assign,nonatomic)NSInteger remainedNum;//还需个数
@property(assign,nonatomic)NSInteger trueStock;//

@end
@interface PriceGroupModel : NSObject
@property(nonatomic)double totalPrice;//总价钱

@end
@interface PlaceOrderRsp: BaseResponse
@property (strong, nonatomic)NSArray *cartInfo;
@property (strong, nonatomic)NSString *orderKey;
//@property(strong,nonatomic)NSDictionary *priceGroup;
@property(nonatomic,strong)PriceGroupModel *priceGroup;
@property (strong, nonatomic) QuUserInfo *userInfo;//
@end
@interface WarningDetalisModel : NSObject
@property (strong, nonatomic)NSString *id;
@property (strong, nonatomic)NSString *user_id;
@property (strong, nonatomic)NSString *obd_macid;
@property (strong, nonatomic)NSString *pt_time;
@property (strong, nonatomic)NSString *add_time;
@property (strong, nonatomic)NSString *lat;
@property (strong, nonatomic)NSString *lon;
@property (strong, nonatomic)NSString *map_lat;
@property (strong, nonatomic)NSString *map_lon;
@property (strong, nonatomic)NSString *speed;
@property (strong, nonatomic)NSString *dir;
@property (strong, nonatomic)NSString *classify;
@property (strong, nonatomic)NSString *describe_classify;
@property (strong, nonatomic)NSString *notea;
@property (strong, nonatomic)NSString *phone;

@end

@interface ExpressInfoReq : BaseRequest
@property (nonatomic,strong)NSString *uni;//

@end

@interface ExpressInfoModel : NSObject
@property (nonatomic,strong)NSString *time;//
@property (nonatomic,strong)NSString *ftime;//
@property (nonatomic,strong)NSString *context;//

@end

@interface ExpressInfoRsp : BaseResponse
@property (nonatomic,strong)NSArray *data;//
@property (strong, nonatomic)NSString *message;
@property (strong, nonatomic)NSString *nu;
@property (strong, nonatomic)NSString *ischeck;
@property (strong, nonatomic)NSString *com;
@property (strong, nonatomic)NSString *status;
@property (strong, nonatomic)NSString *state;

@end

@interface TripListModel : NSObject
@property (nonatomic,strong)NSString *BeginTime;//
@property (nonatomic,strong)NSString *EndTime;//
@property (nonatomic,strong)NSString *IdlingTime;//
@property (strong, nonatomic)NSString *brakeTimes;
@property (strong, nonatomic)NSString *btime;
@property (nonatomic,strong)NSString *coulometric;//
@property (nonatomic,strong)NSString *distance;//
@property (nonatomic,strong)NSString *driveTime;//
@property (strong, nonatomic)NSString *emergencyBrakeTimes;
@property (strong, nonatomic)NSString *emergencySpeedupTimes;
@property (nonatomic,strong)NSString *etime;//
@property (nonatomic,strong)NSString *fraction;//
@property (nonatomic,strong)NSString *fuelHKM;//
@property (strong, nonatomic)NSString *jsType;
@property (strong, nonatomic)NSString *maxEngRPM;
@property (strong, nonatomic)NSString *maxTempc;
@property (strong, nonatomic)NSString *maxspeed;
@property (nonatomic,strong)NSString *overtimeDriverMinutes;//
@property (nonatomic,strong)NSString *powerv;//
@property (nonatomic,strong)NSString *random;//
@property (strong, nonatomic)NSString *speed;
@property (strong, nonatomic)NSString *speedupTimes;
@property (strong, nonatomic)NSString *strokeTime;
@property (strong, nonatomic)NSString *totalSpeedoverSeconds;
@property (nonatomic,strong)NSString *totalfuelUsed;//

@end

@interface TripListRsp : BaseResponse
@property (nonatomic,strong)NSArray *rows;//
@property (strong, nonatomic)NSString *avgFuel;
@property (strong, nonatomic)NSString *totalfuel;
@property (strong, nonatomic)NSString *totalmil;
@property (strong, nonatomic)NSString *totalDriveTime;
@property (strong, nonatomic)NSString *totalCoulometric;
@property (strong, nonatomic)NSString *oilPrice;

@end
@interface OrderStatusModel: NSObject
@property (strong, nonatomic)NSString *type;
@property (strong, nonatomic)NSString *title;
@property (strong, nonatomic)NSString *msg;
@property (strong, nonatomic)NSString *payType;

@end

@interface OrderListModel : NSObject
@property (strong, nonatomic)NSString *id;
@property (strong, nonatomic)NSString *order_id;
@property (strong, nonatomic)NSString *total_num;
@property (strong, nonatomic)NSString *total_price;
@property (strong, nonatomic)NSString *status;//0 代付 1代发 2代收 3代评
@property (nonatomic)NSInteger paid;
@property (nonatomic)NSInteger refund_status;
@property (strong, nonatomic)NSString *user_address;
@property (strong, nonatomic)NSString *real_name;
@property (strong, nonatomic)NSString *user_phone;
@property (strong, nonatomic)NSString *total_postage;

@property (strong, nonatomic)NSString *goods_img;
@property (strong, nonatomic)NSString *goods_name;
@property (strong, nonatomic)NSString *goods_number;

@property (strong, nonatomic)NSString *goods_price;
@property (strong, nonatomic)NSString *goods_unit;
//@property (strong, nonatomic)NSString *order_status;
//订单状态 0待付款 1已付款待发货 2逾期未支付 3已发货 4已收货 5已评价 6申请退款 7申请退货 8已退款 9同意退货 10退货已发货 11退货收货已退款 12 已取消
@property (strong, nonatomic)NSString *order_status_text;

@property (strong, nonatomic)NSString *pay_price;
@property (strong, nonatomic)OrderStatusModel *s_status;
@property (strong, nonatomic)NSDictionary *cartInfo;

@property (strong, nonatomic)NSMutableArray *cartInfos;

@property (strong, nonatomic)NSString *pay_status;
@property (copy, nonatomic)NSNumber *pay_time;
@property (strong, nonatomic)NSString *pay_type;

@end
@interface OrderListRsp : BaseResponse
@property (strong, nonatomic)NSArray *data;

@end
@interface OrderNumRsp : NSObject

@property (strong, nonatomic)NSString *noBuy;
@property (strong, nonatomic)NSString *noPostage;
@property (strong, nonatomic)NSString *noTake;
@property (strong, nonatomic)NSString *noReply;
@property (strong, nonatomic)NSString *noPink;
@end

@interface OrderDetailsReq : BaseRequest

@property (nonatomic,strong)NSString *uni;
@property (nonatomic,strong)NSString *text;
@property (nonatomic,strong)NSString *order_id;


@end

@interface OrderDetailsModel : NSObject
@property (strong, nonatomic)NSString *id;
@property (strong, nonatomic)NSString *action;
@property (strong, nonatomic)NSString *auto_take_time;
@property (strong, nonatomic)NSString *create_time;
@property (strong, nonatomic)NSString *cutoff_time;
@property (strong, nonatomic)NSString *goods_all_price;
@property (strong, nonatomic)NSString *goods_format;
@property (strong, nonatomic)NSString *goods_id;
@property (strong, nonatomic)NSString *goods_img;
@property (strong, nonatomic)NSString *goods_name;
@property (strong, nonatomic)NSString *goods_number;

@property (strong, nonatomic)NSString *goods_price;
@property (strong, nonatomic)NSString *goods_unit;
@property (strong, nonatomic)NSString *order_status;
@property (strong, nonatomic)NSString *order_status_text;
@property (strong, nonatomic)NSString *out_trade_no;
@property (strong, nonatomic)NSString *pay_fee;
@property (strong, nonatomic)NSString *postage;
@property (strong, nonatomic)NSString *pay_status;
@property (strong, nonatomic)NSString *pay_time;
@property (strong, nonatomic)NSString *pay_type;
@property (strong, nonatomic)NSString *receiver_name;
@property (strong, nonatomic)NSString *receiver_address;
@property (strong, nonatomic)NSString *receiver_mobile;
@property (strong, nonatomic)NSString *express_name;
@property (strong, nonatomic)NSString *express_no;


@end

@interface AfenceModel : NSObject

@property (strong, nonatomic)NSString *id;
@property (strong, nonatomic)NSString *report_type;
@property (strong, nonatomic)NSString *rail_name;
@property (strong, nonatomic)NSString *radii;
@property (strong, nonatomic)NSString *address;

@end
@interface AfencetListRsp : BaseResponse
@property (strong, nonatomic)NSArray * data;
@end

@interface UpdateRailReq : BaseRequest
@property (strong, nonatomic)NSString *rail_name;
@property (strong, nonatomic)NSString *lng;
@property (strong, nonatomic)NSString *lat;
@property (strong, nonatomic)NSString *radii;
@property (strong, nonatomic)NSString *address;
@property (strong, nonatomic)NSString *report_type;
@end


@interface OBDDataModel : NSObject

@property (strong, nonatomic)NSString *weidu;
@property (strong, nonatomic)NSString *user_name;
@property (strong, nonatomic)NSString *user_id;
@property (strong, nonatomic)NSString *use_time;
@property (strong, nonatomic)NSString *tel;
@property (strong, nonatomic)NSString *sys_time;
@property (strong, nonatomic)NSString *sudu;
@property (strong, nonatomic)NSString *su;
@property (strong, nonatomic)NSString *sim_id;
@property (strong, nonatomic)NSString *status;
@property (strong, nonatomic)NSString *sex;
@property (strong, nonatomic)NSString *out_time;
@property (strong, nonatomic)NSString *jingdu;
@property (strong, nonatomic)NSString *heart_time;
@property (strong, nonatomic)NSString *factory_date;
@property (strong, nonatomic)NSString *datetime;
@property (strong, nonatomic)NSString *create_time;
@property (strong, nonatomic)NSString *TerminalType;
@property (strong, nonatomic)NSString *owner;

@end
@interface OBDDataModelRsp : BaseResponse
@property (strong, nonatomic)NSArray * data;
@end

@interface CarInfoModel : NSObject

@property (strong, nonatomic)NSString *Number;
@property (strong, nonatomic)NSString *Key;
@property (strong, nonatomic)NSString *Value;


@end
@interface CarInfoRsp : BaseResponse
@property (strong, nonatomic)NSArray * data;
@end

@interface CarCodeModel : NSObject

@property (strong, nonatomic)NSString *obdCount;
@property (strong, nonatomic)NSString *obdTitle;
@property (strong, nonatomic)NSString *sysId;


@end
@interface CarCodeRsp : BaseResponse
@property (strong, nonatomic)NSArray * obdSys;
@end

@interface ChargPicListModel : NSObject
@property (strong, nonatomic)NSString *old_money;
@property (strong, nonatomic)NSString *money;


@end
@interface ChargPicListRsp : BaseResponse
@property (strong, nonatomic)NSArray *data;
@end



@interface AliPreOrderReq : BaseRequest
@property (strong, nonatomic)NSString *orderId;
@property (strong, nonatomic)NSString *payType;///支付类型，1.微信 2.支付宝
@end
@interface AliPreOrderModel : NSObject
@property (strong, nonatomic)NSString *alipayUrl;

@end
@interface AliPreOrderRsp : BaseResponse
@property (strong, nonatomic)NSString *jsConfig;
@end

@interface WXPayModel : NSObject

@property (strong, nonatomic) NSString *appid;
@property (strong, nonatomic) NSString *noncestr;
@property (strong, nonatomic) NSString *package;
@property (strong, nonatomic) NSString *packageName;
@property (strong, nonatomic) NSString *partnerid;
@property (strong, nonatomic) NSString *prepayid;
@property (strong, nonatomic) NSString *sign;
@property (assign, nonatomic) UInt32 timestamp;

@end

@interface WXPayRsp : BaseResponse
@property (strong, nonatomic)WXPayModel *jsConfig;
@end


@interface MessageListReq : BaseRequest
@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) NSString *token;
@property (strong,nonatomic)NSString *pageIndex;
@end
@interface MessageDetalisReq : BaseRequest
@property (strong, nonatomic) NSString *phone;
@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) NSString *token;
@property (strong, nonatomic) NSString *msgId;
@end
@interface MessageListModel : NSObject

@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) NSString *user;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSString *add_time;
@property (strong, nonatomic) NSString *is_see;
@property (assign, nonatomic) NSInteger isReaded;//1:已读 2:未读

@end
@interface MessageListRsp : BaseResponse
@property (strong, nonatomic) NSArray *list;

@end

@interface GetWalletReq : BaseRequest
@property (strong, nonatomic) NSString *customerid;

@end
@interface GetWalletModel : NSObject

@property (strong, nonatomic) NSString *number;//我的佣金

@property (strong, nonatomic) NSString *allnumber;//累计获得佣金
@property (strong, nonatomic) NSString *extractNumber;//累计已提佣金
@property (strong, nonatomic) NSString *direct;//直属
@property (strong, nonatomic) NSString *team;//团队

@property (strong, nonatomic) NSString *todayNumber;//
@property (strong, nonatomic) NSString *todayAllNumber;//
@property (strong, nonatomic) NSString *todayExtractNumber;//

@property (strong, nonatomic) NSString *directNum;//
@property (strong, nonatomic) NSString *teamNum;//
@property (strong, nonatomic) QuUserInfo *userInfo;//
@property (strong, nonatomic) AgentModel *agent;//
@property (strong, nonatomic) NSArray *list;//
@property (strong, nonatomic) NSArray *promotion_product;//
@property (strong, nonatomic) NSString *introduce;//introduce


@end

@interface GetWalletRsp : BaseResponse
@property (strong, nonatomic) GetWalletModel *data;


@end


@interface AccountRecordReq : BaseRequest
@property (strong, nonatomic) NSString *userId;
@property (strong,nonatomic)NSString *pageIndex;
@end
@interface AccountRecordModel : NSObject

@property (strong, nonatomic) NSString *recordId;
@property (strong, nonatomic) NSString *recordTitle;
@property (strong, nonatomic) NSString *recordDateLabel;
@property (strong, nonatomic) NSString *recordFee;//费用
@property (strong, nonatomic) NSString *recordType;//类型：1：充值、入账 等，2：返佣 3:订单支付    

@end
@interface AccountRecordRsp : BaseResponse
@property (strong, nonatomic) NSArray *data;
@end

@interface UploadImgModel : NSObject

@property (strong, nonatomic) NSString *fileUrl;
@property (strong, nonatomic) NSString *originalFileName;

@end
@interface UploadImgRsp : BaseResponse
@property (strong, nonatomic) NSArray *data;
@end

@interface QuShareModel : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString * targetUrl;
@property (strong, nonatomic) NSString *content;
@property (nonatomic)id  imageUrl;
@property (strong, nonatomic) NSArray *platforms;



@end

@interface ShareThemeRsp : BaseResponse

@property (strong, nonatomic) QuShareModel *data;

@end



//支付MOdel
@interface RechargeReq : BaseRequest

@property (strong, nonatomic) NSString *fees;
@property (strong, nonatomic) NSString *memberId;
@property (assign, nonatomic) NSInteger type;

@end

@interface AlipayModel : NSObject

@property (strong, nonatomic) NSString *jsConfig;
//@property (strong, nonatomic) NSString *orderNo;

@end
@interface PayMoneyReq : BaseRequest

@property (strong, nonatomic) NSString *order_id;
@property (strong, nonatomic) NSString * pay_type;//1支付宝 2微信

@property (strong, nonatomic) NSString * pervalue;//
@property (strong, nonatomic) NSString * userid;//
@property (strong, nonatomic) NSString * orderid;//
@end

@interface PayMoneyRsp : BaseResponse

@property (strong, nonatomic) WXPayModel *wxPayResult;
@property (strong, nonatomic) AlipayModel *alipayUrl;

@end

@interface PhoneCheckReq : NSObject
@property (strong, nonatomic) NSString *telephone;
@property (strong, nonatomic) NSString * pervalue;//
@property (strong, nonatomic) NSString * userid;//
@property (strong, nonatomic) NSString * pay_type;//1支付宝 2微信
@property (strong, nonatomic) NSString * orderid;//

@end



@interface CityListRsp : BaseResponse
@property (strong, nonatomic) NSArray *data;
@end

@interface GetCompanyReq : BaseRequest
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString * company;//


@end

@interface WaterCardListModel : NSObject
@property (strong, nonatomic)NSString *id;
@property (strong, nonatomic)NSString *product_id;
@property (strong, nonatomic)NSString *uid;
@property (strong, nonatomic)NSString *wecaccount;
@property (strong, nonatomic)NSString *type;
@property (strong, nonatomic)NSString *productid;
@property (strong, nonatomic)NSString *company;

@end

@interface WaterCardListRsp: NSObject
@property (strong, nonatomic)NSArray *info;

@end

@interface AddWaterCardReq: BaseRequest
@property (strong, nonatomic)NSString *product_id;
@property (strong, nonatomic)NSString *wecaccount;
@end

@interface WaterBillsModel : NSObject
@property (strong, nonatomic)NSString *totalamount;
@property (strong, nonatomic)NSString *wecbalance;
@property (strong, nonatomic)NSString *useraddress;
@property (strong, nonatomic)NSString *company;
@property (strong, nonatomic)NSString *company_id;
@property (strong, nonatomic)NSString *wecaccount;

@end
@interface WaterPlaceOrderReq : BaseRequest
@property (strong, nonatomic)NSString *company_id;
@property (strong, nonatomic)NSString *wecaccount;
@property (strong, nonatomic)NSString *czmoney;
@property (strong, nonatomic)NSString *type;


@end
//MARK:-------优惠券详情Model
@interface CouponListModel : BaseResponse
@property (strong, nonatomic) NSString *id;
@property ( nonatomic) BOOL *isChooseIt;
@property (strong, nonatomic) NSString *cid;//兑换的项目id
@property (strong, nonatomic) NSString *coupon_title;
@property (strong, nonatomic) NSString *coupon_price;
@property (strong, nonatomic) NSString *use_min_price;//满多少钱 可用（无门槛就是0）
@property (strong, nonatomic) NSString *add_time;
@property (assign,nonatomic) NSNumber *end_time;
@property (strong, nonatomic) NSString *use_time;
@property (strong, nonatomic) NSString *type;
@property ( nonatomic) NSInteger status;
@property (strong, nonatomic) NSString *n_add_time;
@property (strong, nonatomic) NSString *n_end_time;
@property (strong, nonatomic) NSString *n_type;
@property (strong, nonatomic) NSString *n_msg;

@property (strong, nonatomic) NSString *is_fail;
@end
//MARK:-------优惠券详情req
@interface CouponListReq : BaseRequest
@property (strong, nonatomic) NSString *userId;
@property (nonatomic,strong) NSString *pageIndex;
@property(nonatomic,strong) NSString *orderId;
@end

@interface CouponListRsp : BaseResponse
@property(nonatomic,strong)NSArray *couponList;
@end

@interface CouponRsp : BaseResponse
@property(nonatomic,strong)NSArray *data;
@end

@interface BalanceListModel : NSObject
@property (strong, nonatomic)NSString *add_time;
@property (strong, nonatomic)NSString *mark;
@property (strong, nonatomic)NSString *number;
@property (strong, nonatomic)NSString *pm;
@property (nonatomic)NSInteger status;//0:未到账 1: 已到账

@end
@interface BalanceListRsp : BaseResponse
@property (strong, nonatomic)NSArray *list;
@property (strong, nonatomic)NSString *arrival_account;
@property (strong, nonatomic)NSString *outstanding_account;
@end

@interface PromoterListModel : NSObject
@property (strong, nonatomic)NSString *uid;
@property (strong, nonatomic)NSString *nickname;
@property (strong, nonatomic)NSString *avatar;
@property (strong, nonatomic)NSString *add_time;
@property (strong, nonatomic)NSString *number;
@property (strong, nonatomic)NSString *money;
@property (nonatomic)NSInteger agent_id;// 0:普通会员 1:代理  2:钻石代理

@end
@interface PromoterListRsp : BaseResponse
@property (strong, nonatomic)NSArray *info;
@property (strong, nonatomic)NSString *total_money;//总共获得的金额
@property (strong, nonatomic)NSString *number;//共有多少代理(粉丝)

@end
@interface CollectListModel : NSObject
@property (strong, nonatomic)NSString *pid;
@property (strong, nonatomic)NSString *store_name;
@property (strong, nonatomic)NSString *price;
@property (strong, nonatomic)NSString *ot_price;
@property (strong, nonatomic)NSString *sales;
@property (strong, nonatomic)NSString *image;
@end
@interface CollectListRsp : BaseResponse
@property (strong, nonatomic)NSArray *data;

@end
@interface WithdrawalReq : BaseRequest
@property (strong, nonatomic)NSString *pid;
@property (strong, nonatomic)NSString *real_name;
@property (strong, nonatomic)NSString *alipay_code;
@property (strong, nonatomic)NSString *bank_code;
@property (strong, nonatomic)NSString *bank_address;
@property (strong, nonatomic)NSString *price;
@end
@interface WithdrawalModel : NSObject
@property (strong, nonatomic)NSString *add_time;
@property (strong, nonatomic)NSString *alipay_code;
@property (strong, nonatomic)NSString *balance;
@property (strong, nonatomic)NSString *bank_address;
@property (strong, nonatomic)NSString *bank_code;
@property (strong, nonatomic)NSString *extract_price;
@property (strong, nonatomic)NSString *extract_type;
@property (strong, nonatomic)NSString *fail_msg;
@property (strong, nonatomic)NSString *fail_time;
@property (strong, nonatomic)NSString *real_name;
@end
@interface WithdrawalRsp : BaseResponse
@property (strong, nonatomic)NSString *minExtractPrice;
@property (strong, nonatomic)WithdrawalModel *extractInfo;

@end
@interface GoodsSearchReq : BaseRequest

//keyword 搜索关键词(提交时base64编码)
//sId
//true string
//默认值传0
//cId
//true string
//分类id默认值传0
//priceOrder
//true string
//价格排序默认为0 降序desc 升序传asc
//salesOrder
//true string
//销量排序默认为0 降序desc 升序传asc
//news
//true string
//是否为新品默认值0 为新品传true
//first
//true string
//开始条数默认值0
//limit
//true string
//查询条数默认值20
@property (nonatomic,strong)NSString *cId;
@property (nonatomic,strong)NSString *sId;
@property (strong, nonatomic) NSString *news;
@property (nonatomic,strong)NSString *priceOrder;
@property (nonatomic,strong)NSString *salesOrder;
@property (strong, nonatomic) NSString *keyword;

@end

///轮播图
@interface PSSlideModel : NSObject

@property (nonatomic , copy) NSString              * remark;
@property (nonatomic , copy) NSString              * ID;
@property (nonatomic , copy) NSString              * image;
@property (nonatomic , copy) NSString              * linkurl;
@property (nonatomic , copy) NSString              * pic;
@property (nonatomic , copy) NSString              * url;
@property (nonatomic , copy) NSString              * image_input;
@property (nonatomic , copy) NSString              * product_id;

@end
///首页商品分类图标
@interface MainCategoryModel : NSObject


@property (nonatomic , copy) NSString              * id;
@property (nonatomic , copy) NSString              * url;
@property (nonatomic , copy) NSString              * title;
@property (nonatomic , copy) NSString              * product_id;
@property (nonatomic , copy) NSString              * name;
@property (nonatomic , copy) NSString              * pic;
@property (nonatomic , copy) NSString              * cid;
@property (nonatomic , copy) NSString              * price;
@property (nonatomic , copy) NSString              * vip_price;
@property (nonatomic , copy) NSString              * cate_name;

@end
///商品分类
@interface GoodsClassModel : NSObject

@property (nonatomic , copy) NSString              * cate_name;
@property (nonatomic , copy) NSString              * id;
@property (nonatomic , strong) NSArray              * child;


@end
@interface GoodsClassRsp : NSObject

@property (nonatomic , strong) NSArray              * data;

@end
///
@interface MainFictitious : NSObject

@property (nonatomic , copy) NSString              * avatar;
@property (nonatomic , copy) NSString              * city;
@property (nonatomic , copy) NSString              * id;
@property (nonatomic , copy) NSString              * nickname;
@property (nonatomic , copy) NSString              * store_name;
@property (nonatomic) NSInteger               type;

@end
@interface KillReq : BaseRequest

@property (nonatomic , copy) NSString              * start_time;
@property (nonatomic , copy) NSString              * end_time;
@property (nonatomic , copy) NSString              * week;
@end

@interface IhavegoodsReq : BaseRequest

@property (nonatomic , copy) NSString              * model_type;
@property (nonatomic , copy) NSString              * com_name;
@property (nonatomic , copy) NSString              * name;
@property (nonatomic , copy) NSString              * phone;
@property (nonatomic , copy) NSString              * content;
@end
