//
//  DMDataManager.m
//  PinyinGame
//
//  Created by yang on 13-10-29.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "DMDataManager.h"

#import "UserModel.h"
#import "GroupModel.h"
#import "BookModel.h"
#import "LessonModel.h"
#import "PinyinModel.h"
#import "WordModel.h"
#import "SentencePatternModel.h"
#import "SentenceModel.h"
#import "TranslationModel.h"

// 1、全局静态对象、并置为nil。
static DMDataManager *dataManager = nil;

@implementation DMDataManager

// 2、构造实例
+ (DMDataManager *)sharedManager
{
    @synchronized(self)
    {
        if (nil == dataManager)
        {
            dataManager = [[self alloc] init];
        }
    }
    return dataManager;
}

// 3、重写allocwithzone，保证只有一个实例
+ (id)allocWithZone:(struct _NSZone *)zone
{
    @synchronized(self)
    {
        if (nil == dataManager)
        {
            dataManager = [super allocWithZone:zone];
            return dataManager;
        }
    }
    return nil;
}

// 4、重写copywithzone
- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)init
{
    @synchronized(self)
    {
        self = [super init];
        
        return self;
    }
}

#pragma mark - Memory Manager

- (void)dealloc
{
    dataManager = nil;
}

#pragma mark - Save Data Manager
// 用户数据
- (void)saveUserDataWithUserID:(NSString *)userID userName:(NSString *)userName userEmail:(NSString *)userEmail error:(NSError *__autoreleasing *)err
{
    // 先查询
    NSMutableArray *arrTmpInfo = [[NSMutableArray alloc] init];
    [arrTmpInfo setArray:[UserModel findAll]];
    NSInteger infoCount = [arrTmpInfo count];
    
    for (int i = 0; i < infoCount; i++)
    {
        UserModel *user = (UserModel *)[arrTmpInfo objectAtIndex:i];
        if ([user.userID isEqualToString:userID])
        {
            // 更新数据
            [self updateUserDataWithUserID:userID userName:userName userEmail:userEmail error:err];
            return;
        }
    }
    
    NSManagedObjectContext *localContext = [NSManagedObjectContext contextForCurrentThread];
    UserModel *user = [UserModel createInContext:localContext];
    user.userID = userID;
    user.userName = userName;
    user.userEmail = userEmail;
    [localContext saveOnlySelfAndWait];
    if (err) *err = [NSError errorWithDomain:@"成功保存用户信息!" code:0 userInfo:nil];
}

// 保存第几套书籍信息
- (void)saveGroupDataWithUserID:(NSString *)userID humanID:(NSInteger)humanID groupID:(NSInteger)groupID groupName:(NSString *)groupName groupIconURL:(NSString *)groupIconURL error:(NSError *__autoreleasing *)err
{
    // 先查询
    GroupModel *groupModel = (GroupModel *)[self queryGroupInfoWithUserID:userID humanID:humanID groupID:groupID];
    if (groupModel.groupIDValue == groupID)
    {
        // 更新数据
        [self updateGroupDataWithUserID:userID humanID:humanID groupID:groupID groupName:groupName groupIconURL:groupIconURL error:err];
        return;
    }
    
    NSManagedObjectContext *localContext = [NSManagedObjectContext contextForCurrentThread];
    GroupModel *group = [GroupModel createInContext:localContext];
    group.humanIDValue = humanID;
    group.groupIDValue = groupID;
    group.groupName = groupName;
    group.groupIconURL = groupIconURL;
    [localContext saveOnlySelfAndWait];
    if (err) *err = [NSError errorWithDomain:@"成功保存书籍信息!" code:0 userInfo:nil];
}

// 保存书本信息
- (void)saveBookDataWithUserID:(NSString *)userID humanID:(NSInteger)humanID groupID:(NSInteger)groupID bookID:(NSInteger)bookID bookName:(NSString *)bookName bookIconURL:(NSString *)bookIconURL bookAuthor:(NSString *)bookAuthor bookIntro:(NSString *)bookIntro bookPublishDate:(NSDate *)publishDate error:(NSError *__autoreleasing *)err
{
    // 先查询
    BookModel *bookModel = (BookModel *)[self queryBookInfoWithUserID:userID humanID:humanID groupID:groupID bookID:bookID];
    if (bookModel.bookIDValue == bookID)
    {
        // 更新数据
        [self updateBookDataWithUserID:userID humanID:humanID groupID:groupID bookID:bookID bookName:bookName bookIconURL:bookIconURL bookAuthor:bookAuthor bookIntro:bookIntro bookPublishDate:publishDate error:err];
        return;
    }
    
    NSManagedObjectContext *localContext = [NSManagedObjectContext contextForCurrentThread];
    BookModel *book = [BookModel createInContext:localContext];
    book.groupIDValue = groupID;
    book.bookIDValue = bookID;
    book.bookName = bookName;
    book.bookIconURL = bookIconURL;
    book.bookAuthor = bookAuthor;
    book.bookIntro = bookIntro;
    book.bookPublishDate = publishDate;
    [localContext saveOnlySelfAndWait];
    if (err) *err = [NSError errorWithDomain:@"成功保存书籍信息!" code:0 userInfo:nil];
}

