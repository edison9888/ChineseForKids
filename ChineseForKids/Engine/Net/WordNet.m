//
//  WordNet.m
//  ChineseForKids
//
//  Created by yang on 13-12-12.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "WordNet.h"
#import "JSONKit.h"
#import "HttpClient.h"
#import "WordDAL.h"
#import "ResponseModel.h"
#import "CommonHelper.h"
#import "Constants.h"

static WordNet *instance = nil;

@interface WordNet ()
@property (nonatomic, strong)HttpClient *requestClient;

@end

@implementation WordNet

+ (WordNet *)sharedInstance
{
    if(instance==nil)
    {
        instance=[[WordNet alloc] init];
    }
    return instance;
}

- (void)dealloc
{
    self.requestClient=nil;
    instance=nil;
}

+(id)getWordGameInfoWithUserID:(NSString *)userID HumanID:(NSString *)humanID GroupID:(NSString *)groupID BookID:(NSString *)bookID TypeID:(NSString *)typeID LessonID:(NSString *)lessonID
{
    WordDAL *wordDAL = [[WordDAL alloc] init];
    NSString *params = [wordDAL getWordGameURLParamsWithSN:SN_SEND_WORDLESSONINFO UserID:userID HumanID:humanID GroupID:groupID BookID:bookID TypeID:typeID LessonID:lessonID productID:productID()];
    
    [self sharedInstance].requestClient = [[HttpClient alloc] init];
    id jsonData = [[[self sharedInstance].requestClient postRequestFromURL:[kHostUrl stringByAppendingString:kGetRubImageLessonDetailInfo] params:params error:nil] objectFromJSONString];
    
    DLog(@"擦图猜字游戏数据: %@", jsonData);
    
    ResponseModel *response = [[ResponseModel alloc] init];
    response.resultInfo = [wordDAL parseWordGameInfoByData:jsonData];
    response.error = wordDAL.error;
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
