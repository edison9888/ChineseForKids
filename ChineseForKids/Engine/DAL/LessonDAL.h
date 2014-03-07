//
//  LessonDAL.h
//  ChineseForKids
//
//  Created by yang on 13-12-10.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LessonDAL : NSObject

@property (nonatomic, strong, readonly)NSError *error;

+(LessonDAL *)sharedInstance;

- (NSString *)getLessonsURLParamsWithSN:(NSString *)SN UserID:(NSString *)userID HumanID:(NSString *)humanID GroupID:(NSString *)groupID BookID:(NSString *)bookID TypeID:(NSString *)typeID productID:(NSString *)productID;

-(id)parseLessonsInfoByData:(id)resultData;

@end
