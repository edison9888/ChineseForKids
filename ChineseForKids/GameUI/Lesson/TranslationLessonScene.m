//
//  TranslationLessonScene.m
//  ChineseForKids
//
//  Created by 唐 希 on 13-8-15.
//  Copyright 2013年 Allen. All rights reserved.

//  Modified by yang on 13-12-13.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "TranslationLessonScene.h"
#import "SimpleAudioEngine.h"
#import "GameManager.h"
#import "GlobalDataHelper.h"
#import "GameLessonData.h"
#import "SentenceTimeControl.h"
#import "SpriteCard.h"

#import "UploadLessonNet.h"
#import "TranslateNet.h"
#import "TranslationModel.h"
#import "LessonModel.h"
#import "ResponseModel.h"

#import "PauseLayer.h"
#import "GameResultsLayer.h"
#import "KnowledgeProgressLayer.h"

#import "CCParallaxNode-Extras.h"

#import "SceneManager.h"
#import "cocos2d.h"

#import "Constants.h"
#import "CommonHelper.h"

#define kMountains_z 0
#define kTreesRoad_z 1

@implementation TranslationLessonScene
{
    int _Level;
    //单个加分数
    int _addScore;
    //卡片数量
    //int _numberOfCards;
    float _cardScale;
    float _time;
    
    //悟空妖怪间隔
    CGFloat monkeySpec;
    
    CCSprite *bgWordImage;
    CCSprite *fgWordImage;
    CCLabelTTF *labelScore;
    
    CCSprite *spMonkey;
    CCSprite *spMonster;
    CCSprite *spSelect;
    CCSprite *spIcoMonster;
    CCSprite *spIcoTimer;
    CCSprite *spProgressBg;
    
    SpriteCard *flippedCard;
    
    SentenceTimeControl *timeControl;
    
    CCParallaxNode *parallaxMountains;
    CCParallaxNode *parallaxTreesRoad;
    CCParallaxNode *parallaxClouds;
    
    NSMutableArray *spCardArray;
    NSMutableArray *arrTransModel;
}

+ (id)nodeWithLessonID:(NSString *)lessonID
{
    return [[self alloc] initWithLessonID:lessonID];
}

