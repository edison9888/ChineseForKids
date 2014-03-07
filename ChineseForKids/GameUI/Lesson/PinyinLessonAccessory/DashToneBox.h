//
//  DashToneBox.h
//  PinyinGame
//
//  Created by yang on 13-10-31.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CCNode;

@protocol DashToneBoxDelegate;

@interface DashToneBox : NSObject

@property (nonatomic, readonly)CGRect boundingBox;

+ (id)dashToneBoxWithParentNode:(CCNode *)parentNode postion:(CGPoint)postion;

// 在虚线声调框内显示声调。
- (void)showToneWithPhoneme:(NSInteger)phoneme rightAnswer:(BOOL)rightAnswer animated:(BOOL)animated;

// 将声调隐藏
- (void)hideTone;

@end

@protocol DashToneBoxDelegate <NSObject>

@optional
- (void)dashToneBox:(DashToneBox *)dashToneBox toneSHowCompleteWithRightAnser:(BOOL)right;

@end