//
//  GameRubImageParser.h
//  ChineseForKids
//
//  Created by 唐 希 on 13-8-29.
//  Copyright (c) 2013年 Allen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WordXMLDataParser : NSObject

/**
 *  将xml文件存储的字的数据加入到CoreData数据库中去。
 *
 *  @param userID   用户ID
 *  @param humanID  儿童还是成人
 *  @param groupID  第几套书籍
 *  @param bookID   书本ID
 *  @param typeID   游戏种类ID
 *  @param lessonID 课程ID
 *  @param err      错误信息
 */
- (void)loadWordXMLDataToCoreDataWithUserID:(NSString *)userID humanID:(NSInteger)humanID groupID:(NSInteger)groupID bookID:(NSInteger)bookID typeID:(NSInteger)typeID lessonID:(NSInteger)lessonID error:(NSError **)err;

@end
