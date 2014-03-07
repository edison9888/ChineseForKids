//
//  DownloadLessonDAL.h
//  ChineseForKids
//
//  Created by yang on 13-12-18.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DownloadLessonDAL : NSObject

@property (nonatomic, strong, readonly)NSError *error;

- (NSString *)getDownloadLessonInfoURLParamsWithSN:(NSString *)SN UserID:(NSString *)userID HumanID:(NSString *)humanID GroupID:(NSString *)groupID BookID:(NSString *)bookID TypeID:(NSString *)typeID LessonID:(NSString *)lessonID productID:(NSString *)productID;

-(id)parseDownloadLessonInfoByData:(id)resultData;

@end