- (id)initWithLessonID:(NSString *)lessonID
{
    CCLOG(@"%@ : %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    if (self = [super init])
    {
        // 设置自身背景色
        //glClearColor(14.0f/255.0f, 216.0f/255.0f, 250.0f/255.0f, 1.0f);
        monkeySpec = 50;
        _Level=0;
        _addScore = SCORE_PER_ROUND;
        
        spCardArray = [[NSMutableArray alloc] init];
        arrTransModel = [[NSMutableArray alloc] init];
        
        [self setTouchEnabled:YES];
        //[self initKnowledgeLayer];
        //[self pauseScene];
        [self initInterface];
        
        [self initParallaxClouds];
        [self initParallaxMountains];
        [self initParallaxTreesRoad];
        
        // 设置自身背景色
        //glClearColor(14.0f/255.0f, 216.0f/255.0f, 250.0f/255.0f, 1.0f);
        // 延迟一帧加载, 以便前一场景的数据完全清空, 达到避开场景切换时的内存使用高峰。
        [self scheduleUpdate];
        [self schedule:@selector(updateParallax:)];
    }
    return self;
}

- (void)update:(ccTime)delta
{
    [self unscheduleUpdate];
    
    [[[CCDirector sharedDirector] view] setMultipleTouchEnabled:YES];
    
    // 播放背景音乐
    [self playBackgroundAudio:@"wordimagebg.mp3"];
    
    // 初始化本关的数据模型
    [self initLessonModel];
    
    // 更新最高得分数据
    [self updateHighScore];
    
    // 加载中英互译的数据
    [self loadTranslateGameData];
    
    // 构建界面显示用的卡片数据
    [self buildCard];
}

- (void)updateParallax:(ccTime)delta
{
    CGPoint backgroundScrollVel = ccp(-60, 0);
    
    parallaxMountains.position = ccpAdd(parallaxMountains.position, ccpMult(backgroundScrollVel, 0.01f));
    for (CCSprite *sprite in parallaxMountains.children)
    {
        if ([parallaxMountains convertToWorldSpace:sprite.position].x <= - sprite.boundingBox.size.width*0.5f)
        {
            [parallaxMountains incrementOffset:ccp(self.boundingBox.size.width+sprite.boundingBox.size.width + arc4random()%((NSInteger)(self.boundingBox.size.width*0.5f)), 0) forChild:sprite];
        }
    }
    
    parallaxTreesRoad.position = ccpAdd(parallaxTreesRoad.position, ccpMult(backgroundScrollVel, 0.038f));
    for (CCSprite *sprite in parallaxTreesRoad.children)
    {
        if ([parallaxTreesRoad convertToWorldSpace:sprite.position].x <= - sprite.boundingBox.size.width*0.5f)
        {
            [parallaxTreesRoad incrementOffset:ccp(self.boundingBox.size.width*2.0f, 0) forChild:sprite];
        }
    }
    
    parallaxClouds.position = ccpAdd(parallaxClouds.position, ccpMult(backgroundScrollVel, 0.01f));
    for (CCSprite *sprite in parallaxClouds.children)
    {
        if ([parallaxClouds convertToWorldSpace:sprite.position].x <= - 100.0f)
        {
            [parallaxClouds incrementOffset:ccp(self.boundingBox.size.width+200.0f, 0) forChild:sprite];
        }
    }
}

- (void)initInterface
{
    CGSize boundSize = [self boundingBox].size;
    
    // 背景
    bgWordImage = [CCSprite spriteWithSpriteFrameName:@"translateGameBkg.png"];
    bgWordImage.position = ccp(boundSize.width*0.5f, boundSize.height*0.5f);
    [self addChild:bgWordImage z:-1];

    // 妖怪的图标
    spIcoMonster = [CCSprite spriteWithSpriteFrameName:@"ico_monster.png"];
    spIcoMonster.anchorPoint = ccp(0, 0.5);
    spIcoMonster.position = ccp(boundSize.width*0.05, boundSize.height*0.9);
    [self addChild:spIcoMonster z:1];
    
    // 分数
    labelScore=[CCLabelTTF labelWithString:@"0" fontName:@"Helvetica-Bold" fontSize:50];
    labelScore.anchorPoint=ccp(0,0.5);
    labelScore.position=ccp(boundSize.width*0.05+spIcoMonster.contentSize.width+15, boundSize.height*0.9);
    [self addChild:labelScore z:1];
    
    // 时间进度条
    timeControl = [SentenceTimeControl timeProgressControlWithParentNode:self];
    
    // 暂停
    CCMenuItemImage *pauseItem=[CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"pause.png"] selectedSprite:nil target:self selector:@selector(gamePause)];
    pauseItem.position = ccp(boundSize.width*0.93, boundSize.height*0.94);
    
    CCMenu *menu =[CCMenu menuWithItems:pauseItem, nil];
    menu.position = CGPointZero;
    [self addChild:menu];
    
    // 妖怪
    spMonster=[CCSprite spriteWithSpriteFrameName:@"monsterFly/0000"];
    //spMonster.scale=0.5;
    //spMonster.anchorPoint=ccp(1, 0);
    CGFloat monsterHeight = 20+spMonster.contentSize.height*0.5;
    spMonster.position = ccp(boundSize.width*2/3, monsterHeight);
    [self addChild:spMonster z:2];
    
    // 执行妖怪奔跑的动画
    [self updateMonsterAnimation];
    
    // 悟空
    spMonkey=[CCSprite spriteWithSpriteFrameName:@"monkeyChase/0000"];
    //spMonkey.scale=0.5;
    //spMonkey.anchorPoint=ccp(1, 0);
    //CGFloat monkeyHeight = 25+spMonkey.contentSize.height*0.5;
    spMonkey.position=ccp(boundSize.width/3, monsterHeight+5);
    [self addChild:spMonkey z:2];
    
    // 执行悟空奔跑的动画
    [self updateMonkeyAnimation];
}

