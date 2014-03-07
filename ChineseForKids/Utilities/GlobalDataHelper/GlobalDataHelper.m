//
//  GlobalDataManager.m
//  PinyinGame
//
//  Created by yang on 13-11-11.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "GlobalDataHelper.h"

// 1、全局静态对象、并置为nil。
static GlobalDataHelper *globalData = nil;

@implementation GlobalDataHelper

// 2、构造实例
+ (GlobalDataHelper *)sharedManager
{
    @synchronized(self)
    {
        if (nil == globalData)
        {
            globalData = [[self alloc] init];
        }
    }
    return globalData;
}

// 3、重写allocwithzone，保证只有一个实例
+ (id)allocWithZone:(struct _NSZone *)zone
{
    @synchronized(self)
    {
        if (nil == globalData)
        {
            globalData = [super allocWithZone:zone];
            return globalData;
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
    self.curUserEmail = nil;
    self.curUserID = nil;
    self.curUserName = nil;
    globalData = nil;
}

@end
