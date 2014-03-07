//
//  TranslateDAL.m
//  ChineseForKids
//
//  Created by yang on 13-12-13.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "TranslateDAL.h"
#import "DMDataManager.h"
#import "TranslateXMLDataParser.h"

#import "TranslationModel.h"
#import "LessonModel.h"
#import "URLUtility.h"
#import "Constants.h"

#import "GlobalDataHelper.h"
#import "CommonHelper.h"

static TranslateDAL *instance = nil;

@implementation TranslateDAL
{
    TranslateXMLDataParser *translateXMLParser;
}

+(TranslateDAL *)sharedInstance
{
    if(instance==nil)
    {
        instance=[[TranslateDAL alloc] init];
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

- (void)loadTranslateDataWithUserID:(NSString *)userID humanID:(NSInteger)humanID groupID:(NSInteger)groupID bookID:(NSInteger)bookID typeID:(NSInteger)typeID lessonID:(NSInteger)lessonID
{
    translateXMLParser = [[TranslateXMLDataParser alloc] init];
    [translateXMLParser loadTranslateXMLDataToCoreDataWithUserID:userID humanID:humanID groupID:groupID bookID:bookID typeID:typeID lessonID:lessonID error:nil];
}

- (NSString *)getTranslationGameURLParamsWithSN:(NSString *)SN UserID:(NSString *)userID HumanID:(NSString *)humanID GroupID:(NSString *)groupID BookID:(NSString *)bookID TypeID:(NSString *)typeID LessonID:(NSString *)lessonID productID:(NSString *)productID
{
    return [[URLUtility sharedInstance] getURLFromParams:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:SN, userID, typeID, lessonID, nil] forKeys:[NSArray arrayWithObjects:@"SN", @"UserID", @"GameType", @"LessonID", nil]]];
}

-(id)parseTranslationGameInfoByData:(id)resultData
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
        if (SN == [SN_BACK_TRANSLESSONINFO integerValue])
        {
            object = [self parseTranslationLessonInfo:results];
        }
    }
    return object;
}

- (NSArray *)parseTranslationLessonInfo:(id)resultData
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
        
        [self parseTranslateInfo:arrKnowledge LessonID:[lessonID integerValue]];
    }
    return nil;
}

- (NSArray *)parseTranslateInfo:(id)knowledgeData LessonID:(NSInteger)lessonID
{
    //NSMutableArray *arrKnowledge = [[NSMutableArray alloc] init];
    if ([knowledgeData isKindOfClass:[NSArray class]])
    {
        NSInteger count = [knowledgeData count];
        for (int i = 0; i < count; i++)
        {
            NSDictionary *dicData = [knowledgeData objectAtIndex:i];
            
            NSString *knowledgeID = [dicData objectForKey:@"KnowledgeID"];
            NSString *chinese     = [dicData objectForKey:@"Chinese"];
            NSString *pinyin      = [dicData objectForKey:@"Pinyin"];
            NSString *english     = [dicData objectForKey:@"English"];
            NSString *progress    = [dicData objectForKey:@"Progress"];
            NSString *audio       = [dicData objectForKey:@"Audio"];
            
            NSString *userID  = [GlobalDataHelper sharedManager].curUserID;
            NSInteger humanID = [GlobalDataHelper sharedManager].curHumanID;
            NSInteger groupID = [GlobalDataHelper sharedManager].curGroupID;
            NSInteger bookID  = [GlobalDataHelper sharedManager].curBookID;
            NSInteger typeID  = [GlobalDataHelper sharedManager].curTypeID;
            
            // 直接存入数据库中
            [[DMDataManager sharedManager] saveTranslationDataWithUserID:userID humanID:humanID groupID:groupID bookID:bookID typeID:typeID lessonID:lessonID knowledgeID:[knowledgeID integerValue] chinese:chinese pinyin:pinyin english:english progress:[progress floatValue] audio:audio error:nil];
        }
    }
    return nil;
}

#pragma mark - Memory Manager
- (void)dealloc
{
    instance = nil;
    translateXMLParser = nil;
}

@end
