//
//  NetWorkRequestDefine.h
//  QuDriver
//
//  Created by Zhuqing on 2017/9/21.
//  Copyright © 2017年 com.Qyueche. All rights reserved.
//

#import <Foundation/Foundation.h>

//接口名
typedef NS_ENUM(NSInteger,XQApiName) {
    checkVersion,//检查更新
    fileupload,//图片上传
    commonaAppconfig,//app配置
    article,//隐私政策相关链接
    getCode,          //注册获取验证码
    getCodeTwo,         //修改密码获取x验证码
    changePassword,        //修改密码
    customerregister, //注册
    login, //验证码登录
    loginSavephone,//登录绑定账号信息
    imageToken,
    regist,
    getInformation, //获取个人信息
    customerupdateInformation,//更新个人信息
    customerlogout,//退出登录
    getParkList,//附近停车场列表
    getHomeIcon,//banner
    getClassify,//获取分类下的子分类
    getClassbanner,//获取分类下的Banner
    phoneNote,//话费金额
    phonecheck,//检查手机和支付金额是否有效
    phoneMakeorder,//手机充值生成订单
    phoneGoodspay,//手机订单充值
    phoneUpdateorder,//更新手机充值订单
    phoneSelectuserdata,//手机充值记录
    mainGoodsList,//首页商品
    goodsSearch,//商品搜索
    mainGoodsDetalis,//商品详情
    killGoodsDetalis,//秒杀商品详情
    mainGoodsPalceOrder,//商品yu下单
    create_order,//创建订单
    addshopingCar,//加入购物车
    shoppingCarNum,//购物车数量
    shoppingCarGoodsList,//购物车产品列表
    shoppingCarEditor,//购物车产品编辑
    shoppingCarDelete,//删除购物车
    confirm_order,//提交购物车获取Key
    pay_order,//我的订单立即支付
    goodsPay,//商品支付
    stopCarInfo,//停车数据
    checkPay,//停车支付
    bindMac,//绑定OBD
    unbindMac,//解绑OBD
    getObdData,//获取OBD数据
    macReLogin,//设备重新登录
    getRailList,//围栏列表
    deleteRail,//c删除围栏
    updateRail,//更新围栏
    addRail,//添加围栏
    alarmList,//报警列表
    alarmDetalis,//报警详情
    orderList,//订单列表
    orderNum,//订单数量
    orderDetalis,//订单详情
    cancelOrder,//取消订单
    confirmTaked,//确认收货
    aRefundOrder,//退款
    expressInfo,//快递信息
    mycarList,//我的爱车
    deleteMycar,//我的爱车
    addMyCar,//添加爱车
    carParkList,//停车记录列表
    addressList,//收货地址列表
    deleteAddress,//删除收货地址
    addAddress,//新增收货地址
    editAddress,//修改收货地址
    defaddress,//获取默认收货地址
    lifeCitysList,//获取支持地区
    lifeGetCompany,//获取支持的水公司
    lifeSet_product_user,//用户产品绑定
    lifeGet_product_user,//获取用户绑定的产品
    lifeSet_del_bin,//删除用户绑定的产品
    lifeQuery_arrearage,//生成查询订单
    lifeGet_money,//根据订单查询是否欠费
    lifeCreate_order,//水充值订单创建
    lifeGoodsPay,//订单提交
    lifeRecord_order,//水电充值记录
    myUser_pro,//分销中心
    myguide,//不是代理时候的商品列表
    mybalance_list,//佣金列表
    myintegral_list,//余额列表
    myPread_list,//客户管理
    mymessageList,//消息
    mycollect_product,//收藏列表
    mycoupon,//优惠券列表
    myWithdral,//提现
    myWithdralInfo,//提现信息
    get_use_coupon,//获取商品可用优惠券
    collect_product,//收藏商品
    cancel_product,//取消收藏
    delete_product,//取消收藏
    evaluationInfo,//评价信息
    evaluation,//评价
    evaluationlist,//评价列表
    hotkeyword,//热门关键字
    goodsCategory,//商品分类
    mainfictitious,//虚拟物品购买
    maybe_love,//你可能喜欢
    get_coupon_user,//新人领取优惠券
    seckill_index,//秒杀商品
    set_cooperate,//我有好货
    cut_list,//砍价列表
    cut_con,//砍价
    cut_now_buy,//购买砍价商品
};
NSString *XQApiNameEnum(XQApiName name);

@interface NetWorkRequestDefine : NSObject

@end
