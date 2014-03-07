//
//  LessonScene.m
//  ChineseForKids
//
//  Created by yang on 13-12-13.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "LessonScene.h"
#import "GlobalDataHelper.h"

#import "GameManager.h"

#import "LessonModel.h"
#import "KnowledgeProgressLayer.h"
#import "PauseLayer.h"
#import "GameResultsLayer.h"
#import "SceneManager.h"
#import "DownloadLessonNet.h"
#import "ResponseModel.h"
#import "DownloadModel.h"

#import "GameLessonData.h"

#import "SimpleAudioEngine.h"
#import "cocos2d.h"

#import "FileHelper.h"
#import "Constants.h"
#import "CommonHelper.h"

@interface LessonScene ()<KnowledgeProgressDelegate, PauseLayerProtocol, GameResultsLayerProtocol>

@end

@implementation LessonScene

- (id)init
{
    //CGSize winSize=[CCDirector sharedDirector].winSize;
    //self = [super initWithColor:ccc4(14, 216, 250,255) width:winSize.width height:winSize.height];
    self = [super init];
    if (self)
    {
        curUserID    = [GlobalDataHelper sharedManager].curUserID;
        curHumanID   = [GlobalDataHelper sharedManager].curHumanID;
        curGroupID   = [GlobalDataHelper sharedManager].curGroupID;
        curBookID    = [GlobalDataHelper sharedManager].curBookID;
        curTypeID    = [GlobalDataHelper sharedManager].curTypeID;
        curLessonID  = [GlobalDataHelper sharedManager].curLessonID;
        nextLessonID = 0;
        
        strHumanID  = [NSString stringWithFormat:@"%d", curHumanID];
        strGroupID  = [NSString stringWithFormat:@"%d", curGroupID];
        strBookID   = [NSString stringWithFormat:@"%d", curBookID];
        strTypeID   = [NSString stringWithFormat:@"%d", curTypeID];
        strLessonID = [NSString stringWithFormat:@"%d", curLessonID];
        
        score = 0;
        oldScore = 0;
        oldStarNum = 0;
        keepRightNum = 0;
        lessonProgress = 0;
    }
    return self;
}

- (void)initLessonModel
{
    lessonModel = (LessonModel *)[[GameManager sharedManager] pickOutLessonInfoWithUserID:curUserID humanID:curHumanID groupID:curGroupID bookID:curBookID typeID:curTypeID lessonID:curLessonID];
    
    if (lessonModel)
    {
        nextLessonID = lessonModel.lessonIDValue+1;
        oldScore = lessonModel.scoreValue;
        oldStarNum = lessonModel.starAmountValue;
    }
    
    //NSLog(@"当前lessonModel: %@", lessonModel);
}

- (void)initKnowledgeLayer
{
    if (!knowledgeLayer)
    {
        knowledgeLayer = [KnowledgeProgressLayer nodeWithLessonID:strLessonID];
        knowledgeLayer.delegate = self;
        knowledgeLayer.position = self.position;
        knowledgeLayer.visible = NO;
        [self addChild:knowledgeLayer z:1000 tag:1000];
    }
}

