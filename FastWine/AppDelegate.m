//
//  AppDelegate.m
//  FastWine
//
//  Created by MOOSON_ on 2019/3/12.
//  Copyright © 2019年 MOOSON_. All rights reserved.
//

#import "AppDelegate.h"
#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>
#import "QMProfileManager.h"
#import "QMHomeViewController.h"
#import "QMManager.h"
#import <QMLineSDK/QMLineSDK.h>
#import "YLImageView.h"
#import "YLGIFImage.h"
#import "MainViewController.h"
// 引入 JPush 功能所需头文件
#import "JPUSHService.h"
// iOS10 注册 APNs 所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
@interface AppDelegate ()<WXApiDelegate,JPUSHRegisterDelegate>
@property(nonatomic,strong)UIImageView *customLaunchImageView;
@property(nonatomic,strong)YLImageView *imageView;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    UIStoryboard *storyboard = [UIStoryboard  storyboardWithName:@"Main" bundle:nil];
 
    [[UIApplication sharedApplication].keyWindow setRootViewController:storyboard];
  
    [_window makeKeyAndVisible];
    

    [[ThirdApiManager shareManager] registerThirdApi];
    
    /**
     创建文件管理类
     name: 可随便填写
     password: 可随便填写
     */
    QMProfileManager *manger = [QMProfileManager sharedInstance];
    [manger loadProfile:@"JSMallKefufileManager" password:@"123456"];
    
    if (@available(iOS 11.0, *)){
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
    
    // 加载动态图片
    [self setUpLaunchScreen];
    
//    //notice: 3.0.0 及以后版本注册可以这样写，也可以继续用之前的注册方式
//    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
//    if (@available(iOS 12.0, *)) {
//        entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound|JPAuthorizationOptionProvidesAppNotificationSettings;
//    } else {
//        // Fallback on earlier versions
//    }
//    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
//        // 可以添加自定义 categories
//        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
//        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
//    }
//    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    // init Push
    // notice: 2.1.5 版本的 SDK 新增的注册方法，改成可上报 IDFA，如果没有使用 IDFA 直接传 nil
//    [JPUSHService setupWithOption:launchOptions appKey:JPushAppKey
//                          channel:@"AppStore"
//                 apsForProduction:YES
//            advertisingIdentifier:nil];
//    [self requestAppVersionCheck];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            if (resultDic){
                NSString *result = [resultDic objectForKey:@"resultStatus"];
                
                if ([@"9000" isEqualToString:result]) {
                    
                    if ([ThirdApiManager shareManager].thirdPaySuccessBlock) {
                        [ThirdApiManager shareManager].thirdPaySuccessBlock();
                    }
                }
                else{
                    if ([ThirdApiManager shareManager].thirdPayFailBlock) {
                        [ThirdApiManager shareManager].thirdPayFailBlock();
                    }
                }
                
            }
            else{
                
                if ([ThirdApiManager shareManager].thirdPayFailBlock) {
                    [ThirdApiManager shareManager].thirdPayFailBlock();
                }
            }
        }];
        return YES;
        
    }
    
    return [WXApi handleOpenURL:url delegate:self];
}

//9.0后的方法
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options{
    
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            if (resultDic){
                NSString *result = [resultDic objectForKey:@"resultStatus"];
                
                if ([@"9000" isEqualToString:result]) {
                    
                    if ([ThirdApiManager shareManager].thirdPaySuccessBlock) {
                        [ThirdApiManager shareManager].thirdPaySuccessBlock();
                    }
                }
                else{
                    if ([ThirdApiManager shareManager].thirdPayFailBlock) {
                        [ThirdApiManager shareManager].thirdPayFailBlock();
                    }
                }
                
            }
            else{
                
                if ([ThirdApiManager shareManager].thirdPayFailBlock) {
                    [ThirdApiManager shareManager].thirdPayFailBlock();
                }
            }
        }];
        return YES;
        
    }
    //这里判断是否发起的请求为微信支付，如果是的话，用WXApi的方法调起微信客户端的支付页面（://pay 之前的那串字符串就是你的APPID，）
    return  [WXApi handleOpenURL:url delegate:self];
}
- (void)onResp:(BaseResp *)resp{
    if ([resp isKindOfClass:[PayResp class]]){
        PayResp *response = (PayResp *)resp;
        switch(response.errCode){
            case WXSuccess:
                //服务器端查询支付通知或查询API返回的结果再提示成功
                NSLog(@"支付成功");
                if ([ThirdApiManager shareManager].thirdPaySuccessBlock) {
                    [ThirdApiManager shareManager].thirdPaySuccessBlock();
                }
                
                break;
            default:
                NSLog(@"支付失败，retcode=%d",resp.errCode);
                if ([ThirdApiManager shareManager].thirdPayFailBlock) {
                    [ThirdApiManager shareManager].thirdPayFailBlock();
                }
                break;
        }
    }
}


