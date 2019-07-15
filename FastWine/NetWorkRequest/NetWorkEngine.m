//
//  NetWorkEngine.m
//  DCITSCardPro
//
//  Created by cssmk_jzb on 2017/5/9.
//  Copyright © 2017年 cssmk_jzb. All rights reserved.
//



#import "NetWorkEngine.h"

#import <CommonCrypto/CommonDigest.h>
#import "AFNetworkActivityIndicatorManager.h"

#import <AVFoundation/AVAsset.h>
#import <AVFoundation/AVAssetExportSession.h>
#import <AVFoundation/AVMediaFormat.h>

// http://wx.ucoolbox.com/doc.php 文档地址

#define ERROR_STRING @"网络错误,请稍候再试"

@implementation NetWorkEngine

#pragma mark - shareManager
/**
 *  获得全局唯一的网络请求实例单例方法
 *
 *  @return 网络请求类的实例
 */

+(instancetype)shareManager
{
    static NetWorkEngine * manager = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        manager = [[self alloc] init];
        
    });
    
    return manager;
}


#pragma mark - 重写initWithBaseURL
/**
 *
 *
 *
 *  @return 通过重写夫类的initWithBaseURL方法,返回网络请求类的实例
 */
-(instancetype)init{
    
    if (self = [super init]) {
        
        
//        [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
//
//        //设置非校验证书模式(https)
//        self.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
//        self.securityPolicy.allowInvalidCertificates = YES;
//        [self.securityPolicy setValidatesDomainName:NO];
//
//        /**设置请求超时时间*/
//
//        self.requestSerializer.timeoutInterval = 30;
//
//        /**设置相应的缓存策略*/
//
//        self.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
//
//        /**分别设置请求以及相应的序列化器*/
//        self.requestSerializer = [AFJSONRequestSerializer serializer];
//
//        AFJSONResponseSerializer * response = [AFJSONResponseSerializer serializer];
//
//        response.removesKeysWithNullValues = YES;
//
////        self.responseSerializer = [AFHTTPResponseSerializer serializer];
//
//        self.responseSerializer = response;
//
//        /**设置apikey ------类似于自己应用中的tokken---此处仅仅作为测试使用*/
////        [self.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
//
////        [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//
////        self.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//        //申明返回的结果是json类型
//        self.responseSerializer = [AFJSONResponseSerializer serializer];
//
//        /**设置可接受的类型*/
//        [self.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"text/plain",@"application/json",@"text/json",@"text/javascript",@"text/html", nil ,nil]];
        
        
//        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        //申明返回的结果是json类型
//        self.responseSerializer = [AFJSONResponseSerializer serializer];
        self.responseSerializer = [AFHTTPResponseSerializer serializer];

        //返回类型
        self.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"text/html", @"application/json", @"text/json", @"text/javascript", @"text/plain",@"application/x-javascript",@"image/png",@"text/html",@"application/x-javascript",@"application/javascript", @"json/text", nil];
        //请求时间
        self.requestSerializer.timeoutInterval= 30;
        
//        [self.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        AFSecurityPolicy *securityPolicy =  [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        
        securityPolicy.allowInvalidCertificates = YES;
        securityPolicy.validatesDomainName = NO;
        self.securityPolicy = securityPolicy;
    }
    
    return self;
}

#pragma mark - 设置请求头
+ (void)addHeaderFieldsWithDictionary:(NSDictionary *)headersDictionary
{
    [headersDictionary enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [[NetWorkEngine shareManager].requestSerializer setValue:obj forHTTPHeaderField:key];
        
    }];
}

#pragma mark - 网络请求的类方法---get/post

/**
 *  网络请求的实例方法
 *
 *  @param type         get / post
 *  @param urlString    请求的地址
 *  @param paraments    请求的参数
 *  @param successBlock 请求成功的回调
 *  @param failureBlock 请求失败的回调
 */

