//
//  WordNet.h
//  ChineseForKids
//
//  Created by yang on 13-12-12.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WordNet : NSObject

+ (id)getWordGameInfoWithUserID:(NSString *)userID HumanID:(NSString *)humanID GroupID:(NSString *)groupID BookID:(NSString *)bookID TypeID:(NSString *)typeID LessonID:(NSString *)lessonID;

+ (void)cancelRequest;

+ (BOOL)isRequestCanceled;

@end
