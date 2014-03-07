//
//  DMDataManager.h
//  PinyinGame
//
//  Created by yang on 13-10-29.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UserModel;
@class GroupModel;
@class BookModel;
@class LessonModel;
@class PinyinModel;
@class WordModel;
@class SentencePatternModel;
@class SentenceModel;
@class TranslationModel;

/**
 * 数据模型的数据管理类, 该类只管理数据模型相关的数据。
 */

@interface DMDataManager : NSObject

/**
 * 以单例形式提供调用
 * @return 该单例对象
 */
+ (DMDataManager *)sharedManager;

/**
 *  保存用户数据
 *
 *  @param userID    用户ID
 *  @param userEmail 用户邮箱
 *  @param err       错误信息
 */
- (void)saveUserDataWithUserID:(NSString *)userID userName:(NSString *)userName userEmail:(NSString *)userEmail error:(NSError **)err;

/**
 *  保存第几套书籍的信息
 *
 *  @param userID       用户ID
 *  @param humanID      区分儿童、成人
 *  @param groupID      套ID
 *  @param groupName    套名称
 *  @param groupIconURL 套图片地址
 *  @param err          错误信息
 */
- (void)saveGroupDataWithUserID:(NSString *)userID humanID:(NSInteger)humanID groupID:(NSInteger)groupID groupName:(NSString *)groupName groupIconURL:(NSString *)groupIconURL error:(NSError **)err;

/**
 *  保存第几套里面的第几册信息, 即相当于书本信息
 *
 *  @param userID      用户ID
 *  @param humanID     区分儿童、成人
 *  @param groupID     套ID
 *  @param bookID      书本ID
 *  @param bookName    书本名称
 *  @param bookIconURL 书本图片地址
 *  @param bookAuthor  书本作者
 *  @param bookIntro   书本简介
 *  @param publishDate 出版日期
 *  @param err         错误信息
 */
- (void)saveBookDataWithUserID:(NSString *)userID humanID:(NSInteger)humanID groupID:(NSInteger)groupID bookID:(NSInteger)bookID bookName:(NSString *)bookName bookIconURL:(NSString *)bookIconURL bookAuthor:(NSString *)bookAuthor bookIntro:(NSString *)bookIntro bookPublishDate:(NSDate *)publishDate error:(NSError **)err;

/**
 *  保存课程信息
 *
 *  @param userID      用户ID
 *  @param humanID     区分儿童、成人
 *  @param groupID     套ID
 *  @param bookID      书本ID
 *  @param typeID      类型ID
 *  @param lessonID    课程ID
 *  @param lessonName  课程名称
 *  @param score       分数
 *  @param starAmount  星级
 *  @param progress    进度
 *  @param locked      是否锁定
 *  @param preLessonID 上一课课程ID
 *  @param nexLessonID 下一课课程ID
 *  @param updateTime  时间戳
 *  @param dataVersion 资源文件版本
 *  @param err         错误信息
 */
- (void)saveLessonDataWithUserID:(NSString *)userID humanID:(NSInteger)humanID groupID:(NSInteger)groupID bookID:(NSInteger)bookID typeID:(NSInteger)typeID lessonID:(NSInteger)lessonID lessonName:(NSString *)lessonName score:(NSInteger)score starAmount:(NSInteger)starAmount progress:(CGFloat)progress locked:(BOOL)locked lessonIndex:(CGFloat)lessonIndex updateTime:(NSString *)updateTime dataVersion:(CGFloat)dataVersion error:(NSError **)err;

/**
 *  保存拼音数据
 *
 *  @param userID      用户ID
 *  @param humanID     区分儿童、成人
 *  @param groupID     套ID
 *  @param bookID      书本ID
 *  @param typeID      类型ID
 *  @param lessonID    课程ID
 *  @param knowledgeID 知识点ID
 *  @param chinese     中文
 *  @param pinyin      拼音
 *  @param english     英语
 *  @param tone        声调
 *  @param phoneme     音素
 *  @param progress    进度
 *  @param audio       音频
 *  @param err         错误信息
 */
