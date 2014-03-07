//
//  SentenceLessonScene.m
//  ChineseForKids
//
//  Created by 唐 希 on 13-8-15.
//  Copyright 2013年 Allen. All rights reserved.

//  Modified by yang on 13-12-13.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "SentenceLessonScene.h"
#import "SimpleAudioEngine.h"
#import "GameManager.h"
#import "GlobalDataHelper.h"
#import "GameLessonData.h"
#import "SentenceTimeControl.h"
#import "SpritePlank.h"

#import "UploadLessonNet.h"
#import "SentenceNet.h"
#import "SentencePatternModel.h"
#import "SentenceModel.h"
#import "LessonModel.h"
#import "ResponseModel.h"

#import "KnowledgeProgressLayer.h"

#import "SceneManager.h"
#import "cocos2d.h"

#import "Constants.h"
#import "CommonHelper.h"

@implementation SentenceLessonScene
{
    int _Level;
    // 楼层
    int _towerLayer;
    // 云层是否漂浮
    bool isCloudFloat;
    
    CCParallaxNode *_backgroundNode;

    CCLabelTTF *lblDropValue;
    CCLabelTTF *labelScore;
    
    CCSprite *spProgressBg;
    CCSprite *spMonkTeam;
    CCSprite *spDropPlank;
    // 底部背景图片
    CCSprite  *bgOrderWord;
    
    CCMenuItemImage *menuSpeakItem;
    CCMenuItemImage *menuRedoItem;

    NSString *_currentValue;
    // 所有的木板
    NSMutableArray *_arrayPlanks;
    // 当前点中的那块木板
    SpritePlank *spTouchPlank;
    //单个加分数
    int _addScore;
    
    // 所有的塔身精灵
    NSMutableArray *arrTowerSprite;
    
    // 所有的句子数据
    NSMutableArray *arrSentence;
    
    // 时间进度条
    SentenceTimeControl *timeControl;
    
    SentencePatternModel *senPatternModel;
    SentenceModel *sentenceModel;
}

//塔高
const int towerOffset = 151;

+ (id)nodeWithLessonID:(NSString *)lessonID
{
    return [[self alloc] initWithLessonID:lessonID];
}

