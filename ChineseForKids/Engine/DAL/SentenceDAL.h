//
//  SentenceDAL.h
//  ChineseForKids
//
//  Created by yang on 13-12-13.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SentenceDAL : NSObject

@property (nonatomic, strong, readonly)NSError *error;

+(SentenceDAL *)sharedInstance;

- (void)loadSentenceDataWithUserID:(NSString *)userID humanID:(NSInteger)humanID groupID:(NSInteger)groupID bookID:(NSInteger)bookID typeID:(NSInteger)typeID lessonID:(NSInteger)lessonID;

- (NSString *)getSentenceGameURLParamsWithSN:(NSString *)SN UserID:(NSString *)userID HumanID:(NSString *)humanID GroupID:(NSString *)groupID BookID:(NSString *)bookID TypeID:(NSString *)typeID LessonID:(NSString *)lessonID productID:(NSString *)productID;

-(id)parseSentenceGameInfoByData:(id)resultData;

@end
