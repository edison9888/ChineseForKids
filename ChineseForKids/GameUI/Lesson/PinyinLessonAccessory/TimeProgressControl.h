//
//  TimeProgressControl.h
//  PinyinGame
//
//  Created by yang on 13-11-2.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "SimpleAudioEngine.h"
#import "cocos2d.h"

/**
 * 时间进度控制
 */

@class CCNode;

@protocol TimeProgressControlDelegate;

@interface TimeProgressControl : NSObject
{
    CCSprite *spTimer;
    CCSprite *spProgressBg;
    CCSprite *spProgressRedBg;
    
    CCProgressTimer *progress;
    
    NSString *oldAudioName;
    
    BOOL timeWarn;
}

@property (nonatomic, unsafe_unretained)id delegate;
@property (nonatomic, readonly)CGRect boundingBox;

+ (id)timeProgressControlWithParentNode:(CCNode *)parentNode;

- (id)initWithParentNode:(CCNode *)parentNode;

- (void)initInterfaceWithParentNode:(CCNode *)parentNode;

@end

@protocol TimeProgressControlDelegate <NSObject>

@optional
// 时间结束
- (void)timeProgressControl:(TimeProgressControl *)control timeOut:(BOOL)timeOut;

@end