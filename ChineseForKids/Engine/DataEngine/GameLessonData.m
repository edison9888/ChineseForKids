//
//  GameLessonData.m
//  ChineseForKids
//
//  Created by yang on 13-12-10.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "GameLessonData.h"

// 1、全局静态对象、并置为nil。
static GameLessonData *gameLessonData = nil;

@implementation GameLessonData

@synthesize isNewHighScore = _isNewHighScore;
@synthesize currentLessonHighScore = _currentLessonHighScore;

// 2、构造实例
+(GameLessonData *)sharedData
{
    @synchronized(self)
    {
        if (nil == gameLessonData)
        {
            gameLessonData = [[self alloc] init];
        }
    }
    return gameLessonData;
}

// 3、重写allocwithzone，保证只有一个实例
+ (id)allocWithZone:(struct _NSZone *)zone
{
    @synchronized(self)
    {
        if (nil == gameLessonData)
        {
            gameLessonData = [super allocWithZone:zone];
            return gameLessonData;
        }
    }
    return nil;
}

// 4、重写copywithzone
- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)init
{
    @synchronized(self)
    {
        self = [super init];
        
        return self;
    }
}

#pragma mark - Memory Manager

- (void)dealloc
{
    self.currentlessonName = nil;
    self.currentLessonID   = nil;
}

#pragma mark Get Function Manager

- (BOOL)isNewHighScore
{
    _isNewHighScore = _currentLessonScore > _currentLessonOldScore ? YES : NO;
    return _isNewHighScore;
}

- (NSInteger)currentLessonHighScore
{
    _currentLessonHighScore = _currentLessonScore > _currentLessonOldScore ? _currentLessonScore : _currentLessonOldScore;
    return _currentLessonHighScore;
}

@end
