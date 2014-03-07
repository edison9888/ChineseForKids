//
//  LessonScene.h
//  ChineseForKids
//
//  Created by yang on 13-12-13.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "CCLayer.h"
#import "CCLabelTTF.h"

@class LessonModel;
@class KnowledgeProgressLayer;

@interface LessonScene : CCLayerColor
{
    NSString *curUserID;
    NSInteger curLessonID;
    NSInteger nextLessonID;
    NSInteger curHumanID;
    NSInteger curGroupID;
    NSInteger curBookID;
    NSInteger curTypeID;
    
    NSString *strHumanID;
    NSString *strGroupID;
    NSString *strBookID;
    NSString *strTypeID;
    NSString *strLessonID;
    // 分数
    NSInteger score;
    NSInteger oldScore;
    // 星星
    NSInteger oldStarNum;
    // 连对数
    NSInteger keepRightNum;
    // 课程进度
    CGFloat lessonProgress;
    
    // 旧的音效文件, 在新的音效文件播放的时候, 将旧的卸载
    NSString *oldAudioName;
    NSString *oldSpriteAnimateAudioName;
    
    // 当前得分
    CCLabelTTF *lblScTitle;
    CCLabelTTF *lblScore;
    
    // 历史最高得分
    CCLabelTTF *lblHScTitle;
    CCLabelTTF *lblHScore;
    
    // 当前关卡数据模型
    LessonModel *lessonModel;
    
    // 知识点学习
    KnowledgeProgressLayer *knowledgeLayer;
}

- (void)initLessonModel;

- (void)initKnowledgeLayer;

- (void)showScoreWithPosition:(CGPoint)position Color:(ccColor3B)ccColor;

- (void)updateHighScore;

- (void)uploadLessonData;
- (void)updateLessonData;

#pragma mark - MenuItem Actinon Manager
- (void)resumeScene;

- (void)pauseScene;

- (void)gamePause;

- (void)gameFinished;

- (void)prepareToQuit;

#pragma mark - BackgroundMusic Manager
- (void)resumeBackgroundAudio;

- (void)stopBackgroundAudio;

- (void)pauseBackgroundAudio;

- (void)playBackgroundAudio:(NSString *)audioName;

- (void)pauseAudioWithName:(NSString *)name;

- (void)playAudioWithName:(NSString *)name;

- (void)playSpriteAudioWithName:(NSString *)name;

#pragma mark - pauseLayer/gameresult Delegate
// 继续
-(void)didRecieveResumeEvent:(CCLayer *)layer;

// 重开
-(void)didRecieveRestartEvent:(CCLayer *)layer;

// 返回(主导航)
- (void)didRecieveQuitEvent:(CCLayer *)layer;

// 进入下一关
- (void)didRecieveEnterNextLessonEvent:(CCLayer *)layer;

// 分数显示结束, 显示知识点进度。
- (void)didRecieveShowKnowledgeProgressEvent:(CCLayer *)layer;

@end
