//
//  Wave.m
//  PinyinGame
//
//  Created by yang on 13-11-19.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "Wave.h"
#import "cocos2d.h"
#import "Constants.h"

@implementation Wave
{
    CCSprite *spWaterWaveOne;
    CCSprite *spWaterWaveTwo;
    CCSprite *spWaterWaveThree;
    CCSprite *spWaterWaveFour;
    CCSprite *spWaterWaveFive;
    CCSprite *spWaterWaveSix;
    CCSprite *spWaterWaveSeven;
    CCSprite *spWaterWaveEight;
    CCSprite *spWaterWaveNine;
    CCSprite *spWaterWaveTeen;
    
    CCSprite *spLandWaveOne;
    CCSprite *spLandWaveTwo;
    CCSprite *spLandWaveThree;
    CCSprite *spLandWaveFour;
    CCSprite *spLandWaveFive;
    CCSprite *spLandWaveSix;
    CCSprite *spLandWaveSeven;
    CCSprite *spLandWaveEight;
    CCSprite *spLandWaveNine;
    CCSprite *spLandWaveTeen;
    CCSprite *spLandWaveEleven;
}

+ (id)waveWithParentNode:(CCNode *)parentNode
{
    return [[self alloc] initWithParentNode:parentNode];
}

- (id)initWithParentNode:(CCNode *)parentNode
{
    CCLOG(@"%@; %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    if (self = [super init])
    {
        CGSize size = [parentNode boundingBox].size;
        spWaterWaveOne   = [CCSprite spriteWithSpriteFrameName:@"waterWave1.png"];
        spWaterWaveOne.position = ccp(size.width*0.28f, size.height*0.42f);
        [parentNode addChild:spWaterWaveOne z:kMainMapWaterWave_z];
        
        spWaterWaveTwo   = [CCSprite spriteWithSpriteFrameName:@"waterWave2.png"];
        spWaterWaveTwo.position = ccp(size.width*0.62f, size.height*0.37f);
        spWaterWaveTwo.scale = 0.3f;
        [parentNode addChild:spWaterWaveTwo z:kMainMapWaterWave_z];
        
        spWaterWaveThree = [CCSprite spriteWithSpriteFrameName:@"waterWave3.png"];
        spWaterWaveThree.position = ccp(size.width*0.82f, size.height*0.14f);
        [parentNode addChild:spWaterWaveThree z:kMainMapWaterWave_z];
        
        spWaterWaveFour  = [CCSprite spriteWithSpriteFrameName:@"waterWave4.png"];
        spWaterWaveFour.position = ccp(size.width*1.25f, size.height*0.21f);
        spWaterWaveFour.scale = 0.6f;
        [parentNode addChild:spWaterWaveFour z:kMainMapWaterWave_z];
        
        spWaterWaveFive  = [CCSprite spriteWithSpriteFrameName:@"waterWave5.png"];
        spWaterWaveFive.position = ccp(size.width*1.44f, size.height*0.256f);
        spWaterWaveFive.scale = 0.3f;
        [parentNode addChild:spWaterWaveFive z:kMainMapWaterWave_z];
        
        spWaterWaveSix   = [CCSprite spriteWithSpriteFrameName:@"waterWave2.png"];
        spWaterWaveSix.position = ccp(size.width*1.76f, size.height*0.298f);
        spWaterWaveSix.scale = 0.6f;
        [parentNode addChild:spWaterWaveSix z:kMainMapWaterWave_z];
        
        spWaterWaveSeven = [CCSprite spriteWithSpriteFrameName:@"waterWave3.png"];
        spWaterWaveSeven.position = ccp(size.width*1.8f, size.height*0.122f);
        spWaterWaveSeven.scale = 0.6f;
        [parentNode addChild:spWaterWaveSeven z:kMainMapWaterWave_z];
        
        spWaterWaveEight = [CCSprite spriteWithSpriteFrameName:@"waterWave4.png"];
        spWaterWaveEight.position = ccp(size.width*2.2f, size.height*0.2f);
        spWaterWaveEight.scale = 0.6f;
        [parentNode addChild:spWaterWaveEight z:kMainMapWaterWave_z];
        
        spWaterWaveNine  = [CCSprite spriteWithSpriteFrameName:@"waterWave5.png"];
        spWaterWaveNine.position = ccp(size.width*2.38f, size.height*0.296f);
        spWaterWaveNine.scale = 0.3f;
        [parentNode addChild:spWaterWaveNine z:kMainMapWaterWave_z];
        
        spWaterWaveTeen  = [CCSprite spriteWithSpriteFrameName:@"waterWave3.png"];
        spWaterWaveTeen.position = ccp(size.width*2.68f, size.height*0.23f);
        spWaterWaveTeen.scale = 0.7f;
        [parentNode addChild:spWaterWaveTeen z:kMainMapWaterWave_z];
        
        // ~~~~~~~~~~~~~~~~~华丽丽的分割线~~~~~~~~~~~~~~~~~~~~~
        // ~~~~~~~~~~~~~~~~~~~~!!!~~~~~~~~~~~~~~~~~~~~~~~~~~~
        spLandWaveOne   = [CCSprite spriteWithSpriteFrameName:@"landWave/0000"];
        spLandWaveOne.position = ccp(size.width*0.285f, size.height*0.42f);
        spLandWaveOne.scaleX = 1.4f;
        [parentNode addChild:spLandWaveOne z:kMainMapLandWave_z];
        
        spLandWaveTwo   = [CCSprite spriteWithSpriteFrameName:@"landWave/0002"];
        spLandWaveTwo.position = ccp(size.width*0.62f, size.height*0.37f);
        spLandWaveTwo.scale = 0.3f;
        [parentNode addChild:spLandWaveTwo z:kMainMapLandWave_z];
        
        spLandWaveThree = [CCSprite spriteWithSpriteFrameName:@"landWave/0004"];
        spLandWaveThree.position = ccp(size.width*0.82f, size.height*0.14f);
        spLandWaveThree.scaleX = 1.6f;
        [parentNode addChild:spLandWaveThree z:kMainMapLandWave_z];
        
        spLandWaveFour  = [CCSprite spriteWithSpriteFrameName:@"landWave/0006"];
        spLandWaveFour.position = ccp(size.width*1.25f, size.height*0.21f);
        spLandWaveFour.scale = 0.6f;
        [parentNode addChild:spLandWaveFour z:kMainMapLandWave_z];
        
        spLandWaveFive  = [CCSprite spriteWithSpriteFrameName:@"landWave/0008"];
        spLandWaveFive.position = ccp(size.width*1.44f, size.height*0.22f);
        spLandWaveFive.scale = 0.3f;
        spLandWaveFive.scaleX = 0.4f;
        [parentNode addChild:spLandWaveFive z:kMainMapLandWave_z];
        
        spLandWaveSix   = [CCSprite spriteWithSpriteFrameName:@"landWave/0010"];
        spLandWaveSix.position = ccp(size.width*1.76f, size.height*0.298f);
        spLandWaveSix.scale = 0.6f;
        [parentNode addChild:spLandWaveSix z:kMainMapLandWave_z];
        
        spLandWaveSeven = [CCSprite spriteWithSpriteFrameName:@"landWave/0012"];
        spLandWaveSeven.position = ccp(size.width*1.84f, size.height*0.126f);
        spLandWaveSeven.scale = 0.6f;
        spLandWaveSeven.scaleX = 1.0f;
        [parentNode addChild:spLandWaveSeven z:kMainMapLandWave_z];
        
        spLandWaveEight = [CCSprite spriteWithSpriteFrameName:@"landWave/0014"];
        spLandWaveEight.position = ccp(size.width*2.2f, size.height*0.2f);
        spLandWaveEight.scale = 0.6f;
        spLandWaveEight.scaleX = 0.8f;
        [parentNode addChild:spLandWaveEight z:kMainMapLandWave_z];
        
        spLandWaveNine  = [CCSprite spriteWithSpriteFrameName:@"landWave/0016"];
        spLandWaveNine.position = ccp(size.width*2.38f, size.height*0.296f);
        spLandWaveNine.scale = 0.3f;
        [parentNode addChild:spLandWaveNine z:kMainMapLandWave_z];
        
        spLandWaveTeen  = [CCSprite spriteWithSpriteFrameName:@"landWave/0018"];
        spLandWaveTeen.position = ccp(size.width*2.66f, size.height*0.21f);
        spLandWaveTeen.scale = 0.7f;
        spLandWaveTeen.scaleX = 1.0f;
        [parentNode addChild:spLandWaveTeen z:kMainMapLandWave_z];
        
        spLandWaveEleven = [CCSprite spriteWithSpriteFrameName:@"landWave/0020"];
        spLandWaveEleven.position = ccp(size.width*2.46f, size.height*0.33f);
        spLandWaveEleven.scale = 0.3f;
        [parentNode addChild:spLandWaveEleven z:kMainMapLandWave_z];
        
        [self startWaveAnimation];
    }
    return self;
}

- (void)startWaveAnimation
{
    [spWaterWaveOne runAction:[self waterWaveAnimate]];
    [spWaterWaveTwo runAction:[self waterWaveAnimate]];
    [spWaterWaveThree runAction:[self waterWaveAnimate]];
    [spWaterWaveFour runAction:[self waterWaveAnimate]];
    [spWaterWaveFive runAction:[self waterWaveAnimate]];
    [spWaterWaveSix runAction:[self waterWaveAnimate]];
    [spWaterWaveSeven runAction:[self waterWaveAnimate]];
    [spWaterWaveEight runAction:[self waterWaveAnimate]];
    [spWaterWaveNine runAction:[self waterWaveAnimate]];
    [spWaterWaveTeen runAction:[self waterWaveAnimate]];
    
    // ~~~~~~~~~~~~~~~~~华丽丽的分割线~~~~~~~~~~~~~~~~~~~~~
    // ~~~~~~~~~~~~~~~~~~~~!!!~~~~~~~~~~~~~~~~~~~~~~~~~~~
    [spLandWaveOne runAction:[self landWaveAnimate]];
    [spLandWaveTwo runAction:[self landWaveAnimate]];
    [spLandWaveThree runAction:[self landWaveAnimate]];
    [spLandWaveFour runAction:[self landWaveAnimate]];
    [spLandWaveFive runAction:[self landWaveAnimate]];
    [spLandWaveSix runAction:[self landWaveAnimate]];
    [spLandWaveSeven runAction:[self landWaveAnimate]];
    [spLandWaveEight runAction:[self landWaveAnimate]];
    [spLandWaveNine runAction:[self landWaveAnimate]];
    [spLandWaveTeen runAction:[self landWaveAnimate]];
    [spLandWaveEleven runAction:[self landWaveAnimate]];
}

- (id)waterWaveAnimate
{
    NSMutableArray *arrAnimation=[NSMutableArray arrayWithCapacity:6];
    
    for(int i = 1; i <= 5; i++)
    {
        NSString *frameName = [NSString stringWithFormat:@"waterWave%d.png", i];
        CCSpriteFrame *frame=[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName];
        [arrAnimation addObject:frame];
    }
    
    CCAnimation *animation = [CCAnimation animationWithSpriteFrames:arrAnimation delay:0.18f];
    CCRepeatForever *repeat = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:animation]];
    return repeat;
}

