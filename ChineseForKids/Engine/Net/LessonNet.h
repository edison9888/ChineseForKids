//
//  LessonNet.h
//  ChineseForKids
//
//  Created by yang on 13-12-10.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LessonNet : NSObject

+ (id)getLessonsInfoWithUserID:(NSString *)userID HumanID:(NSString *)humanID GroupID:(NSString *)groupID BookID:(NSString *)bookID TypeID:(NSString *)typeID;

+ (void)cancelRequest;

+ (BOOL)isRequestCanceled;

@end
