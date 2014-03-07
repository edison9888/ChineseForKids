//
//  PinyinDAL.h
//  ChineseForKids
//
//  Created by yang on 13-12-10.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PinyinDAL : NSObject

@property (nonatomic, strong, readonly)NSError *error;

+(PinyinDAL *)sharedInstance;

- (void)loadPinyinDataWithUserID:(NSString *)userID humanID:(NSInteger)humanID groupID:(NSInteger)groupID bookID:(NSInteger)bookID typeID:(NSInteger)typeID lessonID:(NSInteger)lessonID;

- (NSString *)getPinyinGameURLParamsWithSN:(NSString *)SN UserID:(NSString *)userID HumanID:(NSString *)humanID GroupID:(NSString *)groupID BookID:(NSString *)bookID TypeID:(NSString *)typeID LessonID:(NSString *)lessonID productID:(NSString *)productID;

-(id)parsePinyinGameInfoByData:(id)resultData;

@end
