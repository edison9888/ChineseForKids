//
//  DownloadLessonDAL.m
//  ChineseForKids
//
//  Created by yang on 13-12-18.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "DownloadLessonDAL.h"
#import "DownloadModel.h"
#import "URLUtility.h"
#import "Constants.h"

#import "GlobalDataHelper.h"
#import "CommonHelper.h"

static DownloadLessonDAL *instance = nil;

@implementation DownloadLessonDAL

+(DownloadLessonDAL *)sharedInstance
{
    if(instance==nil)
    {
        instance=[[DownloadLessonDAL alloc] init];
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

- (NSString *)getDownloadLessonInfoURLParamsWithSN:(NSString *)SN UserID:(NSString *)userID HumanID:(NSString *)humanID GroupID:(NSString *)groupID BookID:(NSString *)bookID TypeID:(NSString *)typeID LessonID:(NSString *)lessonID productID:(NSString *)productID
{
    return [[URLUtility sharedInstance] getURLFromParams:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:SN, userID, bookID, typeID, lessonID, nil] forKeys:[NSArray arrayWithObjects:@"SN", @"UserID", @"BookID", @"GameType", @"LessonID", nil]]];
}

-(id)parseDownloadLessonInfoByData:(id)resultData
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
        if (SN == [SN_BACK_DOWNLOADLESSONDATA integerValue])
        {
            object = [self parseDownloadLessonInfo:results];
        }
    }
    return object;
}

- (DownloadModel *)parseDownloadLessonInfo:(id)resultData
{
    DownloadModel *downloadModel = nil;
    if ([resultData isKindOfClass:[NSDictionary class]])
    {
        NSString *lessonID     = [resultData objectForKey:@"LessonID"];
        NSString *progress     = [resultData objectForKey:@"Progress"];
        NSString *dateTime     = [resultData objectForKey:@"UpdateTime"];
        NSString *dataVersion  = [resultData objectForKey:@"DataVersion"];
        NSString *dataURL      = [resultData objectForKey:@"DataURL"];
        
        downloadModel = [[DownloadModel alloc] init];
        downloadModel.lessonID = [lessonID integerValue];
        downloadModel.progress = [progress floatValue];
        downloadModel.updateTime = dateTime;
        downloadModel.dataVersion = [dataVersion floatValue];
        downloadModel.dataURL = dataURL;
    }
    return downloadModel;
}

#pragma mark - Memory Manager
- (void)dealloc
{
    instance = nil;
}

@end
