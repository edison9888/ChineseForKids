//
//  LoadingScene.m
//  PinyinGame
//
//  Created by yang on 13-10-30.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "LoadingScene.h"
#import "GlobalDataHelper.h"
#import "CommonHelper.h"
#import "FileHelper.h"
#import "PreLoadDataManager.h"
#import "SimpleAudioEngine.h"
#import "SceneManager.h"
#import "PinyinNet.h"
#import "PinyinDAL.h"
#import "WordNet.h"
#import "WordDAL.h"
#import "SentenceNet.h"
#import "SentenceDAL.h"
#import "TranslateNet.h"
#import "TranslateDAL.h"
#import "LessonNet.h"
#import "DownloadLessonNet.h"

#import "ResponseModel.h"
#import "GameManager.h"

#import "Constants.h"
#import "cocos2d.h"

@implementation LoadingScene
{
    CCSpriteBatchNode *batchNode;
    CCProgressTimer *progress;
    
    CCSprite *spBackground;
    CCSprite *spProgressbg;
    CCSprite *spSketch;
    CCSprite *spLoading;
    
    NSString *curGameID;
    
    NSString *curUserID;
    NSInteger curHumanID;
    NSInteger curGroupID;
    NSInteger curBookID;
    NSInteger curTypeID;
    NSInteger curLessonID;
    
    NSString *strHumanID;
    NSString *strGroupID;
    NSString *strBookID;
    NSString *strTypeID;
    NSString *strLessonID;
    
    NSInteger assetCount;
    CGFloat progressInterval;
    
    PreLoadDataManager *preLoad;
}

+ (id)sceneWithGameID:(NSString *)gameID
{
    CCScene *scene=[CCScene node];
    LoadingScene *layer = [[LoadingScene alloc] initWithGameID:gameID];
    [scene addChild:layer];
    return scene;
}

+ (id)nodeWithGameID:(NSString *)gameID
{
    return [[self alloc] initWithGameID:gameID];
}

