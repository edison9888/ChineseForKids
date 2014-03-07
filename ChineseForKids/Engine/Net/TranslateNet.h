//
//  TranslateNet.h
//  ChineseForKids
//
//  Created by yang on 13-12-13.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TranslateNet : NSObject

+ (id)getTranslationGameInfoWithUserID:(NSString *)userID HumanID:(NSString *)humanID GroupID:(NSString *)groupID BookID:(NSString *)bookID TypeID:(NSString *)typeID LessonID:(NSString *)lessonID;

+ (void)cancelRequest;

+ (BOOL)isRequestCanceled;

@end
