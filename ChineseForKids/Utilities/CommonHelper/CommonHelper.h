//
//  CommonHelper.h
//  PinyinGame
//
//  Created by yang on 13-11-21.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

NSString *macAddress();
NSString *productID();
NSString *timeStamp();

@interface CommonHelper : NSObject

//+(NSString *)macAddress;
//+(NSString *)productID;

+(ClientType)getClientTypeID;

// 以面包屑的形式查看提示信息。
+ (void)makeToastWithMessage:(NSString *)aMessage view:(UIView *)aView;


#pragma mark - networkRequest Progress Manager
+ (id)addNetworkRequestProgressToView:(UIView *)aView withDelegate:(id)delegate content:(NSString *)aContent;

#pragma mark - 分词处理
+ (NSArray *)separateComponents:(NSString *)components key:(NSString *)key;

#pragma mark - 时间处理
+ (NSDate *)dateFromString:(NSString *)dateStr;

#pragma mark - 字体处理
+ (NSInteger)resizableFontSizeWithFont:(UIFont *)aFont content:(NSString *)aContent width:(CGFloat)aWidth minFontSize:(NSInteger)aMinFontSize lineBreakMode:(NSLineBreakMode)aLineBreakMode;

@end
