//
//  Contents.h
//  PinyinGame
//
//  Created by yang on 13-11-5.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CCNode;

@interface Contents : NSObject

+ (id)contentWithParentNode:(CCNode *)parentNode pinyin:(NSString *)pinyin chinese:(NSString *)chinese position:(CGPoint)position;

- (void)setRightPinyin:(NSString *)rightPinyin;

@end
