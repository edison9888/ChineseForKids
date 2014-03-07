//
//  Monkey.h
//  PinyinGame
//
//  Created by yang on 13-10-31.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CCNode;
@protocol MonkeyDelegate;
/**
 * 悟空
 */
@interface Monkey : NSObject

@property (nonatomic, unsafe_unretained)id delegate;
@property (nonatomic, readwrite)BOOL shouldJump;
@property (nonatomic, readwrite)BOOL shouldFly;
@property (nonatomic, readwrite)BOOL shouldSomersault;

+ (id)monkeyWithParentNode:(CCNode *)parentNode;

@end

@protocol MonkeyDelegate <NSObject>

@optional
- (void)monkey:(Monkey *)monkey animationFinished:(BOOL)finished;

@end
