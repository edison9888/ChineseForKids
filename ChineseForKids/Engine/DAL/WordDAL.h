//
//  WordDAL.h
//  ChineseForKids
//
//  Created by yang on 13-12-12.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WordDAL : NSObject

@property (nonatomic, strong, readonly)NSError *error;

+(WordDAL *)sharedInstance;

- (void)loadWordDataWithUserID:(NSString *)userID humanID:(NSInteger)humanID groupID:(NSInteger)groupID bookID:(NSInteger)bookID typeID:(NSInteger)typeID lessonID:(NSInteger)lessonID;

- (NSString *)getWordGameURLParamsWithSN:(NSString *)SN UserID:(NSString *)userID HumanID:(NSString *)humanID GroupID:(NSString *)groupID BookID:(NSString *)bookID TypeID:(NSString *)typeID LessonID:(NSString *)lessonID productID:(NSString *)productID;

-(id)parseWordGameInfoByData:(id)resultData;

@end
