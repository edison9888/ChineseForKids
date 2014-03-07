//
//  Trees.m
//  PinyinGame
//
//  Created by yang on 13-11-9.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "Trees.h"
#import "cocos2d.h"
#import "Constants.h"

#import "CCParallaxNode-Extras.h"

#define kScaleFactor 3.0f
#define kMoveFactor 60.0f

#define kTreeOneTag   1001
#define kTreeTwoTag   1002
#define kTreeThreeTag 1003

#define kTreeRootOneTag 1004
#define kTreeRootTwoTag 1005
#define kTreeRootThreeTag 1006

#define kStoneOneTag 1007
#define kStoneTwoTag 1008
#define kStoneThreeTag 1009

#define kSpeedOneTag   2001
#define kSpeedTwoTag   2002
#define kSpeedThreeTag 2003

#define kSpeedTROneTag 2004
#define kSpeedTRTwoTag 2005
#define kSpeedTRThreeTag 2006

#define kSpeedStoneOneTag 2007
#define kSpeedStoneTwoTag 2008
#define kSpeedStoneThreeTag 2009

@implementation Trees
{
    CGFloat parentWidth;
    CGFloat parentHeight;
    
    CGPoint oriPosition;
    
    CGFloat moveToPositionY;
    
    __unsafe_unretained CCNode *parent;
    
    CGFloat animationDuration;
    
    CGFloat scalSpeed;
    
    CGFloat treeWidth;
    CGFloat treeRootWidth;
    CGFloat stoneWidth;
    
    NSInteger speedTag;
    
    CCSprite *spMTree;
    CCSprite *spFTree;
    CCSprite *spLTree;
    
    CCSprite *spMTreeRoot;
    CCSprite *spMStone;
    CCSprite *spFStone;
}

+ (id)treesWithParentNode:(CCNode *)parentNode
{
    return [[self alloc] initWithParentNode:parentNode];
}