// 保存课程信息
- (void)saveLessonDataWithUserID:(NSString *)userID humanID:(NSInteger)humanID groupID:(NSInteger)groupID bookID:(NSInteger)bookID typeID:(NSInteger)typeID lessonID:(NSInteger)lessonID lessonName:(NSString *)lessonName score:(NSInteger)score starAmount:(NSInteger)starAmount progress:(CGFloat)progress locked:(BOOL)locked lessonIndex:(CGFloat)lessonIndex updateTime:(NSString *)updateTime dataVersion:(CGFloat)dataVersion error:(NSError *__autoreleasing *)err
{
    // 先查询
    LessonModel *lessonModel = (LessonModel *)[self queryLessonInfoWithUserID:userID humanID:humanID groupID:groupID bookID:bookID typeID:typeID lessonID:lessonID];
    if (lessonModel.lessonIDValue == lessonID/* && lessonModel.lockedValue*/)
    {
        // 更新数据
        [self updateLessonDataWithUserID:userID humanID:humanID groupID:groupID bookID:bookID typeID:typeID lessonID:lessonID lessonName:lessonName score:score starAmount:starAmount progress:progress locked:locked lessonIndex:lessonIndex updateTime:updateTime dataVersion:dataVersion error:err];
        return;
    }
    
    NSManagedObjectContext *localContext = [NSManagedObjectContext contextForCurrentThread];
    LessonModel *lesson = [LessonModel createInContext:localContext];
    lesson.userID = userID;
    lesson.bookIDValue = bookID;
    lesson.typeIDValue = typeID;
    lesson.lessonIDValue = lessonID;
    lesson.lessonName = lessonName;
    lesson.scoreValue = score;
    lesson.starAmountValue = starAmount;
    lesson.progressValue = progress;
    lesson.lockedValue = locked;
    lesson.lessonIndexValue = lessonIndex;
    lesson.updateTime = updateTime;
    lesson.dataVersionValue = dataVersion;
    
    [localContext saveOnlySelfAndWait];
    if (err) *err = [NSError errorWithDomain:@"成功保存课程信息!" code:0 userInfo:nil];
}

// 保存拼音游戏的数据
- (void)savePinyinDataWithUserID:(NSString *)userID humanID:(NSInteger)humanID groupID:(NSInteger)groupID bookID:(NSInteger)bookID typeID:(NSInteger)typeID lessonID:(NSInteger)lessonID knowledgeID:(NSInteger)knowledgeID chinese:(NSString *)chinese pinyin:(NSString *)pinyin english:(NSString *)english tone:(NSString *)tone phoneme:(NSString *)phoneme phonemeCount:(NSInteger)phonemeCount progress:(CGFloat)progress audio:(NSString *)audio error:(NSError *__autoreleasing *)err
{
    // 先查询
    PinyinModel *pinyinModel = (PinyinModel *)[self queryPinyinInfoWithUserID:userID humanID:humanID groupID:groupID bookID:bookID typeID:typeID lessonID:lessonID knowledgeID:knowledgeID];
    if (pinyinModel.knowledgeIDValue == knowledgeID && pinyinModel.lessonIDValue == lessonID)
    {
        // 更新数据
        [self updatePinyinDataWithUserID:userID humanID:humanID groupID:groupID bookID:bookID typeID:typeID lessonID:lessonID knowledgeID:knowledgeID chinese:chinese pinyin:pinyin english:english tone:tone phoneme:phoneme  phonemeCount:phonemeCount progress:progress audio:audio error:err];
        return;
    }
    
    NSManagedObjectContext *localContext = [NSManagedObjectContext contextForCurrentThread];
    PinyinModel *pinyinMD = [PinyinModel createInContext:localContext];
    pinyinMD.userID = userID;
    pinyinMD.typeIDValue = typeID;
    pinyinMD.lessonIDValue = lessonID;
    pinyinMD.knowledgeIDValue = knowledgeID;
    pinyinMD.chinese = chinese;
    pinyinMD.pinyin = pinyin;
    pinyinMD.english = english;
    pinyinMD.tone = tone;
    pinyinMD.phoneme = phoneme;
    pinyinMD.phonemeCountValue = phonemeCount;
    pinyinMD.progressValue = progress;
    pinyinMD.audio = audio;
    
    [localContext saveOnlySelfAndWait];
    if (err) *err = [NSError errorWithDomain:@"成功保存拼音游戏的数据!" code:0 userInfo:nil];
}

