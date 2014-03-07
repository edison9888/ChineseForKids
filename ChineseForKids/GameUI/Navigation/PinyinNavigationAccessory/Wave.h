//
//  Wave.h
//  PinyinGame
//
//  Created by yang on 13-11-19.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CCNode;

@interface Wave : NSObject

+ (id)waveWithParentNode:(CCNode *)parentNode;

- (void)waveMoveWithDistance:(CGFloat)distance;

- (void)waveHideWithAnimate:(BOOL)animate;
- (void)waveShowWithAnimate:(BOOL)animate;

@end