- (void)savePinyinDataWithUserID:(NSString *)userID humanID:(NSInteger)humanID groupID:(NSInteger)groupID bookID:(NSInteger)bookID typeID:(NSInteger)typeID lessonID:(NSInteger)lessonID knowledgeID:(NSInteger)knowledgeID chinese:(NSString *)chinese pinyin:(NSString *)pinyin english:(NSString *)english tone:(NSString *)tone phoneme:(NSString *)phoneme phonemeCount:(NSInteger)phonemeCount progress:(CGFloat)progress audio:(NSString *)audio error:(NSError **)err;

/**
 *  保存擦图猜字游戏的数据
 *
 *  @param userID      用户ID
 *  @param humanID     区分儿童、成人
 *  @param groupID     套ID
 *  @param bookID      书本ID
 *  @param typeID      类型ID
 *  @param lessonID    课程ID
 *  @param knowledgeID 知识点ID
 *  @param rightWord   对的那个字
 *  @param pinyin      拼音
 *  @param english     英语
 *  @param obstruction 干扰项
 *  @param progress    进度
 *  @param err         错误信息
 */
- (void)saveWordDataWithUserID:(NSString *)userID humanID:(NSInteger)humanID groupID:(NSInteger)groupID bookID:(NSInteger)bookID typeID:(NSInteger)typeID lessonID:(NSInteger)lessonID knowledgeID:(NSInteger)knowledgeID rightWord:(NSString *)rightWord pinyin:(NSString *)pinyin english:(NSString *)english obstruction:(NSString *)obstruction progress:(CGFloat)progress audio:(NSString *)audio error:(NSError **)err;

/**
 *  保存连词成句游戏的数据（句型）
 *
 *  @param userID      用户ID
 *  @param humanID     区分儿童、成人
 *  @param groupID     套ID
 *  @param bookID      书本ID
 *  @param typeID      类型ID
 *  @param lessonID    课程ID
 *  @param knowledgeID 知识点ID
 *  @param senPattern  句型
 *  @param english     英语
 *  @param progress    进度
 *  @param err         错误信息
 */
- (void)saveSentencePatternDataWithUserID:(NSString *)userID humanID:(NSInteger)humanID groupID:(NSInteger)groupID bookID:(NSInteger)bookID typeID:(NSInteger)typeID lessonID:(NSInteger)lessonID knowledgeID:(NSInteger)knowledgeID sentencePattern:(NSString *)senPattern english:(NSString *)english progress:(CGFloat)progress error:(NSError **)err;

/**
 *  保存连词成句游戏的句子数据
 *
 *  @param userID      用户ID
 *  @param humanID     区分儿童、成人
 *  @param groupID     套ID
 *  @param bookID      书本ID
 *  @param typeID      类型ID
 *  @param lessonID    课程ID
 *  @param knowledgeID 知识点ID
 *  @param sentenceID  句子ID
 *  @param sentence    句子
 *  @param worderOrder 字/词 排列
 *  @param audio       音频文件
 *  @param err         错误信息
 */
- (void)saveSentenceDataWithUserID:(NSString *)userID humanID:(NSInteger)humanID groupID:(NSInteger)groupID bookID:(NSInteger)bookID typeID:(NSInteger)typeID lessonID:(NSInteger)lessonID knowledgeID:(NSInteger)knowledgeID sentenceID:(NSInteger)sentenceID sentence:(NSString *)sentence worderOrder:(NSString *)worderOrder audio:(NSString *)audio error:(NSError **)err;

/**
 *  保存中英互译游戏的数据
 *
 *  @param userID      用户ID
 *  @param humanID     区分儿童、成人: 0: 儿童, 1: 成人
 *  @param groupID     套ID
 *  @param bookID      书本ID
 *  @param typeID      类型ID
 *  @param lessonID    课程ID
 *  @param knowledgeID 知识点ID
 *  @param chinese     中文
 *  @param pinyin      拼音
 *  @param english     英语
 *  @param progress    进度
 *  @param audio       音频
 *  @param err         错误信息
 */
