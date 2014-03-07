//
//  GroupNet.m
//  ChineseForKids
//
//  Created by yang on 13-12-17.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "GroupNet.h"
#import "JSONKit.h"
#import "HttpClient.h"
#import "GroupDAL.h"
#import "ResponseModel.h"
#import "CommonHelper.h"
#import "Constants.h"

static GroupNet *instance = nil;

@interface GroupNet ()
@property (nonatomic, strong)HttpClient *requestClient;

@end

@implementation GroupNet
+ (GroupNet *)sharedInstance
{
    if(instance==nil)
    {
        instance=[[GroupNet alloc] init];
    }
    return instance;
}

- (void)dealloc
{
    self.requestClient=nil;
    instance=nil;
}

+ (id)getMaterialGroupInfoWithUserID:(NSString *)userID HumanID:(NSString *)humanID
{
    GroupDAL *groupDAL = [[GroupDAL alloc] init];
    NSString *params = [groupDAL getMaterialGroupURLParamsWithSN:SN_SEND_GROUPINFO UserID:userID HumanID:humanID productID:productID()];
    
    [self sharedInstance].requestClient = [[HttpClient alloc] init];
    id jsonData = [[[self sharedInstance].requestClient postRequestFromURL:[kHostUrl stringByAppendingString:kGroupInfo] params:params error:nil] objectFromJSONString];
    
    ResponseModel *response = [[ResponseModel alloc] init];
    response.resultInfo = [groupDAL parseMaterialGroupByData:jsonData];
    response.error = groupDAL.error;
    return response;
}

+ (void)cancelRequest
{
    [[self sharedInstance].requestClient cancelRequest];
}

+ (BOOL)isRequestCanceled
{
    return [[self sharedInstance].requestClient isRequestCanceled];
}

@end