// 保存擦图猜字游戏的数据
- (void)saveWordDataWithUserID:(NSString *)userID humanID:(NSInteger)humanID groupID:(NSInteger)groupID bookID:(NSInteger)bookID typeID:(NSInteger)typeID lessonID:(NSInteger)lessonID knowledgeID:(NSInteger)knowledgeID rightWord:(NSString *)rightWord pinyin:(NSString *)pinyin english:(NSString *)english obstruction:(NSString *)obstruction progress:(CGFloat)progress audio:(NSString *)audio error:(NSError *__autoreleasing *)err
{
    // 先查询
    WordModel *wordModel = (WordModel *)[self queryWordInfoWithUserID:userID humanID:humanID groupID:groupID bookID:bookID typeID:typeID lessonID:lessonID knowledgeID:knowledgeID];
    if (wordModel.knowledgeIDValue == knowledgeID)
    {
        // 更新数据
        [self updateWordDataWithUserID:userID humanID:humanID groupID:groupID bookID:bookID typeID:typeID lessonID:lessonID knowledgeID:knowledgeID rightWord:rightWord pinyin:pinyin english:english obstruction:obstruction progress:progress audio:audio error:err];
        return;
    }
    
    NSManagedObjectContext *localContext = [NSManagedObjectContext contextForCurrentThread];
    WordModel *word = [WordModel createInContext:localContext];
    word.userID = userID;
    word.typeIDValue = typeID;
    word.lessonIDValue = lessonID;
    word.knowledgeIDValue = knowledgeID;
    word.rightWord = rightWord;
    word.pinyin = pinyin;
    word.english = english;
    word.obstruction = obstruction;
    word.progressValue = progress;
    word.audio = audio;
    
    [localContext saveOnlySelfAndWait];
    if (err) *err = [NSError errorWithDomain:@"成功保存擦图猜字游戏的数据!" code:0 userInfo:nil];
}

// 保存连词成句游戏的数据
- (void)saveSentencePatternDataWithUserID:(NSString *)userID humanID:(NSInteger)humanID groupID:(NSInteger)groupID bookID:(NSInteger)bookID typeID:(NSInteger)typeID lessonID:(NSInteger)lessonID knowledgeID:(NSInteger)knowledgeID sentencePattern:(NSString *)senPattern english:(NSString *)english progress:(CGFloat)progress error:(NSError *__autoreleasing *)err
{
    // 先查询
    SentencePatternModel *senPatternModel = (SentencePatternModel *)[self querySentencePatternInfoWithUserID:userID humanID:humanID groupID:groupID bookID:bookID typeID:typeID lessonID:lessonID knowledgeID:knowledgeID];
    if (senPatternModel.knowledgeIDValue == knowledgeID)
    {
        // 更新数据
        [self updateSentencePatternDataWithUserID:userID humanID:humanID groupID:groupID bookID:bookID typeID:typeID lessonID:lessonID knowledgeID:knowledgeID sentencePattern:senPattern english:english progress:progress error:err];
        return;
    }
    
    NSManagedObjectContext *localContext = [NSManagedObjectContext contextForCurrentThread];
    SentencePatternModel *senPatternMD = [SentencePatternModel createInContext:localContext];
    senPatternMD.userID = userID;
    senPatternMD.typeIDValue = typeID;
    senPatternMD.lessonIDValue = lessonID;
    senPatternMD.knowledgeIDValue = knowledgeID;
    senPatternMD.sentencePattern = senPattern;
    senPatternMD.english = english;
    senPatternMD.progressValue = progress;
    
    [localContext saveOnlySelfAndWait];
    if (err) *err = [NSError errorWithDomain:@"成功保存连词成句游戏的句型数据!" code:0 userInfo:nil];
}

- (void)saveSentenceDataWithUserID:(NSString *)userID humanID:(NSInteger)humanID groupID:(NSInteger)groupID bookID:(NSInteger)bookID typeID:(NSInteger)typeID lessonID:(NSInteger)lessonID knowledgeID:(NSInteger)knowledgeID sentenceID:(NSInteger)sentenceID sentence:(NSString *)sentence worderOrder:(NSString *)worderOrder audio:(NSString *)audio error:(NSError *__autoreleasing *)err
{
    // 先查询
    SentenceModel *sentenceModel = (SentenceModel *)[self querySentenceInfoWithUserID:userID humanID:humanID groupID:groupID bookID:bookID typeID:typeID lessonID:lessonID knowledgeID:knowledgeID sentenceID:sentenceID];
    if (sentenceModel.sentenceIDValue == sentenceID)
    {
        // 更新数据
        [self updateSentenceDataWithUserID:userID humanID:humanID groupID:groupID bookID:bookID typeID:typeID lessonID:lessonID knowledgeID:knowledgeID sentenceID:sentenceID sentence:sentence worderOrder:worderOrder audio:audio error:err];
        return;
    }
    
    NSManagedObjectContext *localContext = [NSManagedObjectContext contextForCurrentThread];
    SentenceModel *sentenceMD = [SentenceModel createInContext:localContext];
    sentenceMD.userID = userID;
    sentenceMD.typeIDValue = typeID;
    sentenceMD.lessonIDValue = lessonID;
    sentenceMD.knowledgeIDValue = knowledgeID;
    sentenceMD.sentenceIDValue = sentenceID;
    sentenceMD.sentence = sentence;
    sentenceMD.worderOrder = worderOrder;
    sentenceMD.audio = audio;
    
    [localContext saveOnlySelfAndWait];
    if (err) *err = [NSError errorWithDomain:@"成功保存连词成句游戏的句子数据!" code:0 userInfo:nil];
}

