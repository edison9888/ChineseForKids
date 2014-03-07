//
//  WordTimeControl.h
//  PinyinGame
//
//  Created by yang on 13-11-2.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "TimeProgressControl.h"

/**
 * 时间进度控制
 */

@class CCNode;

@interface WordTimeControl : TimeProgressControl

@property (nonatomic, unsafe_unretained)id<TimeProgressControlDelegate>delegate;
@property (nonatomic, readonly)CGRect boundingBox;

+ (id)timeProgressControlWithParentNode:(CCNode *)parentNode;

@end