- (id)initWithGameID:(NSString *)gameID
{
    CCLOG(@"%@ : %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    if (self = [super init])
    {
        // 设置自身背景色
        glClearColor(117/255.0f, 210/255.0f, 241/255.0f, 255/255.0f);
        curGameID = gameID;
        
        curUserID   = [GlobalDataHelper sharedManager].curUserID;
        curHumanID  = [GlobalDataHelper sharedManager].curHumanID;
        curGroupID  = [GlobalDataHelper sharedManager].curGroupID;
        curBookID   = [GlobalDataHelper sharedManager].curBookID;
        curTypeID   = [GlobalDataHelper sharedManager].curTypeID;
        curLessonID = [GlobalDataHelper sharedManager].curLessonID;
        
        strHumanID  = [NSString stringWithFormat:@"%d", curHumanID];
        strGroupID  = [NSString stringWithFormat:@"%d", curGroupID];
        strBookID   = [NSString stringWithFormat:@"%d", curBookID];
        strTypeID   = [NSString stringWithFormat:@"%d", curTypeID];
        strLessonID = [NSString stringWithFormat:@"%d", curLessonID];
        
        [self setupBatchNode];
        [self initInterface];
        
        // 延迟一帧加载, 以便前一场景的数据完全清空, 达到避开场景切换时的内存使用高峰。
        [self scheduleUpdate];
    }
    return self;
}

- (void)update:(ccTime)delta
{
    CCLOG(@"%@ : %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    [self unscheduleUpdate];
    
    preLoad = [[PreLoadDataManager alloc] init];
    NSDictionary *manifest = [preLoad preLoadDataWithGameID:curGameID];
    
    NSArray *spriteSheets = [manifest objectForKey:kPreSpriteSheets];
    NSArray *images       = [manifest objectForKey:kPreImages];
    NSArray *soundFX      = [manifest objectForKey:kPreSoundFX];
    NSArray *music        = [manifest objectForKey:kPreMusic];
    NSArray *assets       = [manifest objectForKey:kPreAssets];
    
    assetCount = ([spriteSheets count] + [images count] + [soundFX count] + [music count] + [assets count]);
    
    if (assetCount <= 0)
    {
        [self progressUpdate];
        return;
    }
    
    progressInterval = 100.0 / (float) assetCount;
    
    if (soundFX) [self performSelectorOnMainThread:@selector(loadSounds:) withObject:soundFX waitUntilDone:YES];
    
    if (spriteSheets) [self performSelectorOnMainThread:@selector(loadSpriteSheets:) withObject:spriteSheets waitUntilDone:YES];
    
    if (images) [self performSelectorOnMainThread:@selector(loadImages:) withObject:images waitUntilDone:YES];
    
    if (music) [self performSelectorOnMainThread:@selector(loadMusic:) withObject:music waitUntilDone:YES];
    
    if (assets) [self performSelectorOnMainThread:@selector(loadAssets:) withObject:assets waitUntilDone:YES];
}

- (void)onEnter
{
    [super onEnter];
}

- (void)onExit
{
    [super onExit];
}

- (void)setupBatchNode
{
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"LoadingAnimation.plist"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"LoadingTypeAnimation.plist"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"LoadingTypeBkg.plist"];
    /*
    if ([curGameID isEqualToString:kGameTypeSceneID])
    {
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"LoadingTypeAnimation.plist"];
    }
    
    if ([curGameID isEqualToString:kGameTypeSceneID])
    {
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"LoadingTypeBkg.plist"];
    }
    else if ((4 == curTypeID && [curGameID isEqualToString:kCommonNavigationSceneID]) || [curGameID isEqualToString:kTranslateGameSceneID])
    {
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"LoadingTransBkg.plist"];
    }
    else if ((2 == curTypeID && [curGameID isEqualToString:kCommonNavigationSceneID]) || [curGameID isEqualToString:kWordGameSceneID])
    {
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"LoadingWordBkg.plist"];
    }
    else if ((3 == curTypeID && [curGameID isEqualToString:kCommonNavigationSceneID]) || [curGameID isEqualToString:kSentenceGameSceneID])
    {
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"LoadingSentenceBkg.plist"];
    }
    else
    {
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"LoadingBackground.plist"];
    }
     */
}

-(void) initInterface
{
    // background
    spBackground = [CCSprite spriteWithSpriteFrameName:@"loadingBkg.png"];
    spBackground.position = ccp(self.boundingBox.size.width*0.5f, self.boundingBox.size.height*0.5f);
    [self addChild:spBackground z:-1];

    
    //CGPoint skPosition = [curGameID isEqualToString:kGameTypeSceneID] ? ccp(self.boundingBox.size.width*0.5f, self.boundingBox.size.height*0.5f): ccp(self.boundingBox.size.width*0.72f, self.boundingBox.size.height*0.12f);
    spSketch = [CCSprite spriteWithSpriteFrameName:@"ldSketchRun1.png"];
    spSketch.position = ccp(self.boundingBox.size.width*0.5f, self.boundingBox.size.height*0.5f);
    [self addChild:spSketch z:2];
    [self sketchRun];
    /*
    spLoading = [CCSprite spriteWithSpriteFrameName:@"loading.png"];
    spLoading.position = ccp(self.boundingBox.size.width*0.88f, self.boundingBox.size.height*0.06f);
    [self addChild:spLoading z:2];
    [self loadingBreath];
    */
    // 进度条背景
    spProgressbg = [CCSprite spriteWithSpriteFrameName:@"progressBkg.png"];
    spProgressbg.position = ccpAdd(ccp(self.boundingBox.size.width*0.5f, self.boundingBox.size.height*0.5f), ccp(0.0f, -60.0f));
    spProgressbg.visible = [curGameID isEqualToString:kGameTypeSceneID] ? YES : YES;
    [self addChild:spProgressbg];
    
    // 时间进度条
    progress = [CCProgressTimer progressWithSprite:[CCSprite spriteWithSpriteFrameName:@"progress.png"]];//[CCProgressTimer node];
    [progress setPercentage:0.0f];
    progress.midpoint = ccp(0,0);
    progress.barChangeRate = ccp(1,0);
    progress.type = kCCProgressTimerTypeBar;
    progress.position = spProgressbg.position;
    progress.visible = [curGameID isEqualToString:kGameTypeSceneID] ? YES : YES;
    [self addChild:progress];
}

#pragma mark - Animation Manager
- (void)sketchRun
{
    NSMutableArray *arrAnimation=[NSMutableArray arrayWithCapacity:6];
    for(int i = 1; i <= 8; i++)
    {
        NSString *frameName = [NSString stringWithFormat:@"ldSketchRun%d.png", i];
        CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName];
        [arrAnimation addObject:frame];
    }
    
    CCAnimation *animation = [CCAnimation animationWithSpriteFrames:arrAnimation delay:0.083];
    if (spSketch)
    {
        [spSketch runAction:[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:animation]]];
    }
}

