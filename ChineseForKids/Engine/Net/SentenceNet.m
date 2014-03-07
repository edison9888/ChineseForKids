//
//  SentenceNet.m
//  ChineseForKids
//
//  Created by yang on 13-12-13.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "SentenceNet.h"
#import "JSONKit.h"
#import "HttpClient.h"
#import "SentenceDAL.h"
#import "ResponseModel.h"
#import "CommonHelper.h"
#import "Constants.h"

static SentenceNet *instance = nil;

@interface SentenceNet ()
@property (nonatomic, strong)HttpClient *requestClient;

@end

@implementation SentenceNet

+ (SentenceNet *)sharedInstance
{
    if(instance==nil)
    {
        instance=[[SentenceNet alloc] init];
    }
    return instance;
}

- (void)dealloc
{
    self.requestClient=nil;
    instance=nil;
}

+(id)getSentenceGameInfoWithUserID:(NSString *)userID HumanID:(NSString *)humanID GroupID:(NSString *)groupID BookID:(NSString *)bookID TypeID:(NSString *)typeID LessonID:(NSString *)lessonID
{
    SentenceDAL *sentenceDAL = [[SentenceDAL alloc] init];
    NSString *params = [sentenceDAL getSentenceGameURLParamsWithSN:SN_SEND_SENTENCELESSONINFO UserID:userID HumanID:humanID GroupID:groupID BookID:bookID TypeID:typeID LessonID:lessonID productID:productID()];
    
    [self sharedInstance].requestClient = [[HttpClient alloc] init];
    id jsonData = [[[self sharedInstance].requestClient postRequestFromURL:[kHostUrl stringByAppendingString:kGetOrderWordLessonDetailInfo] params:params error:nil] objectFromJSONString];
    
    DLog(@"连词成句数据: %@", jsonData);
    
    ResponseModel *response = [[ResponseModel alloc] init];
    response.resultInfo = [sentenceDAL parseSentenceGameInfoByData:jsonData];
    response.error = sentenceDAL.error;
    return response;
}

+(void)cancelRequest
{
    [[self sharedInstance].requestClient cancelRequest];
}

+ (BOOL)isRequestCanceled
{
    return [[self sharedInstance].requestClient isRequestCanceled];
}

@end