// 保存中英互译游戏的数据
- (void)saveTranslationDataWithUserID:(NSString *)userID humanID:(NSInteger)humanID groupID:(NSInteger)groupID bookID:(NSInteger)bookID typeID:(NSInteger)typeID lessonID:(NSInteger)lessonID knowledgeID:(NSInteger)knowledgeID chinese:(NSString *)chinese pinyin:(NSString *)pinyin english:(NSString *)english progress:(CGFloat)progress audio:(NSString *)audio error:(NSError *__autoreleasing *)err
{
    // 先查询
    TranslationModel *transModel = (TranslationModel *)[self queryTranslationInfoWithUserID:userID humanID:humanID groupID:groupID bookID:bookID typeID:typeID lessonID:lessonID knowledgeID:knowledgeID];
    if (transModel.knowledgeIDValue == knowledgeID)
    {
        // 更新数据
        [self updateTranslationDataWithUserID:userID humanID:humanID groupID:groupID bookID:bookID typeID:typeID lessonID:lessonID knowledgeID:knowledgeID chinese:chinese pinyin:pinyin english:english progress:progress audio:audio error:err];
        return;
    }
    
    NSManagedObjectContext *localContext = [NSManagedObjectContext contextForCurrentThread];
    TranslationModel *transMD = [TranslationModel createInContext:localContext];
    transMD.userID = userID;
    transMD.typeIDValue = typeID;
    transMD.lessonIDValue = lessonID;
    transMD.knowledgeIDValue = knowledgeID;
    transMD.chinese = chinese;
    transMD.pinyin = pinyin;
    transMD.english = english;
    transMD.progressValue = progress;
    transMD.audio = audio;
    
    [localContext saveOnlySelfAndWait];
    if (err) *err = [NSError errorWithDomain:@"成功保存中英互译游戏的数据!" code:0 userInfo:nil];
}

#pragma mark - Update Data Manager
- (void)updateUserDataWithUserID:(NSString *)userID userName:(NSString *)userName userEmail:(NSString *)userEmail error:(NSError *__autoreleasing *)err
{
    NSManagedObjectContext *localContext = [NSManagedObjectContext contextForCurrentThread];
    
    NSInteger errCode = 0;
    NSString *errDomain = [NSString stringWithFormat:@"成功更新用户信息!"];
    
    UserModel *user = (UserModel *)[UserModel findFirstByAttribute:@"userID" withValue:userID inContext:localContext];
    if ([user.userID isEqualToString:userID])
    {
        user.userEmail = userEmail;
        user.userName = userName;
        [localContext saveOnlySelfAndWait];
    }
    else
    {
        errCode = -1;
        errDomain = [NSString stringWithFormat:@"更新用户信息失败!"];
    }
    if (err) *err = [NSError errorWithDomain:errDomain code:errCode userInfo:nil];
}

// 更新套
- (void)updateGroupDataWithUserID:(NSString *)userID humanID:(NSInteger)humanID groupID:(NSInteger)groupID groupName:(NSString *)groupName groupIconURL:(NSString *)groupIconURL error:(NSError *__autoreleasing *)err
{
    NSManagedObjectContext *localContext = [NSManagedObjectContext contextForCurrentThread];
    
    NSInteger errCode = 0;
    NSString *errDomain = [NSString stringWithFormat:@"成功更新书籍信息!"];
    
    GroupModel *group = [self queryGroupInfoWithUserID:userID humanID:humanID groupID:groupID];
    if (group.groupIDValue == groupID)
    {
        group.groupName = groupName;
        group.groupIconURL = groupIconURL;
        [localContext saveOnlySelfAndWait];
    }
    else
    {
        errCode = -1;
        errDomain = [NSString stringWithFormat:@"更新书籍信息失败!"];
    }
    if (err) *err = [NSError errorWithDomain:errDomain code:errCode userInfo:nil];
}

// 更新书本
- (void)updateBookDataWithUserID:(NSString *)userID humanID:(NSInteger)humanID groupID:(NSInteger)groupID bookID:(NSInteger)bookID bookName:(NSString *)bookName bookIconURL:(NSString *)bookIconURL bookAuthor:(NSString *)bookAuthor bookIntro:(NSString *)bookIntro bookPublishDate:(NSDate *)publishDate error:(NSError *__autoreleasing *)err
{
    NSManagedObjectContext *localContext = [NSManagedObjectContext contextForCurrentThread];
    
    NSInteger errCode = 0;
    NSString *errDomain = [NSString stringWithFormat:@"成功更新书本信息!"];
    
    BookModel *book = [self queryBookInfoWithUserID:userID humanID:humanID groupID:groupID bookID:bookID];
    if (book.bookIDValue == bookID)
    {
        book.bookName = bookName;
        book.bookIconURL = bookIconURL;
        book.bookAuthor = bookAuthor;
        book.bookIntro = bookIntro;
        book.bookPublishDate = publishDate;
        [localContext saveOnlySelfAndWait];
    }
    else
    {
        errCode = -1;
        errDomain = [NSString stringWithFormat:@"更新书本信息失败!"];
    }
    if (err) *err = [NSError errorWithDomain:errDomain code:errCode userInfo:nil];
}