- (void)showScoreWithPosition:(CGPoint)position Color:(ccColor3B)ccColor
{
    NSInteger curAddScore = keepRightNum >= 5 ? SCORE_KEEP_RIGHT : SCORE_PER_ROUND;
    score += curAddScore;
    //lblScore.text = [NSString stringWithFormat:@"%d", score];
    lblScore.string = [NSString stringWithFormat:@"%d", score];
    
    NSString *strAddScore = [NSString stringWithFormat:@"+%d", curAddScore];
    CCLabelTTF *tmpScore = [CCLabelTTF labelWithString:strAddScore fontName:kFontNameChil fontSize:kContentsChineseFontSize];
    tmpScore.color = ccColor;
    tmpScore.visible = NO;
    tmpScore.position = position;//ccp(self.boundingBox.size.width*0.75f, self.boundingBox.size.height*0.36f);
    [self addChild:tmpScore z:kTempScore_z];
    
    //CCDelayTime *delay = [CCDelayTime actionWithDuration:0.3f];
    
    CCFadeIn *fadeIn = [CCFadeIn actionWithDuration:0.3f];
    
    CCScaleTo *scaleBig = [CCScaleTo actionWithDuration:0.3f scaleX:1.2f scaleY:1.0f];
    CCSpawn *spawn = [CCSpawn actions:fadeIn, scaleBig, nil];
    
    CCScaleTo *scaleBack = [CCScaleTo actionWithDuration:0.3f scaleX:1.0f scaleY:1.0f];
    
    CCCallBlockN *visibleCallBack = [CCCallBlockN actionWithBlock:^(CCNode *node){
        CCLabelTTF *label = (CCLabelTTF *)node;
        label.visible = YES;
    }];
    
    CCCallBlockN *callBack = [CCCallBlockN actionWithBlock:^(CCNode *node){
        CCLabelTTF *label = (CCLabelTTF *)node;
        [label removeFromParentAndCleanup:YES];
        label = nil;
    }];
    
    CCSequence *seq = [CCSequence actions:/*delay,*/ visibleCallBack, spawn, scaleBack, callBack, nil];
    
    [tmpScore runAction:seq];
}

// 更新历史最高得分
- (void)updateHighScore
{
    lblHScore.string = [NSString stringWithFormat:@"%d", oldScore];
}

#pragma mark - MenuItem Actinon Manager
- (void)resumeScene
{
    [[CCDirector sharedDirector] resume];
    [self resumeBackgroundAudio];
    //[self playAudioWithName:oldAudioName];
}

- (void)pauseScene
{
    [self pauseBackgroundAudio];
    [self pauseAudioWithName:oldAudioName];
    [[CCDirector sharedDirector] pause];
}

- (void)gamePause
{
    [self pauseScene];
    
    PauseLayer *pauseLayer = [PauseLayer node];
    pauseLayer.delegate = self;
    pauseLayer.position = self.position;
    [self addChild:pauseLayer z:1000 tag:1000];
}

- (void)gameFinished
{
    GameManager *gameManager = [GameManager sharedManager];
    // 1、计算本关的星级等等。
    NSInteger starsNum = [gameManager starsNumberWithScore:score];
    // 2、保存本关的星级、最高得分等信息.
    if ((score > oldScore) && lessonModel) lessonModel.scoreValue = score;
    if ((starsNum > oldStarNum) && lessonModel) lessonModel.starAmountValue = starsNum;
    if (lessonModel)
    {
        lessonModel.updateTime = timeStamp();
        lessonModel.progressValue = lessonProgress;
        [lessonModel saveData];
    }
    
    // 4、判断是否解锁下一关
    LessonModel *nexLessonModel = (LessonModel *)[[GameManager sharedManager] pickOutNexLessonInfoWithUserID:curUserID humanID:curHumanID groupID:curGroupID bookID:curBookID typeID:curTypeID curLessonID:curLessonID];
    BOOL isNextLessonLocked = YES;
    
    //NSLog(@"当前课程权重: %f, ID: %d", lessonModel.lessonIndexValue, lessonModel.lessonIDValue);
    //NSLog(@"下一课程权重: %f, ID: %d", nexLessonModel.lessonIndexValue, nexLessonModel.lessonIDValue);
    
    if (nexLessonModel.lessonIndexValue >= lessonModel.lessonIndexValue)
    {
        if (starsNum >= 1 && nexLessonModel.lockedValue)
        {
            nexLessonModel.lockedValue = NO;
            [nexLessonModel saveData];
        }
        isNextLessonLocked = nexLessonModel.lockedValue;
        nextLessonID = nexLessonModel.lessonIDValue;
    }
    
    // 7、保留关卡信息
    GameLessonData *gameData = [GameLessonData sharedData];
    gameData.currentLessonID = curLessonID;
    gameData.currentlessonName = @"";
    gameData.currentLessonOldScore = oldScore;
    gameData.currentLessonScore = score;
    gameData.currentUserID = curUserID;
    gameData.currentlessonstarsNum = starsNum;
    gameData.nextLessonID = nextLessonID;
    gameData.isNextLessonLocked = isNextLessonLocked;
    
    // 9、准备退出本界面
    [self prepareToQuit];
    
    // 10、加载结算界面
    GameResultsLayer *gameResult = [GameResultsLayer node];
    gameResult.position = self.position;
    gameResult.delegate = self;
    [self addChild:gameResult z:1001 tag:1001];
    
#ifndef DLITE_VERSION
    // 11、检查本课数据是否需要更新
    [self performSelectorInBackground:@selector(checkLessonDataVersion) withObject:nil];
    //[self performSelectorInBackground:@selector(uploadLessonData) withObject:nil];
#endif
}

