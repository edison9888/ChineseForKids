//
//  GameResultsLayer.m
//  PinyinGame
//
//  Created by yang on 13-10-30.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "GameResultsLayer.h"
#import "SimpleAudioEngine.h"
#import "GameLessonData.h"
#import "SceneManager.h"
#import "Constants.h"
#import "cocos2d.h"

@interface GameResultsLayer ()
{
    //NSInteger curUnitID;
    NSInteger curLevelID;
    NSInteger nextLevelID;
    NSString *curUserID;
    
    NSInteger levelScore;
    NSInteger highestScore;
    NSInteger starNum;
    
    BOOL levelClear;
    BOOL isNewHighScore;
    
    // 卷轴
    CCSprite *spJuanLeft;
    CCSprite *spJuanRight;
    
    // 宗
    CCSprite *spZone;
    
    CCLabelTTF *lblHighScore;
    CCLabelTTF *lblCurrentScore;
    
    CCSpriteBatchNode *batchNode;
    
    CCMenu *menu;
    GameLessonData *gameData;
}

@end

@implementation GameResultsLayer

- (id)init
{
    CCLOG(@"%@ : %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    CGSize winSize=[[CCDirector sharedDirector] winSize];
    if (self = [super initWithColor:ccc4(0, 0, 0, 180) width:winSize.width height:winSize.height])
    {
        // 设置自身背景色
        glClearColor(0, 0, 0, 180);
        
        gameData = [GameLessonData sharedData];
        
        levelScore   = gameData.currentLessonScore;
        highestScore = gameData.currentLessonHighScore;
        starNum      = gameData.currentlessonstarsNum;
        isNewHighScore = gameData.isNewHighScore;
        
        //[self playBackgroundAudio];
        [self setupBatchNode];
        
        [self playScoreAudio];
        [self initInterface];
        
        [self setTouchEnabled:NO];
    }
    return self;
}

- (void)setupBatchNode
{
    batchNode = [CCSpriteBatchNode batchNodeWithFile:@"gameScore.pvr.ccz"];
    [self addChild:batchNode z:-1];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"gameScore.plist"];
}

- (void)initInterface
{
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    spJuanLeft = [CCSprite spriteWithSpriteFrameName:@"juan.png"];
    spJuanLeft.position = ccp(winSize.width*0.5f, winSize.height+spJuanLeft.contentSize.height*0.5f);
    [self addChild:spJuanLeft z:2];
    
    CCCallBlock *callBack = [CCCallBlock actionWithBlock:^{
        
        spJuanRight=[CCSprite spriteWithSpriteFrameName:@"juan.png"];
        spJuanRight.position=ccp(winSize.width*0.5f,winSize.height*0.5f);
        [self addChild:spJuanRight z:2];
        
        spZone=[CCSprite spriteWithSpriteFrameName:@"zong.png"];
        spZone.position=ccp(winSize.width*0.5f,winSize.height*0.5f);
        spZone.scaleX=0;
        [self addChild:spZone z:1];
        
        CGFloat durationOpen = 1.0f;
        [spJuanLeft runAction:[CCMoveTo actionWithDuration:durationOpen position:ccp(winSize.width/2-spZone.contentSize.width/2, winSize.height/2)]];
        [spJuanRight runAction:[CCMoveTo actionWithDuration:durationOpen position:ccp(winSize.width/2+spZone.contentSize.width/2, winSize.height/2)]];
        [spZone runAction:[CCScaleTo actionWithDuration:durationOpen scaleX:1 scaleY:1]];
        
        CCDelayTime *delayTime = [CCDelayTime actionWithDuration:durationOpen];
        CCCallFunc *addLevelTitleFunc = [CCCallFunc actionWithTarget:self selector:@selector(addLevelTitle)];
        CCCallFunc *showStarAndScoreFunc = [CCCallFunc actionWithTarget:self selector:@selector(showStarAndScore)];
        CCCallFunc *showControlItemsFunc = [CCCallFunc actionWithTarget:self selector:@selector(showControlItems)];
        [self runAction:[CCSequence actions:delayTime, addLevelTitleFunc, showStarAndScoreFunc, showControlItemsFunc, nil]];
        //[self performSelector:@selector(addLevelTitle) withObject:nil afterDelay:durationOpen];
        
    }];
    
    CCSequence *seq = [CCSequence actions:[CCMoveTo actionWithDuration:0.3f position:ccp(winSize.width*0.5f, winSize.height*0.4f)], [CCMoveTo actionWithDuration:0.1f position:ccp(winSize.width*0.5f, winSize.height*0.7f)], [CCMoveTo actionWithDuration:0.05f position:ccp(winSize.width*0.5f, winSize.height*0.5f)], callBack, nil];
    [spJuanLeft runAction:seq];
}