// 更新课程
- (void)updateLessonDataWithUserID:(NSString *)userID humanID:(NSInteger)humanID groupID:(NSInteger)groupID bookID:(NSInteger)bookID typeID:(NSInteger)typeID lessonID:(NSInteger)lessonID lessonName:(NSString *)lessonName score:(NSInteger)score starAmount:(NSInteger)starAmount progress:(CGFloat)progress locked:(BOOL)locked lessonIndex:(CGFloat)lessonIndex updateTime:(NSString *)updateTime dataVersion:(CGFloat)dataVersion error:(NSError  *__autoreleasing *)err
{
    NSManagedObjectContext *localContext = [NSManagedObjectContext contextForCurrentThread];
    
    NSInteger errCode = 0;
    NSString *errDomain = [NSString stringWithFormat:@"成功更新课程信息!"];
    
    LessonModel *lesson = [self queryLessonInfoWithUserID:userID humanID:humanID groupID:groupID bookID:bookID typeID:typeID lessonID:lessonID];
    if (lesson.lessonIDValue == lessonID)
    {
        lesson.lessonName = lessonName;
        lesson.scoreValue = score;
        lesson.starAmountValue = starAmount;
        lesson.progressValue = lesson.progressValue < progress ? progress : lesson.progressValue;
        lesson.lockedValue = lesson.lockedValue ? locked : NO;
        lesson.updateTime = updateTime;
        lesson.dataVersionValue = dataVersion;
        [localContext saveOnlySelfAndWait];
    }
    else
    {
        errCode = -1;
        errDomain = [NSString stringWithFormat:@"更新课程信息失败!"];
    }
    if (err) *err = [NSError errorWithDomain:errDomain code:errCode userInfo:nil];
}

// 更新拼音游戏的数据
- (void)updatePinyinDataWithUserID:(NSString *)userID humanID:(NSInteger)humanID groupID:(NSInteger)groupID bookID:(NSInteger)bookID typeID:(NSInteger)typeID lessonID:(NSInteger)lessonID knowledgeID:(NSInteger)knowledgeID chinese:(NSString *)chinese pinyin:(NSString *)pinyin english:(NSString *)english tone:(NSString *)tone phoneme:(NSString *)phoneme phonemeCount:(NSInteger)phonemeCount progress:(CGFloat)progress audio:(NSString *)audio error:(NSError *__autoreleasing *)err
{
    NSManagedObjectContext *localContext = [NSManagedObjectContext contextForCurrentThread];
    
    NSInteger errCode = 0;
    NSString *errDomain = [NSString stringWithFormat:@"成功更新拼音游戏的数据!"];
    
    PinyinModel *pinyinMD = [self queryPinyinInfoWithUserID:userID humanID:humanID groupID:groupID bookID:bookID typeID:typeID lessonID:lessonID knowledgeID:knowledgeID];
    if (pinyinMD.knowledgeIDValue == knowledgeID)
    {
        pinyinMD.chinese = chinese;
        pinyinMD.pinyin = pinyin;
        pinyinMD.english = english;
        pinyinMD.tone = tone;
        pinyinMD.phoneme = phoneme;
        pinyinMD.phonemeCountValue = phonemeCount;
        pinyinMD.progressValue = pinyinMD.progressValue < progress ? progress : pinyinMD.progressValue;
        pinyinMD.audio = audio;
        [localContext saveOnlySelfAndWait];
    }
    else
    {
        errCode = -1;
        errDomain = [NSString stringWithFormat:@"更新拼音游戏的数据失败!"];
    }
    if (err) *err = [NSError errorWithDomain:errDomain code:errCode userInfo:nil];
}

// 更新插图猜字游戏的数据
- (void)updateWordDataWithUserID:(NSString *)userID humanID:(NSInteger)humanID groupID:(NSInteger)groupID bookID:(NSInteger)bookID typeID:(NSInteger)typeID lessonID:(NSInteger)lessonID knowledgeID:(NSInteger)knowledgeID rightWord:(NSString *)rightWord pinyin:(NSString *)pinyin english:(NSString *)english obstruction:(NSString *)obstruction progress:(CGFloat)progress audio:(NSString *)audio error:(NSError *__autoreleasing *)err
{
    NSManagedObjectContext *localContext = [NSManagedObjectContext contextForCurrentThread];
    
    NSInteger errCode = 0;
    NSString *errDomain = [NSString stringWithFormat:@"成功更新擦图猜字游戏的数据!"];
    
    WordModel *wordMD = [self queryWordInfoWithUserID:userID humanID:humanID groupID:groupID bookID:bookID typeID:typeID lessonID:lessonID knowledgeID:knowledgeID];
    if (wordMD.knowledgeIDValue == knowledgeID)
    {
        wordMD.rightWord = rightWord;
        wordMD.pinyin = pinyin;
        wordMD.english = english;
        wordMD.obstruction = obstruction;
        wordMD.progressValue = wordMD.progressValue < progress ? progress : wordMD.progressValue;
        wordMD.audio = audio;
        [localContext saveOnlySelfAndWait];
    }
    else
    {
        errCode = -1;
        errDomain = [NSString stringWithFormat:@"更新擦图猜字游戏的数据失败!"];
    }
    if (err) *err = [NSError errorWithDomain:errDomain code:errCode userInfo:nil];
}