- (void)initParallaxClouds
{
    CGSize boundSize = self.boundingBox.size;
    CGPoint cloudRatio = ccp(0.2f, 1.0f);
    
    parallaxClouds = [CCParallaxNode node];
    [self addChild:parallaxClouds z:kMountains_z];
    
    CCSprite *spClouds1 = [CCSprite spriteWithSpriteFrameName:@"cloud.png"];
    spClouds1.flipX = YES;
    spClouds1.scale = 0.3f;
    [parallaxClouds addChild:spClouds1 z:kMountains_z parallaxRatio:cloudRatio positionOffset:ccp(boundSize.width*0.1f, boundSize.height*0.8f)];
    
    CCSprite *spClouds2 = [CCSprite spriteWithSpriteFrameName:@"cloud.png"];
    spClouds2.flipX = YES;
    spClouds2.scale = 0.5f;
    [parallaxClouds addChild:spClouds2 z:kMountains_z parallaxRatio:cloudRatio positionOffset:ccp(boundSize.width*0.3f, boundSize.height*0.9f)];
    
    CCSprite *spClouds3 = [CCSprite spriteWithSpriteFrameName:@"cloud.png"];
    spClouds3.flipX = YES;
    spClouds3.scale = 0.4f;
    [parallaxClouds addChild:spClouds3 z:kMountains_z parallaxRatio:cloudRatio positionOffset:ccp(boundSize.width*0.6f, boundSize.height*0.75f)];
    
    CCSprite *spClouds4 = [CCSprite spriteWithSpriteFrameName:@"cloud.png"];
    spClouds4.flipX = YES;
    spClouds4.scale = 0.8f;
    [parallaxClouds addChild:spClouds4 z:kMountains_z parallaxRatio:cloudRatio positionOffset:ccp(boundSize.width*0.8f, boundSize.height*0.7f)];
    
    CCSprite *spClouds5 = [CCSprite spriteWithSpriteFrameName:@"cloud.png"];
    spClouds5.flipX = YES;
    spClouds5.scale = 0.6f;
    [parallaxClouds addChild:spClouds5 z:kMountains_z parallaxRatio:cloudRatio positionOffset:ccp(boundSize.width*0.92f, boundSize.height*0.82f)];
    
    CCSprite *spClouds6 = [CCSprite spriteWithSpriteFrameName:@"cloud.png"];
    spClouds6.flipX = YES;
    spClouds6.scale = 1.0f;
    [parallaxClouds addChild:spClouds6 z:kMountains_z parallaxRatio:cloudRatio positionOffset:ccp(boundSize.width*1.2f, boundSize.height*0.76f)];
}

- (void)initParallaxMountains
{
    CGSize boundSize = self.boundingBox.size;
    CGPoint mountainRatio = ccp(1.0f, 1.0f);
    
    parallaxMountains = [CCParallaxNode node];
    [self addChild:parallaxMountains z:kMountains_z];
    
    CCSprite *spMountain1 = [CCSprite spriteWithSpriteFrameName:@"mountains.png"];
    [parallaxMountains addChild:spMountain1 z:kMountains_z parallaxRatio:mountainRatio positionOffset:ccp(boundSize.width*0.5f, boundSize.height*0.3f)];
    
    CCSprite *spMountain2 = [CCSprite spriteWithSpriteFrameName:@"mountains.png"];
    [parallaxMountains addChild:spMountain2 z:kMountains_z parallaxRatio:mountainRatio positionOffset:ccp(boundSize.width*1.4f, boundSize.height*0.3f)];
    
    CCSprite *spMountain3 = [CCSprite spriteWithSpriteFrameName:@"mountains.png"];
    [parallaxMountains addChild:spMountain3 z:kMountains_z parallaxRatio:mountainRatio positionOffset:ccp(boundSize.width*2.3f, boundSize.height*0.3f)];
}

- (void)initParallaxTreesRoad
{
    CGSize boundSize = self.boundingBox.size;
    CGPoint treesRatio = ccp(2.0f, 1.0f);
    
    parallaxTreesRoad = [CCParallaxNode node];
    [self addChild:parallaxTreesRoad z:kTreesRoad_z];
    
    CCSprite *spTrees1 = [CCSprite spriteWithSpriteFrameName:@"treesAndRoad1.png"];
    [parallaxTreesRoad addChild:spTrees1 z:kTreesRoad_z parallaxRatio:treesRatio positionOffset:ccp(boundSize.width*0.5f, boundSize.height*0.22f)];
    
    CCSprite *spTrees2 = [CCSprite spriteWithSpriteFrameName:@"treesAndRoad2.png"];
    [parallaxTreesRoad addChild:spTrees2 z:kTreesRoad_z parallaxRatio:treesRatio positionOffset:ccp(boundSize.width*1.5f, boundSize.height*0.22f)];
}

#pragma mark - 开启网络更新本课的数据
- (void)updateTranslationLessonData
{
    ResponseModel *response = [TranslateNet getTranslationGameInfoWithUserID:curUserID HumanID:strHumanID GroupID:strGroupID BookID:strBookID TypeID:strTypeID LessonID:strLessonID];
    if ([TranslateNet isRequestCanceled]) return;
    
    if (response.error.code != 0) {
        [self updateTranslationLessonData];
    }
}

#pragma mark - 生成卡片

