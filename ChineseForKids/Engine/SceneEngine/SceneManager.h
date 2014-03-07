//
//  SceneManager.h
//  PinyinGame
//
//  Created by yang on 13-10-30.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SceneManager : NSObject

/**
 * 由于在本游戏中只存在一关一关的游戏,那么这里的gameID和关卡的levelID是一致的。
 * 如果以后游戏中存在其他形式的赠送类游戏或者要跳到其他scene(也可以是非关卡场景)那么就需要其他scene的gameID了。
 *
 */
+ (void)loadingWithGameID:(NSString *)gameID;

/**
 * 登陆场景（包含注册）。
 */
+ (void)goLoginScene;

/**
 *  各套教程
 */
+ (void)goGroupScene;

/**
 *  游戏类型选择: 1: 声调; 2: 猜字; 3: 连词; 4: 中英
 */
+ (void)goGameTypeScene;

/**
 *  拼音游戏的导航场景
 */
+ (void)goPinyinNavigationScene;

/**
 *  擦图猜字游戏的导航场景
 */
+ (void)goWordNavigationScene;

/**
 *  连词成句游戏的导航场景
 */
+ (void)goSentenceNavigationScene;

/**
 *  中英互译游戏的导航场景
 */
+ (void)goTranslateNavigationScene;

/**
 *  通用的游戏导航场景
 */
+ (void)goCommonNavigationScene;

/**
 *  拼音游戏课程的场景
 *
 *  @param lessonID 课程ID
 */
+ (void)goPinyinLessonSceneWithID:(NSString *)lessonID;

/**
 *  擦图猜字游戏的场景
 *
 *  @param lessonID 课程ID
 */
+ (void)goWordLessonSceneWithID:(NSString *)lessonID;

/**
 *  连词成句游戏的场景
 *
 *  @param lessonID 课程ID
 */
+ (void)goSentenceLessonSceneWithID:(NSString *)lessonID;

/**
 *  中英互译游戏的场景
 *
 *  @param lessonID 课程ID
 */
+ (void)goTranslateLessonSceneWithID:(NSString *)lessonID;

@end
