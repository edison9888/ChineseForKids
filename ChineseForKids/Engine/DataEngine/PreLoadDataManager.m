//
//  PreLoadDataManager.m
//  PinyinGame
//
//  Created by yang on 13-10-30.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "PreLoadDataManager.h"
#import "cocos2d.h"
#import "Constants.h"

@implementation PreLoadDataManager
{
    NSString *preLoadFileName;
}

- (id)makeExecuteWithGameID:(NSString *)gameID
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         @"gameTypeScenePreLoadFile",            kGameTypeSceneID,
                         @"pinyinNavigationScenePreloadFile",    kPinyinNavigationSceneID,
                         @"wordNavigationScenePreloadFile",      kWordNavigationSceneID,
                         @"sentenceNavigationScenePreloadFile",  kSentenceNavigationSceneID,
                         @"translateNavigationScenePreloadFile", kTranslateNavigationSceneID,
                         @"commonNavigationScenePreloadFile",    kCommonNavigationSceneID,
                         @"pinyinGameScenePreloadFile",          kPinyinGameSceneID,
                         @"wordGameScenePreloadFile",            kWordGameSceneID,
                         @"sentenceGameScenePreloadFile",        kSentenceGameSceneID,
                         @"translateGameScenePreloadFile",       kTranslateGameSceneID,
                         nil];
    
    return [dic objectForKey:gameID];
}

- (void)AnalysisExecuteWithGameID:(NSString *)gameID error:(NSError *)err
{
    SEL execute;
    NSString *executeName = [self makeExecuteWithGameID:gameID];
    execute = NSSelectorFromString([NSString stringWithFormat:@"%@", executeName]);
    //executeName = @selector(loginActionWithInputInfo:);
    @try
    {
        if ([self respondsToSelector:execute])
        {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [self performSelector:execute withObject:nil];
#pragma clang diagnostic pop
        }
    }
    @catch (NSException *exception)
    {
        NSLog(@"=============在网络调用的控制模块动态调用方法时出错=============\n");
        NSLog(@"出错信息:");
        NSLog(@"错误名称(e_name):%@", exception.name);
        NSLog(@"错误原因(e_resion):%@", exception.reason);
        NSLog(@"出错的函数(executeName):%@", executeName);
    }
}

- (NSString *)preLoadDataFileNameWithGameID:(NSString *)gameID
{
    [self AnalysisExecuteWithGameID:gameID error:nil];
    return preLoadFileName;
}

- (NSDictionary *)preLoadDataWithGameID:(NSString *)gameID
{
    [self AnalysisExecuteWithGameID:gameID error:nil];
    NSString *path = [[CCFileUtils sharedFileUtils] fullPathFromRelativePath:preLoadFileName];
    NSDictionary *manifest = [NSDictionary dictionaryWithContentsOfFile:path];
    return manifest;
}

#pragma mark - Level PreloadDeal Manager
- (void)gameTypeScenePreLoadFile
{
    preLoadFileName = @"preloadTypeScene.plist";
}

- (void)pinyinNavigationScenePreloadFile
{
    preLoadFileName = @"preloadPinyinNavigationMap.plist";
}

- (void)wordNavigationScenePreloadFile
{
    preLoadFileName = @"preloadWordNavigationMap.plist";
}

- (void)sentenceNavigationScenePreloadFile
{
    preLoadFileName = @"preloadSentenceNavigationMap.plist";
}

- (void)translateNavigationScenePreloadFile
{
    preLoadFileName = @"preloadTranslateNavigationMap.plist";
}

- (void)commonNavigationScenePreloadFile
{
    preLoadFileName = @"preloadCommonNavigationMap.plist";
}

- (void)pinyinGameScenePreloadFile
{
    preLoadFileName = @"preloadPinyinLessonScene.plist";
}

- (void)wordGameScenePreloadFile
{
    preLoadFileName = @"preloadWordLessonScene.plist";
}

- (void)sentenceGameScenePreloadFile
{
    preLoadFileName = @"preloadSentenceLessonScene.plist";
}

- (void)translateGameScenePreloadFile
{
    preLoadFileName = @"preloadTranslateLessonScene.plist";
}

#pragma mark - Memory Manager
- (void)dealloc
{
    // 取消全部的performSelector执行的方法。
    //[[self class] cancelPreviousPerformRequestsWithTarget:self];
    preLoadFileName = nil;
}

@end