-(void)buildCard
{
    CGSize winSize=[CCDirector sharedDirector].winSize;
    float spec = 30;
    
    NSArray *arrayNumber=[NSArray arrayWithObjects:@2,@2,@2,@4,@4,@6,@6,@8, nil];
    int numberOfCards = [[arrayNumber objectAtIndex:_Level] intValue];
    
    // 打乱各个数据模块的位置
    int gameWordImagesCount = [arrTransModel count];
    for(int i = 0; i < gameWordImagesCount; i++)
    {
        int m = (arc4random()%(gameWordImagesCount-i)+i);
        [arrTransModel exchangeObjectAtIndex:i withObjectAtIndex:m];
    }
    
    if(gameWordImagesCount < numberOfCards){
        numberOfCards = gameWordImagesCount;
    }
    
    for(int i = 0; i < numberOfCards; i++)
    {
        TranslationModel *transModel = [arrTransModel objectAtIndex:i];
        
        SpriteCard *spCard1 = [[SpriteCard alloc] initWithCard:transModel Content:transModel.chinese];
        spCard1.cardBack.position = ccp(winSize.width*0.5f, winSize.height);
        [self addChild:spCard1.cardBack z:3];
        [self addChild:spCard1.cardOpen z:3];
        [spCardArray addObject:spCard1];
        
        SpriteCard *spCard2 = [[SpriteCard alloc] initWithCard:transModel Content:transModel.english];
        spCard2.cardBack.position = ccp(winSize.width*0.5f, winSize.height);
        [self addChild:spCard2.cardBack z:3];
        [self addChild:spCard2.cardOpen z:3];
        [spCardArray addObject:spCard2];
    }
    int count = [spCardArray count];
    
    for(int i = 0; i < count; i++)
    {
        // 打乱顺序
        int m = (arc4random()%(count-i)+i);
        [spCardArray exchangeObjectAtIndex:i withObjectAtIndex:m];
    }
    
    int index=0;
    if(count == 4){
        _cardScale=1;
        for(int i=0;i<2;i++){
            for(int j=0;j<2;j++){
                SpriteCard *spCard = [spCardArray objectAtIndex:index];
                index++;
                [spCard moveToGame:1 scale:_cardScale position:ccp(winSize.width*0.37+(spCard.cardBack.contentSize.width+spec)*j,winSize.height*0.7-(spCard.cardBack.contentSize.height+spec)*i)];
            }
        }
    }else if(count==8){
        _cardScale=0.75;
        for(int i=0;i<2;i++){
            for(int j=0;j<4;j++){
                SpriteCard *spCard=[spCardArray objectAtIndex:index];
                index++;
                [spCard moveToGame:1 scale:_cardScale position:ccp(winSize.width*0.17+(spCard.cardBack.contentSize.width*_cardScale+spec)*j,winSize.height*0.7-(spCard.cardBack.contentSize.height*_cardScale+spec)*i)];
                
            }
        }
    }else if(count==12){
        _cardScale=0.75;
        for(int i=0;i<3;i++){
            for(int j=0;j<4;j++){
                SpriteCard *spCard=[spCardArray objectAtIndex:index];
                index++;
                [spCard moveToGame:1 scale:_cardScale position:ccp(winSize.width*0.17+(spCard.cardBack.contentSize.width*_cardScale+spec)*j,winSize.height*0.75-(spCard.cardBack.contentSize.height*_cardScale+spec)*i)];
                
            }
        }
    }else if(count==16){
        _cardScale=0.65;
        for(int i=0;i<4;i++){
            for(int j=0;j<4;j++){
                SpriteCard *spCard=[spCardArray objectAtIndex:index];
                index++;
                [spCard moveToGame:1 scale:_cardScale position:ccp(winSize.width*0.25+(spCard.cardBack.contentSize.width*_cardScale+spec/4)*j,winSize.height*0.77-(spCard.cardBack.contentSize.height*_cardScale+spec/4)*i)];
                
            }
        }
    }
    
}

#pragma mark - Sprite Animation Manager
- (void)updateMonsterAnimation
{
    /*
    CGSize boundSize = [self boundingBox].size;
    CGFloat monsterHeight = 25+spMonster.contentSize.height*0.5;
    
    //妖怪奔跑动画
    CCSequence *actionMonster=[CCSequence actions:
                               [CCMoveTo actionWithDuration:5 position:ccp(-spMonster.contentSize.width-monkeySpec-spMonkey.contentSize.width, monsterHeight)]
                               ,[CCFlipX actionWithFlipX:YES],
                               [CCScaleTo actionWithDuration:0 scale:1],
                               [CCMoveTo actionWithDuration:0 position:ccp(-spMonster.contentSize.width,monsterHeight)],
                               [CCMoveTo actionWithDuration:3 position:ccp(boundSize.width+monkeySpec+spMonkey.contentSize.width+spMonster.contentSize.width, monsterHeight)],
                               [CCScaleTo actionWithDuration:0 scale:0.5],
                               [CCFlipX actionWithFlipX:NO], nil];
    [spMonster runAction:[CCRepeatForever actionWithAction:actionMonster]];
    
    NSMutableArray *monsterFrames=[NSMutableArray arrayWithCapacity:2];
    
    for(int i=1;i<=2;i++){
        NSString *frameName=[NSString stringWithFormat:@"monster%d.png",i];
        CCSpriteFrame *frame=[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName];
        [monsterFrames addObject:frame];
    }
    
    CCAnimation *animationMonster=[CCAnimation animationWithSpriteFrames:monsterFrames delay:0.3];
    [spMonster runAction:[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:animationMonster]]];
     */
    
    NSMutableArray *arrAnimation = [NSMutableArray arrayWithCapacity:6];
    for(int i = 0; i <= 19; i++)
    {
        NSString *frameName=[NSString stringWithFormat:@"monsterFly/%04d",i];
        CCSpriteFrame *frame=[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName];
        [arrAnimation addObject:frame];
    }
    
    CCAnimation *animation = [CCAnimation animationWithSpriteFrames:arrAnimation delay:0.06];
    CCRepeatForever *repeat   = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:animation]];
    [spMonster runAction:repeat];
}

