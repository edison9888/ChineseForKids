//
//  GameManager.h
//  PinyinGame
//
//  Created by yang on 13-10-29.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UserModel;
@class LessonModel;
@class PinyinModel;
@class WordModel;
@class SentencePatternModel;

@interface GameManager : NSObject

// 2、构造实例
+ (GameManager *)sharedManager;

/**
 * 存储用户的登陆信息
 * @param userID: 用户ID
 * @param userName: 用户名
 */
- (void)loginWithUserID:(NSString *)userID userName:(NSString *)userName userEmail:(NSString *)userEmail;

#pragma mark - Load DataModels
/**
 *  加载第几套书籍的数据
 *
 *  @param userID  用户ID
 *  @param humanID 儿童或成人
 *
 *  @return 加载指定阅读对象的第几套书籍的信息
 */
- (NSArray *)loadGroupDataWithUserID:(NSString *)userID humanID:(NSInteger)humanID;

/**
 *  加载具体的书籍数据
 *
 *  @param userID  用户ID
 *  @param humanID  儿童或成人
 *  @param groupID  书籍套ID
 *
 *  @return 返回指定的具体书籍数据
 */
- (NSArray *)loadBookDataWithUserID:(NSString *)userID humanID:(NSInteger)humanID groupID:(NSInteger)groupID;

/**
 *  加载某类型下所有的课程数据
 *
 *  @param userID  用户ID
 *  @param humanID  儿童或成人
 *  @param groupID  书籍套ID
 *  @param bookID   书本ID
 *  @param typeID   类型ID
 *
 *  @return 加载指定种类下所有的课程。
 */
- (NSArray *)loadLessonDataWithUserID:(NSString *)userID humanID:(NSInteger)humanID groupID:(NSInteger)groupID bookID:(NSInteger)bookID typeID:(NSInteger)typeID;

/**
 *  加载数据
 *
 *  @param userID   用户ID
 *  @param humanID  儿童或成人
 *  @param groupID  书籍套ID
 *  @param bookID   书本ID
 *  @param typeID   类型ID
 *  @param lessonID 课程ID
 *
 *  @return 加载指定种类typeID下的某一课的所有数据
 */
- (NSArray *)loadDataWithUserID:(NSString *)userID humanID:(NSInteger)humanID groupID:(NSInteger)groupID bookID:(NSInteger)bookID typeID:(NSInteger)typeID lessonID:(NSInteger)lessonID;

/**
 *  加载拼音数据
 *
 *  @param userID   用户ID
 *  @param humanID  儿童或成人
 *  @param groupID  书籍套ID
 *  @param bookID   书本ID
 *  @param typeID   类型ID
 *  @param lessonID 课程ID
 *
 *  @return 返回所有的拼音数据
 */
- (NSArray *)loadPinyinDataWithUserID:(NSString *)userID humanID:(NSInteger)humanID groupID:(NSInteger)groupID bookID:(NSInteger)bookID typeID:(NSInteger)typeID lessonID:(NSInteger)lessonID;

/**
 *  加载擦图猜字游戏的字数据
 *
 *  @param userID   用户ID
 *  @param humanID  儿童或成人
 *  @param groupID  书籍套ID
 *  @param bookID   书本ID
 *  @param typeID   类型ID
 *  @param lessonID 课程ID
 *
 *  @return 返回所有的字数据
 */
- (NSArray *)loadWordDataWithUserID:(NSString *)userID humanID:(NSInteger)humanID groupID:(NSInteger)groupID bookID:(NSInteger)bookID typeID:(NSInteger)typeID lessonID:(NSInteger)lessonID;

/**
 *  加载连词成句游戏的数据
 *
 *  @param userID   用户ID
 *  @param humanID  儿童或成人
 *  @param groupID  书籍套ID
 *  @param bookID   书本ID
 *  @param typeID   类型ID
 *  @param lessonID 课程ID
 *
 *  @return 返回所有连词成句的数据
 */
- (NSArray *)loadSentencePatternDataWithUserID:(NSString *)userID humanID:(NSInteger)humanID groupID:(NSInteger)groupID bookID:(NSInteger)bookID typeID:(NSInteger)typeID lessonID:(NSInteger)lessonID;

/**
 *  加载连词成句游戏的所有句子的信息
 *
 *  @param userID   用户ID
 *  @param humanID  儿童或成人
 *  @param groupID  书籍套ID
 *  @param bookID   书本ID
 *  @param typeID   类型ID
 *  @param lessonID 课程ID
 *  @param senPatternID 句型ID
 *
 *  @return 返回所有连词成句的句子的数据
 */