// 更新连词成句游戏的句型的数据
- (void)updateSentencePatternDataWithUserID:(NSString *)userID humanID:(NSInteger)humanID groupID:(NSInteger)groupID bookID:(NSInteger)bookID typeID:(NSInteger)typeID lessonID:(NSInteger)lessonID knowledgeID:(NSInteger)knowledgeID sentencePattern:(NSString *)senPattern english:(NSString *)english progress:(CGFloat)progress error:(NSError *__autoreleasing *)err
{
    NSManagedObjectContext *localContext = [NSManagedObjectContext contextForCurrentThread];
    
    NSInteger errCode = 0;
    NSString *errDomain = [NSString stringWithFormat:@"成功更新连词成句游戏的句型的数据!"];
    
    SentencePatternModel *senPatternMD = [self querySentencePatternInfoWithUserID:userID humanID:humanID groupID:groupID bookID:bookID typeID:typeID lessonID:lessonID knowledgeID:knowledgeID];
    if (senPatternMD.knowledgeIDValue == knowledgeID)
    {
        senPatternMD.sentencePattern = senPattern;
        senPatternMD.english = english;
        senPatternMD.progressValue = senPatternMD.progressValue < progress ? progress : senPatternMD.progressValue;
        [localContext saveOnlySelfAndWait];
    }
    else
    {
        errCode = -1;
        errDomain = [NSString stringWithFormat:@"更新连词成句游戏的句型的数据失败!"];
    }
    if (err) *err = [NSError errorWithDomain:errDomain code:errCode userInfo:nil];
}

- (void)updateSentenceDataWithUserID:(NSString *)userID humanID:(NSInteger)humanID groupID:(NSInteger)groupID bookID:(NSInteger)bookID typeID:(NSInteger)typeID lessonID:(NSInteger)lessonID knowledgeID:(NSInteger)knowledgeID sentenceID:(NSInteger)sentenceID sentence:(NSString *)sentence worderOrder:(NSString *)worderOrder audio:(NSString *)audio error:(NSError *__autoreleasing *)err
{
    NSManagedObjectContext *localContext = [NSManagedObjectContext contextForCurrentThread];
    
    NSInteger errCode = 0;
    NSString *errDomain = [NSString stringWithFormat:@"成功更新连词成句游戏的句子的数据!"];
    
    SentenceModel *sentenceMD = [self querySentenceInfoWithUserID:userID humanID:humanID groupID:groupID bookID:bookID typeID:typeID lessonID:lessonID knowledgeID:knowledgeID sentenceID:sentenceID];
    if (sentenceMD.sentenceIDValue == sentenceID)
    {
        sentenceMD.sentence = sentence;
        sentenceMD.worderOrder = worderOrder;
        sentenceMD.audio = audio;
        [localContext saveOnlySelfAndWait];
    }
    else
    {
        errCode = -1;
        errDomain = [NSString stringWithFormat:@"更新连词成句游戏的句子的数据失败!"];
    }
    if (err) *err = [NSError errorWithDomain:errDomain code:errCode userInfo:nil];
}

// 更新中英互译游戏的数据
- (void)updateTranslationDataWithUserID:(NSString *)userID humanID:(NSInteger)humanID groupID:(NSInteger)groupID bookID:(NSInteger)bookID typeID:(NSInteger)typeID lessonID:(NSInteger)lessonID knowledgeID:(NSInteger)knowledgeID chinese:(NSString *)chinese pinyin:(NSString *)pinyin english:(NSString *)english progress:(CGFloat)progress audio:(NSString *)audio error:(NSError *__autoreleasing *)err
{
    NSManagedObjectContext *localContext = [NSManagedObjectContext contextForCurrentThread];
    
    NSInteger errCode = 0;
    NSString *errDomain = [NSString stringWithFormat:@"成功更新中英互译游戏的数据!"];
    
    TranslationModel *transMD = [self queryTranslationInfoWithUserID:userID humanID:humanID groupID:groupID bookID:bookID typeID:typeID lessonID:lessonID knowledgeID:knowledgeID];
    if (transMD.knowledgeIDValue == knowledgeID)
    {
        transMD.chinese = chinese;
        transMD.pinyin = pinyin;
        transMD.english = english;
        transMD.progressValue = transMD.progressValue < progress ? progress : transMD.progressValue;
        transMD.audio = audio;
        [localContext saveOnlySelfAndWait];
    }
    else
    {
        errCode = -1;
        errDomain = [NSString stringWithFormat:@"更新中英互译游戏的数据失败!"];
    }
    if (err) *err = [NSError errorWithDomain:errDomain code:errCode userInfo:nil];
}

#pragma mark - Search Single DataModel Data Manager
// 查询用户
- (UserModel *)queryUserInfoWithUserID:(NSString *)userID
{
    NSManagedObjectContext *localContext = [NSManagedObjectContext contextForCurrentThread];
    
    UserModel *user = (UserModel *)[UserModel findFirstByAttribute:@"userID" withValue:userID inContext:localContext];
    //NSAssert(user, @"用户信息获取出错!");
    return user;
}

// 查询套
- (GroupModel *)queryGroupInfoWithUserID:(NSString *)userID humanID:(NSInteger)humanID groupID:(NSInteger)groupID
{
    NSManagedObjectContext *localContext = [NSManagedObjectContext contextForCurrentThread];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"humanID == %@ AND groupID == %@", [NSNumber numberWithInteger:humanID], [NSNumber numberWithInteger:groupID]];
    GroupModel *group = [GroupModel findFirstWithPredicate:predicate inContext:localContext];
    return group;
}