- (id)landWaveAnimate
{
    NSMutableArray *arrAnimation=[NSMutableArray arrayWithCapacity:6];
    for(int i = 0; i <= 31; i++)
    {
        
        NSString *frameName = [NSString stringWithFormat:@"landWave/%04d", i];
        CCSpriteFrame *frame=[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName];
        [arrAnimation addObject:frame];
    }
    
    CCAnimation *animation = [CCAnimation animationWithSpriteFrames:arrAnimation delay:0.06f];
    CCRepeatForever *repeat = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:animation]];
    return repeat;
}


- (void)waveMoveWithDistance:(CGFloat)distance
{
    spWaterWaveOne.position   = ccpAdd(spWaterWaveOne.position, ccp(distance, 0));
    spWaterWaveTwo.position   = ccpAdd(spWaterWaveTwo.position, ccp(distance, 0));
    spWaterWaveThree.position = ccpAdd(spWaterWaveThree.position, ccp(distance, 0));
    spWaterWaveFour.position  = ccpAdd(spWaterWaveFour.position, ccp(distance, 0));
    spWaterWaveFive.position  = ccpAdd(spWaterWaveFive.position, ccp(distance, 0));
    spWaterWaveSix.position   = ccpAdd(spWaterWaveSix.position, ccp(distance, 0));
    spWaterWaveSeven.position = ccpAdd(spWaterWaveSeven.position, ccp(distance, 0));
    spWaterWaveEight.position = ccpAdd(spWaterWaveEight.position, ccp(distance, 0));
    spWaterWaveNine.position  = ccpAdd(spWaterWaveNine.position, ccp(distance, 0));
    spWaterWaveTeen.position  = ccpAdd(spWaterWaveTeen.position, ccp(distance, 0));
    spLandWaveOne.position    = ccpAdd(spLandWaveOne.position, ccp(distance, 0));
    spLandWaveTwo.position    = ccpAdd(spLandWaveTwo.position, ccp(distance, 0));
    spLandWaveThree.position  = ccpAdd(spLandWaveThree.position, ccp(distance, 0));
    spLandWaveFour.position   = ccpAdd(spLandWaveFour.position, ccp(distance, 0));
    spLandWaveFive.position   = ccpAdd(spLandWaveFive.position, ccp(distance, 0));
    spLandWaveSix.position    = ccpAdd(spLandWaveSix.position, ccp(distance, 0));
    spLandWaveSeven.position  = ccpAdd(spLandWaveSeven.position, ccp(distance, 0));
    spLandWaveEight.position  = ccpAdd(spLandWaveEight.position, ccp(distance, 0));
    spLandWaveNine.position   = ccpAdd(spLandWaveNine.position, ccp(distance, 0));
    spLandWaveTeen.position   = ccpAdd(spLandWaveTeen.position, ccp(distance, 0));
    spLandWaveEleven.position = ccpAdd(spLandWaveEleven.position, ccp(distance, 0));
}