+(void)requestWithType:(HttpRequestType)type withUrlString:(NSString *)urlString withParaments:(id)paraments withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock progress:(downloadProgress)progress{
//    NSLog(@"请求URL：%@",urlString);
//    NSLog(@"请求参数：%@",paraments);
    
    NSString *url = urlString;
    
    switch (type) {
            
        case HttpRequestTypeGet:
        {
            [[NetWorkEngine shareManager] GET:url parameters:paraments progress:^(NSProgress * _Nonnull downloadProgress) {
                if (progress) {
                    progress(downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
                }

                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
//                [DCNetWorkManager responseWithResponseObject:responseObject response:successBlock errorResponse:failureBlock];


                NSError *err;
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&err];
                if (dic) {
                    successBlock(dic);
                }

                if(err) {

                    NSLog(@"json解析失败：%@",err);
                    successBlock(responseObject);
                    return ;
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                failureBlock(ERROR_STRING);
            }];
            
            break;
        }
        case HttpRequestTypePost:
        {
            
            [[NetWorkEngine shareManager] POST:url parameters:paraments progress:^(NSProgress * _Nonnull uploadProgress) {
                if (progress) {
                    progress(uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
                }

                
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//                [DCNetWorkManager responseWithResponseObject:responseObject response:successBlock errorResponse:failureBlock];
                NSError *err;
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&err];
                successBlock(dic);
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                failureBlock(ERROR_STRING);
                
                NSLog(@"Error结果：%@",error);
                
            }];
        }
    }
}


/**
 *  网络请求的实例方法 - (带缓存)
 *
 *  @param type         get / post
 *  @param urlString    请求的地址
 *  @param paraments    请求的参数
 *  @param successBlock 请求成功的回调
 *  @param failureBlock 请求失败的回调
 */

+(void)requestWithType:(HttpRequestType)type withUrlString:(NSString *)urlString withParaments:(id)paraments jsonCacheBlock:(requestCache)jsonCache withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock progress:(downloadProgress)progress{
    
    NSDictionary *responsedic = [NetWorkEngine cacheJsonWithURL:urlString];
    
    if (responsedic!=nil) { //获取缓存
        
        jsonCache([NetWorkEngine cacheJsonWithURL:urlString]);
    }
    
//    NSLog(@"请求URL： %@",urlString);
//    NSLog(@"请求参数：%@",paraments);
    
    switch (type) {
            
        case HttpRequestTypeGet:
        {
            [[NetWorkEngine shareManager] GET:urlString parameters:paraments progress:^(NSProgress * _Nonnull downloadProgress) {
                
                progress(downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                successBlock(responseObject);
                
                [NetWorkEngine saveJsonResponseToCacheFile:responseObject andURL:urlString];
                
//                [DCNetWorkManager responseWithResponseObject:responseObject response:successBlock errorResponse:failureBlock];
                successBlock(responseObject);
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                failureBlock(ERROR_STRING);
                
                NSLog(@"Error结果：%@",error);
            }];
            
            break;
        }
            
        case HttpRequestTypePost:
        {
            [[NetWorkEngine shareManager] POST:urlString parameters:paraments progress:^(NSProgress * _Nonnull uploadProgress) {
                
                progress(uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
                
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                NSLog(@"Post请求结果：%@",responseObject);
                
                
                
                [NetWorkEngine saveJsonResponseToCacheFile:responseObject andURL:urlString];
//                [DCNetWorkManager responseWithResponseObject:responseObject response:successBlock errorResponse:failureBlock];
                successBlock(responseObject);
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                failureBlock(ERROR_STRING);
                
                NSLog(@"Error结果：%@",error);
                
            }];
        }
    }
}




#pragma mark - 多图上传
/**
 *  上传图片
 *
 *  @param operations   上传图片等预留参数---视具体情况而定 可移除
 *  @param imageArray   上传的图片数组
 *  @parm width      图片要被压缩到的宽度
 *  @param urlString    上传的url---请填写完整的url
 *  @param successBlock 上传成功的回调
 *  @param failureBlock 上传失败的回调
 *  @param progress     上传进度
 *
 */
+(void)uploadImageWithOperations:(NSDictionary *)operations withImageArray:(NSArray *)imageArray withtargetWidth:(CGFloat )width withUrlString:(NSString *)urlString withSuccessBlock:(requestSuccess)successBlock withFailurBlock:(requestFailure)failureBlock withUpLoadProgress:(uploadProgress)progress;
{
    //1.创建管理者对象
    
    NSLog(@"请求URL： %@",urlString);
    
    urlString = [NSString stringWithFormat:@"%@",urlString];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager POST:urlString parameters:operations constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSUInteger i = 0 ;
        
        /**出于性能考虑,将上传图片进行压缩*/
        for (UIImage * image in imageArray) {
            
            //image的分类方法
//            UIImage *  resizedImage =  [UIImage IMGCompressed:image targetWidth:width];
            
            NSData * imgData = UIImageJPEGRepresentation(image, .5);
            
            // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
            // 要解决此问题，
            // 可以在上传时使用当前的系统事件作为文件名
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            // 设置时间格式
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
            NSString *name = [NSString stringWithFormat:@"image_%ld.png",(long)i];
            
            //将得到的二进制图片拼接到表单中 /** data,指定上传的二进制流;name,服务器端所需参数名*/
            [formData appendPartWithFileData:imgData name:name fileName:fileName mimeType:@"image/png"];
            
            i++;
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        progress(uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        
        successBlock(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failureBlock(ERROR_STRING);
        
    }];
}



#pragma mark - 视频上传

/**
 *  视频上传
 *
 *  @param operations   上传视频预留参数---视具体情况而定 可移除
 *  @param videoPath    上传视频的本地沙河路径
 *  @param urlString     上传的url
 *  @param successBlock 成功的回调
 *  @param failureBlock 失败的回调
 *  @param progress     上传的进度
 */

+(void)uploadVideoWithOperaitons:(NSDictionary *)operations withVideoPath:(NSString *)videoPath withUrlString:(NSString *)urlString withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock withUploadProgress:(uploadProgress)progress
{
    
    
    /**获得视频资源*/
    
    AVURLAsset * avAsset = [AVURLAsset assetWithURL:[NSURL URLWithString:videoPath]];
    
    /**压缩*/
    
    //    NSString *const AVAssetExportPreset640x480;
    //    NSString *const AVAssetExportPreset960x540;
    //    NSString *const AVAssetExportPreset1280x720;
    //    NSString *const AVAssetExportPreset1920x1080;
    //    NSString *const AVAssetExportPreset3840x2160;
    
    AVAssetExportSession  *  avAssetExport = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPreset640x480];
    
    /**创建日期格式化器*/
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
    
    /**转化后直接写入Library---caches*/
    
    NSString *  videoWritePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingString:[NSString stringWithFormat:@"/output-%@.mp4",[formatter stringFromDate:[NSDate date]]]];
    
    
    avAssetExport.outputURL = [NSURL URLWithString:videoWritePath];
    
    
    avAssetExport.outputFileType =  AVFileTypeMPEG4;
    
    
    [avAssetExport exportAsynchronouslyWithCompletionHandler:^{
        
        
        switch ([avAssetExport status]) {
                
                
            case AVAssetExportSessionStatusCompleted:
            {
                
                AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
                
                [manager POST:urlString parameters:operations constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                    
                    //获得沙盒中的视频内容
                    
                    [formData appendPartWithFileURL:[NSURL fileURLWithPath:videoWritePath] name:@"write you want to writre" fileName:videoWritePath mimeType:@"video/mpeg4" error:nil];
                    
                } progress:^(NSProgress * _Nonnull uploadProgress) {
                    
                    progress(uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
                    
                } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
                    
//                    [DCNetWorkManager responseWithResponseObject:responseObject response:successBlock errorResponse:failureBlock];
                    successBlock(responseObject);
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    
                    failureBlock(ERROR_STRING);
                    
                }];
                
                break;
            }
            default:
                break;
        }
    }];
}

#pragma mark - 文件下载

/**
 *  文件下载
 *
 *  @param operations   文件下载预留参数---视具体情况而定 可移除
 *  @param savePath     下载文件保存路径
 *  @param urlString        请求的url
 *  @param successBlock 下载文件成功的回调
 *  @param failureBlock 下载文件失败的回调
 *  @param progress     下载文件的进度显示
 */

+(void)downLoadFileWithOperations:(NSDictionary *)operations withSavaPath:(NSString *)savePath withUrlString:(NSString *)urlString withSuccessBlock:(requestSuccess)successBlock withFailureBlock:(requestFailure)failureBlock withDownLoadProgress:(downloadProgress)progress
{
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    
    [manager downloadTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]] progress:^(NSProgress * _Nonnull downloadProgress) {
        
        progress(downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
        
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        return  [NSURL URLWithString:savePath];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        if (error) {
            
            failureBlock(ERROR_STRING);
        }
        
    }];
    
}