// 显示关卡名称和历史最高得分
- (void)addLevelTitle
{
    //获取屏幕大小
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    //显示文本
    NSString *currentScore = [NSString stringWithFormat:@"得分数: %d", levelScore];
    lblCurrentScore = [CCLabelTTF labelWithString:currentScore fontName:@"Courier-Bold" fontSize:45];
    lblCurrentScore.color = ccc3(73,28,9);
    lblCurrentScore.position = ccp(winSize.width/2,winSize.height/2+spZone.contentSize.height/5);
    [self addChild:lblCurrentScore z:10];
    
    CCSprite *spHighScorebg=[CCSprite spriteWithSpriteFrameName:@"highScoreBkg.png"];
    spHighScorebg.position = ccpAdd(spZone.position, ccp(spZone.contentSize.width/3.8, spZone.contentSize.height/2.8));
    [self addChild:spHighScorebg z:10];
    
    //显示历史最高得分
    NSString *highScore = [NSString stringWithFormat:@"最高记录:%d", highestScore];
    lblHighScore = [CCLabelTTF labelWithString:highScore fontName:@"Courier" fontSize:20];
    lblHighScore.color = ccc3(100, 28, 9);
    lblHighScore.position = spHighScorebg.position;
    [self addChild:lblHighScore z:12];
}

// 显示星星和得分
- (void)showStarAndScore
{
    // 未填充的星星
    for(int i = 0;i < 3;i++)
    {
        CCSprite *spStarUnfill=[CCSprite spriteWithSpriteFrameName:@"star_unfill.png"];
        spStarUnfill.position=ccpAdd(spZone.position, ccp(-(spStarUnfill.contentSize.width*1.2)+i*spStarUnfill.contentSize.width*1.2,0));
        [self addChild:spStarUnfill z:10];
    }
    
    CGFloat waitDuration = 0.0f;
    CGFloat actionDuration = 0.3f;
    // 填充的星星
    for(int i=0; i < starNum; i++)
    {
        CCSprite *spStar=[CCSprite spriteWithSpriteFrameName:@"star.png"];
        spStar.opacity=0;
        spStar.scale=3;
        spStar.position=ccpAdd(spZone.position, ccp(-(spStar.contentSize.width*1.2)+i*spStar.contentSize.width*1.2,0));
        [self addChild:spStar z:10];
        
        [spStar runAction:[CCSequence actions:[CCDelayTime actionWithDuration:waitDuration], [CCFadeTo actionWithDuration:actionDuration opacity:255], nil]];
        
        [spStar runAction:[CCSequence actions:[CCDelayTime actionWithDuration:waitDuration], [CCScaleTo actionWithDuration:actionDuration scale:1], nil]];
        waitDuration += actionDuration * 2.0f;
    }
    
    // 是否为最高分
    if(isNewHighScore)
    {
        CCSprite *spHighScoretap=[CCSprite spriteWithSpriteFrameName:@"newHighScore.png"];
        spHighScoretap.opacity=0;
        spHighScoretap.scale=2;
        spHighScoretap.position = ccpAdd(spZone.position, ccp(-spZone.contentSize.width/4, spZone.contentSize.height/3.45));
        [self addChild:spHighScoretap z:10];
        
        [spHighScoretap runAction:[CCSequence actions:[CCDelayTime actionWithDuration:waitDuration],[CCFadeTo actionWithDuration:actionDuration opacity:255], nil]];
        
        [spHighScoretap runAction:[CCSequence actions:[CCDelayTime actionWithDuration:waitDuration],[CCScaleTo actionWithDuration:actionDuration scale:1], nil]];
        waitDuration += actionDuration * 2.0f;
    }
    
    // 显示结束
    CCDelayTime *delayTime = [CCDelayTime actionWithDuration:waitDuration*1.6f+2.0f];
    CCCallFunc *gameResultShowEndFunc = [CCCallFunc actionWithTarget:self selector:@selector(gameResultsShowEnd)];
    [self runAction:[CCSequence actions:delayTime, gameResultShowEndFunc, nil]];
}