- (void)waveHideWithAnimate:(BOOL)animate
{
    if (animate)
    {
        [spWaterWaveOne runAction:[self waveHideAnimation]];
        [spWaterWaveTwo runAction:[self waveHideAnimation]];
        [spWaterWaveThree runAction:[self waveHideAnimation]];
        [spWaterWaveFour runAction:[self waveHideAnimation]];
        [spWaterWaveFive runAction:[self waveHideAnimation]];
        [spWaterWaveSix runAction:[self waveHideAnimation]];
        [spWaterWaveSeven runAction:[self waveHideAnimation]];
        [spWaterWaveEight runAction:[self waveHideAnimation]];
        [spWaterWaveNine runAction:[self waveHideAnimation]];
        [spWaterWaveTeen runAction:[self waveHideAnimation]];
        
        [spLandWaveOne runAction:[self waveHideAnimation]];
        [spLandWaveTwo runAction:[self waveHideAnimation]];
        [spLandWaveThree runAction:[self waveHideAnimation]];
        [spLandWaveFour runAction:[self waveHideAnimation]];
        [spLandWaveFive runAction:[self waveHideAnimation]];
        [spLandWaveSix runAction:[self waveHideAnimation]];
        [spLandWaveSeven runAction:[self waveHideAnimation]];
        [spLandWaveEight runAction:[self waveHideAnimation]];
        [spLandWaveNine runAction:[self waveHideAnimation]];
        [spLandWaveTeen runAction:[self waveHideAnimation]];
        [spLandWaveEleven runAction:[self waveHideAnimation]];
    }
    else
    {
        spWaterWaveOne.visible = NO;
        spWaterWaveTwo.visible = NO;
        spWaterWaveThree.visible = NO;
        spWaterWaveFour.visible = NO;
        spWaterWaveFive.visible = NO;
        spWaterWaveSix.visible = NO;
        spWaterWaveSeven.visible = NO;
        spWaterWaveEight.visible = NO;
        spWaterWaveNine.visible = NO;
        spWaterWaveTeen.visible = NO;
    }
}

