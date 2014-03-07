//
//  PauseLayer.m
//  ChineseForKids
//
//  Created by 唐 希 on 13-8-19.
//  Copyright 2013年 Allen. All rights reserved.
//

#import "PauseLayer.h"
#import "CustomMenu.h"
#import "SimpleAudioEngine.h"

@interface PauseLayer()
{
    CCSprite *bgWordImage;
    CustomMenu *menu;
}

-(void) initInterface;

@end

@implementation PauseLayer

- (id)init
{
    CCLOG(@"%@ : %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    CGSize winSize=[[CCDirector sharedDirector] winSize];
    if (self = [super initWithColor:ccc4(0, 0, 0, 180) width:winSize.width height:winSize.height])
    {
        //glClearColor(0, 0, 0, 0.5f);
        
        [self initInterface];
    }
    return self;
}

- (void)initInterface
{
    CGSize winSize=[CCDirector sharedDirector].winSize;
    
    bgWordImage = [CCSprite spriteWithSpriteFrameName:@"pauseBkg.png"];
    bgWordImage.position  = ccp(winSize.width*0.5f, winSize.height*0.5f);
    [self addChild:bgWordImage z:1];
   
    CCMenuItemImage *resumeItem = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"resume.png"] selectedSprite:nil target:self selector:@selector(doResume)];
    resumeItem.position=ccp(winSize.width*0.35f, winSize.height*0.26f);
    
    CCMenuItemImage *restartItem=[CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"reStart.png"] selectedSprite:nil target:self selector:@selector(doRestart)];
    restartItem.position=ccp(winSize.width*0.5f, winSize.height*0.26f);
    
    CCMenuItemImage *selectItem=[CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"backToMainMap.png"] selectedSprite:nil target:self selector:@selector(doSelect)];
    selectItem.position=ccp(winSize.width*0.65f, winSize.height*0.26f);
    
    menu = [CustomMenu menuWithItems:restartItem,resumeItem,selectItem, nil];
    menu.position = CGPointZero;
    [self addChild:menu z:21];
    
    self.touchEnabled = YES;
}

- (void) onEnter
{
    [super onEnter];
    
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self
                                                              priority:kCCMenuHandlerPriority - 1
                                                       swallowsTouches:YES];
}

- (void) onExit
{
    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
    
    [super onExit];
}


- (BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    return YES;
}

#pragma mark - menu callback
// 游戏暂停的三种功能:1、重玩; 2、继续; 3、退出当前回到导航(Home)
// 我们希望把这三种功能统一交给正在玩的那个游戏场景去处理。

- (void)doRestart
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didRecieveRestartEvent:)]) {
        [self.delegate didRecieveRestartEvent:self];
    }
}

- (void)doResume
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didRecieveResumeEvent:)]) {
        [self.delegate didRecieveResumeEvent:self];
    }
}

- (void)doSelect
{
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didRecieveQuitEvent:)]) {
        [self.delegate didRecieveQuitEvent:self];
    }
}

#pragma mark - Memory Manager
- (void)dealloc
{
    CCLOG(@"%@ : %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    [menu removeAllChildrenWithCleanup:YES];
    
    [bgWordImage removeFromParentAndCleanup:YES];
    [menu removeFromParentAndCleanup:YES];
    
    bgWordImage = nil;
    menu = nil;
    
    [[CCTextureCache sharedTextureCache] removeAllTextures];
}

@end