- (void)saveTranslationDataWithUserID:(NSString *)userID humanID:(NSInteger)humanID groupID:(NSInteger)groupID bookID:(NSInteger)bookID typeID:(NSInteger)typeID lessonID:(NSInteger)lessonID knowledgeID:(NSInteger)knowledgeID chinese:(NSString *)chinese pinyin:(NSString *)pinyin english:(NSString *)english progress:(CGFloat)progress audio:(NSString *)audio error:(NSError **)err;

#pragma mark - Update Data Manager
/**
 *  更新用户信息
 *
 *  @param userID    用户ID
 *  @param userEmail 用户名
 *  @param err       错误信息
 */
- (void)updateUserDataWithUserID:(NSString *)userID userName:(NSString *)userName userEmail:(NSString *)userEmail error:(NSError **)err;

/**
 *  更新第几套书籍的信息
 *
 *  @param userID       用户ID
 *  @param humanID      区分儿童、成人
 *  @param groupID      套ID
 *  @param groupName    套名称
 *  @param groupIconURL 套图片地址
 *  @param err          错误信息
 */
- (void)updateGroupDataWithUserID:(NSString *)userID humanID:(NSInteger)humanID groupID:(NSInteger)groupID groupName:(NSString *)groupName groupIconURL:(NSString *)groupIconURL error:(NSError **)err;

/**
 *  更新第几套里面的第几册信息, 即相当于书本信息
 *
 *  @param userID      用户ID
 *  @param humanID     区分儿童、成人
 *  @param groupID     套ID
 *  @param bookID      书本ID
 *  @param bookName    书本名称
 *  @param bookIconURL 书本图片地址
 *  @param bookAuthor  书本作者
 *  @param bookIntro   书本简介
 *  @param publishDate 出版日期
 *  @param err         错误信息
 */
- (void)updateBookDataWithUserID:(NSString *)userID humanID:(NSInteger)humanID groupID:(NSInteger)groupID bookID:(NSInteger)bookID bookName:(NSString *)bookName bookIconURL:(NSString *)bookIconURL bookAuthor:(NSString *)bookAuthor bookIntro:(NSString *)bookIntro bookPublishDate:(NSDate *)publishDate error:(NSError **)err;


/**
 *  更新课程信息
 *
 *  @param userID      用户ID
 *  @param humanID     区分儿童、成人
 *  @param groupID     套ID
 *  @param bookID      书本ID
 *  @param typeID      类型ID
 *  @param lessonID    课程ID
 *  @param lessonName  课程名称
 *  @param score       分数
 *  @param starAmount  星级
 *  @param progress    进度
 *  @param locked      是否锁定
 *  @param preLessonID 上一课课程ID
 *  @param nexLessonID 下一课课程ID
 *  @param updateTime  时间戳
 *  @param dataVersion 资源文件版本
 *  @param err         错误信息
 */
- (void)updateLessonDataWithUserID:(NSString *)userID humanID:(NSInteger)humanID groupID:(NSInteger)groupID bookID:(NSInteger)bookID typeID:(NSInteger)typeID lessonID:(NSInteger)lessonID lessonName:(NSString *)lessonName score:(NSInteger)score starAmount:(NSInteger)starAmount progress:(CGFloat)progress locked:(BOOL)locked lessonIndex:(CGFloat)lessonIndex updateTime:(NSString *)updateTime dataVersion:(CGFloat)dataVersion error:(NSError **)err;

