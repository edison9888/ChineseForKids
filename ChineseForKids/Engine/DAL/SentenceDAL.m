//
//  SentenceDAL.m
//  ChineseForKids
//
//  Created by yang on 13-12-13.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "SentenceDAL.h"
#import "DMDataManager.h"
#import "SentenceXMLDataParser.h"

#import "SentencePatternModel.h"
#import "SentenceModel.h"
#import "LessonModel.h"
#import "URLUtility.h"
#import "Constants.h"

#import "GlobalDataHelper.h"
#import "CommonHelper.h"

static SentenceDAL *instance = nil;

@implementation SentenceDAL
{
    SentenceXMLDataParser *sentenceXMLParser;
}

+(SentenceDAL *)sharedInstance
{
    if(instance==nil)
    {
        instance=[[SentenceDAL alloc] init];
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

- (void)loadSentenceDataWithUserID:(NSString *)userID humanID:(NSInteger)humanID groupID:(NSInteger)groupID bookID:(NSInteger)bookID typeID:(NSInteger)typeID lessonID:(NSInteger)lessonID
{
    sentenceXMLParser = [[SentenceXMLDataParser alloc] init];
    [sentenceXMLParser loadSentenceXMLDataToCoreDataWithUserID:userID humanID:humanID groupID:groupID bookID:bookID typeID:typeID lessonID:lessonID error:nil];
}

- (NSString *)getSentenceGameURLParamsWithSN:(NSString *)SN UserID:(NSString *)userID HumanID:(NSString *)humanID GroupID:(NSString *)groupID BookID:(NSString *)bookID TypeID:(NSString *)typeID LessonID:(NSString *)lessonID productID:(NSString *)productID
{
    return [[URLUtility sharedInstance] getURLFromParams:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:SN, userID, typeID, lessonID, nil] forKeys:[NSArray arrayWithObjects:@"SN", @"UserID", @"GameType", @"LessonID", nil]]];
}

-(id)parseSentenceGameInfoByData:(id)resultData
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
        if (SN == [SN_BACK_SENTENCELESSONINFO integerValue])
        {
            object = [self parseSenPatternLessonInfo:results];
        }
    }
    return object;
}

- (NSArray *)parseSenPatternLessonInfo:(id)resultData
{
    //NSMutableArray *arrSenPattern = [[NSMutableArray alloc] init];
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
        
        [self parseSenPatternInfo:arrKnowledge LessonID:[lessonID integerValue]];
    }
    return nil;
}

- (NSArray *)parseSenPatternInfo:(id)knowledgeData LessonID:(NSInteger)lessonID
{
    //NSMutableArray *arrKnowledge = [[NSMutableArray alloc] init];
    if ([knowledgeData isKindOfClass:[NSArray class]])
    {
        NSInteger count = [knowledgeData count];
        for (int i = 0; i < count; i++)
        {
            NSDictionary *dicData = [knowledgeData objectAtIndex:i];
            
            NSString *knowledgeID = [dicData objectForKey:@"KnowledgeID"];
            NSString *senPattern  = [dicData objectForKey:@"SentencePattern"];
            NSString *progress    = [dicData objectForKey:@"Progress"];
            NSString *english     = [dicData objectForKey:@"English"];
            NSArray *arrSentences = [dicData objectForKey:@"Sentences"];
            
            NSString *userID  = [GlobalDataHelper sharedManager].curUserID;
            NSInteger humanID = [GlobalDataHelper sharedManager].curHumanID;
            NSInteger groupID = [GlobalDataHelper sharedManager].curGroupID;
            NSInteger bookID  = [GlobalDataHelper sharedManager].curBookID;
            NSInteger typeID  = [GlobalDataHelper sharedManager].curTypeID;
            
            // 直接存入数据库中
            [[DMDataManager sharedManager] saveSentencePatternDataWithUserID:userID humanID:humanID groupID:groupID bookID:bookID typeID:typeID lessonID:lessonID knowledgeID:[knowledgeID integerValue] sentencePattern:senPattern english:english progress:[progress floatValue] error:nil];
            [self parseSentenceInfo:arrSentences LessonID:lessonID KnowledgeID:[knowledgeID integerValue]];
        }
    }
    return nil;
}

- (NSArray *)parseSentenceInfo:(id)sentenceData LessonID:(NSInteger)lessonID KnowledgeID:(NSInteger)knowledgeID
{
    //NSMutableArray *arrSentence = [[NSMutableArray alloc] init];
    if ([sentenceData isKindOfClass:[NSArray class]])
    {
        NSInteger count = [sentenceData count];
        for (int i = 0; i < count; i++)
        {
            NSDictionary *dicData = [sentenceData objectAtIndex:i];
            
            NSString *sentenceID  = [dicData objectForKey:@"SentenceID"];
            NSString *sentence    = [dicData objectForKey:@"Sentence"];
            NSString *worderOrder = [dicData objectForKey:@"WorderOrder"];
            NSString *audio       = [dicData objectForKey:@"Audio"];
            
            NSString *userID  = [GlobalDataHelper sharedManager].curUserID;
            NSInteger humanID = [GlobalDataHelper sharedManager].curHumanID;
            NSInteger groupID = [GlobalDataHelper sharedManager].curGroupID;
            NSInteger bookID  = [GlobalDataHelper sharedManager].curBookID;
            NSInteger typeID  = [GlobalDataHelper sharedManager].curTypeID;
            
            worderOrder = [worderOrder stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            DLog(@"sentence: %@; worderOrder: %@", sentence, worderOrder);
            
            // 直接存入数据库中
            [[DMDataManager sharedManager] saveSentenceDataWithUserID:userID humanID:humanID groupID:groupID bookID:bookID typeID:typeID lessonID:lessonID knowledgeID:knowledgeID sentenceID:[sentenceID integerValue] sentence:sentence worderOrder:worderOrder audio:audio error:nil];
        }
    }
    return nil;
}

#pragma mark - Memory Manager
- (void)dealloc
{
    instance = nil;
    sentenceXMLParser = nil;
}

@end