- (NSArray *)queryAllGroupInfoWithUserID:(NSString *)userID humanID:(NSInteger)humanID
{
    //NSLog(@"%@: %d", NSStringFromSelector(_cmd), humanID);
    NSManagedObjectContext *localContext = [NSManagedObjectContext contextForCurrentThread];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"humanID == %@", [NSNumber numberWithInteger:humanID]];
    //NSArray *arrData = [GroupModel findAllWithPredicate:predicate inContext:localContext];
    NSArray *arrData = [GroupModel findAllSortedBy:@"groupID" ascending:NO withPredicate:predicate inContext:localContext];
    return arrData;
}

// 查询书本
- (BookModel *)queryBookInfoWithUserID:(NSString *)userID humanID:(NSInteger)humanID groupID:(NSInteger)groupID bookID:(NSInteger)bookID
{
    NSManagedObjectContext *localContext = [NSManagedObjectContext contextForCurrentThread];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"groupID == %@ AND bookID == %@", [NSNumber numberWithInteger:groupID], [NSNumber numberWithInteger:bookID]];
    BookModel *book = [BookModel findFirstWithPredicate:predicate inContext:localContext];
    return book;
}

- (NSArray *)queryAllBookInfoWithUserID:(NSString *)userID humanID:(NSInteger)humanID groupID:(NSInteger)groupID
{
    NSManagedObjectContext *localContext = [NSManagedObjectContext contextForCurrentThread];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"groupID == %@", [NSNumber numberWithInteger:groupID]];
    NSArray *arrData = [BookModel findAllWithPredicate:predicate inContext:localContext];
    return arrData;
}

// 查询课程
- (LessonModel *)queryLessonInfoWithUserID:(NSString *)userID humanID:(NSInteger)humanID groupID:(NSInteger)groupID bookID:(NSInteger)bookID typeID:(NSInteger)typeID lessonID:(NSInteger)lessonID
{
    NSManagedObjectContext *localContext = [NSManagedObjectContext contextForCurrentThread];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userID == %@ AND bookID == %@ AND typeID == %@ AND lessonID == %@", userID, [NSNumber numberWithInteger:bookID], [NSNumber numberWithInteger:typeID], [NSNumber numberWithInteger:lessonID]];
    LessonModel *lesson = [LessonModel findFirstWithPredicate:predicate inContext:localContext];
    return lesson;
}

- (NSArray *)queryAllLessonInfoWithUserID:(NSString *)userID humanID:(NSInteger)humanID groupID:(NSInteger)groupID bookID:(NSInteger)bookID typeID:(NSInteger)typeID
{
    NSManagedObjectContext *localContext = [NSManagedObjectContext contextForCurrentThread];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userID == %@ AND bookID == %@ AND typeID == %@", userID, [NSNumber numberWithInteger:bookID], [NSNumber numberWithInteger:typeID]];
    NSArray *arrData = [LessonModel findAllWithPredicate:predicate inContext:localContext];
    return arrData;
}

// 查询拼音游戏的所有数据
- (PinyinModel *)queryPinyinInfoWithUserID:(NSString *)userID humanID:(NSInteger)humanID groupID:(NSInteger)groupID bookID:(NSInteger)bookID typeID:(NSInteger)typeID lessonID:(NSInteger)lessonID knowledgeID:(NSInteger)knowledgeID
{
    NSManagedObjectContext *localContext = [NSManagedObjectContext contextForCurrentThread];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userID == %@ AND typeID == %@ AND lessonID == %@ AND knowledgeID == %@", userID, [NSNumber numberWithInteger:typeID], [NSNumber numberWithInteger:lessonID], [NSNumber numberWithInteger:knowledgeID]];
    PinyinModel *pinyinMD = [PinyinModel findFirstWithPredicate:predicate inContext:localContext];
    return pinyinMD;
}

- (NSArray *)queryAllPinyinInfoWithUserID:(NSString *)userID humanID:(NSInteger)humanID groupID:(NSInteger)groupID bookID:(NSInteger)bookID typeID:(NSInteger)typeID lessonID:(NSInteger)lessonID
{
    DLog(@"%@, %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    NSManagedObjectContext *localContext = [NSManagedObjectContext contextForCurrentThread];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userID == %@ AND typeID == %@ AND lessonID == %@", userID, [NSNumber numberWithInteger:typeID], [NSNumber numberWithInteger:lessonID]];
    
    NSArray *arrData = [PinyinModel findAllWithPredicate:predicate inContext:localContext];
    return arrData;
}

// 查询擦图猜字游戏的所有数据
- (WordModel *)queryWordInfoWithUserID:(NSString *)userID humanID:(NSInteger)humanID groupID:(NSInteger)groupID bookID:(NSInteger)bookID typeID:(NSInteger)typeID lessonID:(NSInteger)lessonID knowledgeID:(NSInteger)knowledgeID
{
    NSManagedObjectContext *localContext = [NSManagedObjectContext contextForCurrentThread];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userID == %@ AND typeID == %@ AND lessonID == %@ AND knowledgeID == %@", userID, [NSNumber numberWithInteger:typeID], [NSNumber numberWithInteger:lessonID], [NSNumber numberWithInteger:knowledgeID]];
    WordModel *wordMD = [WordModel findFirstWithPredicate:predicate inContext:localContext];
    return wordMD;
}