// 远程通知注册成功委托
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"注册deviceToken---%@",deviceToken);
    [QMConnect setServerToken:deviceToken];
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
    
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@" userinfo ===== %@", userInfo);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    NSString *messageAlert = [[userInfo objectForKey:@"aps"]objectForKey:@"alert"];
    NSString *accessId = [userInfo objectForKey:@"accessId"];
    NSString *sid = [userInfo objectForKey:@"sid"];
    
    NSArray *array = [sid componentsSeparatedByString:@"@"];
    NSString *userId = array[array.count - 2];
    
    NSString *userName = @"用户名";
    
    if (application.applicationState == UIApplicationStateActive) {
        [application setApplicationIconBadgeNumber:0];
        //弹框通知
        UIAlertController * stateAlert = [UIAlertController alertControllerWithTitle:@"客服新消息" message:messageAlert preferredStyle:UIAlertControllerStyleAlert];
        [stateAlert addAction:[UIAlertAction actionWithTitle:@"前往" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [QMConnect registerSDKWithAppKey:accessId userName:userName userId:userId];
        }]];
        [stateAlert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
        [self.window.rootViewController presentViewController:stateAlert animated:YES completion:nil];
    }else {
        [QMConnect registerSDKWithAppKey:accessId userName:userName userId:userId];
    }
    
    [QMManager defaultManager].selectedPush = YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 1;
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}
#pragma mark- JPUSHRegisterDelegate

// iOS 12 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(UNNotification *)notification{
    if (notification && [notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //从通知界面直接进入应用
    }else{
        //从通知设置界面进入应用
    }
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有 Badge、Sound、Alert 三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}


//添加启动图
- (void)setUpLaunchScreen{
    
    NSURL *fileUrl;
    if (SCREEN_HEIGHT==480) {// 屏幕的高度为480
        fileUrl = [[NSBundle mainBundle] URLForResource:@"Qidongye1" withExtension:@"gif"]; // 加载GIF图片
    }else if(SCREEN_HEIGHT==568) {// 屏幕的高度为568
        //5 5s         0.853333 0.851574
        fileUrl = [[NSBundle mainBundle] URLForResource:@"Qidongye1" withExtension:@"gif"]; // 加载GIF图片
        
    }else if(SCREEN_HEIGHT==667){// 屏幕的高度为667
        //6 6s 7       1.000000 1.000000
        fileUrl = [[NSBundle mainBundle] URLForResource:@"Qidongye1" withExtension:@"gif"]; // 加载GIF图片
    }else if(SCREEN_HEIGHT==736){// 屏幕的高度为736
        //6p 6sp 7p
        fileUrl = [[NSBundle mainBundle] URLForResource:@"Qidongye1" withExtension:@"gif"]; // 加载GIF图片
    }else if(SCREEN_HEIGHT==812){// 屏幕的高度为812    375.000000 812.000000
        // x
        fileUrl = [[NSBundle mainBundle] URLForResource:@"Qidongye1" withExtension:@"gif"]; // 加载GIF图片
        
    }else{
        
    }
    
    
    
    CGImageSourceRef gifSource = CGImageSourceCreateWithURL((CFURLRef) fileUrl, NULL);           //将GIF图片转换成对应的图片源
    size_t frameCout = CGImageSourceGetCount(gifSource);                                         // 获取其中图片源个数，即由多少帧图片组成
    NSMutableArray *frames = [[NSMutableArray alloc] init];                                      // 定义数组存储拆分出来的图片
    for (size_t i = 0; i < frameCout; i++) {
        CGImageRef imageRef = CGImageSourceCreateImageAtIndex(gifSource, i, NULL); // 从GIF图片中取出源图片
        UIImage *imageName = [UIImage imageWithCGImage:imageRef];                  // 将图片源转换成UIimageView能使用的图片源
        [frames addObject:imageName];                                              // 将图片加入数组中
        CGImageRelease(imageRef);
    }
    
    self.customLaunchImageView = [[UIImageView alloc]initWithFrame:self.window.bounds];
  
    NSLog(@"宽高为%lf %lf",self.window.bounds.size.width,self.window.bounds.size.height);
    self.customLaunchImageView.userInteractionEnabled = YES;
    
    self.customLaunchImageView.animationImages = frames; // 将图片数组加入UIImageView动画数组中
    self.customLaunchImageView.animationDuration = 0.7; // 每次动画时长
    [self.customLaunchImageView startAnimating];         // 开启动画，此处没有调用播放次数接口，UIImageView默认播放次数为无限次，故这里不做处理
   
//    [[UIApplication sharedApplication].keyWindow addSubview:_imageView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.customLaunchImageView];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self.customLaunchImageView];
    
    //2秒后自动关闭
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self yourButtonClick];
    });
}

- (void)yourButtonClick {
    
    // 移动自定义启动图
    if (self.customLaunchImageView) {
        [UIView animateWithDuration:0.3 animations:^{
            self.customLaunchImageView.alpha = 0;
        } completion:^(BOOL finished) {
            [self.customLaunchImageView removeFromSuperview];
            self.customLaunchImageView = nil;
        }];
    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"FastWine"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end