- (id)initWithLessonID:(NSString *)lessonID
{
    CCLOG(@"%@ : %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    if (self = [super init])
    {
        _Level=0;
        _towerLayer=0;
        isCloudFloat=YES;
        _addScore = SCORE_PER_ROUND;
        
        arrSentence = [[NSMutableArray alloc] init];
        _arrayPlanks = [[NSMutableArray alloc] init];
        
        [self setTouchEnabled:YES];
        //[self initKnowledgeLayer];
        //[self pauseScene];
        [self initInterface];
        
        // 设置自身背景色
        glClearColor(14.0f/255.0f, 216.0f/255.0f, 250.0f/255.0f, 1.0f);
        // 延迟一帧加载, 以便前一场景的数据完全清空, 达到避开场景切换时的内存使用高峰。
        [self scheduleUpdate];
        
    }
    return self;
}

- (void)update:(ccTime)delta
{
    [self unscheduleUpdate];
    
    [[[CCDirector sharedDirector] view] setMultipleTouchEnabled:YES];
    
    // 播放背景音乐
    [self playBackgroundAudio:@"orderwordbg.mp3"];
    
    // 初始化本关的数据模型
    [self initLessonModel];
    
    // 更新最高得分数据
    [self updateHighScore];

    // 加载连词成句的数据
    [self loadSentenceGameData];
    
    // 生成木板
    [self buildPlanks];
}

- (void)initInterface
{
    CGSize boundSize = [self boundingBox].size;
    
    bgOrderWord = [CCSprite spriteWithSpriteFrameName:@"orderwordGameBkg.png"];
    bgOrderWord.position = ccp(boundSize.width/2, boundSize.height/2);
    [self addChild:bgOrderWord z:1];
    //添加连续滚动背景
    _backgroundNode = [CCParallaxNode node];
    [self addChild:_backgroundNode z:5];
    
    CGPoint ratio = ccp(1.0,0.5);
    
    CCSprite *spTower1 = [CCSprite spriteWithSpriteFrameName:@"sub_tower1.png"];
    spTower1.tag=1;
    [[spTower1 texture] setAliasTexParameters];
    spTower1.anchorPoint = ccp(0,0);
    [_backgroundNode addChild:spTower1 z:1 parallaxRatio:ratio positionOffset:ccp(boundSize.width*0.025, boundSize.height*0.2)];
    float towerHeight=spTower1.contentSize.height;
    CGPoint towerPosition=spTower1.position;
    for(int i=0;i<=5;i++){
        CCSprite *spTower2 = [CCSprite spriteWithSpriteFrameName:@"sub_tower2.png"];
        spTower2.tag=2;
        [[spTower2 texture] setAliasTexParameters];
        spTower2.anchorPoint = ccp(0,0);
        [_backgroundNode addChild:spTower2 z:1 parallaxRatio:ratio positionOffset:ccpAdd(towerPosition, ccp(0, towerHeight))];
        towerHeight=spTower2.contentSize.height;
        towerPosition=spTower2.position;
    }
    
    spMonkTeam=[CCSprite spriteWithSpriteFrameName:@"monkteam1.png"];
    spMonkTeam.position=ccpAdd(spTower1.position, ccp(spTower1.contentSize.width/2, spTower1.contentSize.height/3));
    [self addChild:spMonkTeam z:5];
    
    NSMutableArray *monkTeamFrames=[NSMutableArray arrayWithCapacity:2];
    
    for(int i=1;i<=4;i++){
        NSString *frameName=[NSString stringWithFormat:@"monkteam%d.png",i];
        CCSpriteFrame *frame=[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName];
        [monkTeamFrames addObject:frame];
    }
    CCAnimation *animationMonkTeam=[CCAnimation animationWithSpriteFrames:monkTeamFrames delay:0.2];
    [spMonkTeam runAction:[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:animationMonkTeam]]];    
    
    CCSprite *spIcoCloud=[CCSprite spriteWithSpriteFrameName:@"cloud3.png"];
    spIcoCloud.anchorPoint=ccp(0, 0.5);
    spIcoCloud.position=ccp(0, boundSize.height*0.9);
    [self addChild:spIcoCloud z:20];
    
    CCSprite *spIcoTower=[CCSprite spriteWithSpriteFrameName:@"ico_tower.png"];
    spIcoTower.anchorPoint=ccp(0, 0.5);
    spIcoTower.position=ccp(boundSize.width*0.05, boundSize.height*0.9);
    [self addChild:spIcoTower z:20];
    
    labelScore=[CCLabelTTF labelWithString:@"0" fontName:@"Helvetica-Bold" fontSize:50];
    labelScore.color=ccc3(108, 68, 6);
    labelScore.anchorPoint=ccp(0,0.5);
    labelScore.position=ccp(boundSize.width*0.05+spIcoTower.contentSize.width+15, boundSize.height*0.9);
    [self addChild:labelScore z:20];
    
    // 时间进度条
    timeControl = [SentenceTimeControl timeProgressControlWithParentNode:self];
    
    // 暂停
    CCMenuItemImage *pauseItem=[CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"pause.png"] selectedSprite:nil target:self selector:@selector(gamePause)];
    pauseItem.position = ccp(self.boundingBox.size.width*0.93, self.boundingBox.size.height*0.94);
    /*
    menuSpeakItem=[CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"btnspeaker.png"] selectedSprite:nil target:self selector:@selector(playAudio)];
    menuSpeakItem.position=ccp(boundSize.width/1.075, boundSize.height/1.21);
    */
    
    menuRedoItem=[CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"btnredo.png"] selectedSprite:nil target:self selector:@selector(doRedo)];
    menuRedoItem.position = ccp(boundSize.width/1.076, boundSize.height/1.43);
    menuRedoItem.scale = 1.5f;
    menuRedoItem.visible = NO;
    
    CCMenu *menu =[CCMenu menuWithItems:pauseItem, menuRedoItem, nil];
    menu.position = CGPointZero;
    [self addChild:menu z:20];
    
    spDropPlank=[CCSprite spriteWithSpriteFrameName:@"plank.png"];
    spDropPlank.position=ccp(boundSize.width/1.4, boundSize.height/1.32);
    [self addChild:spDropPlank z:10];
    
    _currentValue = @"";
    lblDropValue = [CCLabelTTF labelWithString:_currentValue fontName:@"Helvetica-Bold" fontSize:50];
    lblDropValue.color = ccc3(2, 175, 207);
    lblDropValue.anchorPoint = ccp(0, 0.5);
    lblDropValue.position = ccpAdd(spDropPlank.position, ccp(-spDropPlank.contentSize.width/2.5, 0));
    [self addChild:lblDropValue z:10];
    
    /*
    // 当前得分
    lblScTitle = [CCLabelTTF labelWithString:@"Score" fontName:kFontNameChil fontSize:kPinyinFontSize*0.8f dimensions:CGSizeMake(kScoreLabel_Width, kScoreLabel_Height - 5) hAlignment:kCCTextAlignmentRight];
    lblScTitle.position = ccp(self.boundingBox.size.width - kScoreLabel_Width*0.5f, self.boundingBox.size.height - lblScTitle.boundingBox.size.height*0.5f);
    lblScTitle.color = ccc3(255.0f, 255.0f, 255.0f);
    [self addChild:lblScTitle z:kRightrTree_z+1];
    
    lblScore = [CCLabelTTF labelWithString:@"0" fontName:kFontNameBold fontSize:kPinyinFontSize dimensions:CGSizeMake(kScoreLabel_Width, kScoreLabel_Height) hAlignment:kCCTextAlignmentRight];
    lblScore.position = ccp(self.boundingBox.size.width - kScoreLabel_Width*0.5f, lblScTitle.position.y-lblScTitle.boundingBox.size.height*0.5f-lblScore.boundingBox.size.height*0.5f);
    lblScore.color = ccc3(255.0f, 255.0f, 255.0f);
    [self addChild:lblScore z:kRightrTree_z+1];
    
    // 历史最高分
    lblHScTitle = [CCLabelTTF labelWithString:@"HighScore" fontName:kFontNameChil fontSize:kPinyinFontSize*0.8f dimensions:CGSizeMake(kScoreLabel_Width, kScoreLabel_Height - 5) hAlignment:kCCTextAlignmentRight];
    lblHScTitle.position = ccp(self.boundingBox.size.width - kScoreLabel_Width*0.5f, lblScore.position.y-lblScore.boundingBox.size.height*0.5f-lblHScTitle.boundingBox.size.height*0.5f);
    lblHScTitle.color = ccc3(255.0f, 255.0f, 255.0f);
    [self addChild:lblHScTitle z:kRightrTree_z+1];
    
    lblHScore = [CCLabelTTF labelWithString:@"0" fontName:kFontNameBold fontSize:kPinyinFontSize dimensions:CGSizeMake(kScoreLabel_Width, kScoreLabel_Height) hAlignment:kCCTextAlignmentRight];
    lblHScore.position = ccp(self.boundingBox.size.width - kScoreLabel_Width*0.5f, lblHScTitle.position.y-lblHScTitle.boundingBox.size.height*0.5f-lblHScore.boundingBox.size.height*0.5f);
    lblHScore.color = ccc3(255.0f, 255.0f, 255.0f);
    [self addChild:lblHScore z:kRightrTree_z+1];
     */
}