/**
 *  更新拼音数据
 *
 *  @param userID      用户ID
 *  @param humanID     区分儿童、成人
 *  @param groupID     套ID
 *  @param bookID      书本ID
 *  @param typeID      类型ID
 *  @param lessonID    课程ID
 *  @param knowledgeID 知识点ID
 *  @param chinese     中文
 *  @param pinyin      拼音
 *  @param english     英语
 *  @param tone        声调
 *  @param phoneme     音素
 *  @param progress    进度
 *  @param audio       音频
 *  @param err         错误信息
 */
- (void)updatePinyinDataWithUserID:(NSString *)userID humanID:(NSInteger)humanID groupID:(NSInteger)groupID bookID:(NSInteger)bookID typeID:(NSInteger)typeID lessonID:(NSInteger)lessonID knowledgeID:(NSInteger)knowledgeID chinese:(NSString *)chinese pinyin:(NSString *)pinyin english:(NSString *)english tone:(NSString *)tone phoneme:(NSString *)phoneme phonemeCount:(NSInteger)phonemeCount progress:(CGFloat)progress audio:(NSString *)audio error:(NSError **)err;

/**
 *  更新擦图猜字游戏的数据
 *
 *  @param userID      用户ID
 *  @param humanID     区分儿童、成人
 *  @param groupID     套ID
 *  @param bookID      书本ID
 *  @param typeID      类型ID
 *  @param lessonID    课程ID
 *  @param knowledgeID 知识点ID
 *  @param rightWord   对的那个字
 *  @param pinyin      拼音
 *  @param english     英语
 *  @param obstruction 干扰项
 *  @param progress    进度
 *  @param err         错误信息
 */
- (void)updateWordDataWithUserID:(NSString *)userID humanID:(NSInteger)humanID groupID:(NSInteger)groupID bookID:(NSInteger)bookID typeID:(NSInteger)typeID lessonID:(NSInteger)lessonID knowledgeID:(NSInteger)knowledgeID rightWord:(NSString *)rightWord pinyin:(NSString *)pinyin english:(NSString *)english obstruction:(NSString *)obstruction progress:(CGFloat)progress audio:(NSString *)audio error:(NSError **)err;

/**
 *  更新连词成句游戏的数据（句型）
 *
 *  @param userID      用户ID
 *  @param humanID     区分儿童、成人
 *  @param groupID     套ID
 *  @param bookID      书本ID
 *  @param typeID      类型ID
 *  @param lessonID    课程ID
 *  @param knowledgeID 知识点ID
 *  @param senPattern  句型
 *  @param english     英语
 *  @param progress    进度
 *  @param err         错误信息
 */
- (void)updateSentencePatternDataWithUserID:(NSString *)userID humanID:(NSInteger)humanID groupID:(NSInteger)groupID bookID:(NSInteger)bookID typeID:(NSInteger)typeID lessonID:(NSInteger)lessonID knowledgeID:(NSInteger)knowledgeID sentencePattern:(NSString *)senPattern english:(NSString *)english progress:(CGFloat)progress error:(NSError **)err;

/**
 *  更新连词成句游戏的句子数据
 *
 *  @param userID      用户ID
 *  @param humanID     区分儿童、成人
 *  @param groupID     套ID
 *  @param bookID      书本ID
 *  @param typeID      类型ID
 *  @param lessonID    课程ID
 *  @param knowledgeID 知识点ID
 *  @param sentenceID  句子ID
 *  @param sentence    句子
 *  @param worderOrder 字/词 排列
 *  @param audio       音频文件
 *  @param err         错误信息
 */
- (void)updateSentenceDataWithUserID:(NSString *)userID humanID:(NSInteger)humanID groupID:(NSInteger)groupID bookID:(NSInteger)bookID typeID:(NSInteger)typeID lessonID:(NSInteger)lessonID knowledgeID:(NSInteger)knowledgeID sentenceID:(NSInteger)sentenceID sentence:(NSString *)sentence worderOrder:(NSString *)worderOrder audio:(NSString *)audio error:(NSError *__autoreleasing *)err;

