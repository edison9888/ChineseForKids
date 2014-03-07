//
//  CrashLogHelper.h
//  NYCodeFunPorject
//
//  Created by junfeng yang on 12-9-7.
//  Copyright (c) 2012年 star-net. All rights reserved.
//
//  说明:
//      IOS SDK中提供了一个现成的函数NSSetUncaughtExceptionHandler用来做异常处理，但功能非常有限，而引起崩溃的大多数原因如:
//      内存访问错误，重复释放等错误就无能为力了。
//      因为这种错误它抛出的是Signal。
//      所以必须要专门做Signal处理。
//

#import <Foundation/Foundation.h>

@interface CrashLogHelper : NSObject<UIAlertViewDelegate>
{
    BOOL dismissed;
}

+ (void)startLog;
+ (void)stopLog;
+ (void)clearLog;
+ (NSString *)loggingPath;

@end
NSString *getAppInfo(void);
void MySignalHandler(int signal);
void InstallUncaughtExceptionHandler(void);
void UnstallUncaughtExceptionHandler(void);
void clearLog(void);

void UncaughtExceptionHandler(NSException *execption);
