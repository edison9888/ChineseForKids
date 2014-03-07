//
//  UploadLessonDAL.m
//  ChineseForKids
//
//  Created by yang on 13-12-18.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "UploadLessonDAL.h"
#import "URLUtility.h"
#import "Constants.h"

#import "GlobalDataHelper.h"
#import "CommonHelper.h"

static UploadLessonDAL *instance = nil;

@implementation UploadLessonDAL

+(UploadLessonDAL *)sharedInstance
{
    if(instance==nil)
    {
        instance=[[UploadLessonDAL alloc] init];
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

- (NSString *)getUploadLessonInfoURLParamsWithSN:(NSString *)SN UserID:(NSString *)userID HumanID:(NSString *)humanID GroupID:(NSString *)groupID BookID:(NSString *)bookID TypeID:(NSString *)typeID LessonID:(NSString *)lessonID Score:(NSString *)score StarAmount:(NSString *)starAmount Progress:(NSString *)progress Locked:(NSString *)locked UpdateTime:(NSString *)updateTime DataVersion:(NSString *)dataVersion Knowledges:(NSString *)knowledges productID:(NSString *)productID
{
    return [[URLUtility sharedInstance] getURLFromParams:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:SN, userID, typeID, lessonID, score, starAmount, progress, locked, updateTime, dataVersion, knowledges, nil] forKeys:[NSArray arrayWithObjects:@"SN", @"UserID", @"GameType", @"LessonID", @"Score", @"StarAmount", @"Progress", @"Locked", @"UpdateTime", @"DataVersion", @"Knowledges", nil]]];
}

-(id)parseUploadLessonInfoByData:(id)resultData
{
    id object = nil;
    _error = [NSError errorWithDomain:@"获取信息错误!" code:1 userInfo:nil];
    if ([resultData isKindOfClass:[NSDictionary class]])
    {
        BOOL success = [[resultData objectForKey:@"Success"] boolValue];
        NSString *message = [resultData objectForKey:@"Message"];
        NSInteger errorCode = success ? 0 : 1;
        //NSLog(@"errorCode: %d", errorCode);
        _error = [NSError errorWithDomain:message code:errorCode userInfo:nil];
    }
    return object;
}

#pragma mark - Memory Manager
- (void)dealloc
{
    instance = nil;
}

@end
