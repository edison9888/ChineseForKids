//
//  HSFontHandleManager.h
//  HSChildrenLearnCard
//
//  Created by yang on 13-9-17.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSFontHandleManager : NSObject

/**
 * 根据指定区域的大小来计算出适合的字体大小。
 * @param aFont:初始字体(默认).
 * @param aContent:文字内容.
 * @param aWidth:所占宽度.
 * @param aMinFontSize:字体大小的最小值
 * @param aLineBreakMode:换行模式
 * @return 返回改变后的字体大小值。
 */
+ (NSInteger)resizableFontSizeWithFont:(UIFont *)aFont content:(NSString *)aContent width:(CGFloat)aWidth minFontSize:(NSInteger)aMinFontSize lineBreakMode:(NSLineBreakMode)aLineBreakMode;

/**
 * 根据指定区域的大小来计算出适合的字体。
 * @param aFont:初始字体(默认).
 * @param aContent:文字内容.
 * @param aWidth:所占宽度.
 * @param aMinFontSize:字体大小的最小值
 * @param aLineBreakMode:换行模式
 * @return 返回改变后的字体。
 */
+ (UIFont *)resizableSizeFontWithFont:(UIFont *)aFont content:(NSString *)aContent width:(CGFloat)aWidth minFontSize:(NSInteger)aMinFontSize lineBreakMode:(NSLineBreakMode)aLineBreakMode;

@end
