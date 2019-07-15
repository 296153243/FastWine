//
//  UploadImgManager.h
//  CLTravel
//
//  Created by MOOSON_ on 2018/11/26.
//  Copyright © 2018年 MOOSON_. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QiniuSDK.h>

NS_ASSUME_NONNULL_BEGIN
// 请求成功回调block
typedef void(^Success)(id responseObject);
// 请求失败回调block
typedef void(^Failure)(NSError * error);

@interface UploadImgManager : NSObject
/** 创建网络请求管理类 */
+(instancetype)manager;

/**
 * ********************      向服务器上传图片       ********************
 *  urlStr  请求的网址
 *  params  发送请求的参数的字典
 *  imageArray  需要上传图片的数组
 *  file  接收上传文件的key的数组
 *  imageName  上传图片取什么名字的数组（自己取的）
 *
 */
-(void)PostImagesToServer:(NSString *) strUrl dicPostParams:(NSMutableDictionary *)params imageArray:(NSArray *) imageArray file:(NSArray *)fileArray imageName:(NSArray *)imageNameArray Success :(Success)success andFailure:(Failure)failure;

-(void)uploadImageWithImageArr:(NSArray *)imgArr success:(Success)success andFaile:(Failure)failure;//原生多张上传
-(void)uploadImageWithImage:(UIImage *)image success:(Success)success andFaile:(Failure)failure;//原生单张上传

-(void)uploadImageToQNImage:(NSArray *)imgArr success:(Success)success andFaile:(Failure)failure;//七牛单张上传

-(void)uploadImages:(NSArray *)images atIndex:(NSInteger)index token:(NSString *)token uploadManager:(QNUploadManager *)uploadManager keys:(NSMutableArray *)keys;
@end

NS_ASSUME_NONNULL_END