- (void)updateMonkeyAnimation
{
    /*
    CGSize boundSize = [self boundingBox].size;
    CGFloat monkeyHeight=25+spMonkey.contentSize.height*0.5;
    
    //猴子奔跑动画
    CCSequence *actionMonkey=[CCSequence actions:
                              [CCMoveTo actionWithDuration:5 position:ccp(-spMonkey.contentSize.width,monkeyHeight)],
                              [CCMoveTo actionWithDuration:0 position:ccp(-spMonkey.contentSize.width-monkeySpec-spMonster.contentSize.width, monkeyHeight)],[CCFlipX actionWithFlipX:YES],
                              [CCScaleTo actionWithDuration:0 scale:1],
                              [CCMoveTo actionWithDuration:3 position:ccp(boundSize.width, monkeyHeight)],
                              [CCMoveTo actionWithDuration:0 position:ccp(boundSize.width+monkeySpec+spMonster.contentSize.width*2,monkeyHeight)],
                              [CCScaleTo actionWithDuration:0 scale:0.5],[CCFlipX actionWithFlipX:NO], nil];
    
    
    [spMonkey runAction:[CCRepeatForever actionWithAction:actionMonkey]];
    
    NSMutableArray *monkeyFrames=[NSMutableArray arrayWithCapacity:2];
    
    for(int i=1;i<=2;i++){
        NSString *frameName=[NSString stringWithFormat:@"monkey%d.png",i];
        CCSpriteFrame *frame=[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName];
        [monkeyFrames addObject:frame];
    }
    
    CCAnimation *animationMonkey=[CCAnimation animationWithSpriteFrames:monkeyFrames delay:0.05];
    [spMonkey runAction:[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:animationMonkey]]];
     */
    
    NSMutableArray *arrAnimation = [NSMutableArray arrayWithCapacity:6];
    for(int i = 0; i <= 7; i++)
    {
        NSString *frameName=[NSString stringWithFormat:@"monkeyChase/%04d",i];
        CCSpriteFrame *frame=[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName];
        [arrAnimation addObject:frame];
    }
    
    CCAnimation *animation = [CCAnimation animationWithSpriteFrames:arrAnimation delay:0.05];
    CCRepeatForever *repeat   = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:animation]];
    [spMonkey runAction:repeat];
}

- (void)updateMonkeyRightAnimation
{
    [self hideMonkeyAndMonster];
    
    NSMutableArray *arrAnimation = [NSMutableArray arrayWithCapacity:6];
    for(int i = 0; i <= 39; i++)
    {
        NSString *frameName=[NSString stringWithFormat:@"monkeyJump/%04d",i];
        CCSpriteFrame *frame=[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName];
        [arrAnimation addObject:frame];
    }
    
    CCCallBlockN *callBlockN = [CCCallBlockN actionWithBlock:^(CCNode *node){
        [self showMonkeyAndMonster];
        
        [spSelect removeFromParentAndCleanup:YES];
        spSelect = nil;
    }];
    CCAnimation *animation = [CCAnimation animationWithSpriteFrames:arrAnimation delay:0.04];
    CCSequence *sequence = [CCSequence actions:[CCAnimate actionWithAnimation:animation], callBlockN, nil];
    if (!spSelect)
    {
        spSelect = [CCSprite spriteWithSpriteFrameName:@"monkeyJump/0000"];
        spSelect.position = ccp(self.boundingBox.size.width*0.5f+8, self.boundingBox.size.height*0.216f);
        [self addChild:spSelect z:2];
        
        [spSelect runAction:sequence];
    }
}

