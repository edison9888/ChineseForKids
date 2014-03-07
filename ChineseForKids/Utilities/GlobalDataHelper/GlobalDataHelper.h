//
//  GlobalDataHelper.h
//  PinyinGame
//
//  Created by yang on 13-11-11.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 全局数据管理类, 管理一些全局要用到的数据, 比如当前用的UserID, UserEmail等.
 */
@interface GlobalDataHelper : NSObject

@property (nonatomic, copy)NSString *curUserID;
@property (nonatomic, copy)NSString *curUserEmail;
@property (nonatomic, copy)NSString *curUserName;
@property (nonatomic, readwrite)NSInteger curHumanID;
@property (nonatomic, readwrite)NSInteger curGroupID;
@property (nonatomic, readwrite)NSInteger curBookID;
@property (nonatomic, readwrite)NSInteger curTypeID;
@property (nonatomic, readwrite)NSInteger curLessonID;
@property (nonatomic, readwrite)BOOL shouldPlayBackgroundAudio;

+ (GlobalDataHelper *)sharedManager;

@end
