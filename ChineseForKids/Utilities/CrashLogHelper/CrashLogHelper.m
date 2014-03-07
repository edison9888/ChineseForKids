//
//  NYExceptionHandler.m
//  NYCodeFunPorject
//
//  Created by junfeng yang on 12-9-7.
//  Copyright (c) 2012年 star-net. All rights reserved.
//

#import "CrashLogHelper.h"
#include <libkern/OSAtomic.h>
#include <execinfo.h>
//#import "common.h"

NSString *const lmUncaughtExceptionHandlerSignalExceptionName = @"lmUncaughtExceptionHandlerSignalExceptionName";
NSString *const lmUncaughtExceptionHandlerSignalKey           = @"UncaughtExceptionHandlerSignalKey";
NSString *const lmUncaughtExceptionHandlerAddressesKey        = @"UncaughtExceptionHandlerAddressesKey";

volatile int32_t lmUncaughtExceptionCount   = 0;
const    int32_t lmUncaughtExceptionMaximum = 10;
const NSInteger lmUncaughtExceptionHandlerSkipAddressCount   = 4;
const NSInteger lmUncaughtExceptionHandlerReportAddressCount = 5;

NSUncaughtExceptionHandler *_uncaughtExceptionHandler;

@implementation CrashLogHelper

+ (NSArray *)backtrace
{
    void *callstack[128];
    //backtrace函数功能:回溯堆栈，简单的说就是可以列出当前函数调用关系.主要用于程序异常退出时寻找错误原因。
    int frames  = backtrace(callstack, 128);
    //backtrace_symbols将从backtrace函数获取的信息转化为一个字符串数组,参数1应该是从backtrace函数获取的数组指针,参数2为size是该数组中的元素个数(backtrace的返回值)
    char **strs = backtrace_symbols(callstack, frames);
    int i;
    NSMutableArray *backtrace = [NSMutableArray arrayWithCapacity:frames];
    for (i = lmUncaughtExceptionHandlerSkipAddressCount;
         i < lmUncaughtExceptionHandlerSkipAddressCount + lmUncaughtExceptionHandlerReportAddressCount;
         i++) 
    {
        [backtrace addObject:[NSString stringWithUTF8String:strs[i]]];
    }
    free(strs);
    return backtrace;
}