- (void)updateMonkeyWrongAnimation
{
    [self hideMonkeyAndMonster];
    
    NSMutableArray *arrAnimation = [NSMutableArray arrayWithCapacity:6];
    for(int i = 0; i <= 31; i++)
    {
        NSString *frameName=[NSString stringWithFormat:@"monkeyWrong/%04d",i];
        CCSpriteFrame *frame=[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName];
        [arrAnimation addObject:frame];
    }
    
    CCCallBlockN *callBlockN = [CCCallBlockN actionWithBlock:^(CCNode *node){
        [self showMonkeyAndMonster];
        
        [spSelect removeFromParentAndCleanup:YES];
        spSelect = nil;
    }];
    CCAnimation *animation = [CCAnimation animationWithSpriteFrames:arrAnimation delay:0.05];
    CCSequence *sequence = [CCSequence actions:[CCAnimate actionWithAnimation:animation], callBlockN, nil];
    if (!spSelect)
    {
        spSelect = [CCSprite spriteWithSpriteFrameName:@"monkeyWrong/0000"];
        spSelect.position = ccp(self.boundingBox.size.width*0.5f, self.boundingBox.size.height*0.186f);
        [self addChild:spSelect z:2];
        
        [spSelect runAction:sequence];
        [[SimpleAudioEngine sharedEngine] playEffect:@"transWrong.wav"];
    }
}

- (void)updateMonkeyKeepRightAnimation
{
    [self hideMonkeyAndMonster];
    
    NSMutableArray *arrAnimation = [NSMutableArray arrayWithCapacity:6];
    for(int i = 0; i <= 39; i++)
    {
        NSString *frameName=[NSString stringWithFormat:@"monkeyJump/%04d",i];
        CCSpriteFrame *frame=[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName];
        [arrAnimation addObject:frame];
    }
    CCCallBlockN *callBlockN = [CCCallBlockN actionWithBlock:^(CCNode *node){
        [self showMonkeyAndMonster];
        [spSelect removeFromParentAndCleanup:YES];
        spSelect = nil;
    }];
    CCAnimation *animation = [CCAnimation animationWithSpriteFrames:arrAnimation delay:0.04];
    CCSequence *sequence = [CCSequence actions:[CCAnimate actionWithAnimation:animation], callBlockN, nil];
    if (!spSelect)
    {
        spSelect = [CCSprite spriteWithSpriteFrameName:@"monkeyJump/0000"];
        spSelect.position = ccp(self.boundingBox.size.width*0.5f+8, self.boundingBox.size.height*0.216f);
        [self addChild:spSelect z:2];
        [spSelect runAction:sequence];
    }
}

- (void)hideMonkeyAndMonster
{
    spMonkey.visible  = NO;
    spMonster.visible = NO;
}

- (void)showMonkeyAndMonster
{
    spMonkey.visible  = YES;
    spMonster.visible = YES;
}

#pragma mark - CCTouchs Manager
- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch=[touches anyObject] ;
    CGPoint location=[touch locationInView:[touch view]];
    location=[[CCDirector sharedDirector] convertToGL:location];
    [self TouchCard:location];
}

- (void)TouchCard:(CGPoint)touchLocation{
    
    for (int i=0; i<spCardArray.count; i++)
    {
        SpriteCard *spCard=[spCardArray objectAtIndex:i];
        if(!spCard.cardBack.visible&&!spCard.cardOpen.visible) return;
        
        if (CGRectContainsPoint(spCard.cardBack.boundingBox, touchLocation))
        {
            if(!spCard.canFlip) return;
            [[SimpleAudioEngine sharedEngine]playEffect:@"cardclick.mp3"];
            
            [spCard flipCardAnimation:!spCard.cardBack.visible canFlip:NO];
            
            if(!spCard.cardBack.visible)
            {
                flippedCard = nil;
            }
            else
            {
                if(flippedCard == nil)
                {
                    flippedCard = spCard;
                }
                else
                {
                    [self performSelector:@selector(callCheckFlippedCard:) withObject:[NSArray arrayWithObjects:flippedCard, spCard, nil ] afterDelay:0.5];
                    flippedCard = nil;
                }
            }// else 结束
        }// if 结束
    }// for 结束
}

- (void)callCheckFlippedCard:(NSArray *)inputArray
{
    [self checkFlippedCard:[inputArray objectAtIndex:0] currentCard:[inputArray objectAtIndex:1]];
}

