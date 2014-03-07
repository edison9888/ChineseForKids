//
//  PinyinNet.h
//  ChineseForKids
//
//  Created by yang on 13-12-10.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PinyinNet : NSObject

+ (id)getPinyinGameInfoWithUserID:(NSString *)userID HumanID:(NSString *)humanID GroupID:(NSString *)groupID BookID:(NSString *)bookID TypeID:(NSString *)typeID LessonID:(NSString *)lessonID;

+ (void)cancelRequest;

+ (BOOL)isRequestCanceled;

@end
