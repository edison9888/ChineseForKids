//
//  PinyinNet.m
//  ChineseForKids
//
//  Created by yang on 13-12-10.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "PinyinNet.h"
#import "JSONKit.h"
#import "HttpClient.h"
#import "PinyinDAL.h"
#import "ResponseModel.h"
#import "CommonHelper.h"
#import "Constants.h"

static PinyinNet *instance = nil;

@interface PinyinNet ()
@property (nonatomic, strong)HttpClient *requestClient;

@end

@implementation PinyinNet

+ (PinyinNet *)sharedInstance
{
    if(instance==nil)
    {
        instance=[[PinyinNet alloc] init];
    }
    return instance;
}

- (void)dealloc
{
    self.requestClient=nil;
    instance=nil;
}

+(id)getPinyinGameInfoWithUserID:(NSString *)userID HumanID:(NSString *)humanID GroupID:(NSString *)groupID BookID:(NSString *)bookID TypeID:(NSString *)typeID LessonID:(NSString *)lessonID
{
    PinyinDAL *pinyinDAL = [[PinyinDAL alloc] init];
    NSString *params = [pinyinDAL getPinyinGameURLParamsWithSN:SN_SEND_TONELESSONINFO UserID:userID HumanID:humanID GroupID:groupID BookID:bookID TypeID:typeID LessonID:lessonID productID:productID()];
    
    [self sharedInstance].requestClient = [[HttpClient alloc] init];
    id jsonData = [[[self sharedInstance].requestClient postRequestFromURL:[kHostUrl stringByAppendingString:kGetToneLessonDetailInfo] params:params error:nil] objectFromJSONString];
    
    //NSLog(@"拼音数据: %@", jsonData);
    
    ResponseModel *response = [[ResponseModel alloc] init];
    response.resultInfo = [pinyinDAL parsePinyinGameInfoByData:jsonData];
    response.error = pinyinDAL.error;
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
