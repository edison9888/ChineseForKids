//
//  LessonDAL.m
//  ChineseForKids
//
//  Created by yang on 13-12-10.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "LessonDAL.h"
#import "LessonModel.h"
#import "URLUtility.h"
#import "Constants.h"

#import "DMDataManager.h"
#import "GlobalDataHelper.h"
#import "CommonHelper.h"

static LessonDAL *instance = nil;

@implementation LessonDAL

+(LessonDAL *)sharedInstance
{
    if(instance==nil)
    {
        instance=[[LessonDAL alloc] init];
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

-(void)dealloc
{
    instance = nil;
}

- (NSString *)getLessonsURLParamsWithSN:(NSString *)SN UserID:(NSString *)userID HumanID:(NSString *)humanID GroupID:(NSString *)groupID BookID:(NSString *)bookID TypeID:(NSString *)typeID productID:(NSString *)productID
{
    return [[URLUtility sharedInstance] getURLFromParams:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:SN, userID, bookID, typeID, nil] forKeys:[NSArray arrayWithObjects:@"SN", @"UserID", @"BookID", @"GameType", nil]]];
}

-(id)parseLessonsInfoByData:(id)resultData
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
        if (SN == [SN_BACK_LESSONINFO integerValue])
        {
            object = [self parseLessonsInfo:results];
        }
    }
    return object;
}

- (NSArray *)parseLessonsInfo:(id)resultData
{
    //NSMutableArray *arrLesson = [[NSMutableArray alloc] init];
    if ([resultData isKindOfClass:[NSArray class]])
    {
        NSInteger count = [resultData count];
        for (int i = 0; i < count; i++)
        {
            NSDictionary *dicData = [resultData objectAtIndex:i];
            
            NSString *lessonID     = [dicData objectForKey:@"LessonID"];
            NSString *lessonName   = [dicData objectForKey:@"LessonName"];
            NSString *score        = [dicData objectForKey:@"Score"];
            NSString *starAmount   = [dicData objectForKey:@"StarAmount"];
            NSString *progress     = [dicData objectForKey:@"Progress"];
            NSString *locked       = [dicData objectForKey:@"Locked"];
            NSString *lessonIndex  = [dicData objectForKey:@"LessonIndex"];
            NSString *dateTime     = [dicData objectForKey:@"UpdateTime"];
            NSString *dataVersion  = [dicData objectForKey:@"DataVersion"];
    
            NSString *userID  = [GlobalDataHelper sharedManager].curUserID;
            NSInteger humanID = [GlobalDataHelper sharedManager].curHumanID;
            NSInteger groupID = [GlobalDataHelper sharedManager].curGroupID;
            NSInteger bookID  = [GlobalDataHelper sharedManager].curBookID;
            NSInteger typeID  = [GlobalDataHelper sharedManager].curTypeID;
        
            // 直接存入数据库中
            [[DMDataManager sharedManager] saveLessonDataWithUserID:userID humanID:humanID groupID:groupID bookID:bookID typeID:typeID lessonID:[lessonID integerValue] lessonName:lessonName score:[score integerValue] starAmount:[starAmount integerValue] progress:[progress floatValue] locked:[locked boolValue] lessonIndex:[lessonIndex floatValue] updateTime:dateTime dataVersion:[dataVersion floatValue] error:nil];
            
        }
    }
    return nil;
}

@end