- (void)showControlItems
{
    CGSize size = self.boundingBox.size;
    CCMenuItemImage *itemBack = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"backToMainMap.png"] selectedSprite:nil target:self selector:@selector(backToNavigation)];
    itemBack.position = ccp(size.width*0.3f, size.height*0.32f);
    
    CCMenuItemImage *itemRestart = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"reStart.png"] selectedSprite:nil target:self selector:@selector(restartCurrentGame)];
    itemRestart.position = ccp(size.width*0.43f, size.height*0.32f);
    
    CCMenuItemImage *itemNextLesson = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"nextLevel.png"] selectedSprite:nil target:self selector:@selector(enterNextLesson)];
    itemNextLesson.position = ccp(size.width*0.56f, size.height*0.32f);
    itemNextLesson.visible = !gameData.isNextLessonLocked;
    
    CCMenuItemImage *itemKnowledge = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"knowledge.png"] selectedSprite:nil target:self selector:@selector(enterKnowledgeLayer)];
    itemKnowledge.position = ccp(size.width*0.69f, size.height*0.32f);
    
    menu =[CCMenu menuWithItems:itemBack, itemRestart, itemNextLesson, itemKnowledge, nil];
    menu.position = CGPointZero;
    [self addChild:menu z:20];
}

- (void)gameResultsShowEnd
{
    //[self stopBackgroundAudio];
    [self setTouchEnabled:YES];
}

#pragma mark - ItemAction Manager
- (void)backToNavigation
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didRecieveQuitEvent:)])
    {
        [self.delegate didRecieveQuitEvent:self];
    }
}

- (void)restartCurrentGame
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didRecieveRestartEvent:)])
    {
        [self.delegate didRecieveRestartEvent:self];
    }
}

- (void)enterNextLesson
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didRecieveEnterNextLessonEvent:)])
    {
        [self.delegate didRecieveEnterNextLessonEvent:self];
    }
}

- (void)enterKnowledgeLayer
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didRecieveShowKnowledgeProgressEvent:)])
    {
        [self.delegate didRecieveShowKnowledgeProgressEvent:self];
    }
}

#pragma mark - Background Audio
- (void)playScoreAudio
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"caculateScore.mp3"];
}

- (void)playBackgroundAudio
{
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"caculateScore.mp3" loop:YES];
}

- (void)stopBackgroundAudio
{
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
}

#pragma mark - Memory Manager
- (void)dealloc
{
    [[self class] cancelPreviousPerformRequestsWithTarget:self];
    
    [spJuanLeft stopAllActions];
    [spJuanLeft removeFromParentAndCleanup:YES];
    spJuanLeft = nil;
    
    [spJuanRight stopAllActions];
    [spJuanRight removeFromParentAndCleanup:YES];
    spJuanRight = nil;
    
    [spZone stopAllActions];
    [spZone removeFromParentAndCleanup:YES];
    spZone = nil;
    
    [lblCurrentScore removeFromParentAndCleanup:YES];
    lblCurrentScore = nil;
    
    [batchNode removeAllChildrenWithCleanup:YES];
    [batchNode removeFromParentAndCleanup:YES];
    batchNode = nil;
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:@"gamescore.plist"];
    [CCSpriteFrameCache purgeSharedSpriteFrameCache];
    
    // 移除所有的纹理集, 来降低内存。
    [[CCTextureCache sharedTextureCache] removeAllTextures];
    [CCTextureCache purgeSharedTextureCache];
}

@end
