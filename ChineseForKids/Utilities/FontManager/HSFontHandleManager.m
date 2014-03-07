//
//  HSFontHandleManager.m
//  HSChildrenLearnCard
//
//  Created by yang on 13-9-17.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "HSFontHandleManager.h"

@implementation HSFontHandleManager

+ (NSInteger)resizableFontSizeWithFont:(UIFont *)aFont content:(NSString *)aContent width:(CGFloat)aWidth minFontSize:(NSInteger)aMinFontSize lineBreakMode:(NSLineBreakMode)aLineBreakMode
{
    CGFloat fontSize = 0;
    [aContent sizeWithFont:aFont minFontSize:aMinFontSize actualFontSize:&fontSize forWidth:aWidth lineBreakMode:aLineBreakMode];
    return fontSize;
}

+ (UIFont *)resizableSizeFontWithFont:(UIFont *)aFont content:(NSString *)aContent width:(CGFloat)aWidth minFontSize:(NSInteger)aMinFontSize lineBreakMode:(NSLineBreakMode)aLineBreakMode
{
    CGFloat fontSize = 0;
    [aContent sizeWithFont:aFont minFontSize:aMinFontSize actualFontSize:&fontSize forWidth:aWidth lineBreakMode:aLineBreakMode];
    return [UIFont fontWithName:aFont.fontName size:fontSize];
}

@end
