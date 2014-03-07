//
//  Contents.m
//  PinyinGame
//
//  Created by yang on 13-11-5.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "Contents.h"

#import "Constants.h"
#import "cocos2d.h"

@implementation Contents
{
    CCLabelTTF *lblPinyin;
    CCLabelTTF *lblChinese;
}

+ (id)contentWithParentNode:(CCNode * __unsafe_unretained)parentNode pinyin:(NSString *)pinyin chinese:(NSString *)chinese position:(CGPoint)position
{
    return [[self alloc] initWithParentNode:parentNode pinyin:pinyin chinese:chinese position:position];
}

- (id)initWithParentNode:(CCNode *__unsafe_unretained)parentNode pinyin:(NSString *)pinyin chinese:(NSString *)chinese position:(CGPoint)position
{
    CCLOG(@"%@; %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    if (self = [super init])
    {
        BOOL chineseEmpty = [chinese isEqualToString:@""];
        
        CGFloat pinyinFontSize = chineseEmpty ? kContentsChineseFontSize : kPinyinFontSize;
        CGFloat pinyinPostionY = chineseEmpty ? -kContentsChineseFontSize*0.36f : 0.0f;
        
        lblPinyin = [CCLabelTTF labelWithString:pinyin fontName:kFontName fontSize:pinyinFontSize];
        lblPinyin.color = kPinyinColor;
        lblPinyin.position = ccpAdd(position, ccp(0.0f, pinyinPostionY));
        CCScaleTo *scaleTo = [CCScaleTo actionWithDuration:0.3f scaleX:1.2f scaleY:1.1f];
        CCScaleTo *scaleBack = [CCScaleTo actionWithDuration:0.3f scaleX:1.0f scaleY:1.0f];
        CCEaseBounceInOut *easeInOutTo = [CCEaseBounceInOut actionWithAction:scaleTo];
        CCEaseBounceInOut *easeInOutBack = [CCEaseBounceInOut actionWithAction:scaleBack];
        CCSequence *seq = [CCSequence actions:easeInOutTo, easeInOutBack, nil];
        [parentNode addChild:lblPinyin z:10];
        [lblPinyin runAction:seq];
        
        lblChinese = [CCLabelTTF labelWithString:chinese fontName:kFontName fontSize:kContentsChineseFontSize];
        lblChinese.color = kPinyinColor;
        lblChinese.position = ccpAdd(position, ccp(0.0f, -kContentsChineseFontSize*0.72f));
        [parentNode addChild:lblChinese z:10];
        [lblChinese runAction:[seq copy]];
    }
    return self;
}

- (void)setRightPinyin:(NSString *)rightPinyin
{
    [lblPinyin setString:rightPinyin];
}

#pragma mark - Memory Manager
- (void)dealloc
{
    CCLOG(@"%@; %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    [lblPinyin stopAllActions];
    [lblPinyin removeFromParentAndCleanup:YES];
    lblPinyin = nil;
    
    [lblChinese removeFromParentAndCleanup:YES];
    lblChinese = nil;
}

@end