#pragma mark -  取消所有的网络请求
/**
 *  取消所有的网络请求
 *  a finished (or canceled) operation is still given a chance to execute its completion block before it iremoved from the queue.
 */

+(void)cancelAllRequest{
    
    [[NetWorkEngine shareManager].operationQueue cancelAllOperations];
}

#pragma mark -   取消指定的url请求
/**
 *  取消指定的url请求
 *
 *  @param requestType 该请求的请求类型
 *  @param string      该请求的完整url
 */

+(void)cancelHttpRequestWithRequestType:(NSString *)requestType requestUrlString:(NSString *)string{
    NSError * error;
    
    /**根据请求的类型 以及 请求的url创建一个NSMutableURLRequest---通过该url去匹配请求队列中是否有该url,如果有的话 那么就取消该请求*/
    
    NSString * urlToPeCanced = [[[[NetWorkEngine shareManager].requestSerializer requestWithMethod:requestType URLString:string parameters:nil error:&error] URL] path];
    
    
    for (NSOperation * operation in [NetWorkEngine shareManager].operationQueue.operations) {
        
        //如果是请求队列
        if ([operation isKindOfClass:[NSURLSessionTask class]]) {
            
            //请求的类型匹配
            BOOL hasMatchRequestType = [requestType isEqualToString:[[(NSURLSessionTask *)operation currentRequest] HTTPMethod]];
            
            //请求的url匹配
            
            BOOL hasMatchRequestUrlString = [urlToPeCanced isEqualToString:[[[(NSURLSessionTask *)operation currentRequest] URL] path]];
            
            //两项都匹配的话  取消该请求
            if (hasMatchRequestType&&hasMatchRequestUrlString) {
                
                [operation cancel];
                
            }
        }
    }
}