/**
 *  更新中英互译游戏的数据
 *
 *  @param userID      用户ID
 *  @param humanID     区分儿童、成人: 0: 儿童, 1: 成人
 *  @param groupID     套ID
 *  @param bookID      书本ID
 *  @param typeID      类型ID
 *  @param lessonID    课程ID
 *  @param knowledgeID 知识点ID
 *  @param chinese     中文
 *  @param pinyin      拼音
 *  @param english     英语
 *  @param progress    进度
 *  @param audio       音频
 *  @param err         错误信息
 */
- (void)updateTranslationDataWithUserID:(NSString *)userID humanID:(NSInteger)humanID groupID:(NSInteger)groupID bookID:(NSInteger)bookID typeID:(NSInteger)typeID lessonID:(NSInteger)lessonID knowledgeID:(NSInteger)knowledgeID chinese:(NSString *)chinese pinyin:(NSString *)pinyin english:(NSString *)english progress:(CGFloat)progress audio:(NSString *)audio error:(NSError **)err;

#pragma mark - Search Single DataModel Data Manager
/**
 *  查询用户信息
 *
 *  @param userID 用户ID
 *
 *  @return 返回用户信息模型
 */
- (UserModel *)queryUserInfoWithUserID:(NSString *)userID;

/**
 *  查询书籍的套信息
 *
 *  @param userID  用户ID
 *  @param humanID 儿童还是成人
 *  @param groupID 套ID
 *
 *  @return 返回套信息模型
 */
- (GroupModel *)queryGroupInfoWithUserID:(NSString *)userID humanID:(NSInteger)humanID groupID:(NSInteger)groupID;

/**
 *  查询所有的书籍的套的信息
 *
 *  @param userID  用户ID
 *  @param humanID 儿童还是成人
 *
 *  @return 返回所有的书籍的套信息
 */
- (NSArray *)queryAllGroupInfoWithUserID:(NSString *)userID humanID:(NSInteger)humanID;

/**
 *  查询书本信息
 *
 *  @param userID  用户ID
 *  @param humanID 儿童还是成人
 *  @param groupID 套ID
 *  @param bookID  书本ID
 *
 *  @return 返回书本信息模型
 */
- (BookModel *)queryBookInfoWithUserID:(NSString *)userID humanID:(NSInteger)humanID groupID:(NSInteger)groupID bookID:(NSInteger)bookID;

/**
 *  查询所有的书本信息
 *
 *  @param userID  用户ID
 *  @param humanID 儿童还是成人
 *  @param groupID 套ID
 *
 *  @return 返回所有书本信息
 */
- (NSArray *)queryAllBookInfoWithUserID:(NSString *)userID humanID:(NSInteger)humanID groupID:(NSInteger)groupID;

/**
 *  查询课程信息
 *
 *  @param userID   用户ID
 *  @param humanID  儿童还是成人
 *  @param groupID  套ID
 *  @param bookID   书本ID
 *  @param typeID   类型ID: 1: 声调; 2: 猜字; 3: 连词; 4: 中英
 *  @param lessonID 课程ID
 *
 *  @return 返回课程信息模型
 */
- (LessonModel *)queryLessonInfoWithUserID:(NSString *)userID humanID:(NSInteger)humanID groupID:(NSInteger)groupID bookID:(NSInteger)bookID typeID:(NSInteger)typeID lessonID:(NSInteger)lessonID;

/**
 *  查询出所有的课程的数据
 *
 *  @param userID  用户ID
 *  @param humanID 儿童还是成人
 *  @param groupID 套ID
 *  @param bookID  书本ID
 *  @param typeID  类型ID: 1: 声调; 2: 猜字; 3: 连词; 4: 中英
 *
 *  @return 返回所有的课程的信息
 */
- (NSArray *)queryAllLessonInfoWithUserID:(NSString *)userID humanID:(NSInteger)humanID groupID:(NSInteger)groupID bookID:(NSInteger)bookID typeID:(NSInteger)typeID;

