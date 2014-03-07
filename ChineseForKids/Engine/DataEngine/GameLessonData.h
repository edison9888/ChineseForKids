//
//  GameLessonData.h
//  ChineseForKids
//
//  Created by yang on 13-12-10.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameLessonData : NSObject

// 当前关卡是否刷新了最高分
@property(nonatomic, readonly)BOOL isNewHighScore;
// 当前关卡最高分
@property(nonatomic, readonly)NSInteger currentLessonHighScore;
// 当前关卡的历史分数
@property(nonatomic, readwrite)NSInteger currentLessonOldScore;
// 当前关卡的当前分数
@property(nonatomic, readwrite)NSInteger currentLessonScore;
// 当前关卡的星星数
@property(nonatomic, readwrite)NSInteger currentlessonstarsNum;
// 下一关ID
@property(nonatomic, readwrite)NSInteger nextLessonID;
// 下一关是否解锁
@property(nonatomic, readwrite)BOOL isNextLessonLocked;
// 当前关卡的ID
@property(nonatomic, readwrite)NSInteger currentLessonID;
// 当前关卡的名称
@property(nonatomic, copy)NSString *currentlessonName;
// 当前关卡所属的用户
@property(nonatomic, copy)NSString *currentUserID;

+ (GameLessonData *)sharedData;

@end
