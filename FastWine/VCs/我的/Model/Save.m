//
//  Save.m
//  NDBaseProject
//
//  Created by WenhuaLuo on 17/6/14.
//  Copyright © 2017年 王猛. All rights reserved.
//

#import "Save.h"
#import <objc/runtime.h>

#define kMessagePath(path) [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:path]

@implementation Save

+ (void)setObject:(id)value forKey:(NSString *)defaultName{
    //存储数据
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:defaultName];
    //立刻同步
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

+ (id)objectForKey:(NSString *)defaultName
{
    //利用NSUserDefaults，就能直接访问软件的偏好设置（Lobarary/Preferences）
    return [[NSUserDefaults standardUserDefaults] objectForKey:defaultName];
}


/**
 *  存储帐号信息
 */
+ (void)saveUser:(User *)user
{
    [NSKeyedArchiver archiveRootObject:user toFile:kMessagePath(@"user.plist")];
}

/**
 *  获得上次存储的帐号
 *
 */
+ (User *)user
{
    User *user = [NSKeyedUnarchiver unarchiveObjectWithFile:kMessagePath(@"user.plist")];
    
    return user;
}

+ (NSString *)userID
{
    User *user = [self user];
    
    return user.uid;
}

+ (BOOL)isLogin
{
    User *user = [self user];
    if (!user.uid || user.uid.length==0) {
        return NO;
    }
    return YES;
}

+ (NSString *)userAvatar
{
    User *user = [self user];
    
    return user.avatar;
}

+ (NSString *)userPhone
{
    User *user = [self user];
    
    return user.phone;

}

+ (NSString *)userName
{
    User *user = [self user];
    return user.nickname;
}


+ (NSString *)odb_macid{
    User *user = [self user];
    return user.uid;
}
+ (NSString *)obd_mds{
    User *user = [self user];
    return user.uid;
}

+ (NSString *)obd_user_id{
    User *user = [self user];
    return user.uid;
}
@end




@implementation User

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"userID":@"id"
             };
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    unsigned int count = 0;
    Ivar *ivars = class_copyIvarList([User class], &count);
    for (int index = 0; index < count; index ++) {
        Ivar ivar = ivars[index];
        const char *name = ivar_getName(ivar);
        NSString *key = [NSString stringWithUTF8String:name];
        id value = [self valueForKey:key];
        [aCoder encodeObject:value forKey:key];
    }
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        unsigned int count = 0;
        Ivar *ivars = class_copyIvarList([User class], &count);
        for (int index = 0; index < count; index ++) {
            Ivar ivar = ivars[index];
            const char *name = ivar_getName(ivar);
            NSString *key = [NSString stringWithUTF8String:name];
            id value = [aDecoder decodeObjectForKey:key];
            
            [self setValue:value forKey:key];
        }
    }
    return self;
}

@end