/**
 *  查询拼音游戏的数据
 *
 *  @param userID      用户ID
 *  @param humanID     儿童还是成人
 *  @param groupID     套ID
 *  @param bookID      书本ID
 *  @param typeID      类型ID: 1: 声调; 2: 猜字; 3: 连词; 4: 中英
 *  @param lessonID    课程ID
 *  @param knowledgeID 知识点ID, 这里就是拼音的ID
 *
 *  @return 返回指定拼音的数据
 */
- (PinyinModel *)queryPinyinInfoWithUserID:(NSString *)userID humanID:(NSInteger)humanID groupID:(NSInteger)groupID bookID:(NSInteger)bookID typeID:(NSInteger)typeID lessonID:(NSInteger)lessonID knowledgeID:(NSInteger)knowledgeID;

/**
 *  查询拼音游戏的所有的数据
 *
 *  @param userID      用户ID
 *  @param humanID     儿童还是成人
 *  @param groupID     套ID
 *  @param bookID      书本ID
 *  @param typeID      类型ID: 1: 声调; 2: 猜字; 3: 连词; 4: 中英
 *  @param lessonID    课程ID
 *
 *  @return 返回指定课程下所有的拼音游戏的数据
 */
- (NSArray *)queryAllPinyinInfoWithUserID:(NSString *)userID humanID:(NSInteger)humanID groupID:(NSInteger)groupID bookID:(NSInteger)bookID typeID:(NSInteger)typeID lessonID:(NSInteger)lessonID;

/**
 *  查询擦图猜字游戏的数据
 *
 *  @param userID      用户ID
 *  @param humanID     儿童还是成人
 *  @param groupID     套ID
 *  @param bookID      书本ID
 *  @param typeID      类型ID: 1: 声调; 2: 猜字; 3: 连词; 4: 中英
 *  @param lessonID    课程ID
 *  @param knowledgeID 知识点ID, 这里指的是字数据的ID
 *
 *  @return 返回指定字数据的信息
 */
- (WordModel *)queryWordInfoWithUserID:(NSString *)userID humanID:(NSInteger)humanID groupID:(NSInteger)groupID bookID:(NSInteger)bookID typeID:(NSInteger)typeID lessonID:(NSInteger)lessonID knowledgeID:(NSInteger)knowledgeID;

/**
 *  查询擦图猜字游戏的所有数据
 *
 *  @param userID      用户ID
 *  @param humanID     儿童还是成人
 *  @param groupID     套ID
 *  @param bookID      书本ID
 *  @param typeID      类型ID: 1: 声调; 2: 猜字; 3: 连词; 4: 中英
 *  @param lessonID    课程ID
 *
 *  @return 返回指定课程下所有的拼音游戏的数据
 */
- (NSArray *)queryAllWordInfoWithUserID:(NSString *)userID humanID:(NSInteger)humanID groupID:(NSInteger)groupID bookID:(NSInteger)bookID typeID:(NSInteger)typeID lessonID:(NSInteger)lessonID;


/**
 *  查询连词成句游戏的数据（句型）
 *
 *  @param userID      用户ID
 *  @param humanID     儿童还是成人: 0、儿童; 1、成人。
 *  @param groupID     套ID
 *  @param bookID      书本ID
 *  @param typeID      类型ID: 1: 声调; 2: 猜字; 3: 连词; 4: 中英
 *  @param lessonID    课程ID
 *  @param knowledgeID 知识点ID, 这里指的是句型数据的ID
 *
 *  @return 返回指定句型的数据
 */
- (SentencePatternModel *)querySentencePatternInfoWithUserID:(NSString *)userID humanID:(NSInteger)humanID groupID:(NSInteger)groupID bookID:(NSInteger)bookID typeID:(NSInteger)typeID lessonID:(NSInteger)lessonID knowledgeID:(NSInteger)knowledgeID;

