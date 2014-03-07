//
//  SceneManager.m
//  PinyinGame
//
//  Created by yang on 13-10-30.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "SceneManager.h"
#import "cocos2d.h"
#import "LoadingScene.h"
#import "LoginScene.h"
#import "GameLibraryScene.h"
#import "GameTypeScene.h"
#import "PinyinNavigationScene.h"
#import "WordNavigationScene.h"
#import "SentenceNavigationScene.h"
#import "TranslateNavigationScene.h"
#import "GameNavigationScene.h"

#import "PinyinLessonScene.h"
#import "WordLessonScene.h"
#import "SentenceLessonScene.h"
#import "TranslationLessonScene.h"

@interface SceneManager()

+ (void)go:(CCLayer *)layer;
+ (CCScene *)wrap:(CCLayer *)layer;

@end

@implementation SceneManager

#pragma mark - Loading
+ (void)loadingWithGameID:(NSString *)gameID
{
    [SceneManager go:[LoadingScene nodeWithGameID:gameID]];
}

+ (void)goLoginScene
{
    [SceneManager go:[LoginScene node]];
}

+ (void)goGroupScene
{
    [SceneManager go:[GameLibraryScene node]];
}

+ (void)goGameTypeScene
{
    [SceneManager go:[GameTypeScene node]];
}

+ (void)goPinyinNavigationScene
{
    [SceneManager go:[PinyinNavigationScene node]];
}

+ (void)goWordNavigationScene
{
    [SceneManager go:[WordNavigationScene node]];
}

+ (void)goSentenceNavigationScene
{
    [SceneManager go:[SentenceNavigationScene node]];
}

+ (void)goTranslateNavigationScene
{
    [SceneManager go:[TranslateNavigationScene node]];
}

+ (void)goCommonNavigationScene
{
    [SceneManager go:[GameNavigationScene node]];
}

+ (void)goPinyinLessonSceneWithID:(NSString *)lessonID
{
    [SceneManager go:[PinyinLessonScene nodeWithLessonID:lessonID]];
}

+ (void)goWordLessonSceneWithID:(NSString *)lessonID
{
    [SceneManager go:[WordLessonScene nodeWithLessonID:lessonID]];
}

+ (void)goSentenceLessonSceneWithID:(NSString *)lessonID
{
    [SceneManager go:[SentenceLessonScene nodeWithLessonID:lessonID]];
}

+ (void)goTranslateLessonSceneWithID:(NSString *)lessonID
{
    [SceneManager go:[TranslationLessonScene nodeWithLessonID:lessonID]];
}

#pragma mark - Go distination scene
+ (void)go:(CCLayer *)layer
{
    CCDirector *director=[CCDirector sharedDirector];
    CCScene *newScene=[SceneManager wrap:layer];
    
    if([director runningScene])
    {
        [director replaceScene:newScene];
    }
    else
    {
        [director runWithScene:newScene];
    }
}

+ (CCScene *)wrap:(CCLayer *)layer
{
    CCScene *newScene=[CCScene node];
    [newScene addChild:layer];
    return newScene;
}

@end