- (void)checkFlippedCard:(SpriteCard *)spBeforeCard currentCard:(SpriteCard *)spCurrentCard
{
    TranslationModel *transModel = (TranslationModel *)[spCurrentCard transModel];
    
    //if(spBeforeCard.value == spCurrentCard.value)
    if (spBeforeCard.transModel.knowledgeIDValue == transModel.knowledgeIDValue)
    {
        // 1、更新该知识点对的次数
        transModel.rightTimesValue += (transModel.rightTimesValue  < PINYIN_SHOW_PROBABILITY) ? 1 : 0;
        // 2、更新该知识点的进度.所有这些数据都以概率为参考。
        transModel.progressValue = transModel.rightTimesValue/(CGFloat)PINYIN_SHOW_PROBABILITY;
        // 3、本课程总体进度
        lessonProgress += transModel.progressValue;
        // 4、保存这种更改
        [transModel saveData];
        
        [self addScoreWithPosition:spCurrentCard.cardOpen.position];
        
        keepRightNum++;
        keepRightNum >= 3 ? [self updateMonkeyKeepRightAnimation]: [self updateMonkeyRightAnimation];
        
        [self checkEncourage];
        
        NSMutableArray *cardFrames=[NSMutableArray arrayWithCapacity:2];
        
        for(int i=1;i<=7;i++)
        {
            NSString *frameName=[NSString stringWithFormat:@"carddisappear%d.png",i];
            CCSpriteFrame *frame=[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName];
            [cardFrames addObject:frame];
        }
        
        CCAnimation *animationCard = [CCAnimation animationWithSpriteFrames:cardFrames delay:0.1];
        
        void(^ block)(id) = ^(id object){
            SpriteCard *spCard = (SpriteCard *)object;
            [spCardArray removeObject:spCard];
            [spCard destroy];
            if([spCardArray count] < 1)
            {
                _Level++;
                if(_Level>7) _Level=7;
                [self buildCard];
            }
        };
        
        CCCallBlockO *curCallBO = [CCCallBlockO actionWithBlock:block object:spCurrentCard];
        CCCallBlockO *befCallBO = [CCCallBlockO actionWithBlock:block object:spBeforeCard];
        
        void(^ delBlock)(id) = ^(id object){
            SpriteCard *spCard = (SpriteCard *)object;
            [spCard hideContent];
        };
        
        CCCallBlockO *curDelCallBO = [CCCallBlockO actionWithBlock:delBlock object:spCurrentCard];
        CCCallBlockO *befDelCallBO = [CCCallBlockO actionWithBlock:delBlock object:spBeforeCard];
        
        [spCurrentCard.cardOpen runAction:[CCSequence actions:curDelCallBO, [CCAnimate actionWithAnimation:animationCard], curCallBO, nil]];
        [spBeforeCard.cardOpen runAction:[CCSequence actions:befDelCallBO, [CCAnimate actionWithAnimation:animationCard], befCallBO, nil]];
        
        [[SimpleAudioEngine sharedEngine] playEffect:@"carddisappear.mp3" pitch:1.0f pan:0.0f gain:0.5f];
        //[[SimpleAudioEngine sharedEngine] playEffect:spCurrentCard.audio];
        [self playAudioWithName:spCurrentCard.audio];
    }
    else
    {
        keepRightNum = 0;
        _addScore = SCORE_PER_ROUND;
        [self updateMonkeyWrongAnimation];
        
        // 1、更新选错的次数
        transModel.wrongTimesValue += (transModel.wrongTimesValue < PINYIN_SHOW_PROBABILITY) ? 1 : 0;
        // 2、保存这种更改
        [transModel saveData];
        
        [spBeforeCard flipCardAnimation:YES canFlip:YES];
        [spCurrentCard flipCardAnimation:YES canFlip:YES];
        
    }
}

-(void)addScoreWithPosition:(CGPoint)position
{
    CCLabelTTF *lblAddScore = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"+%d",_addScore ] fontName:@"Helvetica-Bold" fontSize:40];
    lblAddScore.scale = 0.1f;
    lblAddScore.color = ccc3(108, 68, 6);
    lblAddScore.position=position;
    [self addChild:lblAddScore z:20];
    
    id callback=[CCCallBlock actionWithBlock:^{
        [lblAddScore removeFromParentAndCleanup:YES];
        score += _addScore;
        [labelScore setString:[NSString stringWithFormat:@"%d", score]];
        
    }];
    [lblAddScore runAction:[CCScaleTo actionWithDuration:0.2 scale:1]];
    [lblAddScore runAction:[CCSequence actions:[CCMoveTo actionWithDuration:1 position:ccpAdd(labelScore.position, ccp(labelScore.boundingBox.size.width*0.5f+lblAddScore.boundingBox.size.width*0.5f, 0.0f))],callback, nil]];
}

-(void)checkEncourage
{
    if(keepRightNum >= 3){
        _addScore+=20;
    }
    if(keepRightNum >= 5){
        _addScore+=30;
    }
    if(keepRightNum >= 8){
        _addScore+=50;
    }
}