- (void)waveShowWithAnimate:(BOOL)animate
{
    if (animate)
    {
        [spWaterWaveOne runAction:[self waveShowAimation]];
        [spWaterWaveTwo runAction:[self waveShowAimation]];
        [spWaterWaveThree runAction:[self waveShowAimation]];
        [spWaterWaveFour runAction:[self waveShowAimation]];
        [spWaterWaveFive runAction:[self waveShowAimation]];
        [spWaterWaveSix runAction:[self waveShowAimation]];
        [spWaterWaveSeven runAction:[self waveShowAimation]];
        [spWaterWaveEight runAction:[self waveShowAimation]];
        [spWaterWaveNine runAction:[self waveShowAimation]];
        [spWaterWaveTeen runAction:[self waveShowAimation]];
        
        [spLandWaveOne runAction:[self waveShowAimation]];
        [spLandWaveTwo runAction:[self waveShowAimation]];
        [spLandWaveThree runAction:[self waveShowAimation]];
        [spLandWaveFour runAction:[self waveShowAimation]];
        [spLandWaveFive runAction:[self waveShowAimation]];
        [spLandWaveSix runAction:[self waveShowAimation]];
        [spLandWaveSeven runAction:[self waveShowAimation]];
        [spLandWaveEight runAction:[self waveShowAimation]];
        [spLandWaveNine runAction:[self waveShowAimation]];
        [spLandWaveTeen runAction:[self waveShowAimation]];
        [spLandWaveEleven runAction:[self waveShowAimation]];
    }
    else
    {
        spWaterWaveOne.visible = YES;
        spWaterWaveTwo.visible = YES;
        spWaterWaveThree.visible = YES;
        spWaterWaveFour.visible = YES;
        spWaterWaveFive.visible = YES;
        spWaterWaveSix.visible = YES;
        spWaterWaveSeven.visible = YES;
        spWaterWaveEight.visible = YES;
        spWaterWaveNine.visible = YES;
        spWaterWaveTeen.visible = YES;
    }
}