// 会呼吸的loading
- (void)loadingBreath
{
    CCScaleTo *scaleBig = [CCScaleTo actionWithDuration:0.3f scale:1.05f];
    CCScaleTo *scaleBack = [CCScaleTo actionWithDuration:0.3f scale:1.0f];
    CCScaleTo *scaleSmall = [CCScaleTo actionWithDuration:0.3f scale:0.95f];
    
    CCSequence *seq = [CCSequence actions:scaleBig, scaleBack, scaleSmall, scaleBack, nil];
    [spLoading runAction:[CCRepeatForever actionWithAction:seq]];
}

#pragma mark - PreLoad Manager
- (void)loadMusic:(NSArray *) musicFiles
{
    for (NSString *music in musicFiles)
    {
        [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:music];
        [self progressUpdate];
    }
}

- (void)loadSounds:(NSArray *)soundClips
{
    for (NSString *soundClip in soundClips)
    {
        [[SimpleAudioEngine sharedEngine] preloadEffect:soundClip];
        [self progressUpdate];
    }
}

- (void)loadSpriteSheets:(NSArray *) spriteSheets
{
    for (NSString *spriteSheet in spriteSheets)
    {
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:spriteSheet];
        [self progressUpdate];
    }
}

- (void)loadImages:(NSArray *) images
{
    for (NSString *image in images)
    {
        [[CCTextureCache sharedTextureCache] addImage:image];
        [self progressUpdate];
    }
}

- (void)loadAssets:(NSArray *) assets
{
    for (NSString *asset in assets)
    {
        [self progressUpdate];
    }
}

- (void)progressUpdate
{
    //CCLOG(@"assetCount:%d", assetCount);
    if (--assetCount > 0)
    {
        CCProgressFromTo *ac = [CCProgressFromTo actionWithDuration:0.2 from:progress.percentage to:100.0f - (progressInterval * assetCount)];
        [progress runAction:ac];
    }
    else
    {
        
        CCProgressFromTo *ac = [CCProgressFromTo actionWithDuration:0.2 from:progress.percentage to:100];
        
        //CCCallFunc *callback = [CCCallFunc actionWithTarget:self selector:@selector(loadingComplete)];
        
        id action = [CCSequence actions:ac, nil];
        [progress runAction:action];
        
        [self performSelector:@selector(loadingComplete) withObject:nil afterDelay:0.2f];
        //[self loadingComplete];
    }
}
/*
- (void)progressUpdate
{
    CCLOG(@"assetCount:%d", assetCount);
    if (--assetCount <= 0)
    {
        [self loadingComplete];
    }
    
}
 */