- (void)handleException:(NSException *)exception
{
    //NSLocalizedString:用来引用国际化文件
    //括号里第一个参数是要显示的内容,与各Localizable.strings中的id对应
    //第二个是对第一个参数的注释,一般可以为空串
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Unhandled exception", nil) message:[NSString stringWithFormat:NSLocalizedString(@"程序崩溃,是否继续", @"%@\n%@"), [exception reason], [[exception userInfo] objectForKey:lmUncaughtExceptionHandlerAddressesKey]] delegate:self cancelButtonTitle:NSLocalizedString(@"退出", nil) otherButtonTitles:NSLocalizedString(@"继续", nil), nil];
    [alert show];
    //-------------------------------------------------往文件中写日志-----------------------------------------------------
    //开始记录日志
    //[self startLog];
    NSArray  *stackArray = [exception callStackSymbols];
    NSString *reason = [exception reason];
    NSString *name   = [exception name];
    //NSString *sysErrInfo = [NSString stringWithFormat:@"异常名称：%@\n异常原因：%@\n异常堆栈信息：%@",name, reason, stackArray];
    //将调用栈拼成日志字符串输出。
    NSMutableString *strSymbols = [[NSMutableString alloc] init];
    for (NSString *item in stackArray)
    {
        [strSymbols appendString:item];
        [strSymbols appendString:@"\r\n"];
    }
    NSString *buildDate = [NSString stringWithFormat:@"%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"BUILD_DATE"]];                          //取得编译日志信息
    NSString *path = [self logPath];
    //先判断旧日志的信息量是否超过1M,如果超过就将旧日志删除,如果没有超过则将新日志与就日志合并。
    NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];                //先获取日志文件的属性信息
    NSNumber *fileSize = [attributes objectForKey:NSFileSize];
    if (fileSize)
    {
        //判断文件大小是否超过1M
        if ([fileSize intValue] > 1024*1024)
        {
            [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
        }
    }
    
    NSString *newLog = [NSString stringWithFormat:@"=============异常崩溃报告=============\n异常名称:\n%@\n异常原因:\n%@\n异常堆栈信息:\n%@\n发生日期:%@\n版本号:_%@\n", name, reason, [stackArray componentsJoinedByString:@"\r\n"], [NSDate date], buildDate];
    //取得旧日志的信息。
    NSMutableString *logStr =[[NSMutableString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    //将新日志与就日志信息合并。
    [logStr appendString:newLog];
    [logStr writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"%@", logStr);
    //-------------------------------------------------------------------------------------------------------------------
    
    //取得所有模块
    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
    CFArrayRef allModes  = CFRunLoopCopyAllModes(runLoop);
    //再此hold住线程,不让线程崩溃退出
    while (!dismissed)
    {
        for (NSString *mode in (__bridge NSArray *)allModes)
        {
            CFRunLoopRunInMode((__bridge CFStringRef)mode, 0.001, false);
        }
    }
    CFRelease(allModes);
    NSSetUncaughtExceptionHandler(NULL);
    signal(SIGABRT, SIG_DFL);
    signal(SIGILL, SIG_DFL);
    signal(SIGSEGV, SIG_DFL);
    signal(SIGFPE, SIG_DFL);
    signal(SIGBUS, SIG_DFL);
    signal(SIGPIPE, SIG_DFL);
    //关于isEqual与isEqualToString
    //isEqual:是string和id类型的值比较，先判断是否为字符串，再判断是否相等
    //isEqualToString则是直接用于字符串比较，省去判断后者是否为字符串
    if ([[exception name] isEqual:lmUncaughtExceptionHandlerSignalExceptionName])
    {
        kill(getpid(), [[[exception userInfo] objectForKey:lmUncaughtExceptionHandlerSignalKey] intValue]);
    }
    else
    {
        [exception raise];
    }
}
#pragma mark -
#pragma mark 写入日志文件
+ (void)startLog
{
    fflush(stderr);
    dup2(dup(STDERR_FILENO), STDERR_FILENO);
    freopen([[self loggingPath] cStringUsingEncoding:NSASCIIStringEncoding], "a+", stderr);
    
    _uncaughtExceptionHandler = NSGetUncaughtExceptionHandler();
    //设置处理未捕获的异常的Handler
    NSSetUncaughtExceptionHandler(&UncaughtExceptionHandler);
}

+ (void)stopLog
{
    fflush(stderr);
    dup2(dup(STDERR_FILENO), STDERR_FILENO);
    close(STDERR_FILENO);
    //还原为系统处理异常的Handler
    NSSetUncaughtExceptionHandler(_uncaughtExceptionHandler);
}

+ (void)clearLog
{
    NSString *emptyStr = [NSString stringWithFormat:@""];
    //[emptyStr writeToFile:exceptionPath atomically:YES encoding:NSStringEncodingConversionExternalRepresentation error:nil];
    [emptyStr writeToFile:[self loggingPath] atomically:YES encoding:NSStringEncodingConversionExternalRepresentation error:nil];
}

+ (NSString *)loggingPath
{
    NSArray *paths =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *logPath = [documentsDirectory stringByAppendingPathComponent:@"log.log"];
    return logPath;
}

- (NSString *)logPath
{
    NSArray *paths =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *logPath = [documentsDirectory stringByAppendingPathComponent:@"log.log"];
    return logPath;
}

#pragma mark -
#pragma mark UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (0 == buttonIndex)
    {
        dismissed = YES;
    }
}

@end

NSString *getAppInfo()
{
    NSString *appInfo = [NSString stringWithFormat:@"App:%@%@(%@)\nDevice:%@\nOS Version:%@\n UDID:%d\n",
                         [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"],
                         [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"],
                         [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"],
                         [UIDevice currentDevice].model,
                         [UIDevice currentDevice].systemName,
                         [UIDevice currentDevice].userInterfaceIdiom];
    NSLog(@"Crash!!!%@",appInfo);
    return appInfo;
}

void MySignalHandler(int signal)
{
    int32_t exceptionCount = OSAtomicIncrement32(&lmUncaughtExceptionCount);
    if (exceptionCount > lmUncaughtExceptionMaximum)
    {
        return;
    }
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObject:[NSNumber numberWithInt:signal] forKey:lmUncaughtExceptionHandlerSignalKey];
    NSArray *callStack = [CrashLogHelper backtrace];
    [userInfo setObject:callStack forKey:lmUncaughtExceptionHandlerAddressesKey];
    [[[CrashLogHelper alloc] init] performSelectorOnMainThread:@selector(handleException:) withObject:[NSException exceptionWithName:lmUncaughtExceptionHandlerSignalExceptionName reason:[NSString stringWithFormat:NSLocalizedString(@"Signal %d was raised.\n", @"%@"), signal, getAppInfo()] userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:signal] forKey:lmUncaughtExceptionHandlerSignalKey]] waitUntilDone:NO];
}

//每当有应用程序崩溃的信息发生后，抛出信号，调用信号处理函数MySignalHandler。
void InstallUncaughtExceptionHandler()
{
    signal(SIGABRT, MySignalHandler);
    signal(SIGILL, MySignalHandler);
    signal(SIGSEGV, MySignalHandler);
    signal(SIGFPE, MySignalHandler);
    signal(SIGBUS, MySignalHandler);
    signal(SIGPIPE, MySignalHandler);
#ifdef DEBUG
#else
    //[[[[NYExceptionHandler alloc] init] autorelease] performSelectorOnMainThread:@selector(startLog) withObject:nil waitUntilDone:NO];
#endif
}

void UnstallUncaughtExceptionHandler()
{
#ifdef DEBUG
#else
    //[[[[NYExceptionHandler alloc] init] autorelease] performSelectorOnMainThread:@selector(stopLog) withObject:nil waitUntilDone:NO];
#endif
    NSSetUncaughtExceptionHandler(NULL);
    signal(SIGABRT, SIG_DFL);
    signal(SIGILL, SIG_DFL);
    signal(SIGSEGV, SIG_DFL);
    signal(SIGFPE, SIG_DFL);
    signal(SIGBUS, SIG_DFL);
    signal(SIGPIPE, SIG_DFL);
}

void clearLog()
{
#ifdef DEBUG
#else
    [[[CrashLogHelper alloc] init] performSelectorOnMainThread:@selector(clearLog) withObject:nil waitUntilDone:NO];
#endif
}


void UncaughtExceptionHandler(NSException *exception)
{
    //开始记录日志
    //[self startLog];
    NSArray  *stackArray = [exception callStackSymbols];
    NSString *reason = [exception reason];
    NSString *name   = [exception name];
    //NSString *sysErrInfo = [NSString stringWithFormat:@"异常名称：%@\n异常原因：%@\n异常堆栈信息：%@",name, reason, stackArray];
    //将调用栈拼成日志字符串输出。
    NSMutableString *strSymbols = [[NSMutableString alloc] init];
    for (NSString *item in stackArray)
    {
        [strSymbols appendString:item];
        [strSymbols appendString:@"\r\n"];
    }
    NSString *buildDate = [NSString stringWithFormat:@"%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"BUILD_DATE"]];
    //取得编译日志信息
    NSString *path = [CrashLogHelper loggingPath];
    
    //先判断旧日志的信息量是否超过1M,如果超过就将旧日志删除,如果没有超过则将新日志与就日志合并。
    NSDictionary *attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];                //先获取日志文件的属性信息
    NSNumber *fileSize = [attributes objectForKey:NSFileSize];
    if (fileSize)
    {
        //判断文件大小是否超过1M
        if ([fileSize intValue] > 1024*1024)
        {
            [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
        }
    }

    NSString *newLog = [NSString stringWithFormat:@"=============异常崩溃报告=============\n异常名称:\n%@\n异常原因:\n%@\n异常堆栈信息:\n%@\n发生日期:%@\n版本号:_%@\n", name, reason, [stackArray componentsJoinedByString:@"\r\n"], [NSDate date], buildDate];
    //取得旧日志的信息。
    NSMutableString *logStr =[[NSMutableString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    //将新日志与就日志信息合并。
    [logStr appendString:newLog];
    [logStr writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"%@", logStr);
}


















