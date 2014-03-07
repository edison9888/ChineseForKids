//
//  GameManager.m
//  PinyinGame
//
//  Created by yang on 13-10-29.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "GameManager.h"
#import "GlobalDataHelper.h"
#import "DMDataManager.h"

#import "UserModel.h"
#import "LessonModel.h"
#import "PinyinModel.h"
#import "WordModel.h"
#import "SentencePatternModel.h"
#import "TranslationModel.h"

#import "Constants.h"

// 1、全局静态对象、并置为nil。
static GameManager *gameManager = nil;

@implementation GameManager
{
    NSInteger curPinyinID;
    NSInteger curWordID;
    NSInteger curSenPatternID;
    NSInteger curTransID;
}

// 2、构造实例
+ (GameManager *)sharedManager
{
    @synchronized(self)
    {
        if (nil == gameManager)
        {
            gameManager = [[self alloc] init];
        }
    }
    return gameManager;
}

// 3、重写allocwithzone，保证只有一个实例
+ (id)allocWithZone:(struct _NSZone *)zone
{
    @synchronized(self)
    {
        if (nil == gameManager)
        {
            gameManager = [super allocWithZone:zone];
            return gameManager;
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
        if (self)
        {
            
        }
        
        return self;
    }
}

#pragma mark - Memory Manager

- (void)dealloc
{
    gameManager = nil;
    
}

#pragma mark - UserLogin Info
- (void)loginWithUserID:(NSString *)userID userName:(NSString *)userName userEmail:(NSString *)userEmail
{
    [GlobalDataHelper sharedManager].curUserID = userID;
    [GlobalDataHelper sharedManager].curUserName= userName;
    [self saveUserInfoWithUserID:userID userName:userName userEmail:userEmail];
    
}

#pragma mark - Save Data
// 用户信息
- (void)saveUserInfoWithUserID:(NSString *)userID userName:(NSString *)userName userEmail:(NSString *)userEmail
{
    [[DMDataManager sharedManager] saveUserDataWithUserID:userID userName:userName userEmail:userEmail error:nil];
}

#pragma mark - Query Data
- (NSArray *)loadGroupDataWithUserID:(NSString *)userID humanID:(NSInteger)humanID
{
    NSArray *arrGroup = [[DMDataManager sharedManager] queryAllGroupInfoWithUserID:userID humanID:humanID];
    return arrGroup;
}

- (NSArray *)loadBookDataWithUserID:(NSString *)userID humanID:(NSInteger)humanID groupID:(NSInteger)groupID
{
    NSArray *arrBook = [[DMDataManager sharedManager] queryAllBookInfoWithUserID:userID humanID:humanID groupID:groupID];
    return arrBook;
}

- (NSArray *)loadLessonDataWithUserID:(NSString *)userID humanID:(NSInteger)humanID groupID:(NSInteger)groupID bookID:(NSInteger)bookID typeID:(NSInteger)typeID
{
    NSArray *arrLesson = [[DMDataManager sharedManager] queryAllLessonInfoWithUserID:userID humanID:humanID groupID:groupID bookID:bookID typeID:typeID];

    return arrLesson;
}

- (NSArray *)loadDataWithUserID:(NSString *)userID humanID:(NSInteger)humanID groupID:(NSInteger)groupID bookID:(NSInteger)bookID typeID:(NSInteger)typeID lessonID:(NSInteger)lessonID
{
    NSArray *arrData = nil;
    switch (typeID)
    {
        case 1:
        {
            arrData = [self loadPinyinDataWithUserID:userID humanID:humanID groupID:groupID bookID:bookID typeID:typeID lessonID:lessonID];
            break;
        }
        case 2:
        {
            arrData = [self loadWordDataWithUserID:userID humanID:humanID groupID:groupID bookID:bookID typeID:typeID lessonID:lessonID];
            break;
        }
        case 3:
        {
            arrData = [self loadSentencePatternDataWithUserID:userID humanID:humanID groupID:groupID bookID:bookID typeID:typeID lessonID:lessonID];
            break;
        }
        case 4:
        {
            arrData = [self loadTranslationDataWithUserID:userID humanID:humanID groupID:groupID bookID:bookID typeID:typeID lessonID:lessonID];
            break;
        }
            
        default:
            break;
    }
    return arrData;
}

- (NSArray *)loadPinyinDataWithUserID:(NSString *)userID humanID:(NSInteger)humanID groupID:(NSInteger)groupID bookID:(NSInteger)bookID typeID:(NSInteger)typeID lessonID:(NSInteger)lessonID
{
    NSArray *arrPinyin = [[DMDataManager sharedManager] queryAllPinyinInfoWithUserID:userID humanID:humanID groupID:groupID bookID:bookID typeID:typeID lessonID:lessonID];
    //NSLog(@"拼音数据: %@", arrPinyin);
    return arrPinyin;
}

- (NSArray *)loadWordDataWithUserID:(NSString *)userID humanID:(NSInteger)humanID groupID:(NSInteger)groupID bookID:(NSInteger)bookID typeID:(NSInteger)typeID lessonID:(NSInteger)lessonID
{
    NSArray *arrWord = [[DMDataManager sharedManager] queryAllWordInfoWithUserID:userID humanID:humanID groupID:groupID bookID:bookID typeID:typeID lessonID:lessonID];
    
    return arrWord;
}

- (NSArray *)loadSentencePatternDataWithUserID:(NSString *)userID humanID:(NSInteger)humanID groupID:(NSInteger)groupID bookID:(NSInteger)bookID typeID:(NSInteger)typeID lessonID:(NSInteger)lessonID
{
    NSArray *arrSenPattern = [[DMDataManager sharedManager] queryAllSentencePatternInfoWithUserID:userID humanID:humanID groupID:groupID bookID:bookID typeID:typeID lessonID:lessonID];
    
    return arrSenPattern;
}

- (NSArray *)loadSentenceDataWithUserID:(NSString *)userID humanID:(NSInteger)humanID groupID:(NSInteger)groupID bookID:(NSInteger)bookID typeID:(NSInteger)typeID lessonID:(NSInteger)lessonID senPatternID:(NSInteger)senPatternID
{
    NSArray *arrSentence = [[DMDataManager sharedManager] queryAllSentenceInfoWithUserID:userID humanID:humanID groupID:groupID bookID:bookID typeID:typeID lessonID:lessonID knowledgeID:senPatternID];
    
    return arrSentence;
}

- (NSArray *)loadTranslationDataWithUserID:(NSString *)userID humanID:(NSInteger)humanID groupID:(NSInteger)groupID bookID:(NSInteger)bookID typeID:(NSInteger)typeID lessonID:(NSInteger)lessonID
{
    NSArray *arrTranslation = [[DMDataManager sharedManager] queryAllTranslationInfoWithUserID:userID humanID:humanID groupID:groupID bookID:bookID typeID:typeID lessonID:lessonID];
    
    return arrTranslation;
}

#pragma mark - Pick out a DataModel
- (UserModel *)pickOutUserWithUserID:(NSString *)userID
{
    UserModel *user = [[DMDataManager sharedManager] queryUserInfoWithUserID:userID];
    return user;
}

- (LessonModel *)pickOutLessonInfoWithUserID:(NSString *)userID humanID:(NSInteger)humanID groupID:(NSInteger)groupID bookID:(NSInteger)bookID typeID:(NSInteger)typeID lessonID:(NSInteger)lessonID
{
    LessonModel *lessonModel = [[DMDataManager sharedManager] queryLessonInfoWithUserID:userID humanID:humanID groupID:groupID bookID:bookID typeID:typeID lessonID:lessonID];
    return lessonModel;
}

- (LessonModel *)pickOutNexLessonInfoWithUserID:(NSString *)userID humanID:(NSInteger)humanID groupID:(NSInteger)groupID bookID:(NSInteger)bookID typeID:(NSInteger)typeID curLessonID:(NSInteger)lessonID
{
    NSArray *arrLesson = [self loadLessonDataWithUserID:userID humanID:humanID groupID:groupID bookID:bookID typeID:typeID];
    
    if (!arrLesson || [arrLesson count] <= 0) return nil;
    // 排序, 升序排列
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"lessonIndexValue" ascending:YES];
    arrLesson = [arrLesson sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    //DLog(@"所有课程: %@", arrLesson);
    
    // 当前的LessonModel
    NSInteger count = [arrLesson count];
    int i = 0;
    for (i = 0; i < count; i++)
    {
        LessonModel *curLessonModel = (LessonModel *)[arrLesson objectAtIndex:i];
        if (curLessonModel.lessonIDValue == lessonID)
        {
            break;
        }
    }
    NSInteger index = (i >= count - 1) ? (count-1) : i + 1;
    LessonModel *nexLessonModel = (LessonModel *)[arrLesson objectAtIndex:index];
    return nexLessonModel;
}

- (PinyinModel *)pickOutPinyinInfoWithUserID:(NSString *)userID humanID:(NSInteger)humanID groupID:(NSInteger)groupID bookID:(NSInteger)bookID typeID:(NSInteger)typeID lessonID:(NSInteger)lessonID
{
    // 先给当前拼音数据数组填充数据。
    NSArray *arrPinyinData = [self loadPinyinDataWithUserID:userID humanID:humanID groupID:groupID bookID:bookID typeID:typeID lessonID:lessonID];
    if (arrPinyinData)
    {
        // 排序, 升序排列
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"progressValue" ascending:YES];
        arrPinyinData = [arrPinyinData sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    }
    
    NSInteger pinyinMaxProb = 0;
    //NSLog(@"pinyin: %@", curPinyinData);
    NSInteger pinyinCount = [arrPinyinData count];
    
    PinyinModel *mdPinyin = nil;
    // 所有的一切都是建立在有数值的基础上的。
    if (pinyinCount > 0)
    {
        NSInteger tmpIndex = 0;
        // 为什么选第0个, 因为我们在加载拼音数据模型的时候是经过按probMax降序排序的。
        CGFloat progress = ((PinyinModel *)[arrPinyinData objectAtIndex:0]).progressValue;
        pinyinMaxProb = PINYIN_SHOW_PROBABILITY * (1 - progress);
        NSInteger probFactor = pinyinMaxProb > 0 ?  arc4random() % pinyinMaxProb + 1 : 0;
        
        NSInteger sameCount = 0;
        NSInteger tProbMaxValue = 0;
        //NSLog(@"概率最大值: %d", probFactor);
        
        do
        {
            //NSLog(@"循环中...");
            tmpIndex = (arc4random() % pinyinCount);
            //NSLog(@"当前索引: %d", tmpIndex);
            mdPinyin = (PinyinModel *)[arrPinyinData objectAtIndex:tmpIndex];
            CGFloat tProgress = mdPinyin.progressValue;
            tProbMaxValue = PINYIN_SHOW_PROBABILITY * (1 - tProgress);
            //NSLog(@"当前概率值: %d", tProbMaxValue);
            
            if (curPinyinID == mdPinyin.knowledgeIDValue) sameCount++;
            else sameCount = 0;
            if (sameCount >= 2) break;
        }
        // 不停地去取值, 一直到取得了概率值包含概率因子的数据模型。
        while (tProbMaxValue < probFactor || curPinyinID == mdPinyin.knowledgeIDValue);
        curPinyinID = mdPinyin.knowledgeIDValue;
    }
    //DLog(@"curPinyinData 激活: %@", curPinyinData);
    return mdPinyin;
}

- (WordModel *)pickOutWordInfoWithUserID:(NSString *)userID humanID:(NSInteger)humanID groupID:(NSInteger)groupID bookID:(NSInteger)bookID typeID:(NSInteger)typeID lessonID:(NSInteger)lessonID
{
    // 先给当前字数据数组填充数据。
    NSArray *arrWordData = [self loadWordDataWithUserID:userID humanID:humanID groupID:groupID bookID:bookID typeID:typeID lessonID:lessonID];
    //NSLog(@"擦图猜字游戏数据: %@", arrWordData);
    if (arrWordData)
    {
        // 排序, 升序排列
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"progressValue" ascending:YES];
        arrWordData = [arrWordData sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    }
    NSInteger wordMaxProb = 0;
    
    NSInteger wordCount = [arrWordData count];
    
    WordModel *wordModel = nil;
    // 所有的一切都是建立在有数值的基础上的。
    if (wordCount > 0)
    {
        NSInteger tmpIndex = 0;
        // 为什么选第0个, 因为我们在加载拼音数据模型的时候是经过按probMax降序排序的。
        CGFloat progress = ((WordModel *)[arrWordData objectAtIndex:0]).progressValue;
        wordMaxProb = PINYIN_SHOW_PROBABILITY * (1 - progress);
        NSInteger probFactor = wordMaxProb > 0 ?  arc4random() % wordMaxProb + 1 : 0;
        
        //NSInteger tmpIndex = (arc4random() % pinyinCount);
        //NSLog(@"当前索引: %d", tmpIndex);
        NSInteger sameCount = 0;
        NSInteger tProbMaxValue = 0;
        //NSLog(@"概率最大值: %d", probFactor);
        do
        {
            //NSLog(@"循环中...");
            tmpIndex = (arc4random() % wordCount);
            //NSLog(@"当前索引: %d", tmpIndex);
            wordModel = (WordModel *)[arrWordData objectAtIndex:tmpIndex];
            CGFloat tProgress = wordModel.progressValue;
            tProbMaxValue = PINYIN_SHOW_PROBABILITY * (1 - tProgress);
            //NSLog(@"当前概率值: %d", tProbMaxValue);
            
            if (curWordID == wordModel.knowledgeIDValue) sameCount++;
            else sameCount = 0;
            if (sameCount >= 2) break;
        }
        // 不停地去取值, 一直到取得了概率值包含概率因子的数据模型。
        while (tProbMaxValue < probFactor || curWordID == wordModel.knowledgeIDValue);
        curWordID = wordModel.knowledgeIDValue;
    }
    
    return wordModel;
}

- (SentencePatternModel *)pickOutSenPatternInfoWithUserID:(NSString *)userID humanID:(NSInteger)humanID groupID:(NSInteger)groupID bookID:(NSInteger)bookID typeID:(NSInteger)typeID lessonID:(NSInteger)lessonID
{
    // 先给当前字数据数组填充数据。
    NSArray *arrSenPatternData = [self loadSentencePatternDataWithUserID:userID humanID:humanID groupID:groupID bookID:bookID typeID:typeID lessonID:lessonID];
    if (arrSenPatternData)
    {
        // 排序, 升序排列
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"progressValue" ascending:YES];
        arrSenPatternData = [arrSenPatternData sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    }
    
    NSInteger senPattMaxProb = 0;
    
    NSInteger senPatternCount = [arrSenPatternData count];
    
    SentencePatternModel *senPatternModel = nil;
    // 所有的一切都是建立在有数值的基础上的。
    if (senPatternCount > 0)
    {
        //NSInteger tmpIndex = (arc4random() % senPatternCount);
        //NSLog(@"当前索引: %d", tmpIndex);
        //senPatternModel = (SentencePatternModel *)[arrSenPatternData objectAtIndex:tmpIndex];
        
        NSInteger tmpIndex = 0;
        // 为什么选第0个, 因为我们在加载拼音数据模型的时候是经过按probMax降序排序的。
        CGFloat progress = ((WordModel *)[arrSenPatternData objectAtIndex:0]).progressValue;
        senPattMaxProb = PINYIN_SHOW_PROBABILITY * (1 - progress);
        NSInteger probFactor = senPattMaxProb > 0 ?  arc4random() % senPattMaxProb + 1 : 0;
        
        //NSInteger tmpIndex = (arc4random() % pinyinCount);
        //NSLog(@"当前索引: %d", tmpIndex);
        NSInteger sameCount = 0;
        NSInteger tProbMaxValue = 0;
        do
        {
            tmpIndex = (arc4random() % senPatternCount);
            //NSLog(@"当前索引: %d", tmpIndex);
            senPatternModel = (SentencePatternModel *)[arrSenPatternData objectAtIndex:tmpIndex];
            CGFloat tProgress = senPatternModel.progressValue;
            tProbMaxValue = PINYIN_SHOW_PROBABILITY * (1 - tProgress);
            
            if (curSenPatternID == senPatternModel.knowledgeIDValue) sameCount++;
            else sameCount = 0;
            if (sameCount >= 2) break;
        }
        // 不停地去取值, 一直到取得了概率值包含概率因子的数据模型。
        while (tProbMaxValue < probFactor || curSenPatternID == senPatternModel.knowledgeIDValue);
        curSenPatternID = senPatternModel.knowledgeIDValue;
    }
    
    return senPatternModel;
}

#pragma mark - 游戏成绩计算
- (NSInteger)starsNumberWithScore:(NSInteger)score
{
    // 当获取当前等级的得分时,就计算出获得的星星数。
    NSInteger starNum = 0;
    if(score >= 10 && score <= 200)
    {
        starNum = 1;
    }
    else if(score > 200 && score < 2000)
    {
        starNum = 2;
    }
    else if(score >= 2000)
    {
        starNum = 3;
    }
    return starNum;
}

@end
