//
//  Peach.h
//  PinyinGame
//
//  Created by yang on 13-10-31.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CCNode;

@protocol PeachTouchDelegate;
/**
 * 桃子
 */
@interface Peach : NSObject

@property (nonatomic, readwrite)BOOL touchEnabled;
@property (nonatomic, readwrite)BOOL isRightPhoneme;
@property (nonatomic, readwrite)BOOL isMoveRightPeach;
@property (nonatomic, readonly)NSInteger phoneme;
@property (nonatomic, readonly)CGRect boundingBox;
@property (nonatomic, unsafe_unretained)id<PeachTouchDelegate>delegate;

+ (id)peachWithParentNode:(CCNode *)parentNode phoneme:(NSInteger)phoneme position:(CGPoint)position;

@end

@protocol PeachTouchDelegate <NSObject>

@optional
- (void)peach:(Peach *)peach touchEnd:(UITouch *)touch;

@end
