//
//  UploadLessonDAL.h
//  ChineseForKids
//
//  Created by yang on 13-12-18.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UploadLessonDAL : NSObject

@property (nonatomic, strong, readonly)NSError *error;

- (NSString *)getUploadLessonInfoURLParamsWithSN:(NSString *)SN UserID:(NSString *)userID HumanID:(NSString *)humanID GroupID:(NSString *)groupID BookID:(NSString *)bookID TypeID:(NSString *)typeID LessonID:(NSString *)lessonID Score:(NSString *)score StarAmount:(NSString *)starAmount Progress:(NSString *)progress Locked:(NSString *)locked UpdateTime:(NSString *)updateTime DataVersion:(NSString *)dataVersion Knowledges:(NSString *)knowledges productID:(NSString *)productID;

-(id)parseUploadLessonInfoByData:(id)resultData;

@end