#pragma mark - 缓存处理 方法
+(BOOL)saveJsonResponseToCacheFile:(id)jsonResponse andURL:(NSString *)URL{
    
//    NSDictionary *json = jsonResponse;
//    
//    NSString *path = [self cacheFilePathWithURL:URL];
//    
//    YYCache *cache = [[YYCache alloc] initWithPath:path];
//    
//    if(json!=nil)
//    {
//        BOOL state = [cache containsObjectForKey:URL];
//        
//        [cache setObject:json forKey:URL];
//        
//        if(state){
//            
//            NSLog(@"缓存写入/更新成功");
//        }
//        
//        return state;
//    }
    
    return NO;
}


+(id )cacheJsonWithURL:(NSString *)URL{
    
    id cacheJson;
    
//    NSString *path = [self cacheFilePathWithURL:URL];
//    
//    YYCache *cache = [[YYCache alloc] initWithPath:path];
//    
//    BOOL state = [cache containsObjectForKey:URL];
//    
//    if(state){
//        
//        cacheJson = [cache objectForKey:URL];
//    }
    
    return cacheJson;
}

+ (NSString *)cacheFilePathWithURL:(NSString *)URL {
    
    NSString *pathOfLibrary = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *path = [pathOfLibrary stringByAppendingPathComponent:@"bcwYYCache"];
    
    [self checkDirectory:path];//check路径
    
    //文件名
    NSString *cacheFileNameString = [NSString stringWithFormat:@"URL:%@ AppVersion:%@",URL,[self appVersionString]];
    NSString *cacheFileName = [self md5StringFromString:cacheFileNameString];
    path = [path stringByAppendingPathComponent:cacheFileName];
    
    //   DNSLog(@"缓存 path = %@",path);
    
    return path;
}

+(void)checkDirectory:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir;
    if (![fileManager fileExistsAtPath:path isDirectory:&isDir]) {
        [self createBaseDirectoryAtPath:path];
    } else {
        if (!isDir) {
            NSError *error = nil;
            [fileManager removeItemAtPath:path error:&error];
            [self createBaseDirectoryAtPath:path];
        }
    }
}

+ (void)createBaseDirectoryAtPath:(NSString *)path {
    __autoreleasing NSError *error = nil;
    [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES
                                               attributes:nil error:&error];
    if (error) {
        NSLog(@"create cache directory failed, error = %@", error);
    } else {
        
        [self addDoNotBackupAttribute:path];
    }
}

+ (void)addDoNotBackupAttribute:(NSString *)path {
    NSURL *url = [NSURL fileURLWithPath:path];
    NSError *error = nil;
    [url setResourceValue:[NSNumber numberWithBool:YES] forKey:NSURLIsExcludedFromBackupKey error:&error];
    if (error) {
        NSLog(@"error to set do not backup attribute, error = %@", error);
    }
}

+ (NSString *)md5StringFromString:(NSString *)string {
    
    if(string == nil || [string length] == 0)  return nil;
    
    const char *value = [string UTF8String];
    
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    CC_MD5(value, (CC_LONG)strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    
    return outputString;
}

+ (NSString *)appVersionString {
    
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

@end