- (void)loadingComplete
{    
    if ([curGameID isEqualToString:kGameTypeSceneID])
    {
        [SceneManager goGameTypeScene];
    }
    else if ([curGameID isEqualToString:kPinyinNavigationSceneID])
    {
        [SceneManager goPinyinNavigationScene];
    }
    else if ([curGameID isEqualToString:kWordNavigationSceneID])
    {
        [SceneManager goWordNavigationScene];
    }
    else if ([curGameID isEqualToString:kSentenceNavigationSceneID])
    {
        [SceneManager goSentenceNavigationScene];
    }
    else if ([curGameID isEqualToString:kTranslateNavigationSceneID])
    {
        [SceneManager goTranslateNavigationScene];
    }
    else if ([curGameID isEqualToString:kCommonNavigationSceneID])
    {
#ifdef DLITE_VERSION
        [SceneManager goCommonNavigationScene];
#else
        if ([self loadCommonNavigationNetworkData])
        {
            [SceneManager goCommonNavigationScene];
        }
        else
        {
            // 显示网络错误信息
            [CommonHelper makeToastWithMessage:NSLocalizedString(@"获取数据出错!", @"") view:[[CCDirector sharedDirector] view]];
            // 返回种类选择界面
            [SceneManager loadingWithGameID:kGameTypeSceneID];
        }
#endif
        
    }
    else
    {
        // 加载数据
        if ([curGameID isEqualToString:kPinyinGameSceneID])
        {
            NSString *pinyinID = [NSString stringWithFormat:@"%d", curLessonID];
#ifdef DLITE_VERSION
            [[PinyinDAL sharedInstance] loadPinyinDataWithUserID:curUserID humanID:curHumanID groupID:curGroupID bookID:curBookID typeID:curTypeID lessonID:curLessonID];
            
            // 跳转到拼音游戏界面
            [SceneManager goPinyinLessonSceneWithID:pinyinID];
        
#else
            if ([self loadPinyinLessonNetworkData])
            {
                // 跳转到拼音游戏界面
                [SceneManager goPinyinLessonSceneWithID:pinyinID];
            }
            else
            {
                // 显示网络错误信息
                [CommonHelper makeToastWithMessage:NSLocalizedString(@"获取数据出错!", @"") view:[[CCDirector sharedDirector] view]];
                // 返回种类选择界面
                [SceneManager loadingWithGameID:kCommonNavigationSceneID];
            }
#endif
        }
        else if ([curGameID isEqualToString:kWordGameSceneID])
        {
            
            NSString *wordID = [NSString stringWithFormat:@"%d", curLessonID];
            
#ifdef DLITE_VERSION
            [[WordDAL sharedInstance] loadWordDataWithUserID:curUserID humanID:curHumanID groupID:curGroupID bookID:curBookID typeID:curTypeID lessonID:curLessonID];
            
            // 跳转到擦图猜字游戏界面
            [SceneManager goWordLessonSceneWithID:wordID];
#else
            if ([self loadWordLessonNetworkData])
            {
                [SceneManager goWordLessonSceneWithID:wordID];
            }
            else
            {
                // 显示网络错误信息
                [CommonHelper makeToastWithMessage:NSLocalizedString(@"获取数据出错!", @"") view:[[CCDirector sharedDirector] view]];
                // 返回种类选择界面
                [SceneManager loadingWithGameID:kCommonNavigationSceneID];
            }
#endif
        }
        else if ([curGameID isEqualToString:kSentenceGameSceneID])
        {
            NSString *senPatternID = [NSString stringWithFormat:@"%d", curLessonID];
            
#ifdef DLITE_VERSION
            [[SentenceDAL sharedInstance] loadSentenceDataWithUserID:curUserID humanID:curHumanID groupID:curGroupID bookID:curBookID typeID:curTypeID lessonID:curLessonID];
            
            [SceneManager goSentenceLessonSceneWithID:senPatternID];
#else
            if ([self loadSentenceLessonNetworkData])
            {
                [SceneManager goSentenceLessonSceneWithID:senPatternID];
            }
            else
            {
                // 显示网络错误信息
                [CommonHelper makeToastWithMessage:NSLocalizedString(@"获取数据出错!", @"") view:[[CCDirector sharedDirector] view]];
                // 返回种类选择界面
                [SceneManager loadingWithGameID:kCommonNavigationSceneID];
            }
#endif
        }
        else if ([curGameID isEqualToString:kTranslateGameSceneID])
        {
            NSString *translateID = [NSString stringWithFormat:@"%d", curLessonID];
#ifdef DLITE_VERSION
            [[TranslateDAL sharedInstance] loadTranslateDataWithUserID:curUserID humanID:curHumanID groupID:curGroupID bookID:curBookID typeID:curTypeID lessonID:curLessonID];
            
            [SceneManager goTranslateLessonSceneWithID:translateID];
#else
            if ([self loadTranslateLessonNetworkData])
            {
                [SceneManager goTranslateLessonSceneWithID:translateID];
            }
            else
            {
                // 显示网络错误信息
                [CommonHelper makeToastWithMessage:NSLocalizedString(@"获取数据出错!", @"") view:[[CCDirector sharedDirector] view]];
                // 返回种类选择界面
                [SceneManager loadingWithGameID:kCommonNavigationSceneID];
            }
#endif
        }
    }
}