- (id)waveHideAnimation
{
    CCFadeOut *fadeOut = [CCFadeOut actionWithDuration:0.2f];
    return fadeOut;
}

- (id)waveShowAimation
{
    CCFadeIn *fadeIn = [CCFadeIn actionWithDuration:0.2f];
    return fadeIn;
}

#pragma mark - Memory Manager
- (void)dealloc
{
    [spWaterWaveOne removeFromParentAndCleanup:YES];
    [spWaterWaveTwo removeFromParentAndCleanup:YES];
    [spWaterWaveThree removeFromParentAndCleanup:YES];
    [spWaterWaveFour removeFromParentAndCleanup:YES];
    [spWaterWaveFive removeFromParentAndCleanup:YES];
    [spWaterWaveSix removeFromParentAndCleanup:YES];
    [spWaterWaveSeven removeFromParentAndCleanup:YES];
    [spWaterWaveEight removeFromParentAndCleanup:YES];
    [spWaterWaveNine removeFromParentAndCleanup:YES];
    [spWaterWaveTeen removeFromParentAndCleanup:YES];
    [spLandWaveOne removeFromParentAndCleanup:YES];
    [spLandWaveTwo removeFromParentAndCleanup:YES];
    [spLandWaveThree removeFromParentAndCleanup:YES];
    [spLandWaveFour removeFromParentAndCleanup:YES];
    [spLandWaveFive removeFromParentAndCleanup:YES];
    [spLandWaveSix removeFromParentAndCleanup:YES];
    [spLandWaveSeven removeFromParentAndCleanup:YES];
    [spLandWaveEight removeFromParentAndCleanup:YES];
    [spLandWaveNine removeFromParentAndCleanup:YES];
    [spLandWaveTeen removeFromParentAndCleanup:YES];
    [spLandWaveEleven removeFromParentAndCleanup:YES];
    
    spWaterWaveOne   = nil;
    spWaterWaveTwo   = nil;
    spWaterWaveThree = nil;
    spWaterWaveFour  = nil;
    spWaterWaveFive  = nil;
    spWaterWaveSix   = nil;
    spWaterWaveSeven = nil;
    spWaterWaveEight = nil;
    spWaterWaveNine  = nil;
    spWaterWaveTeen  = nil;
    spLandWaveOne    = nil;
    spLandWaveTwo    = nil;
    spLandWaveThree  = nil;
    spLandWaveFour   = nil;
    spLandWaveFive   = nil;
    spLandWaveSix    = nil;
    spLandWaveSeven  = nil;
    spLandWaveEight  = nil;
    spLandWaveNine   = nil;
    spLandWaveTeen   = nil;
    spLandWaveEleven = nil;
}

@end
