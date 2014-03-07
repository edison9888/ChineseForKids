//
//  TimeProgressControl.m
//  PinyinGame
//
//  Created by yang on 13-11-2.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "TimeProgressControl.h"
#import "GlobalDataHelper.h"

@implementation TimeProgressControl

+ (id)timeProgressControlWithParentNode:(CCNode *)parentNode
{
    return [[self alloc] initWithParentNode:parentNode];
}

- (id)initWithParentNode:(CCNode *)parentNode
{
    CCLOG(@"%@; %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    if (self = [super init])
    {
        timeWarn = NO;
        self.delegate = parentNode;
        [self initInterfaceWithParentNode:parentNode];
        
        [[[CCDirector sharedDirector] scheduler] scheduleSelector:@selector(checkTimerProgress:) forTarget:self interval:1.0f paused:NO];
    }
    return self;
}

- (void)initInterfaceWithParentNode:(CCNode *)parentNode
{
    // 闹钟
    spTimer=[CCSprite spriteWithSpriteFrameName:@"timer.png"];
    spTimer.position = ccp(parentNode.boundingBox.size.width*0.06f, parentNode.boundingBox.size.height*0.86f);
    [parentNode addChild:spTimer z:kLeftTree_z+2 tag:kTimerTag];
    
    // 进度条背景
    spProgressBg = [CCSprite spriteWithSpriteFrameName:@"progressBkg.png"];
    spProgressBg.position = ccp(spTimer.position.x, spTimer.position.y-(spTimer.boundingBox.size.height*0.5f+spProgressBg.boundingBox.size.width*0.5f));//ccpAdd(spTimer.position, ccpAdd(ccp(-spTimer.boundingBox.size.width*0.6f, 0), ccp(-spProgressBg.boundingBox.size.width*0.5f, -spTimer.boundingBox.size.height/6.0f)));
    spProgressBg.rotation = 90;
    [parentNode addChild:spProgressBg z:kLeftTree_z+1 tag:kTimerProgressBkgTag];
    
    // 进度条红色背景框
    spProgressRedBg = [CCSprite spriteWithSpriteFrameName:@"progressRedBkg.png"];
    spProgressRedBg.visible = NO;
    spProgressRedBg.position = spProgressBg.position;//ccpAdd(spTimer.position, ccpAdd(ccp(-spTimer.boundingBox.size.width*0.6f, 0), ccp(-spProgressRedBg.boundingBox.size.width*0.5f, -spTimer.boundingBox.size.height/6.0f)));
    spProgressRedBg.rotation = 90;
    [parentNode addChild:spProgressRedBg z:kLeftTree_z+1 tag:kTimerProgressRedBkgTag];
    
    // 进度条
    progress=[CCProgressTimer progressWithSprite:[CCSprite spriteWithSpriteFrameName:@"progressFill.png"]];
    [progress setPercentage:100.0f];
    progress.midpoint = ccp(1, 0.5);
    progress.barChangeRate = ccp(1,0);
    progress.type = kCCProgressTimerTypeBar;
    progress.position = spProgressBg.position;
    progress.rotation = 90;
    [parentNode addChild:progress z:kLeftTree_z+1 tag:kTimerProgressTag];
    [self updateProgress];
}

#pragma mark - Update Manager
- (void)updateProgress
{
    id callBack = [CCCallBlock actionWithBlock:^{
        [self progressTimeOut];
    }];
    ccTime duration = TIME_PER_LEVEL;
    if ([GlobalDataHelper sharedManager].curTypeID == 3)
    {
        duration = 90;
    }
    [progress runAction:[CCSequence actions:[CCProgressFromTo actionWithDuration:duration from:progress.percentage to:0], callBack,nil]];
}


// 处理时间走到一定百分比的时候的处理
- (void)checkTimerProgress:(ccTime)delta
{
    // 时间走到50%时的处理
    if (progress.percentage <= 50 && !timeWarn)
    {
        timeWarn = YES;
        // 绿色的进度变成红色的。
        CCBlink *blink = [CCBlink actionWithDuration:0.9f blinks:2];
        CCCallBlock *callBlock = [CCCallBlock actionWithBlock:^{
            [progress.sprite removeFromParentAndCleanup:YES];
            progress.sprite = nil;
            progress.sprite = [CCSprite spriteWithSpriteFrameName:@"progressRedfill.png"];
        }];
        
        CCFadeOut *fadeOut = [CCFadeOut actionWithDuration:0.1f];
        CCFadeIn  *fadeIn  = [CCFadeIn actionWithDuration:0.1f];
        
        CCSequence *sequence = [CCSequence actions:blink, fadeOut, callBlock, fadeIn, nil];
        [progress runAction:sequence];
    }
    
    // 时间走到10%时的处理
    if (progress.percentage <= 20)
    {
        // 进度条的背景变成红色的框, 然后闪烁。
        CCBlink *blink = [CCBlink actionWithDuration:1.0f blinks:1];
        
        CCCallBlock *callBlock = [CCCallBlock actionWithBlock:^{
            if (!spProgressRedBg.visible) spProgressRedBg.visible = YES;
        }];
        CCSequence *sequence = [CCSequence actions:blink, callBlock, nil];
        
        [spProgressRedBg runAction:sequence];
        // 发出嘟嘟嘟的报警声
        //[[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:0.2f];
        [self playAudioWithName:@"clockTick.caf"];
    }
}

- (void)playAudioWithName:(NSString *)name
{
    if (name && ![name isEqualToString:@""])
    {
        CCLOG(@"%@ : %@ name:%@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), name);
        // 先卸载旧的音效, 以免音效播放出现混乱
        [[SimpleAudioEngine sharedEngine] unloadEffect:oldAudioName];
        [[SimpleAudioEngine sharedEngine] playEffect:name];
        oldAudioName = name;
    }
}

#pragma mark - Delegate
- (void)progressTimeOut
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(timeProgressControl:timeOut:)])
    {
        [self.delegate timeProgressControl:self timeOut:YES];
    }
}

#pragma mark - Memory Manager
- (void)dealloc
{
    CCLOG(@"%@: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    [spTimer removeFromParentAndCleanup:YES];
    [spProgressBg removeFromParentAndCleanup:YES];
    [spProgressRedBg removeFromParentAndCleanup:YES];
    
    [progress stopAllActions];
    [progress removeFromParentAndCleanup:YES];
    
    spTimer = nil;
    spProgressBg = nil;
    spProgressRedBg = nil;
    progress = nil;
    
    oldAudioName = nil;
    
    _delegate = nil;
}

@end
