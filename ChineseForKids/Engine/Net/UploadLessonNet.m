//
//  UploadLessonNet.m
//  ChineseForKids
//
//  Created by yang on 13-12-18.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "UploadLessonNet.h"
#import "JSONKit.h"
#import "HttpClient.h"
#import "UploadLessonDAL.h"
#import "ResponseModel.h"
#import "CommonHelper.h"
#import "Constants.h"

static UploadLessonNet *instance = nil;

@interface UploadLessonNet ()
@property (nonatomic, strong)HttpClient *requestClient;

@end

@implementation UploadLessonNet
+ (UploadLessonNet *)sharedInstance
{
    if(instance==nil)
    {
        instance=[[UploadLessonNet alloc] init];
    }
    return instance;
}

- (void)dealloc
{
    self.requestClient=nil;
    instance=nil;
}

+(id)uploadLessonInfoWithUserID:(NSString *)userID HumanID:(NSString *)humanID GroupID:(NSString *)groupID BookID:(NSString *)bookID TypeID:(NSString *)typeID LessonID:(NSString *)lessonID Score:(NSString *)score StarAmount:(NSString *)starAmount Progress:(NSString *)progress Locked:(NSString *)locked UpdateTime:(NSString *)updateTime DataVersion:(NSString *)dataVersion Knowledges:(NSString *)knowledges
{
    UploadLessonDAL *uploadDAL = [[UploadLessonDAL alloc] init];
    NSString *params = [uploadDAL getUploadLessonInfoURLParamsWithSN:SN_SEND_UPLOADLESSONINFO UserID:userID HumanID:humanID GroupID:groupID BookID:bookID TypeID:typeID LessonID:lessonID Score:score StarAmount:starAmount Progress:progress Locked:locked UpdateTime:updateTime DataVersion:dataVersion Knowledges:knowledges productID:productID()];
    
    [self sharedInstance].requestClient = [[HttpClient alloc] init];
    id jsonData = [[[self sharedInstance].requestClient postRequestFromURL:[kHostUrl stringByAppendingString:kUpdateLessonDetailInfo] params:params error:nil] objectFromJSONString];
    
    ResponseModel *response = [[ResponseModel alloc] init];
    response.resultInfo = [uploadDAL parseUploadLessonInfoByData:jsonData];
    response.error = uploadDAL.error;
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