#pragma mark - Load Data
- (void)loadTranslateGameData
{
    NSArray *arrTransMD = [[GameManager sharedManager] loadTranslationDataWithUserID:curUserID humanID:curHumanID groupID:curGroupID bookID:curBookID typeID:curTypeID lessonID:curLessonID];
    if (arrTransMD) {
        [arrTransModel setArray:arrTransMD];
    }
}


#pragma mark - 准备退出本界面时的处理
- (void)prepareToQuit
{
    [[[CCDirector sharedDirector] scheduler] unscheduleAllForTarget:timeControl];
    [[[CCDirector sharedDirector] scheduler] unscheduleAllForTarget:self];
    
    [super prepareToQuit];
}

#pragma mark - TimerProgress Delegate

- (void)timeProgressControl:(SentenceTimeControl *)control timeOut:(BOOL)timeOut
{
    if (timeOut)
    {
        // 显示分数和进度界面
        [self gameFinished];
    }
}

- (void)updateLessonData
{
    [self performSelectorInBackground:@selector(updateTranslationLessonData) withObject:nil];
}

- (void)uploadLessonData
{
    NSArray *arrData = [[GameManager sharedManager] loadTranslationDataWithUserID:curUserID humanID:curHumanID groupID:curGroupID bookID:curBookID typeID:curTypeID lessonID:curLessonID];
    
    NSString *knowledges = @"";
    for (int i = 0; i < [arrData count]; i++)
    {
        TranslationModel *transTModel = [arrData objectAtIndex:i];
        knowledges = [knowledges stringByAppendingFormat:@"%d|%.2f,", transTModel.knowledgeIDValue, transTModel.progressValue];
    }
    knowledges = [knowledges substringToIndex:[knowledges length]-1];
    
    NSString *strScore = [NSString stringWithFormat:@"%d", lessonModel.scoreValue];
    NSString *strStarNum = [NSString stringWithFormat:@"%d", lessonModel.starAmountValue];
    NSString *strProgress = [NSString stringWithFormat:@"%.2f", lessonModel.progressValue];
    NSString *strDataVersion = [NSString stringWithFormat:@"%f", lessonModel.dataVersionValue];
    NSString *strTimeStamp = [NSString stringWithFormat:@"%@", lessonModel.updateTime];
    // 上传更新数据，locked为0：因为本关既然能进来玩说明是已经解锁了的。
    [UploadLessonNet uploadLessonInfoWithUserID:curUserID HumanID:strHumanID GroupID:strGroupID BookID:strBookID TypeID:strTypeID LessonID:strLessonID Score:strScore StarAmount:strStarNum Progress:strProgress Locked:@"0" UpdateTime:strTimeStamp DataVersion:strDataVersion Knowledges:knowledges];
}

#pragma mark - pauseLayer/gameresult Delegate
// 继续
-(void)didRecieveResumeEvent:(CCLayer *)layer
{
    [super didRecieveResumeEvent:layer];
}

// 重开
-(void)didRecieveRestartEvent:(CCLayer *)layer
{
    [super didRecieveRestartEvent:layer];
    
    [SceneManager loadingWithGameID:kTranslateGameSceneID];
}

// 返回(主导航)
- (void)didRecieveQuitEvent:(CCLayer *)layer
{
    [super didRecieveQuitEvent:layer];
    //[SceneManager loadingWithGameID:kTranslateNavigationSceneID];
    [SceneManager loadingWithGameID:kCommonNavigationSceneID];
}

// 进入下一关
- (void)didRecieveEnterNextLessonEvent:(CCLayer *)layer;
{
    [super didRecieveEnterNextLessonEvent:layer];
    
    [SceneManager loadingWithGameID:kTranslateGameSceneID];
}

// 分数显示结束, 显示知识点进度。
- (void)didRecieveShowKnowledgeProgressEvent:(CCLayer *)layer
{
    [super didRecieveShowKnowledgeProgressEvent:layer];
}

#pragma mark - Memory Manager
- (void)dealloc
{
    CCLOG(@"%@ : %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    [[self class] cancelPreviousPerformRequestsWithTarget:self];
    
    [TranslateNet cancelRequest];
    oldSpriteAnimateAudioName = nil;
    
    [parallaxMountains removeAllChildrenWithCleanup:YES];
    [parallaxMountains removeFromParentAndCleanup:YES];
    parallaxMountains = nil;
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFrames];
    [CCSpriteFrameCache purgeSharedSpriteFrameCache];
    
    [[CCTextureCache sharedTextureCache] removeAllTextures];
    [CCTextureCache purgeSharedTextureCache];
    
    // 释放所有音效和背景音乐
    [SimpleAudioEngine end];
    CCLOG(@"%@ : %@; 结束! ", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
}

@end