- (BOOL)loadCommonNavigationNetworkData
{
    BOOL success = NO;
    NSArray *arrTLesson = [[GameManager sharedManager] loadLessonDataWithUserID:curUserID humanID:curHumanID groupID:curGroupID bookID:curBookID typeID:curTypeID];
    
    if (arrTLesson && ([arrTLesson count] > 0))
    {
        success = YES;
    }
    else
    {
        ResponseModel *response = [LessonNet getLessonsInfoWithUserID:curUserID HumanID:strHumanID GroupID:strGroupID BookID:strBookID TypeID:strTypeID];
        if (response.error.code == 0)
        {
            success = YES;
        }
    }
    return success;
}

// 是否有下载文件的提示文件路径
- (NSString *)downloadDataTipPath
{
    NSString *downloadDir = [kDownloadedPath stringByAppendingPathComponent:strLessonID];
    NSString *tipFile = [NSString stringWithFormat:@"%@_%@.txt", strTypeID, strLessonID];
    NSString *tipPath = [downloadDir stringByAppendingPathComponent:tipFile];
    return tipPath;
}

- (BOOL)loadPinyinLessonNetworkData
{
    BOOL success = NO;
    NSString *tipPath = [self downloadDataTipPath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:tipPath])
    {
        NSArray *arrTPinyin = [[GameManager sharedManager] loadPinyinDataWithUserID:curUserID humanID:curHumanID groupID:curGroupID bookID:curBookID typeID:curTypeID lessonID:curLessonID];
        
        if (arrTPinyin && ([arrTPinyin count] > 0)){
            success = YES;
        }else{
            success = [self downloadPinyinLessonData];
        }
    }
    else
    {
        success = [self downloadPinyinLessonData];
    }
    return success;
}

- (BOOL)downloadPinyinLessonData
{
    BOOL success = NO;
    ResponseModel *response = [PinyinNet getPinyinGameInfoWithUserID:curUserID HumanID:strHumanID GroupID:strGroupID BookID:strBookID TypeID:strTypeID LessonID:strLessonID];
    
    if (response.error.code == 0){
        success = [self downloadLessonSource];
    }
    return success;
}

- (BOOL)loadWordLessonNetworkData
{
    BOOL success = NO;
    NSString *tipPath = [self downloadDataTipPath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:tipPath])
    {
        NSArray *arrTWord = [[GameManager sharedManager] loadWordDataWithUserID:curUserID humanID:curHumanID groupID:curGroupID bookID:curBookID typeID:curTypeID lessonID:curLessonID];
        
        if (arrTWord && ([arrTWord count] > 0)){
            success = YES;
        }else{
            success = [self downloadWordLessonData];
        }
    }
    else
    {
        success = [self downloadWordLessonData];
    }
    
    return success;
}

- (BOOL)downloadWordLessonData
{
    BOOL success = NO;
    ResponseModel *response = [WordNet getWordGameInfoWithUserID:curUserID HumanID:strHumanID GroupID:strGroupID BookID:strBookID TypeID:strTypeID LessonID:strLessonID];
    
    if (response.error.code == 0){
        success = [self downloadLessonSource];
    }
    return success;
}