- (NSArray *)loadSentenceDataWithUserID:(NSString *)userID humanID:(NSInteger)humanID groupID:(NSInteger)groupID bookID:(NSInteger)bookID typeID:(NSInteger)typeID lessonID:(NSInteger)lessonID senPatternID:(NSInteger)senPatternID;

/**
 *  加载中英互译游戏的数据
 *
 *  @param userID   用户ID
 *  @param humanID  儿童或成人
 *  @param groupID  书籍套ID
 *  @param bookID   书本ID
 *  @param typeID   类型ID
 *  @param lessonID 课程ID
 *
 *  @return 返回所有中英互译的数据
 */
- (NSArray *)loadTranslationDataWithUserID:(NSString *)userID humanID:(NSInteger)humanID groupID:(NSInteger)groupID bookID:(NSInteger)bookID typeID:(NSInteger)typeID lessonID:(NSInteger)lessonID;

#pragma mark - Pick out a DataModel
/**
 *  查询出用户数据
 *
 *  @param userID 用户ID
 *
 *  @return 返回某用户数据
 */
- (UserModel *)pickOutUserWithUserID:(NSString *)userID;

/**
 *  查询课程数据
 *
 *  @param userID   用户ID
 *  @param humanID  儿童或成人
 *  @param groupID  书籍套ID
 *  @param bookID   书本ID
 *  @param typeID   类型ID
 *  @param lessonID 课程ID
 *
 *  @return 返回课程数据
 */
- (LessonModel *)pickOutLessonInfoWithUserID:(NSString *)userID humanID:(NSInteger)humanID groupID:(NSInteger)groupID bookID:(NSInteger)bookID typeID:(NSInteger)typeID lessonID:(NSInteger)lessonID;

/**
 *  查询下一课程数据
 *
 *  @param userID   用户ID
 *  @param humanID  儿童或成人
 *  @param groupID  书籍套ID
 *  @param bookID   书本ID
 *  @param typeID   类型ID
 *  @param lessonID 当前课程ID
 *
 *  @return 返回课程数据
 */
- (LessonModel *)pickOutNexLessonInfoWithUserID:(NSString *)userID humanID:(NSInteger)humanID groupID:(NSInteger)groupID bookID:(NSInteger)bookID typeID:(NSInteger)typeID curLessonID:(NSInteger)lessonID;

/**
 *  查询拼音数据
 *
 *  @param userID   用户ID
 *  @param humanID  儿童或成人
 *  @param groupID  书籍套ID
 *  @param bookID   书本ID
 *  @param typeID   类型ID
 *  @param lessonID 课程ID
 *
 *  @return 返回拼音数据
 */
- (PinyinModel *)pickOutPinyinInfoWithUserID:(NSString *)userID humanID:(NSInteger)humanID groupID:(NSInteger)groupID bookID:(NSInteger)bookID typeID:(NSInteger)typeID lessonID:(NSInteger)lessonID;

/**
 *  查询文字数据
 *
 *  @param userID   用户ID
 *  @param humanID  儿童或成人
 *  @param groupID  书籍套ID
 *  @param bookID   书本ID
 *  @param typeID   类型ID
 *  @param lessonID 课程ID
 *
 *  @return 返回文字数据
 */
- (WordModel *)pickOutWordInfoWithUserID:(NSString *)userID humanID:(NSInteger)humanID groupID:(NSInteger)groupID bookID:(NSInteger)bookID typeID:(NSInteger)typeID lessonID:(NSInteger)lessonID;

/**
 *  查询连词成句游戏的数据
 *
 *  @param userID   用户ID
 *  @param humanID  儿童或成人
 *  @param groupID  书籍套ID
 *  @param bookID   书本ID
 *  @param typeID   类型ID
 *  @param lessonID 课程ID
 *
 *  @return 返回连词成句游戏的数据
 */
- (SentencePatternModel *)pickOutSenPatternInfoWithUserID:(NSString *)userID humanID:(NSInteger)humanID groupID:(NSInteger)groupID bookID:(NSInteger)bookID typeID:(NSInteger)typeID lessonID:(NSInteger)lessonID;

#pragma mark - 游戏成绩计算
- (NSInteger)starsNumberWithScore:(NSInteger)score;

@end
