//
//  DownloadLessonNet.h
//  ChineseForKids
//
//  Created by yang on 13-12-18.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DownloadLessonNet : NSObject

+ (DownloadLessonNet *)sharedInstance;

- (id)getLessonDonwloadInfoWithUserID:(NSString *)userID HumanID:(NSString *)humanID GroupID:(NSString *)groupID BookID:(NSString *)bookID TypeID:(NSString *)typeID LessonID:(NSString *)lessonID;

- (id)downloadLessonInfoWithUserID:(NSString *)userID HumanID:(NSString *)humanID GroupID:(NSString *)groupID BookID:(NSString *)bookID TypeID:(NSString *)typeID LessonID:(NSString *)lessonID error:(NSError **)error;

- (void)cancelRequest;

- (BOOL)isRequestCanceled;

@end
