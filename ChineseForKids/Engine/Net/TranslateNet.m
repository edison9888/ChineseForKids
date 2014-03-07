//
//  TranslateNet.m
//  ChineseForKids
//
//  Created by yang on 13-12-13.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "TranslateNet.h"
#import "JSONKit.h"
#import "HttpClient.h"
#import "TranslateDAL.h"
#import "ResponseModel.h"
#import "CommonHelper.h"
#import "Constants.h"

static TranslateNet *instance = nil;

@interface TranslateNet ()
@property (nonatomic, strong)HttpClient *requestClient;

@end

@implementation TranslateNet
+ (TranslateNet *)sharedInstance
{
    if(instance==nil)
    {
        instance=[[TranslateNet alloc] init];
    }
    return instance;
}

- (void)dealloc
{
    self.requestClient = nil;
    instance = nil;
}

+(id)getTranslationGameInfoWithUserID:(NSString *)userID HumanID:(NSString *)humanID GroupID:(NSString *)groupID BookID:(NSString *)bookID TypeID:(NSString *)typeID LessonID:(NSString *)lessonID
{
    TranslateDAL *translateDAL = [[TranslateDAL alloc] init];
    NSString *params = [translateDAL getTranslationGameURLParamsWithSN:SN_SEND_TRANSLESSONINFO UserID:userID HumanID:humanID GroupID:groupID BookID:bookID TypeID:typeID LessonID:lessonID productID:productID()];
    
    [self sharedInstance].requestClient = [[HttpClient alloc] init];
    id jsonData = [[[self sharedInstance].requestClient postRequestFromURL:[kHostUrl stringByAppendingString:kGetTransLessonDetailInfo] params:params error:nil] objectFromJSONString];
    
    ResponseModel *response = [[ResponseModel alloc] init];
    response.resultInfo = [translateDAL parseTranslationGameInfoByData:jsonData];
    response.error = translateDAL.error;
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
