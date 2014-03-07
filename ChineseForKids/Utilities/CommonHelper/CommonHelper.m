//
//  CommonHelper.m
//  PinyinGame
//
//  Created by yang on 13-11-21.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "CommonHelper.h"

#include <sys/socket.h> // getMacAddr()
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import "sys/utsname.h"
#import "Toast+UIView.h"
#import "HTProgressHUD.h"

NSString *macAddress()
{
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if ((buf = (char*)(malloc(len))) == NULL) {
        printf("Could not allocate memory. error!\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        free(buf);
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    return outstring;
}

NSString *productID()
{
	NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *identifier = [infoDictionary objectForKey:@"CFBundleIdentifier"];
    NSString *strVersion = [infoDictionary objectForKey:@"CFBundleVersion"];
    NSString *productID  = [NSString stringWithFormat:@"%@_%@", identifier, strVersion];
    return productID;
}

NSString *timeStamp()
{
	NSDate* nowDate = [NSDate date];
	NSTimeZone* timename = [[NSTimeZone alloc] init];
	NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init ];
	[outputFormatter setDateFormat:@"YYMMddHHmmssSSS"];
	[outputFormatter setTimeZone:timename];
	NSString *newDateString = [outputFormatter stringFromDate:nowDate];
	return newDateString;
}

@implementation CommonHelper

+(ClientType)getClientTypeID
{
    ClientType type=0;
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *device=[NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    if( [device isEqualToString:@"i386"] || [device isEqualToString:@"x86_64"] ) type=14;
    else if( [device isEqualToString:@"iPhone1,1"] ) type=ClientiPhone1G;
    else if( [device isEqualToString:@"iPhone1,2"] ) type=ClientiPhone2G;
    else if( [device isEqualToString:@"iPhone2,1"] ) type=ClientiPhone3GS;
    else if( [device isEqualToString:@"iPhone3,1"] ) type=ClientiPhone4;
    else if( [device isEqualToString:@"iPod1,1"] ) type=ClientiPod1G;
    else if( [device isEqualToString:@"iPod2,1"] ) type=ClientiPod2G;
    else if( [device isEqualToString:@"iPod3,1"] ) type=ClientiPod3G;
    else if( [device isEqualToString:@"iPod4,1"] ) type=ClientiPod4G;
    else if( [device isEqualToString:@"iPad1,1"] ) type=ClientiPad1;
    else if( [device isEqualToString:@"iPad2,1"] ) type=ClientiPad2;
    else if( [device isEqualToString:@"iPad3,1"] ) type=ClientiPad3;
    else if( [device isEqualToString:@"iPhone4,1"]) type=ClientiPhone4S;
    else if( [device isEqualToString:@"iPhone5,1"]) type=ClientiPhone5;
    return type;
}

+ (void)makeToastWithMessage:(NSString *)aMessage view:(UIView *)aView
{
    [aView makeToast:aMessage duration:2.0 position:[NSValue valueWithCGPoint:CGPointMake(aView.center.x, aView.center.y+(aView.bounds.size.height - aView.center.y)/2)]];
}

#pragma mark - networkRequest Progress Manager
+ (id)addNetworkRequestProgressToView:(UIView *)aView withDelegate:(id)delegate content:(NSString *)aContent
{
    HTProgressHUD *HUD = [[HTProgressHUD alloc] initWithView:aView];
	[aView addSubview:HUD];
    HUD.delegate = delegate;
	HUD.labelText = aContent;
	HUD.dimBackground = YES;
	[HUD show:YES];
    return HUD;
}

#pragma mark - 分词处理
+ (NSArray *)separateComponents:(NSString *)components key:(NSString *)key
{
    if (!components) return nil;
    NSMutableArray *arrSeparated  = [[NSMutableArray alloc] init];
    // 如果有key值, 那么按照key值来分; 如果没有key值, 那么按照子串的范围来分
    if (key)
    {
        NSArray *arrTmpSep = [components componentsSeparatedByString:key];
        
        if (arrTmpSep) [arrSeparated setArray:arrTmpSep];
    }
    else
    {
        size_t length = [components length];
        for (size_t i = 0; i < length; i++)
        {
            NSString *strC = [components substringWithRange:NSMakeRange(i, 1)];
            [arrSeparated addObject:strC];
        }
    }
    return arrSeparated;
}

#pragma mark - 时间处理
+ (NSDate *)dateFromString:(NSString *)dateStr
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:dateStr];
    return date;
}

#pragma mark - 字体处理
+ (NSInteger)resizableFontSizeWithFont:(UIFont *)aFont content:(NSString *)aContent width:(CGFloat)aWidth minFontSize:(NSInteger)aMinFontSize lineBreakMode:(NSLineBreakMode)aLineBreakMode
{
    CGFloat fontSize = 0;
    [aContent sizeWithFont:aFont minFontSize:aMinFontSize actualFontSize:&fontSize forWidth:aWidth lineBreakMode:aLineBreakMode];
    return fontSize;
}

@end
