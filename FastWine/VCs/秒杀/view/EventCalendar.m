//
//  EventCalendar.m
//  FastWine
//
//  Created by MOOSON_ on 2019/6/20.
//  Copyright © 2019 MOOSON_. All rights reserved.
//

#import "EventCalendar.h"
#import <EventKit/EventKit.h>
#import <UIKit/UIKit.h>

@implementation EventCalendar

static EventCalendar *calendar;

+ (instancetype)sharedEventCalendar{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        calendar = [[EventCalendar alloc] init];
    });
    
    return calendar;
}

+(instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        calendar = [super allocWithZone:zone];
    });
    return calendar;
}

- (void)createEventCalendarTitle:(NSString *)title location:(NSString *)location startDate:(NSDate *)startDate endDate:(NSDate *)endDate allDay:(BOOL)allDay alarmArray:(NSArray *)alarmArray{
    __weak typeof(self) weakSelf = self;
    
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    
    if ([eventStore respondsToSelector:@selector(requestAccessToEntityType:completion:)])
    {
        [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error){
            
            dispatch_async(dispatch_get_main_queue(), ^{
                __strong typeof(weakSelf) strongSelf = weakSelf;
                if (error)
                {
                    [strongSelf showAlert:@"添加失败，请稍后重试"];
                    
                }else if (!granted){
                    [strongSelf showAlert:@"不允许使用日历,请在设置中允许此App使用日历"];
                    
                }else{
                    EKEvent *event  = [EKEvent eventWithEventStore:eventStore];
                    event.title     = title;
                    event.location = location;
                    
                    NSDateFormatter *tempFormatter = [[NSDateFormatter alloc]init];
                    [tempFormatter setDateFormat:@"dd.MM.yyyy HH:mm"];
                    
                    event.startDate = startDate;
                    event.endDate   = endDate;
                    event.allDay = allDay;
                    
                    //添加提醒
                    if (alarmArray && alarmArray.count > 0) {
                        
                        for (NSString *timeString in alarmArray) {
                            [event addAlarm:[EKAlarm alarmWithRelativeOffset:[timeString integerValue]]];
                        }
                    }
                    
                    [event setCalendar:[eventStore defaultCalendarForNewEvents]];
                    NSError *err;
                    [eventStore saveEvent:event span:EKSpanThisEvent error:&err];
                    [strongSelf showAlert:@"已添加到系统日历中"];
                    
                }
            });
        }];
    }
}

- (void)showAlert:(NSString *)message
{
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
//    
//    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        
//    }];
//
//    [alertController addAction:okAction];
//    [self presentViewController:alertController animated:YES completion:nil];
    [QuHudHelper qu_showMessage:message];
}

@end