- (BOOL)loadSentenceLessonNetworkData
{
    BOOL success = NO;
    NSString *tipPath = [self downloadDataTipPath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:tipPath])
    {
        NSArray *arrTSen = [[GameManager sharedManager] loadSentencePatternDataWithUserID:curUserID humanID:curHumanID groupID:curGroupID bookID:curBookID typeID:curTypeID lessonID:curLessonID];
        
        if (arrTSen && ([arrTSen count] > 0)){
            success = YES;
        }else{
            success = [self downloadSentenceLessonData];
        }
    }
    else
    {
        success = [self downloadSentenceLessonData];
    }
    
    return success;
}

- (BOOL)downloadSentenceLessonData
{
    BOOL success = NO;
    ResponseModel *response = [SentenceNet getSentenceGameInfoWithUserID:curUserID HumanID:strHumanID GroupID:strGroupID BookID:strBookID TypeID:strTypeID LessonID:strLessonID];
    
    if (response.error.code == 0){
        success = [self downloadLessonSource];
    }
    return success;
}

- (BOOL)loadTranslateLessonNetworkData
{
    BOOL success = NO;
    NSString *tipPath = [self downloadDataTipPath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:tipPath])
    {
        NSArray *arrTTrans = [[GameManager sharedManager] loadTranslationDataWithUserID:curUserID humanID:curHumanID groupID:curGroupID bookID:curBookID typeID:curTypeID lessonID:curLessonID];
        
        if (arrTTrans && ([arrTTrans count] > 0)){
            success = YES;
        }else{
            success = [self downloadTranslateLessonData];
        }
    }
    else
    {
        success = [self downloadTranslateLessonData];
    }
    
    return success;
}

- (BOOL)downloadTranslateLessonData
{
    BOOL success = NO;
    ResponseModel *response = [TranslateNet getTranslationGameInfoWithUserID:curUserID HumanID:strHumanID GroupID:strGroupID BookID:strBookID TypeID:strTypeID LessonID:strLessonID];
    
    if (response.error.code == 0){
        success = [self downloadLessonSource];
    }
    return success;
}

- (BOOL)downloadLessonSource
{
    BOOL success = NO;
    NSError *error;
    // 下载资源文件
    ResponseModel *response = [[DownloadLessonNet sharedInstance] downloadLessonInfoWithUserID:curUserID HumanID:strHumanID GroupID:strGroupID BookID:strBookID TypeID:strTypeID LessonID:strLessonID error:&error];
    if (response.error.code == 0)
    {
        if (error.code == 0)
        {
            // 下载成功
            success = YES;
        }
    }
    return success;
}

#pragma mark - Memory Manager

- (void)dealloc
{
    CCLOG(@"%@ : %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    [[self class] cancelPreviousPerformRequestsWithTarget:self];
    [batchNode removeAllChildrenWithCleanup:YES];
    [batchNode removeFromParentAndCleanup:YES];
    batchNode = nil;
    
    [spBackground removeFromParentAndCleanup:YES];
    spBackground = nil;
    
    [spProgressbg removeFromParentAndCleanup:YES];
    spProgressbg = nil;
    
    [progress removeFromParentAndCleanup:YES];
    progress = nil;
    
    [spLoading removeFromParentAndCleanup:YES];
    spLoading = nil;
    
    [spSketch removeFromParentAndCleanup:YES];
    spSketch = nil;
    
    preLoad = nil;
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:@"LoadingAnimation.plist"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:@"LoadingTypeAnimation.plist"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:@"LoadingBackground.plist"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:@"LoadingTypeBkg.plist"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:@"LoadingTransBkg.plist"];
    // 移除纹理, 来降低内存。
    
    [[CCTextureCache sharedTextureCache] removeTextureForKey:@"progress.png"];
    [[CCTextureCache sharedTextureCache] removeTextureForKey:@"loading.png"];
    [[CCTextureCache sharedTextureCache] removeTextureForKey:@"ldSketchRun1.png"];
    [[CCTextureCache sharedTextureCache] removeTextureForKey:@"loadingBkg.png"];
}

@end