- (void)prepareToQuit
{
    for (CCSprite *sp in [self children]) [sp stopAllActions];
    
    [[[CCDirector sharedDirector] touchDispatcher] removeAllDelegates];
    [[CCDirector sharedDirector] resume];
    
    [self pauseAudioWithName:oldAudioName];
    [self stopBackgroundAudio];
    [self stopAllActions];
}

- (void)uploadLessonData
{
    
}

- (void)updateLessonData
{
    
}

- (void)checkLessonDataVersion
{
    @autoreleasepool
    {
        ResponseModel *response = [[DownloadLessonNet sharedInstance] getLessonDonwloadInfoWithUserID:curUserID HumanID:strHumanID GroupID:strGroupID BookID:strBookID TypeID:strTypeID LessonID:strLessonID];
        if (response.error.code != 0) return;
        
        DownloadModel *downloadModel = (DownloadModel *)response.resultInfo;
        //NSLog(@"downLoad Time: %@, lesson Time: %@", downloadModel.updateTime, lessonModel.updateTime);
        if (downloadModel.dataVersion != lessonModel.dataVersionValue)
        {
            // 先下载.
            //NSLog(@"下载");
            NSError *error;
            ResponseModel *response = [[DownloadLessonNet sharedInstance] downloadLessonInfoWithUserID:curUserID HumanID:strHumanID GroupID:strGroupID BookID:strBookID TypeID:strTypeID LessonID:strLessonID error:&error];
            
            // 下载数据且解压成功
            if ((response.error.code == 0) && (error.code == 0))
            {
                //NSLog(@"下载，更新课程数据");
                // 更新本课程的所有声调游戏知识点的数据
                [self performSelectorInBackground:@selector(updateLessonData) withObject:nil];
            }
        }
        else if (![downloadModel.updateTime isEqualToString:lessonModel.updateTime])
        {
            if (downloadModel.progress > lessonModel.progressValue)
            {
                //NSLog(@"不下载，但更新数据");
                // 更新本课程的所有声调游戏知识点的数据
                [self performSelectorInBackground:@selector(updateLessonData) withObject:nil];
            }
            else if (downloadModel.progress < lessonModel.progressValue)
            {
                //NSLog(@"上传数据");
                // 更新服务器的课程数据
                [self performSelectorInBackground:@selector(uploadLessonData) withObject:nil];
            }
        }
    }
}

