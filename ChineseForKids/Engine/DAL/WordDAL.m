//
//  WordDAL.m
//  ChineseForKids
//
//  Created by yang on 13-12-12.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "WordDAL.h"
#import "DMDataManager.h"
#import "WordXMLDataParser.h"

#import "WordModel.h"
#import "LessonModel.h"
#import "URLUtility.h"
#import "Constants.h"

#import "GlobalDataHelper.h"
#import "CommonHelper.h"

static WordDAL *instance = nil;

@implementation WordDAL
{
    WordXMLDataParser *wordXMLParser;
}

+(WordDAL *)sharedInstance
{
    if(instance==nil)
    {
        instance=[[WordDAL alloc] init];
    }
    return instance;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}

- (void)loadWordDataWithUserID:(NSString *)userID humanID:(NSInteger)humanID groupID:(NSInteger)groupID bookID:(NSInteger)bookID typeID:(NSInteger)typeID lessonID:(NSInteger)lessonID
{
    wordXMLParser = [[WordXMLDataParser alloc] init];
    [wordXMLParser loadWordXMLDataToCoreDataWithUserID:userID humanID:humanID groupID:groupID bookID:bookID typeID:typeID lessonID:lessonID error:nil];
}

- (NSString *)getWordGameURLParamsWithSN:(NSString *)SN UserID:(NSString *)userID HumanID:(NSString *)humanID GroupID:(NSString *)groupID BookID:(NSString *)bookID TypeID:(NSString *)typeID LessonID:(NSString *)lessonID productID:(NSString *)productID
{
    return [[URLUtility sharedInstance] getURLFromParams:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:SN, userID, typeID, lessonID, nil] forKeys:[NSArray arrayWithObjects:@"SN", @"UserID", @"GameType", @"LessonID", nil]]];
}

-(id)parseWordGameInfoByData:(id)resultData
{
    id object = nil;
    _error = [NSError errorWithDomain:@"获取信息错误!" code:1 userInfo:nil];
    if ([resultData isKindOfClass:[NSDictionary class]])
    {
        NSInteger SN = [[resultData objectForKey:@"SN"] integerValue];
        BOOL success = [[resultData objectForKey:@"Success"] boolValue];
        NSString *message = [resultData objectForKey:@"Message"];
        id results = [resultData objectForKey:@"Results"];
        NSInteger errorCode = success ? 0 : 1;
        //NSLog(@"errorCode: %d", errorCode);
        _error = [NSError errorWithDomain:message code:errorCode userInfo:nil];
        // 目前根据协议, 只有用户登陆才会返回有具体信息。
        if (SN == [SN_BACK_WORDLESSONINFO integerValue])
        {
            object = [self parseWordLessonInfo:results];
        }
    }
    return object;
}

- (NSArray *)parseWordLessonInfo:(id)resultData
{
    //NSMutableArray *arrWord = [[NSMutableArray alloc] init];
    if ([resultData isKindOfClass:[NSDictionary class]])
    {
        NSString *lessonID     = [resultData objectForKey:@"LessonID"];
        NSString *lessonName   = [resultData objectForKey:@"LessonName"];
        NSString *score        = [resultData objectForKey:@"Score"];
        NSString *starAmount   = [resultData objectForKey:@"StarAmount"];
        NSString *progress     = [resultData objectForKey:@"Progress"];
        NSString *locked       = [resultData objectForKey:@"Locked"];
        NSString *dateTime     = [resultData objectForKey:@"UpdateTime"];
        NSString *dataVersion  = [resultData objectForKey:@"DataVersion"];
        NSArray *arrKnowledge  = [resultData objectForKey:@"Knowledges"];
        
        NSString *userID  = [GlobalDataHelper sharedManager].curUserID;
        NSInteger humanID = [GlobalDataHelper sharedManager].curHumanID;
        NSInteger groupID = [GlobalDataHelper sharedManager].curGroupID;
        NSInteger bookID  = [GlobalDataHelper sharedManager].curBookID;
        NSInteger typeID  = [GlobalDataHelper sharedManager].curTypeID;
        
        // 直接存入数据库中
        [[DMDataManager sharedManager] saveLessonDataWithUserID:userID humanID:humanID groupID:groupID bookID:bookID typeID:typeID lessonID:[lessonID integerValue] lessonName:lessonName score:[score integerValue] starAmount:[starAmount integerValue] progress:[progress floatValue] locked:[locked boolValue] lessonIndex:0.0f updateTime:dateTime dataVersion:[dataVersion floatValue] error:nil];
        
        [self parseWordGameInfo:arrKnowledge LessonID:[lessonID integerValue]];
    }
    return nil;
}

- (NSArray *)parseWordGameInfo:(id)knowledgeData LessonID:(NSInteger)lessonID
{
    //NSMutableArray *arrKnowledge = [[NSMutableArray alloc] init];
    if ([knowledgeData isKindOfClass:[NSArray class]])
    {
        NSInteger count = [knowledgeData count];
        for (int i = 0; i < count; i++)
        {
            NSDictionary *dicData = [knowledgeData objectAtIndex:i];
            
            NSString *knowledgeID = [dicData objectForKey:@"KnowledgeID"];
            NSString *rightWord   = [dicData objectForKey:@"Chinese"];
            NSString *pinyin      = [dicData objectForKey:@"Pinyin"];
            NSString *english     = [dicData objectForKey:@"English"];
            NSString *obstruction = [dicData objectForKey:@"Obstruction"];
            NSString *progress    = [dicData objectForKey:@"Progress"];
            NSString *audio       = [dicData objectForKey:@"Audio"];
            
            NSString *userID  = [GlobalDataHelper sharedManager].curUserID;
            NSInteger humanID = [GlobalDataHelper sharedManager].curHumanID;
            NSInteger groupID = [GlobalDataHelper sharedManager].curGroupID;
            NSInteger bookID  = [GlobalDataHelper sharedManager].curBookID;
            NSInteger typeID  = [GlobalDataHelper sharedManager].curTypeID;
            
            // 直接存入数据库中
            [[DMDataManager sharedManager] saveWordDataWithUserID:userID humanID:humanID groupID:groupID bookID:bookID typeID:typeID lessonID:lessonID knowledgeID:[knowledgeID integerValue] rightWord:rightWord pinyin:pinyin english:english obstruction:obstruction progress:[progress floatValue] audio:audio error:nil];
        }
    }
    return nil;
}

#pragma mark - Memory Manager
- (void)dealloc
{
    instance = nil;
    wordXMLParser = nil;
}

@end