#pragma mark - 开启网络更新本课的数据
- (void)updateSentencePatternLessonData
{
    ResponseModel *response = [SentenceNet getSentenceGameInfoWithUserID:curUserID HumanID:strHumanID GroupID:strGroupID BookID:strBookID TypeID:strTypeID LessonID:strLessonID];
    if ([SentenceNet isRequestCanceled]) return;
    
    if (response.error.code != 0) {
        [self updateSentencePatternLessonData];
    }
}

#pragma mark - 加载游戏数据及处理游戏逻辑
-(void)loadSentenceGameData
{
    CCLOG(@"%@ : %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    senPatternModel = (SentencePatternModel *)[[GameManager sharedManager] pickOutSenPatternInfoWithUserID:curUserID humanID:curHumanID groupID:curGroupID bookID:curBookID typeID:curTypeID lessonID:curLessonID];
    NSArray *arrSen = [[GameManager sharedManager] loadSentenceDataWithUserID:curUserID humanID:curHumanID groupID:curGroupID bookID:curBookID typeID:curTypeID lessonID:curLessonID senPatternID:senPatternModel.knowledgeIDValue];
    if (arrSen)
    {
        [arrSentence setArray:arrSen];
    }
}

//生成木板
-(void)buildPlanks
{
    CGSize winSize=[CCDirector sharedDirector].winSize;
    [spDropPlank stopAllActions];
    spDropPlank.position=ccp(winSize.width/1.4, winSize.height/1.32);
    spDropPlank.scale = 1;
    spDropPlank.rotation = 0;
    menuRedoItem.visible=NO;
    // 随机抽取
    sentenceModel = [arrSentence objectAtIndex:_Level];
    //NSLog(@"sentenceModel.worderOrder: %@", sentenceModel.worderOrder);
    
    NSArray *arrayWords = [sentenceModel.worderOrder componentsSeparatedByString:@"|"];
    for(int i=0; i < [arrayWords count]; i++)
    {
        SpritePlank *spPlank = [[SpritePlank alloc] initWithValue:[arrayWords objectAtIndex:i]];
        
        float randomX=[self randomValueBetween:1.1 high:1.9];
        float randomY=[self randomValueBetween:1.67 high:6];
        CGPoint position = ccp(winSize.width/randomX, winSize.height/randomY);
        bool isBound = YES;
        
        NSInteger sum = 0;
        //木板重叠重置木板位置
        while (isBound)
        {
            sum++;
            isBound = NO;
            spPlank.spPlankbg.position = position;
            for (int j = 0; j < [_arrayPlanks count]; j++)
            {
                SpritePlank *tempPlank = [_arrayPlanks objectAtIndex:j];
                //if(CGRectContainsPoint(tempPlank.spPlankbg.boundingBox, position))
                if(CGRectIntersectsRect(tempPlank.spPlankbg.boundingBox, spPlank.spPlankbg.boundingBox))
                {
                    isBound = YES;
                    break;
                }
            }
            if(isBound)
            {
                randomX = [self randomValueBetween:1.1 high:1.9];
                randomY = [self randomValueBetween:1.67 high:6];
                position = ccp(winSize.width/randomX, winSize.height/randomY);
            }
            if (sum > [_arrayPlanks count]*[_arrayPlanks count]*[_arrayPlanks count])
            {
                break;
            }
        }
        
        spPlank.spPlankbg.position = position;
        spPlank.lblValue.position  = position;
        
        [self addChild:spPlank.spPlankbg z:10];
        [self addChild:spPlank.lblValue z:10];
        [_arrayPlanks addObject:spPlank];
    }
    
    //[self performSelector:@selector(playAudio) withObject:nil afterDelay:1];
    
    [self playAudioWithName:sentenceModel.audio];
}

-(void)DropPlank:(SpritePlank *)spPlank
{
    NSString *plankValue = [spPlank.value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    _currentValue = [_currentValue stringByAppendingString:plankValue];
    
    CGFloat fontSize = [CommonHelper resizableFontSizeWithFont:[UIFont fontWithName:lblDropValue.fontName size:50] content:_currentValue width:spDropPlank.contentSize.width*18/20 minFontSize:6 lineBreakMode:NSLineBreakByCharWrapping];
    [lblDropValue setFontSize:fontSize];
    [lblDropValue setString:_currentValue];
    
    if ([_arrayPlanks containsObject:spPlank])
    {
        [_arrayPlanks removeObject:spPlank];
    }
    spPlank = nil;
    
    menuRedoItem.visible=YES;
    
    if(_arrayPlanks.count == 0)
    {
        menuRedoItem.visible = NO;
        
        NSString *sentence = [sentenceModel.sentence stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if([_currentValue isEqualToString:sentence])
        {
            // 1、更新该知识点对的次数
            senPatternModel.rightTimesValue += senPatternModel.rightTimesValue  < PINYIN_SHOW_PROBABILITY ? 1 : 0;
            // 2、更新该知识点的进度.所有这些数据都以概率为参考。
            senPatternModel.progressValue = senPatternModel.rightTimesValue/(CGFloat)PINYIN_SHOW_PROBABILITY;
            // 3、本课程总体进度
            lessonProgress += senPatternModel.progressValue;
            // 4、保存这种更改
            [senPatternModel saveData];
            // 及时加载数据
            [self loadSentenceGameData];
            // 5、动画表示当次游戏结束
            [self completePlank];
            // 6、连对++
            keepRightNum++;
            // 7、检查激励
            [self checkEncourage];
        }
        else
        {
            // 1、更新选错的次数
            senPatternModel.wrongTimesValue += senPatternModel.wrongTimesValue < PINYIN_SHOW_PROBABILITY ? 1 : 0;
            // 2、保存这种更改
            [senPatternModel saveData];
            // 及时加载数据
            [self loadSentenceGameData];
            // 3、木板状态
            [self disappearPlank];
            // 4、重置连对次数
            keepRightNum=0;
            // 5、重置初始分数。
            _addScore = SCORE_PER_ROUND;
            // 6、设置木板显示的内容
            _currentValue = @"";
            [lblDropValue setString:_currentValue];
        }
        _Level = arc4random() % [arrSentence count];
        //_currentValue = @"";
        //[lblDropValue setString:_currentValue];
    }
    
    [[SimpleAudioEngine sharedEngine] playEffect:@"dropplank.mp3"];
}

-(void)completePlank
{
    CGSize winSize=[CCDirector sharedDirector].winSize;
    
    CGPoint position = ccp(winSize.width/3.5, winSize.height/1.52);
    id callBack = [CCCallBlock actionWithBlock:^{
        [self addScoreWithPosition:position];
        [self updateBackground];
        [self buildPlanks];
    }];
    
    CCCallBlock *callBlock = [CCCallBlock actionWithBlock:^{
        _currentValue = @"";
        [lblDropValue setString:_currentValue];
    }];
    
    CCCallBlockN *callBlockN = [CCCallBlockN actionWithBlock:^(CCNode *node){
        CCSprite *spTDropPlank = (CCSprite *)node;
        ccBezierConfig c={position,ccp(winSize.width/1.77, winSize.height/1.6),ccp(winSize.width/1.77, winSize.height/1.6)};
        [spTDropPlank runAction:[CCSequence actions:[CCBezierTo actionWithDuration:1 bezier:c], callBack, nil]];
        [spTDropPlank runAction:[CCScaleTo actionWithDuration:0.3 scale:0.2]];
        [spTDropPlank runAction:[CCRepeatForever actionWithAction:[CCSequence actions:[CCRotateTo actionWithDuration:0.25 angle:180],[CCRotateTo actionWithDuration:0.2 angle:360], nil]]];
        [[SimpleAudioEngine sharedEngine] playEffect:@"completeplank.mp3" pitch:1.0f pan:0.0f gain:0.5f];
    }];
    
    CCDelayTime *delay = [CCDelayTime actionWithDuration:0.6f];
    [spDropPlank runAction:[CCSequence actions:delay, callBlock, callBlockN, nil]];
    
    /*
    ccBezierConfig c={position,ccp(winSize.width/1.77, winSize.height/1.6),ccp(winSize.width/1.77, winSize.height/1.6)};
    [spDropPlank runAction:[CCSequence actions:[CCBezierTo actionWithDuration:1 bezier:c],callBack, nil]];
    [spDropPlank runAction:[CCScaleTo actionWithDuration:0.3 scale:0.2]];
    [spDropPlank runAction:[CCRepeatForever actionWithAction:[CCSequence actions:[CCRotateTo actionWithDuration:0.25 angle:180],[CCRotateTo actionWithDuration:0.2 angle:360], nil]]];
    */
    [spMonkTeam runAction:[CCSequence actions:[CCFadeTo actionWithDuration:1 opacity:0],[CCMoveTo actionWithDuration:0 position:ccp(winSize.width/3.95, winSize.height/2.13)], nil]];
}

-(void)disappearPlank
{
    spDropPlank.visible=NO;
    CCSprite *spPlankDestroy = [CCSprite spriteWithSpriteFrameName:@"plank.png"];
    spPlankDestroy.position=spDropPlank.position;
    [self addChild:spPlankDestroy z:10];
    
    id callBack = [CCCallBlock actionWithBlock:^{
        [self removeChild:spPlankDestroy cleanup:YES];
        spDropPlank.visible=YES;
        [self buildPlanks];
    }];
    
    NSMutableArray *plankFrames=[NSMutableArray arrayWithCapacity:2];
    
    for(int i=1;i<=5;i++){
        NSString *frameName=[NSString stringWithFormat:@"plank_destroy%d.png",i];
        CCSpriteFrame *frame=[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName];
        [plankFrames addObject:frame];
    }
    CCAnimation *animationPlank=[CCAnimation animationWithSpriteFrames:plankFrames delay:0.1];
    
    [spPlankDestroy runAction:[CCSequence actions:[CCAnimate actionWithAnimation:animationPlank],[CCDelayTime actionWithDuration:0.3],[CCFadeTo actionWithDuration:0.7 opacity:0],callBack,nil]];
    
    [[SimpleAudioEngine sharedEngine]playEffect:@"plankdestroy.mp3" pitch:1.0f pan:0.0f gain:0.5f];
    //[spDropPlank runAction:[CCSequence actions:[CCBlink actionWithDuration:0.5 blinks:3],callBack, nil]];
}

-(void)updateBackground
{
    CGSize winSize=[CCDirector sharedDirector].winSize;
    
    CCSprite *spTowerPlank;
    if(_towerLayer==0){
        spTowerPlank=[CCSprite spriteWithSpriteFrameName:@"tower_plank1.png"];
        [[spTowerPlank texture] setAliasTexParameters];
        spTowerPlank.anchorPoint = ccp(0.5,0.5);
        [_backgroundNode addChild:spTowerPlank z:1 parallaxRatio:ccp(1.0,0.5) positionOffset:ccp(winSize.width/3.95, winSize.height/1.593+towerOffset*_towerLayer)];
        
    }else{
        spTowerPlank=[CCSprite spriteWithSpriteFrameName:@"tower_plank2.png"];
        [[spTowerPlank texture] setAliasTexParameters];
        spTowerPlank.anchorPoint = ccp(0.5,0.5);
        [_backgroundNode addChild:spTowerPlank z:1 parallaxRatio:ccp(1.0,0.5) positionOffset:ccp(winSize.width/3.95, winSize.height/1.593+towerOffset*_towerLayer)];
        
    }
    
    _towerLayer++;
    if(_towerLayer>2 && isCloudFloat){
        [self initCloud];
        isCloudFloat=NO;
    }
    
    for(CCSprite *background in _backgroundNode.children){
        if(background.tag==2 && [_backgroundNode convertToWorldSpace:background.position].y<0){
            _backgroundNode.position=ccpAdd(_backgroundNode.position, ccp(0, towerOffset*2));
            [_backgroundNode removeChild:spTowerPlank cleanup:YES];
            _towerLayer--;
        }
    }
    
    if (bgOrderWord!=nil) {
        if(bgOrderWord.position.y+bgOrderWord.contentSize.height/2<0){
            [self removeChild:bgOrderWord cleanup:YES];
            bgOrderWord=nil;
        }else{
            [bgOrderWord runAction:[CCMoveTo actionWithDuration:1 position:CGPointMake(bgOrderWord.position.x,bgOrderWord.position.y-towerOffset)]];
        }
    }
    id callback1=[CCCallBlock actionWithBlock:^{
        [spMonkTeam runAction:[CCFadeTo actionWithDuration:0.5 opacity:255]];
    }];
    [_backgroundNode runAction:[CCSequence actions:[CCMoveTo actionWithDuration:1 position:CGPointMake(0,_backgroundNode.position.y-towerOffset*2)],callback1,nil]];
}

- (void)doRedo
{
    _currentValue=@"";
    [_arrayPlanks removeAllObjects];
    [lblDropValue setString:_currentValue];
    sentenceModel = nil;
    
    [self buildPlanks];
}

-(float)randomValueBetween:(float)low high:(float)high{
    return (((float)arc4random()/0xFFFFFFFFu)*(high-low))+low;
}

-(void)initCloud
{
    CGSize winSize=[CCDirector sharedDirector].winSize;
    
    CCSprite *spCloud1 = [CCSprite spriteWithSpriteFrameName:@"cloud1.png"];
    spCloud1.anchorPoint=ccp(0, 0.5);
    spCloud1.position=ccp(winSize.width, winSize.height/2);
    [self addChild:spCloud1 z:4];
    CCSprite *spCloud2 = [CCSprite spriteWithSpriteFrameName:@"cloud2.png"];
    spCloud2.anchorPoint=ccp(0, 0.5);
    spCloud2.position=ccp(winSize.width, winSize.height/5);
    [self addChild:spCloud2 z:4];
    
    [spCloud1 runAction:[CCRepeatForever actionWithAction:[CCSequence actions:[CCMoveTo actionWithDuration:30 position:ccp(-spCloud1.contentSize.width, winSize.height/2)],[CCDelayTime actionWithDuration:0],[CCMoveTo actionWithDuration:0 position:ccp(winSize.width, winSize.height/2)], nil]]];
    
    id callback1=[CCCallBlock actionWithBlock:^{
        [spCloud2 runAction:[CCRepeatForever actionWithAction:[CCSequence actions:[CCMoveTo actionWithDuration:30 position:ccp(-spCloud1.contentSize.width, winSize.height/5)],[CCDelayTime actionWithDuration:0],[CCMoveTo actionWithDuration:0 position:ccp(winSize.width, winSize.height/5)], nil]]];
    }];
    
    [spCloud2 runAction:[CCSequence actions:[CCDelayTime actionWithDuration:15],callback1, nil]];
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
    if(keepRightNum==3){
        _addScore+=20;
    }
    if(keepRightNum==5){
        _addScore+=30;
    }
    if(keepRightNum==8){
        _addScore+=50;
    }
}

#pragma mark - CCTouchs Manager
- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch=[touches anyObject];
    CGPoint location=[touch locationInView:[touch view]];
    location=[[CCDirector sharedDirector] convertToGL:location];
    
    for (int i=0; i<_arrayPlanks.count; i++)
    {
        SpritePlank *spPlank=[_arrayPlanks objectAtIndex:i];
        if (CGRectContainsPoint(spPlank.spPlankbg.boundingBox,location))
        {
            spTouchPlank = spPlank;
            //木板置顶
            [self removeChild:spPlank.spPlankbg];
            [self removeChild:spPlank.lblValue];
            [self addChild:spPlank.spPlankbg z:10];
            [self addChild:spPlank.lblValue z:10];
        }
    }
}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    //获取之前的活动点
    CGPoint oldTouchLocation = [touch previousLocationInView:touch.view];
    oldTouchLocation = [[CCDirector sharedDirector] convertToGL:oldTouchLocation];
    oldTouchLocation = [self convertToNodeSpace:oldTouchLocation];
    
    //坐标转换
    CGPoint translation = ccpSub(touchLocation, oldTouchLocation);
    if(spTouchPlank!=nil){
        [spTouchPlank dragPlank:translation];
    }
    
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    /*
     UITouch *touch=[touches anyObject] ;
     CGPoint location=[touch locationInView:[touch view]];
     location=[[CCDirector sharedDirector] convertToGL:location];
     */
    if(spTouchPlank != nil)
    {
        BOOL needShow = (spTouchPlank.spPlankbg.boundingBox.origin.y > spDropPlank.boundingBox.origin.y) && (spTouchPlank.spPlankbg.position.x > spDropPlank.boundingBox.origin.x);
        if (CGRectIntersectsRect(spTouchPlank.spPlankbg.boundingBox,spDropPlank.boundingBox) || needShow)
        {
            [self DropPlank:spTouchPlank];
        }
    }
    spTouchPlank = nil;
}

#pragma mark - 准备退出本界面时的处理
- (void)prepareToQuit
{
    [[[CCDirector sharedDirector] scheduler] unscheduleAllForTarget:timeControl];
    
    [super prepareToQuit];
}

#pragma mark - TimerProgress Delegate

- (void)timeProgressControl:(SentenceTimeControl *)control timeOut:(BOOL)timeOut
{
    if (timeOut)
    {
        // 显示分数和进度界面
        [self gameFinished];
        glClearColor(14.0f/255.0f, 216.0f/255.0f, 250.0f/255.0f, 1.0f);
    }
}

- (void)updateLessonData
{
    [self performSelectorInBackground:@selector(updateSentencePatternLessonData) withObject:nil];
}

- (void)uploadLessonData
{
    NSArray *arrData = [[GameManager sharedManager] loadSentencePatternDataWithUserID:curUserID humanID:curHumanID groupID:curGroupID bookID:curBookID typeID:curTypeID lessonID:curLessonID];
    
    NSString *knowledges = @"";
    for (int i = 0; i < [arrData count]; i++)
    {
        SentencePatternModel *senPatternTModel = [arrData objectAtIndex:i];
        knowledges = [knowledges stringByAppendingFormat:@"%d|%.2f,", senPatternTModel.knowledgeIDValue, senPatternTModel.progressValue];
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
    [SceneManager loadingWithGameID:kSentenceGameSceneID];
}

// 返回(主导航)
- (void)didRecieveQuitEvent:(CCLayer *)layer
{
    [super didRecieveQuitEvent:layer];
    //[SceneManager loadingWithGameID:kSentenceNavigationSceneID];
    [SceneManager loadingWithGameID:kCommonNavigationSceneID];
}

// 进入下一关
- (void)didRecieveEnterNextLessonEvent:(CCLayer *)layer;
{
    [super didRecieveEnterNextLessonEvent:layer];
    [SceneManager loadingWithGameID:kSentenceGameSceneID];
}

// 分数显示结束, 显示知识点进度。
- (void)didRecieveShowKnowledgeProgressEvent:(CCLayer *)layer
{
    [super didRecieveShowKnowledgeProgressEvent:layer];
    glClearColor(14.0f/255.0f, 216.0f/255.0f, 250.0f/255.0f, 1.0f);
}

#pragma mark - Memory Manager
- (void)dealloc
{
    CCLOG(@"%@ : %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    [[self class] cancelPreviousPerformRequestsWithTarget:self];
    [SentenceNet cancelRequest];
    
    [_backgroundNode removeAllChildrenWithCleanup:YES];
    [_backgroundNode removeFromParentAndCleanup:YES];
    _backgroundNode = nil;
    
    [lblDropValue removeFromParentAndCleanup:YES];
    lblDropValue = nil;
    
    [labelScore removeFromParentAndCleanup:YES];
    labelScore = nil;
    
    [spProgressBg removeFromParentAndCleanup:YES];
    spProgressBg = nil;
    
    [spMonkTeam removeFromParentAndCleanup:YES];
    spMonkTeam = nil;
    
    [spDropPlank removeFromParentAndCleanup:YES];
    spDropPlank = nil;
    // 底部背景图片
    [bgOrderWord removeFromParentAndCleanup:YES];
    bgOrderWord = nil;
    
    [menuSpeakItem removeFromParentAndCleanup:YES];
    menuSpeakItem = nil;
    
    [menuRedoItem removeFromParentAndCleanup:YES];
    menuRedoItem = nil;
    
    [knowledgeLayer removeFromParentAndCleanup:YES];
    knowledgeLayer = nil;
    
    _currentValue = nil;
    // 所有的木板
    [_arrayPlanks removeAllObjects];
    _arrayPlanks = nil;
    // 当前点中的那块木板
    spTouchPlank = nil;
    
    // 所有的塔身精灵
    [arrTowerSprite removeAllObjects];
    arrTowerSprite = nil;
    
    // 所有的句子数据
    [arrSentence removeAllObjects];
    arrSentence = nil;
    
    // 时间进度条
    timeControl = nil;
    // 数据模型
    senPatternModel = nil;
    sentenceModel = nil;
    lessonModel = nil;
    oldAudioName = nil;
    oldSpriteAnimateAudioName = nil;
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFrames];
    [CCSpriteFrameCache purgeSharedSpriteFrameCache];
    
    [[CCTextureCache sharedTextureCache] removeAllTextures];
    [CCTextureCache purgeSharedTextureCache];
    
    // 释放所有音效和背景音乐
    [SimpleAudioEngine end];
    CCLOG(@"%@ : %@; 结束! ", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
}

@end