- (NSArray *)queryAllWordInfoWithUserID:(NSString *)userID humanID:(NSInteger)humanID groupID:(NSInteger)groupID bookID:(NSInteger)bookID typeID:(NSInteger)typeID lessonID:(NSInteger)lessonID
{
    NSManagedObjectContext *localContext = [NSManagedObjectContext contextForCurrentThread];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userID == %@ AND typeID == %@ AND lessonID == %@", userID, [NSNumber numberWithInteger:typeID], [NSNumber numberWithInteger:lessonID]];
    NSArray *arrData = [WordModel findAllWithPredicate:predicate inContext:localContext];
    return arrData;
}

// 查询连词成句游戏的句型的数据
- (SentencePatternModel *)querySentencePatternInfoWithUserID:(NSString *)userID humanID:(NSInteger)humanID groupID:(NSInteger)groupID bookID:(NSInteger)bookID typeID:(NSInteger)typeID lessonID:(NSInteger)lessonID knowledgeID:(NSInteger)knowledgeID
{
    NSManagedObjectContext *localContext = [NSManagedObjectContext contextForCurrentThread];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userID == %@ AND typeID == %@ AND lessonID == %@ AND knowledgeID == %@", userID, [NSNumber numberWithInteger:typeID], [NSNumber numberWithInteger:lessonID], [NSNumber numberWithInteger:knowledgeID]];
    SentencePatternModel *senPatternMD = [SentencePatternModel findFirstWithPredicate:predicate inContext:localContext];
    return senPatternMD;
}

- (NSArray *)queryAllSentencePatternInfoWithUserID:(NSString *)userID humanID:(NSInteger)humanID groupID:(NSInteger)groupID bookID:(NSInteger)bookID typeID:(NSInteger)typeID lessonID:(NSInteger)lessonID
{
    NSManagedObjectContext *localContext = [NSManagedObjectContext contextForCurrentThread];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userID == %@ AND typeID == %@ AND lessonID == %@", userID, [NSNumber numberWithInteger:typeID], [NSNumber numberWithInteger:lessonID]];
    NSArray *arrData = [SentencePatternModel findAllWithPredicate:predicate inContext:localContext];
    return arrData;
}

// 查询连词成句游戏的句子的数据
- (SentenceModel *)querySentenceInfoWithUserID:(NSString *)userID humanID:(NSInteger)humanID groupID:(NSInteger)groupID bookID:(NSInteger)bookID typeID:(NSInteger)typeID lessonID:(NSInteger)lessonID knowledgeID:(NSInteger)knowledgeID sentenceID:(NSInteger)sentenceID
{
    NSManagedObjectContext *localContext = [NSManagedObjectContext contextForCurrentThread];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userID == %@ AND typeID == %@ AND lessonID == %@ AND knowledgeID == %@ AND sentenceID == %@", userID, [NSNumber numberWithInteger:typeID], [NSNumber numberWithInteger:lessonID], [NSNumber numberWithInteger:knowledgeID], [NSNumber numberWithInteger:sentenceID]];
    SentenceModel *sentenceMD = [SentenceModel findFirstWithPredicate:predicate inContext:localContext];
    return sentenceMD;
}

- (NSArray *)queryAllSentenceInfoWithUserID:(NSString *)userID humanID:(NSInteger)humanID groupID:(NSInteger)groupID bookID:(NSInteger)bookID typeID:(NSInteger)typeID lessonID:(NSInteger)lessonID knowledgeID:(NSInteger)knowledgeID
{
    NSManagedObjectContext *localContext = [NSManagedObjectContext contextForCurrentThread];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userID == %@ AND typeID == %@ AND lessonID == %@ AND knowledgeID == %@", userID, [NSNumber numberWithInteger:typeID], [NSNumber numberWithInteger:lessonID], [NSNumber numberWithInteger:knowledgeID]];
    NSArray *arrData = [SentenceModel findAllWithPredicate:predicate inContext:localContext];
    return arrData;
}

// 查询中英互译游戏的数据
- (TranslationModel *)queryTranslationInfoWithUserID:(NSString *)userID humanID:(NSInteger)humanID groupID:(NSInteger)groupID bookID:(NSInteger)bookID typeID:(NSInteger)typeID lessonID:(NSInteger)lessonID knowledgeID:(NSInteger)knowledgeID
{
    NSManagedObjectContext *localContext = [NSManagedObjectContext contextForCurrentThread];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userID == %@ AND typeID == %@ AND lessonID == %@ AND knowledgeID == %@", userID, [NSNumber numberWithInteger:typeID], [NSNumber numberWithInteger:lessonID], [NSNumber numberWithInteger:knowledgeID]];
    TranslationModel *transMD = [TranslationModel findFirstWithPredicate:predicate inContext:localContext];
    return transMD;
}

- (NSArray *)queryAllTranslationInfoWithUserID:(NSString *)userID humanID:(NSInteger)humanID groupID:(NSInteger)groupID bookID:(NSInteger)bookID typeID:(NSInteger)typeID lessonID:(NSInteger)lessonID
{
    NSManagedObjectContext *localContext = [NSManagedObjectContext contextForCurrentThread];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userID == %@ AND typeID == %@ AND lessonID == %@", userID, [NSNumber numberWithInteger:typeID], [NSNumber numberWithInteger:lessonID]];
    NSArray *arrData = [TranslationModel findAllWithPredicate:predicate inContext:localContext];
    return arrData;
}

@end
