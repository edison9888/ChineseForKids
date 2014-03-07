//
//  Monkey.m
//  PinyinGame
//
//  Created by yang on 13-10-31.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "Monkey.h"
#import "cocos2d.h"
#import "Constants.h"

@implementation Monkey
{
    CCSprite *spMonkey;
}

+ (id)monkeyWithParentNode:(CCNode *)parentNode
{
    return [[self alloc] initWithParentNode:parentNode];
}

- (id)initWithParentNode:(CCNode *)parentNode
{
    CCLOG(@"%@; %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    if (self = [super init])
    {
        self.delegate = parentNode;
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        spMonkey = [CCSprite spriteWithSpriteFrameName:@"monkeyRun/0000"];
        spMonkey.position = ccp(winSize.width*0.5f, winSize.height*0.32f);
        [parentNode addChild:spMonkey z:kMonkey_z tag:kMonkeyTag];
        
        [self monkeyRun];
    }
    return self;
}

#pragma mark - Update Manager

#pragma mark - Animation Manager
- (void)monkeyRun
{
    NSMutableArray *arrAnimation=[NSMutableArray arrayWithCapacity:6];
    for(int i = 9; i >= 0; i--)
    {
        NSString *frameName = [NSString stringWithFormat:@"monkeyRun/%04d", i];
        CCSpriteFrame *frame=[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName];
        [arrAnimation addObject:frame];
    }
    
    CCAnimation *animation = [CCAnimation animationWithSpriteFrames:arrAnimation delay:0.083];
    if (spMonkey)
    {
        [spMonkey stopAllActions];
        [spMonkey runAction:[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:animation]]];
    }
}

- (void)monkeyJump
{
    // 跳跃结束的时候由box2D来控制返回回到奔跑状态
    NSMutableArray *arrAnimation=[NSMutableArray arrayWithCapacity:6];
    NSString *frameName = [NSString stringWithFormat:@"monkeyRun/0002"];
    CCSpriteFrame *frame=[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName];
    [arrAnimation addObject:frame];
    
    CCAnimation *animation = [CCAnimation animationWithSpriteFrames:arrAnimation delay:0.083];
    if (spMonkey)
    {
        [spMonkey stopAllActions];
        [spMonkey runAction:[CCSequence actions:[CCAnimate actionWithAnimation:animation], /*delayTime, callBlock,*/ nil]];
    }
}

// 悟空飞
- (void)monkeyFly
{
    NSMutableArray *arrAnimation=[NSMutableArray arrayWithCapacity:6];
    for(int i = 0; i <= 10; i++)
    {
        NSString *frameName = [NSString stringWithFormat:@"monkeyFly/%04d", i];
        CCSpriteFrame *frame=[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName];
        [arrAnimation addObject:frame];
    }
    
    CCAnimation *animation = [CCAnimation animationWithSpriteFrames:arrAnimation delay:0.083];
    if (spMonkey)
    {
        [spMonkey stopAllActions];
        CCCallFunc *monkeyRunFunc = [CCCallFunc actionWithTarget:self selector:@selector(monkeyRun)];
        CCCallFunc *animateEndFunc = [CCCallFunc actionWithTarget:self selector:@selector(monkeyAnimationFinished)];
        CCAnimate *animate = [CCAnimate actionWithAnimation:animation];
        CCSequence *seq = [CCSequence actions:animate, monkeyRunFunc, animateEndFunc, nil];
        [spMonkey runAction:seq];
    }
}

// 悟空翻跟斗
- (void)monkeySomersault
{
    NSMutableArray *arrAnimation=[NSMutableArray arrayWithCapacity:6];
    for(int i = 0; i <= 9; i++)
    {
        NSString *frameName = [NSString stringWithFormat:@"monkeySomersault/%04d", i];
        CCSpriteFrame *frame=[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName];
        [arrAnimation addObject:frame];
    }
    
    CCAnimation *animation = [CCAnimation animationWithSpriteFrames:arrAnimation delay:0.083];
    if (spMonkey)
    {
        [spMonkey stopAllActions];
        CCCallFunc *monkeyRunFunc = [CCCallFunc actionWithTarget:self selector:@selector(monkeyRun)];
        CCCallFunc *animateEndFunc = [CCCallFunc actionWithTarget:self selector:@selector(monkeyAnimationFinished)];
        CCAnimate *animate = [CCAnimate actionWithAnimation:animation];
        CCSequence *seq = [CCSequence actions:animate, monkeyRunFunc, animateEndFunc, nil];
        [spMonkey runAction:seq];
    }
}

- (void)monkeyAnimationFinished
{
    // 通知跳跃/飞结束
    if (self.delegate && [self.delegate respondsToSelector:@selector(monkey:animationFinished:)])
    {
        [self.delegate monkey:self animationFinished:YES];
    }
}

#pragma mark - Set Property Manger
- (void)setShouldJump:(BOOL)shouldJump
{
    
}

- (void)setShouldFly:(BOOL)shouldFly
{
    if (shouldFly)
    {
        [self monkeyFly];
    }
    _shouldFly = shouldFly;
}

- (void)setShouldSomersault:(BOOL)shouldSomersault
{
    if (shouldSomersault)
    {
        [self monkeySomersault];
    }
    _shouldSomersault = shouldSomersault;
}

#pragma mark - Memory Manager
- (void)dealloc
{
    CCLOG(@"%@; %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    [spMonkey stopAllActions];
    [spMonkey removeFromParentAndCleanup:YES];
    spMonkey = nil;
    
    _delegate = nil;
}

@end
