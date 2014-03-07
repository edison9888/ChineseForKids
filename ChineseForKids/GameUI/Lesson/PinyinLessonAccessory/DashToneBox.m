//
//  DashToneBox.m
//  PinyinGame
//
//  Created by yang on 13-10-31.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "DashToneBox.h"
#import "cocos2d.h"
#import "Constants.h"

@interface DashToneBox ()

@property (nonatomic, unsafe_unretained)id<DashToneBoxDelegate>delegate;

@end

@implementation DashToneBox
{
    CCSprite *spTone;
    CCSprite *spDashBox;
    BOOL isRightAnswer;
}

+ (id)dashToneBoxWithParentNode:(CCNode *)parentNode postion:(CGPoint)postion
{
    return [[self alloc] initWithParentNode:parentNode position:postion];
}

- (id)initWithParentNode:(CCNode *)parentNode position:(CGPoint)postion
{
    CCLOG(@"%@; %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    if (self = [super init])
    {
        _delegate = (id)parentNode;
        
        spDashBox = [CCSprite spriteWithSpriteFrameName:@"dashBoard.png"];
        spDashBox.position = postion;
        [parentNode addChild:spDashBox z:kDashBox_z tag:kDashBoxTag];
        _boundingBox = spDashBox.boundingBox;
        
        spTone = [CCSprite spriteWithSpriteFrameName:@"tone0.png"];
        spTone.position = spDashBox.position;
        spTone.visible = NO;
        [parentNode addChild:spTone z:kDashBox_Tone_z tag:kDashBoxToneTag];

    }
    return self;
}

#pragma mark - Update Manager

- (void)showToneWithPhoneme:(NSInteger)phoneme rightAnswer:(BOOL)rightAnswer animated:(BOOL)animated
{
    CCLOG(@"%@; %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    isRightAnswer = rightAnswer;
    if (spTone)
    {
        NSString *frameName = [NSString stringWithFormat:@"tone%d.png", phoneme];
        CCSpriteFrame *frame=[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName];
        [spTone setDisplayFrame:frame];
    }
    
    if (!rightAnswer)
    {
        CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"dashBoardRed.png"];
        [spDashBox setDisplayFrame:frame];
        CCBlink *blink = [CCBlink actionWithDuration:0.4f blinks:3];
        
        CCCallBlockN *callBack = [CCCallBlockN actionWithBlock:^(CCNode *node){
            CCSprite *spDash = (CCSprite *)node;
            CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"dashBoard.png"];
            [spDash setDisplayFrame:frame];
        }];
        
        CCSequence *seq = [CCSequence actions:blink, callBack, nil];
        
        [spDashBox runAction:seq];
    }
    
    // 加载显示出来的动画
    [self showTone];
}

#pragma mark - Animation Manager
- (void)showTone
{
    CCLOG(@"%@; %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    if (spTone)
    {
        spTone.visible = YES;
        CCCallFunc *callFunc = [CCCallFunc actionWithTarget:self selector:@selector(showToneComplete)];
        CCScaleTo *scaleTo = [CCScaleTo actionWithDuration:0.5f scale:1.1f];
        CCScaleTo *scaleBack = [CCScaleTo actionWithDuration:0.5f scale:1.0f];
        CCSequence *seq = [CCSequence actions:scaleTo, scaleBack, callFunc, nil];
        [spTone runAction:seq];
    }
}

- (void)hideTone
{
    CCLOG(@"%@; %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    if (spTone)
    {
        spTone.visible = NO;
    }
}

- (void)showToneComplete
{
    CCLOG(@"%@; %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    if (self.delegate && [self.delegate respondsToSelector:@selector(dashToneBox:toneSHowCompleteWithRightAnser:)])
    {
        [self.delegate dashToneBox:self toneSHowCompleteWithRightAnser:isRightAnswer];
    }
}

#pragma mark - Memory Manager
- (void)dealloc
{
    CCLOG(@"%@; %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    //[[self class] cancelPreviousPerformRequestsWithTarget:self];

    [spTone stopAllActions];
    [spTone removeFromParentAndCleanup:YES];
    spTone = nil;
    
    [spDashBox stopAllActions];
    [spDashBox removeFromParentAndCleanup:YES];
    spDashBox = nil;
    
    _delegate = nil;
    //NSLog(@"%@; %@ 结束!", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
}

@end
