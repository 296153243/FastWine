//
//  UploadImgManager.m
//  CLTravel
//
//  Created by MOOSON_ on 2018/11/26.
//  Copyright © 2018年 MOOSON_. All rights reserved.
//

#import "UploadImgManager.h"

#define UPLOADURL [HOSTNAME stringByAppendingString:XQApiNameEnum(fileupload)]
@implementation UploadImgManager

static UploadImgManager * instance = nil;

+ (instancetype)manager{
    
    static dispatch_once_t onceTocken;
    dispatch_once(&onceTocken, ^{
        instance = [[UploadImgManager alloc] init];
    });
    return instance;
}
/**
 * ********************      向服务器上传图片               ********************
 *  urlStr  请求的网址
 *  params  发送请求的参数
 *  imageArray  需要上传图片的数组
 *  file  接收上传文件的key
 *  imageName  上传图片取什么名字（自己取的）
 *
 */
-(void)PostImagesToServer:(NSString *) strUrl dicPostParams:(NSMutableDictionary *)params imageArray:(NSArray *) imageArray file:(NSArray *)fileArray imageName:(NSArray *)imageNameArray Success :(Success)success andFailure:(Failure)failure{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //分界线的标识符
        NSString *TWITTERFON_FORM_BOUNDARY = @"AaB03x";
        NSURL *url = [NSURL URLWithString:strUrl];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        //分界线 --AaB03x
        NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
        //结束符 AaB03x--
        NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
        //要上传的图片
        UIImage *image;
        
        //将要上传的图片压缩 并赋值与上传的Data数组
        NSMutableArray *imageDataArray = [NSMutableArray array];
        for (int i = 0; i<imageArray.count; i++) {
            //要上传的图片
            image= imageArray[i];
            /**************  将图片压缩成我们需要的数据包大小 *******************/
            NSData * data = UIImageJPEGRepresentation(image, 1.0);
            CGFloat dataKBytes = data.length/1000.0;
            CGFloat maxQuality = 0.9f;
            CGFloat lastData = dataKBytes;
            while (dataKBytes > 1024 && maxQuality > 0.01f) {
                //将图片压缩成1M
                maxQuality = maxQuality - 0.01f;
                data = UIImageJPEGRepresentation(image, maxQuality);
                dataKBytes = data.length / 1000.0;
                if (lastData == dataKBytes) {
                    break;
                }else{
                    lastData = dataKBytes;
                }
            }
            /**************  将图片压缩成我们需要的数据包大小 *******************/
            [imageDataArray addObject:data];
        }
        
        //http body的字符串
        NSMutableString *body=[[NSMutableString alloc]init];
        //参数的集合的所有key的集合
        NSArray *keys= [params allKeys];
        
        //遍历keys
        for(int i=0;i<[keys count];i++) {
            //得到当前key
            NSString *key=[keys objectAtIndex:i];
            
            //添加分界线，换行
            [body appendFormat:@"%@\r\n",MPboundary];
            //添加字段名称，换2行
            [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
            
            //添加字段的值
            [body appendFormat:@"%@\r\n",[params objectForKey:key]];
            
        }
        
        //声明myRequestData，用来放入http body
        NSMutableData *myRequestData=[NSMutableData data];
        //将body字符串转化为UTF8格式的二进制
        [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
        
        //循环加入上传图片
        for(int i = 0; i< [imageDataArray count] ; i++){
            //要上传的图片
            //得到图片的data
            NSData* data =  imageDataArray[i];
            NSMutableString *imgbody = [[NSMutableString alloc] init];
            //此处循环添加图片文件
            //添加图片信息字段
            ////添加分界线，换行
            [imgbody appendFormat:@"%@\r\n",MPboundary];
            [imgbody appendFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@.jpg\"\r\n", fileArray[i],imageNameArray[i]];
            //声明上传文件的格式
            [imgbody appendFormat:@"Content-Type: application/octet-stream; charset=utf-8\r\n\r\n"];
            
            //将body字符串转化为UTF8格式的二进制
            [myRequestData appendData:[imgbody dataUsingEncoding:NSUTF8StringEncoding]];
            //将image的data加入
            [myRequestData appendData:data];
            [myRequestData appendData:[ @"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        }
        //声明结束符：--AaB03x--
        NSString *end=[[NSString alloc]initWithFormat:@"%@\r\n",endMPboundary];
        //加入结束符--AaB03x--
        [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
        
        //设置HTTPHeader中Content-Type的值
        NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
        //设置HTTPHeader
        [request setValue:content forHTTPHeaderField:@"Content-Type"];
        //设置Content-Length
        [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[myRequestData length]] forHTTPHeaderField:@"Content-Length"];
        //设置http body
        [request setHTTPBody:myRequestData];
        //http method
        [request setHTTPMethod:@"POST"];
        
        // 3.获得会话对象
        NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:nil];
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            //网络请求失败
            if (error != nil) {
                return;
            }
            //成功进行解析
            NSMutableDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            NSLog(@"%@--%@",dic, response);
        }];
        
        [task resume];
    });
}
#pragma makr -- 上传图片到服务器
-(void)uploadImageWithImageArr:(NSArray *)imgArr success:(Success)success andFaile:(Failure)failure{
    [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    //分线程队列执行
    dispatch_sync(dispatch_get_global_queue(0, 0), ^{
        //此处url
        NSString *url = UPLOADURL;
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                               cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                           timeoutInterval:30];
        request.HTTPMethod = @"POST";
        //分界线的标识符
        NSString *TWITTERFON_FORM_BOUNDARY = @"AaB03x";
        //分界线 --AaB03x
        NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
        //结束符 AaB03x--
        NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
        /*
         上传格图片格式：
         --AaB03x
         Content-Disposition: form-data; name="file"; filename="currentImage.png"
         Content-Type: image/png
         */
        NSMutableArray *imageDataArray = [NSMutableArray array];
        UIImage *image;
        for (int i = 0; i<imgArr.count; i++) {
            //要上传的图片
            image= imgArr[i];
            /**************  将图片压缩成我们需要的数据包大小 *******************/
            NSData * data = UIImageJPEGRepresentation(image, 1.0);
            CGFloat dataKBytes = data.length/1000.0;
            CGFloat maxQuality = 0.9f;
            CGFloat lastData = dataKBytes;
            while (dataKBytes > 1024 && maxQuality > 0.01f) {
                //将图片压缩成200K
                maxQuality = maxQuality - 0.01f;
                data = UIImageJPEGRepresentation(image, maxQuality);
                dataKBytes = data.length / 200.0;
                if (lastData == dataKBytes) {
                    break;
                }else{
                    lastData = dataKBytes;
                }
            }
            /**************  将图片压缩成我们需要的数据包大小 *******************/
            [imageDataArray addObject:data];
        }
        
        //声明结束符：--AaB03x--
        NSString *end=[[NSString alloc]initWithFormat:@"\r\n%@",endMPboundary];
        //声明myRequestData，用来放入http body
        NSMutableData *myRequestData=[NSMutableData data];
        //http body的字符串
        NSMutableString *body=[[NSMutableString alloc]init];
        //声明file字段
        for (int i = 0 ; i < imageDataArray.count ; i++) {
            //要上传的图片
            //得到图片的data
            NSData* data =  imageDataArray[i];
            //循环添加图片文件
            //添加分界线，换行
            [body appendFormat:@"%@\r\n",MPboundary];
            //添加图片信息字段
            NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
            formatter.dateFormat=@"yyyyMMddHHmmss";
            NSString *str=[formatter stringFromDate:[NSDate date]];
            NSString *fileName=[NSString stringWithFormat:@"%@%d.jpg",str,i];
            [body appendFormat:@"%@", [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"file\"; filename=\"%@\"\r\n",fileName]];
            //声明上传文件的格式
            [body appendFormat:@"Content-Type: image/jpg\r\n\r\n"];
            
            //将body字符串转化为UTF8格式的二进制
            [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
            //将image的data加入
            [myRequestData appendData:data];
            
            NSLog(@"网络请求body:%@",body);
        }
        //加入结束符--AaB03x--
        [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
        //设置HTTPHeader中Content-Type的值
        NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
        //设置HTTPHeader
        [request setValue:content forHTTPHeaderField:@"Content-Type"];
        //设置Content-Length
        [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[myRequestData length]] forHTTPHeaderField:@"Content-Length"];
        //设置http body
        [request setHTTPBody:myRequestData];
        
        NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:nil];
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            //网络请求失败
            if (error != nil) {
                return;
            }
            //成功进行解析
            NSMutableDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            NSLog(@"response--%@--%@",dic, response);
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.0001 * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES ];
            });
            if (success) {
                success(dic);
            }
            
        }];
        
        [task resume];
    });
   
    
}
-(void)uploadImageWithImage:(UIImage *)image success:(Success)success andFaile:(Failure)failure{
    [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    //分线程队列执行
    dispatch_sync(dispatch_get_global_queue(0, 0), ^{
        //此处url
        NSString *url = UPLOADURL;
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                               cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                           timeoutInterval:30];
        request.HTTPMethod = @"POST";
        //分界线的标识符
        NSString *TWITTERFON_FORM_BOUNDARY = @"AaB03x";
        //分界线 --AaB03x
        NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
        //结束符 AaB03x--
        NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
        /*
         上传格图片格式：
         --AaB03x
         Content-Disposition: form-data; name="file"; filename="currentImage.png"
         Content-Type: image/png
         */
        NSMutableArray *imageDataArray = [NSMutableArray array];
        
        NSData * data = UIImageJPEGRepresentation(image, 1.0);
        CGFloat dataKBytes = data.length/1000.0;
        CGFloat maxQuality = 0.9f;
        CGFloat lastData = dataKBytes;
        while (dataKBytes > 1024 && maxQuality > 0.01f) {
            //将图片压缩成500K
            maxQuality = maxQuality - 0.01f;
            data = UIImageJPEGRepresentation(image, maxQuality);
            dataKBytes = data.length / 200.0;
            if (lastData == dataKBytes) {
                break;
            }else{
                lastData = dataKBytes;
            }
        }
        /**************  将图片压缩成我们需要的数据包大小 *******************/
        [imageDataArray addObject:data];
        
        //声明结束符：--AaB03x--
        NSString *end=[[NSString alloc]initWithFormat:@"\r\n%@",endMPboundary];
        //声明myRequestData，用来放入http body
        NSMutableData *myRequestData=[NSMutableData data];
        //http body的字符串
        NSMutableString *body=[[NSMutableString alloc]init];
        //声明file字段
        for (int i = 0 ; i < imageDataArray.count ; i++) {
            //要上传的图片
            //得到图片的data
            NSData* data =  imageDataArray[i];
            //循环添加图片文件
            //添加分界线，换行
            [body appendFormat:@"%@\r\n",MPboundary];
            //添加图片信息字段
            NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
            formatter.dateFormat=@"yyyyMMddHHmmss";
            NSString *str=[formatter stringFromDate:[NSDate date]];
            NSString *fileName=[NSString stringWithFormat:@"%@%d.jpg",str,i];
            [body appendFormat:@"%@", [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"file\"; filename=\"%@\"\r\n",fileName]];
            //声明上传文件的格式
            [body appendFormat:@"Content-Type: image/jpg\r\n\r\n"];
            
            //将body字符串转化为UTF8格式的二进制
            [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
            //将image的data加入
            [myRequestData appendData:data];
            
            NSLog(@"网络请求body:%@",body);
        }
        //加入结束符--AaB03x--
        [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
        //设置HTTPHeader中Content-Type的值
        NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
        //设置HTTPHeader
        [request setValue:content forHTTPHeaderField:@"Content-Type"];
        //设置Content-Length
        [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[myRequestData length]] forHTTPHeaderField:@"Content-Length"];
        //设置http body
        [request setHTTPBody:myRequestData];
        
        NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:nil];
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            //网络请求失败
            if (error != nil) {
                return;
            }
            //成功进行解析
            NSMutableDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            NSLog(@"response--%@--%@",dic, response);
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.0001 * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES ];
            });
            if (success) {
                success(dic);
            }
            
        }];
        
        [task resume];
    });
}
-(void)uploadImageToQNImage:(NSArray *)imgArr success:(Success)success andFaile:(Failure)failure{
    
    [[HTTPRequest sharedManager] requestDataWithApiName:imageToken withParameters:nil isEnable:NO withSuccess:^(id responseObject) {
        QNUploadManager *upManager = [[QNUploadManager alloc] init];
        QNUploadOption *uploadOption = [[QNUploadOption alloc] initWithMime:nil progressHandler:^(NSString *key, float percent) {
            NSLog(@"上传进度 %.2f", percent);
        }
                                                                     params:nil
                                                                   checkCrc:NO
                                                         cancellationSignal:nil];
        NSMutableArray *imageDataArray = [NSMutableArray array];
        UIImage *image;
        for (int i = 0; i<imgArr.count; i++) {
            //要上传的图片
            image= imgArr[i];
            /**************  将图片压缩成我们需要的数据包大小 *******************/
            NSData * data = UIImageJPEGRepresentation(image, 1.0);
            CGFloat dataKBytes = data.length/1000.0;
            CGFloat maxQuality = 0.9f;
            CGFloat lastData = dataKBytes;
            while (dataKBytes > 1024 && maxQuality > 0.01f) {
                //将图片压缩成200K
                maxQuality = maxQuality - 0.01f;
                data = UIImageJPEGRepresentation(image, maxQuality);
                dataKBytes = data.length / 200.0;
                if (lastData == dataKBytes) {
                    break;
                }else{
                    lastData = dataKBytes;
                }
            }
            /**************  将图片压缩成我们需要的数据包大小 *******************/
            [imageDataArray addObject:data];
        }
        //声明file字段
        for (int i = 0 ; i < imageDataArray.count ; i++) {
            //要上传的图片
//            UIImage* getImage =  imageDataArray[i];
            //得到图片的data
            NSData *data = imageDataArray[i];
          
            //添加图片信息字段
            NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
            formatter.dateFormat=@"yyyyMMddHHmmss";
            NSString *str=[formatter stringFromDate:[NSDate date]];
            NSString *fileName=[NSString stringWithFormat:@"%@%d.jpg",str,i];
//            NSLog(@"tiken %@", responseObject[@"data"][@"token"]);

            [upManager putData:data key:fileName token:responseObject[@"data"][@"token"] complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                NSLog(@"QINIUinfo---:%@", info);
                NSLog(@"QINIUresp---%@", resp);
                NSString *imgUrl = [NSString stringWithFormat:@"http://polks363k.bkt.clouddn.com/%@",resp[@"key"]];
                if (success) {
                    success(imgUrl);
                }
            } option:uploadOption];
            
        }
        
    } withError:^(NSError *error) {
        
    }];
   
    

 
    
}
-(void)uploadImages:(NSArray *)images atIndex:(NSInteger)index token:(NSString *)token uploadManager:(QNUploadManager *)uploadManager keys:(NSMutableArray *)keys{
    UIImage *image = images[index];
    __block NSInteger imageIndex = index;
    NSData *data = UIImageJPEGRepresentation(image, 0.5);
    NSTimeInterval time= [[NSDate new] timeIntervalSince1970];
    NSString *filename = [NSString stringWithFormat:@"%@_%ld_%.f.%@",@"status",686734963504054272,time,@"jpg"];
    [uploadManager putData:data key:filename token:@""
                  complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                      if (info.isOK) {
                          [keys addObject:key];
                          NSLog(@"idInex %ld,OK",index);
                          imageIndex++;
                          if (imageIndex >= images.count) {
                              NSLog(@"上传完成");
                              for (NSString *imgKey in keys) {
                                  NSLog(@"%@",imgKey);
                              }
                              return ;
                          }
                          [self uploadImages:images atIndex:imageIndex token:token uploadManager:uploadManager keys:keys];
                      }
                      
                  } option:nil];
}

@end