#pragma mark - BackgroundMusic Manager
- (void)resumeBackgroundAudio
{
    CCLOG(@"%@ : %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    [[SimpleAudioEngine sharedEngine] resumeBackgroundMusic];
}

- (void)stopBackgroundAudio
{
    CCLOG(@"%@ : %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
}

- (void)pauseBackgroundAudio
{
    CCLOG(@"%@ : %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    [[SimpleAudioEngine sharedEngine] pauseBackgroundMusic];
}

- (void)playBackgroundAudio:(NSString *)audioName
{
    CCLOG(@"%@ : %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    if ([GlobalDataHelper sharedManager].shouldPlayBackgroundAudio)
    {
        [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:0.4f];
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:audioName];
    }
}

- (void)pauseAudioWithName:(NSString *)name
{
    if (name && ![name isEqualToString:@""])
    {
        CCLOG(@"%@ : %@ name:%@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), name);
        [[SimpleAudioEngine sharedEngine] unloadEffect:name];
    }
}

- (void)playAudioWithName:(NSString *)name
{
    if (name && ![name isEqualToString:@""])
    {
        CCLOG(@"%@ : %@ name:%@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), name);
        // 先卸载旧的音效, 以免音效播放出现混乱
        NSString *lessonAudio = [NSString stringWithFormat:@"%d", lessonModel.lessonIDValue];
        NSString *audio = [[kDownloadedPath stringByAppendingPathComponent:lessonAudio] stringByAppendingPathComponent:name];
        //NSArray *arrAudio = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:[kDownloadedPath stringByAppendingPathComponent:lessonAudio]  error:nil];
        //NSLog(@"所有的音频文件: %@", arrAudio);
        //NSLog(@"播放的音频: %@", audio);
        
        [[SimpleAudioEngine sharedEngine] unloadEffect:oldAudioName];
        [[SimpleAudioEngine sharedEngine] playEffect:audio];
        oldAudioName = audio;
    }
}

- (void)playSpriteAudioWithName:(NSString *)name
{
    if (name && ![name isEqualToString:@""])
    {
        [[SimpleAudioEngine sharedEngine] unloadEffect:oldSpriteAnimateAudioName];
        [[SimpleAudioEngine sharedEngine] playEffect:name];
        oldSpriteAnimateAudioName = name;
    }
}

#pragma mark - knowledgeLayer Delegate
- (void)knowledgeProgress:(KnowledgeProgressLayer *)layer quit:(BOOL)quit
{
    if (knowledgeLayer)
    {
        [knowledgeLayer removeFromParentAndCleanup:YES];
        knowledgeLayer = nil;
    }
    
    if (!self.touchEnabled)
    {
        [self setTouchEnabled:YES];
        [self resumeScene];
    }
}

#pragma mark - pauseLayer/gameresult Delegate
// 继续
-(void)didRecieveResumeEvent:(CCLayer *)layer
{
    [self resumeScene];
    [self removeChild:layer cleanup:YES];
    [[SimpleAudioEngine sharedEngine] playEffect:oldAudioName];
}

// 重开
-(void)didRecieveRestartEvent:(CCLayer *)layer
{
    [self prepareToQuit];
    [self removeChild:layer cleanup:YES];
}

// 返回(主导航)
- (void)didRecieveQuitEvent:(CCLayer *)layer
{
    [self prepareToQuit];
    [self removeChild:layer cleanup:YES];
}

// 进入下一关
- (void)didRecieveEnterNextLessonEvent:(GameResultsLayer *)layer
{
    [self prepareToQuit];
    [self removeChild:layer cleanup:YES];
    
    [GlobalDataHelper sharedManager].curLessonID = nextLessonID;
    //[SceneManager loadingWithGameID:[self gameSceneID]];
}

// 分数显示结束, 显示知识点进度。
- (void)didRecieveShowKnowledgeProgressEvent:(GameResultsLayer *)layer
{
    [self initKnowledgeLayer];
}

/*
- (NSString *)gameSceneID
{
    NSInteger typeID = [GlobalDataHelper sharedManager].curTypeID;
    NSString *gameSceneID = kPinyinGameSceneID;
    switch (typeID)
    {
        case 1:
        {
            gameSceneID = kPinyinGameSceneID;
            break;
        }
        case 2:
        {
            gameSceneID = kWordGameSceneID;
            break;
        }
        case 3:
        {
            gameSceneID = kSentenceGameSceneID;
            break;
        }
        case 4:
        {
            gameSceneID = kTranslateGameSceneID;
            break;
        }
        default:
            break;
    }
    return gameSceneID;
}
 */

@end