- (id)initWithParentNode:(CCNode *)parentNode
{
    CCLOG(@"%@; %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    if (self = [super init])
    {
        parent = parentNode;
        parentWidth  = parentNode.boundingBox.size.width;
        parentHeight = parentNode.boundingBox.size.height;
        
        oriPosition = ccp(parentWidth*0.5f, parentHeight*0.168f);
        moveToPositionY = parentHeight*1.4;
        animationDuration = 6.0f;
        scalSpeed = 0.5f;
        
        [self initTreesTunnelWithParent:parentNode];
        [self initTreeRootTunnelWithParent:parentNode];
        [self initStoneTunnelWithParent:parentNode];
    }
    return self;
}

#pragma mark - Init Manager
- (void)initTreesTunnelWithParent:(CCNode *)parentNode
{
    spMTree = [CCSprite spriteWithSpriteFrameName:@"tree.png"];
    treeWidth = spMTree.boundingBox.size.width;
    spMTree.scale = 0.2f;
    spMTree.position = oriPosition;
    [parentNode addChild:spMTree z:kLeftMoveFlowerParallaxNode_z tag:kTreeOneTag];
    [self scaleMoveTreeOne:spMTree];
    
    spFTree = [CCSprite spriteWithSpriteFrameName:@"tree.png"];
    spFTree.scale = 0.0f;
    [parentNode addChild:spFTree z:kLeftMoveFlowerParallaxNode_z tag:kTreeTwoTag];
    CCCallBlockN *callBackS = [CCCallBlockN actionWithBlock:^(CCNode *node){
        CCSprite *spTree = (CCSprite *)node;
        spTree.scale = 0.2f;
        spTree.position = oriPosition;
        [self scaleMoveTreeTwo:spTree];
    }];
    CCDelayTime *delayS = [CCDelayTime actionWithDuration:2.0f];
    [spFTree runAction:[CCSequence actions:delayS, callBackS, nil]];
    
    
    spLTree = [CCSprite spriteWithSpriteFrameName:@"tree.png"];
    spLTree.scale = 0.0f;
    [parentNode addChild:spLTree z:kLeftMoveFlowerParallaxNode_z tag:kTreeThreeTag];
    CCCallBlockN *callBackT = [CCCallBlockN actionWithBlock:^(CCNode *node){
        CCSprite *spTree = (CCSprite *)node;
        spTree.scale = 0.2f;
        spTree.position = oriPosition;
        [self scaleMoveTreeThree:spTree];
    }];
    CCDelayTime *delayT = [CCDelayTime actionWithDuration:4.0f];
    [spLTree runAction:[CCSequence actions:delayT, callBackT, nil]];
}

- (void)initStoneTunnelWithParent:(CCNode *)parentNode
{
    spMStone = [CCSprite spriteWithSpriteFrameName:@"stone.png"];
    stoneWidth = spMStone.boundingBox.size.width;
    
    spMStone.scale = 0.4f;
    spMStone.position = ccpAdd(oriPosition, ccp(0.0f, -60.0f));;
    [parentNode addChild:spMStone z:kLeftMoveFlowerParallaxNode_z tag:kStoneOneTag];
    [self scaleMoveStoneOne:spMStone];
    
    spFStone = [CCSprite spriteWithSpriteFrameName:@"stone.png"];
    spFStone.scale = 0.0f;
    [parentNode addChild:spFStone z:kLeftMoveFlowerParallaxNode_z tag:kStoneTwoTag];
    CCCallBlockN *callBackS = [CCCallBlockN actionWithBlock:^(CCNode *node){
        CCSprite *sp = (CCSprite *)node;
        sp.scale = 0.12f;
        sp.position = ccpAdd(oriPosition, ccp(0.0f, -50.0f));
        [self scaleMoveStoneTwo:sp];
    }];
    CCDelayTime *delayS = [CCDelayTime actionWithDuration:4.1f];
    [spFStone runAction:[CCSequence actions:delayS, callBackS, nil]];
}

- (void)initTreeRootTunnelWithParent:(CCNode *)parentNode
{
    spMTreeRoot = [CCSprite spriteWithSpriteFrameName:@"treeRoot.png"];
    
    treeRootWidth = spMTreeRoot.boundingBox.size.width;
    spMTreeRoot.scale = 0.7f;
    spMTreeRoot.position = ccpAdd(oriPosition, ccp(0.0f, -30.0f));;
    [parentNode addChild:spMTreeRoot z:kLeftMoveFlowerParallaxNode_z tag:kTreeRootOneTag];
    [self scaleMoveTreeRootOne:spMTreeRoot];
}

#pragma mark - MoveTree Animation Manager
- (void)scaleMoveTreeOne:(CCSprite *)spTree
{
    CCSpawn *spawn = (CCSpawn *)[self scaleMoveTreeAnimation];
    
    CCCallBlockN *callBack = [CCCallBlockN actionWithBlock:^(CCNode *node){
        CCSprite *spTree = (CCSprite *)node;
        spTree.scale = 0.2f;
        spTree.position = oriPosition;
        [self scaleMoveTreeOne:spTree];
    }];
    
    CCSequence *seq = [CCSequence actions:spawn, callBack, nil];
    CCSpeed *speed = [CCSpeed actionWithAction:seq speed:scalSpeed];
    speed.tag = kSpeedOneTag;
    [spTree runAction:speed];
    
    [[[CCDirector sharedDirector] scheduler] unscheduleSelector:@selector(quickTreeOneMove) forTarget:self];
    
    [[[CCDirector sharedDirector] scheduler] scheduleSelector:@selector(quickTreeOneMove) forTarget:self interval:0 paused:NO];
}

- (void)scaleMoveTreeTwo:(CCSprite *)spTree
{
    CCSpawn *spawn = (CCSpawn *)[self scaleMoveTreeAnimation];
    
    CCCallBlockN *callBack = [CCCallBlockN actionWithBlock:^(CCNode *node){
        CCSprite *spTree = (CCSprite *)node;
        spTree.scale = 0.2f;
        spTree.position = oriPosition;
        [self scaleMoveTreeTwo:spTree];
    }];
    
    CCSequence *seq = [CCSequence actions:spawn, callBack, nil];
    CCSpeed *speed = [CCSpeed actionWithAction:seq speed:scalSpeed];
    speed.tag = kSpeedTwoTag;
    [spTree runAction:speed];
    
    [[[CCDirector sharedDirector] scheduler] unscheduleSelector:@selector(quickTreeTwoMove) forTarget:self];
    
    [[[CCDirector sharedDirector] scheduler] scheduleSelector:@selector(quickTreeTwoMove) forTarget:self interval:0 paused:NO];
}

- (void)scaleMoveTreeThree:(CCSprite *)spTree
{
    CCSpawn *spawn = (CCSpawn *)[self scaleMoveTreeAnimation];
    
    CCCallBlockN *callBack = [CCCallBlockN actionWithBlock:^(CCNode *node){
        CCSprite *spTree = (CCSprite *)node;
        spTree.scale = 0.2f;
        spTree.position = oriPosition;
        [self scaleMoveTreeThree:spTree];
    }];
    
    CCSequence *seq = [CCSequence actions:spawn, callBack, nil];
    CCSpeed *speed = [CCSpeed actionWithAction:seq speed:scalSpeed];
    speed.tag = kSpeedThreeTag;
    [spTree runAction:speed];
    
    [[[CCDirector sharedDirector] scheduler] unscheduleSelector:@selector(quickTreeThreeMove) forTarget:self];
    
    [[[CCDirector sharedDirector] scheduler] scheduleSelector:@selector(quickTreeThreeMove) forTarget:self interval:0 paused:NO];
}

- (id)scaleMoveTreeAnimation
{
    CCMoveTo *moveTo = [CCMoveTo actionWithDuration:animationDuration position:ccp(oriPosition.x, moveToPositionY)];
    CCScaleTo *scaleTo = [CCScaleTo actionWithDuration:animationDuration scale:kScaleFactor];
    CCSpawn *spawn = [CCSpawn actions:moveTo, scaleTo, nil];

    return spawn;
}

#pragma mark - MoveTreeRoot Animation Manager
- (void)scaleMoveTreeRootOne:(CCSprite *)spTreeRoot
{
    CCFadeIn *fadeIn = [CCFadeIn actionWithDuration:0.2f];
    CCSpawn *spawn = [CCSpawn actions:(CCSpawn *)[self scaleMoveTreeRootAnimation], fadeIn, nil];
    
    CCCallBlockN *callBack = [CCCallBlockN actionWithBlock:^(CCNode *node){
        CCSprite *sp = (CCSprite *)node;
        sp.scale = 0.12f;
        sp.opacity = 0.0f;
        sp.position = ccpAdd(oriPosition, ccp(0.0f, -49.0f));
        [self scaleMoveTreeRootOne:sp];
    }];
    
    CCSequence *seq = [CCSequence actions:spawn, callBack, nil];
    CCSpeed *speed = [CCSpeed actionWithAction:seq speed:scalSpeed];
    speed.tag = kSpeedTROneTag;
    [spTreeRoot runAction:speed];
    
    [[[CCDirector sharedDirector] scheduler] unscheduleSelector:@selector(quickTreeRootOneMove) forTarget:self];
    
    [[[CCDirector sharedDirector] scheduler] scheduleSelector:@selector(quickTreeRootOneMove) forTarget:self interval:0 paused:NO];
}

- (id)scaleMoveTreeRootAnimation
{
    CCMoveTo *moveTo = [CCMoveTo actionWithDuration:animationDuration position:ccp(oriPosition.x, moveToPositionY*0.4f)];
    CCScaleTo *scaleTo = [CCScaleTo actionWithDuration:animationDuration scale:kScaleFactor];
    CCSpawn *spawn = [CCSpawn actions:moveTo, scaleTo, nil];
    
    return spawn;
}

#pragma mark - MoveStone Animation Manager
- (void)scaleMoveStoneOne:(CCSprite *)spStone
{
    CCFadeIn *fadeIn = [CCFadeIn actionWithDuration:0.1f];
    CCSpawn *spawn = [CCSpawn actions:(CCSpawn *)[self scaleMoveStoneAnimation], fadeIn, nil];
    
    CCCallBlockN *callBack = [CCCallBlockN actionWithBlock:^(CCNode *node){
        CCSprite *sp = (CCSprite *)node;
        sp.scale = 0.12f;
        sp.opacity = 0.0f;
        sp.position = ccpAdd(oriPosition, ccp(0.0f, -50.0f));
        [self scaleMoveStoneOne:sp];
    }];
    
    CCSequence *seq = [CCSequence actions:spawn, callBack, nil];
    CCSpeed *speed = [CCSpeed actionWithAction:seq speed:scalSpeed];
    speed.tag = kSpeedStoneOneTag;
    [spStone runAction:speed];
    
    [[[CCDirector sharedDirector] scheduler] unscheduleSelector:@selector(quickStoneOneMove) forTarget:self];
    
    [[[CCDirector sharedDirector] scheduler] scheduleSelector:@selector(quickStoneOneMove) forTarget:self interval:0 paused:NO];
}

- (void)scaleMoveStoneTwo:(CCSprite *)spStone
{
    CCFadeIn *fadeIn = [CCFadeIn actionWithDuration:0.1f];
    CCSpawn *spawn = [CCSpawn actions:(CCSpawn *)[self scaleMoveStoneAnimation], fadeIn, nil];
    
    CCCallBlockN *callBack = [CCCallBlockN actionWithBlock:^(CCNode *node){
        CCSprite *sp = (CCSprite *)node;
        sp.scale = 0.12f;
        sp.opacity = 0.0f;
        sp.position = ccpAdd(oriPosition, ccp(0.0f, -50.0f));
        [self scaleMoveStoneTwo:sp];
    }];
    
    CCSequence *seq = [CCSequence actions:spawn, callBack, nil];
    CCSpeed *speed = [CCSpeed actionWithAction:seq speed:scalSpeed];
    speed.tag = kSpeedStoneTwoTag;
    [spStone runAction:speed];
    
    [[[CCDirector sharedDirector] scheduler] unscheduleSelector:@selector(quickStoneTwoMove) forTarget:self];
    
    [[[CCDirector sharedDirector] scheduler] scheduleSelector:@selector(quickStoneTwoMove) forTarget:self interval:0 paused:NO];
}

- (id)scaleMoveStoneAnimation
{
    CCMoveTo *moveTo = [CCMoveTo actionWithDuration:animationDuration*1.5f position:ccp(oriPosition.x, -moveToPositionY*0.8f)];
    CCScaleTo *scaleTo = [CCScaleTo actionWithDuration:animationDuration*1.5f scale:kScaleFactor*4];
    CCSpawn *spawn = [CCSpawn actions:moveTo, scaleTo, nil];
    
    return spawn;
}

#pragma mark - Tree One
- (void)quickTreeOneMove
{
    CCSprite*sprite = (CCSprite*)[parent getChildByTag:kTreeOneTag];
    CCSpeed *speed = (CCSpeed*)[sprite getActionByTag:kSpeedOneTag];
    
    CGFloat tmpTreeWidth = sprite.boundingBox.size.width;
    CGFloat speedFactor = tmpTreeWidth/treeWidth;
    
    [speed setSpeed:speedFactor];
}

#pragma mark - Tree Two
- (void)quickTreeTwoMove
{
    CCSprite*sprite = (CCSprite*)[parent getChildByTag:kTreeTwoTag];
    CCSpeed *speed = (CCSpeed*)[sprite getActionByTag:kSpeedTwoTag];
    
    CGFloat tmpTreeWidth = sprite.boundingBox.size.width;
    CGFloat speedFactor = tmpTreeWidth/treeWidth;
    
    [speed setSpeed:speedFactor];
}

#pragma mark - Tree Three
- (void)quickTreeThreeMove
{
    CCSprite*sprite = (CCSprite*)[parent getChildByTag:kTreeThreeTag];
    CCSpeed *speed = (CCSpeed*)[sprite getActionByTag:kSpeedThreeTag];
    
    CGFloat tmpTreeWidth = sprite.boundingBox.size.width;
    CGFloat speedFactor = tmpTreeWidth/treeWidth;
    
    [speed setSpeed:speedFactor];
}


#pragma mark - TreeRoot
- (void)quickTreeRootOneMove
{
    CCSprite*sprite = (CCSprite*)[parent getChildByTag:kTreeRootOneTag];
    CCSpeed *speed = (CCSpeed*)[sprite getActionByTag:kSpeedTROneTag];
    
    CGFloat tmpTreeWidth = sprite.boundingBox.size.width;
    CGFloat speedFactor = tmpTreeWidth/treeRootWidth;
    
    [speed setSpeed:speedFactor];
}

#pragma mark - Stone
- (void)quickStoneOneMove
{
    CCSprite*sprite = (CCSprite*)[parent getChildByTag:kStoneOneTag];
    CCSpeed *speed = (CCSpeed*)[sprite getActionByTag:kSpeedStoneOneTag];
    
    CGFloat tmpTreeWidth = sprite.boundingBox.size.width;
    CGFloat speedFactor = tmpTreeWidth/stoneWidth;
    
    [speed setSpeed:speedFactor];
}

- (void)quickStoneTwoMove
{
    CCSprite*sprite = (CCSprite*)[parent getChildByTag:kStoneTwoTag];
    CCSpeed *speed = (CCSpeed*)[sprite getActionByTag:kSpeedStoneTwoTag];
    
    CGFloat tmpTreeWidth = sprite.boundingBox.size.width;
    CGFloat speedFactor = tmpTreeWidth/stoneWidth;
    
    [speed setSpeed:speedFactor];
}

#pragma mark - Memory Manager
- (void)dealloc
{
    [spMTree removeFromParentAndCleanup:YES];
    spMTree = nil;
    
    [spFTree removeFromParentAndCleanup:YES];
    spFTree = nil;
    
    [spLTree removeFromParentAndCleanup:YES];
    spLTree = nil;
    
    [spMTreeRoot removeFromParentAndCleanup:YES];
    spMTreeRoot = nil;

    [spMStone removeFromParentAndCleanup:YES];
    spMStone = nil;
    
    [spFStone removeFromParentAndCleanup:YES];
    spFStone = nil;
    
    parent = nil;
}

@end