/**
 *  查询连词成句游戏的所有数据（句型）
 *
 *  @param userID   用户ID
 *  @param humanID  儿童还是成人: 0、儿童; 1、成人。
 *  @param groupID  套ID
 *  @param bookID   书本ID
 *  @param typeID   类型ID: 1: 声调; 2: 猜字; 3: 连词; 4: 中英
 *  @param lessonID 课程ID
 *
 *  @return 返回指定课程下所有的连词成句游戏的数据
 */
- (NSArray *)queryAllSentencePatternInfoWithUserID:(NSString *)userID humanID:(NSInteger)humanID groupID:(NSInteger)groupID bookID:(NSInteger)bookID typeID:(NSInteger)typeID lessonID:(NSInteger)lessonID;

/**
 *  查询连词成句游戏的句子数据
 *
 *  @param userID      用户ID
 *  @param humanID     儿童还是成人: 0、儿童; 1、成人。
 *  @param groupID     套ID
 *  @param bookID      书本ID
 *  @param typeID      类型ID: 1: 声调; 2: 猜字; 3: 连词; 4: 中英
 *  @param lessonID    课程ID
 *  @param knowledgeID 知识点ID
 *  @param sentenceID  句子数据ID
 *
 *  @return 返回指定的句子的信息
 */
- (SentenceModel *)querySentenceInfoWithUserID:(NSString *)userID humanID:(NSInteger)humanID groupID:(NSInteger)groupID bookID:(NSInteger)bookID typeID:(NSInteger)typeID lessonID:(NSInteger)lessonID knowledgeID:(NSInteger)knowledgeID sentenceID:(NSInteger)sentenceID;

/**
 *  查询连词成句游戏的所有句子数据
 *
 *  @param userID      用户ID
 *  @param humanID     儿童还是成人: 0、儿童; 1、成人。
 *  @param groupID     套ID
 *  @param bookID      书本ID
 *  @param typeID      类型ID: 1: 声调; 2: 猜字; 3: 连词; 4: 中英
 *  @param lessonID    课程ID
 *  @param knowledgeID 知识点ID
 *
 *  @return 返回指定句型下的句子数据
 */
- (NSArray *)queryAllSentenceInfoWithUserID:(NSString *)userID humanID:(NSInteger)humanID groupID:(NSInteger)groupID bookID:(NSInteger)bookID typeID:(NSInteger)typeID lessonID:(NSInteger)lessonID knowledgeID:(NSInteger)knowledgeID;

/**
 *  查询中英互译游戏的数据
 *
 *  @param userID      用户ID
 *  @param humanID     儿童还是成人: 0、儿童; 1、成人。
 *  @param groupID     套ID
 *  @param bookID      书本ID
 *  @param typeID      类型ID: 1: 声调; 2: 猜字; 3: 连词; 4: 中英
 *  @param lessonID    课程ID
 *  @param knowledgeID 知识点ID, 这里是中英互译数据的ID
 *
 *  @return 返回中英互译的数据
 */
- (TranslationModel *)queryTranslationInfoWithUserID:(NSString *)userID humanID:(NSInteger)humanID groupID:(NSInteger)groupID bookID:(NSInteger)bookID typeID:(NSInteger)typeID lessonID:(NSInteger)lessonID knowledgeID:(NSInteger)knowledgeID;

/**
 *  查询中英互译游戏的所有数据
 *
 *  @param userID   用户ID
 *  @param humanID  儿童还是成人: 0、儿童; 1、成人。
 *  @param groupID  套ID
 *  @param bookID   书本ID
 *  @param typeID   类型ID: 1: 声调; 2: 猜字; 3: 连词; 4: 中英
 *  @param lessonID 课程ID
 *
 *  @return 返回指定课程下所有的中英互译游戏的数据
 */
- (NSArray *)queryAllTranslationInfoWithUserID:(NSString *)userID humanID:(NSInteger)humanID groupID:(NSInteger)groupID bookID:(NSInteger)bookID typeID:(NSInteger)typeID lessonID:(NSInteger)lessonID;

@end
