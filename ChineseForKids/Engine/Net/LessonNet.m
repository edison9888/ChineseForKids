//
//  LessonNet.m
//  ChineseForKids
//
//  Created by yang on 13-12-10.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "LessonNet.h"
#import "JSONKit.h"
#import "HttpClient.h"
#import "LessonDAL.h"
#import "ResponseModel.h"
#import "CommonHelper.h"
#import "Constants.h"

static LessonNet *instance = nil;

@interface LessonNet ()
@property (nonatomic, strong)HttpClient *requestClient;

@end

@implementation LessonNet

+ (LessonNet *)sharedInstance
{
    if(instance==nil)
    {
        instance=[[LessonNet alloc] init];
    }
    return instance;
}

- (void)dealloc
{
    self.requestClient=nil;
    instance=nil;
}

+(id)getLessonsInfoWithUserID:(NSString *)userID HumanID:(NSString *)humanID GroupID:(NSString *)groupID BookID:(NSString *)bookID TypeID:(NSString *)typeID
{
    LessonDAL *lessonDAL = [[LessonDAL alloc] init];
    NSString *params = [lessonDAL getLessonsURLParamsWithSN:SN_SEND_LESSONINFO UserID:userID HumanID:humanID GroupID:groupID BookID:bookID TypeID:typeID productID:productID()];
    
    [self sharedInstance].requestClient = [[HttpClient alloc] init];
    id jsonData = [[[self sharedInstance].requestClient postRequestFromURL:[kHostUrl stringByAppendingString:kGetLessons] params:params error:nil] objectFromJSONString];
    
    //NSLog(@"课程数据: %@", jsonData);
    
    ResponseModel *response = [[ResponseModel alloc] init];
    response.resultInfo = [lessonDAL parseLessonsInfoByData:jsonData];
    response.error = lessonDAL.error;
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
