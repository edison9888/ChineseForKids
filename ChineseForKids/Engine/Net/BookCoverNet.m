//
//  BookCoverNet.m
//  ChineseForKids
//
//  Created by yang on 13-12-17.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "BookCoverNet.h"
#import "JSONKit.h"
#import "HttpClient.h"
#import "BookCoverDAL.h"
#import "ResponseModel.h"
#import "CommonHelper.h"
#import "Constants.h"

static BookCoverNet *instance = nil;

@interface BookCoverNet ()
@property (nonatomic, strong)HttpClient *requestClient;

@end

@implementation BookCoverNet
+ (BookCoverNet *)sharedInstance
{
    if(instance==nil)
    {
        instance=[[BookCoverNet alloc] init];
    }
    return instance;
}

- (void)dealloc
{
    self.requestClient=nil;
    instance=nil;
}

+(id)getBookCoverInfoWithUserID:(NSString *)userID HumanID:(NSString *)humanID GroupID:(NSString *)groupID
{
    BookCoverDAL *bookDAL = [[BookCoverDAL alloc] init];
    NSString *params = [bookDAL getBookCoverURLParamsWithSN:SN_SEND_BOOKINFO UserID:userID HumanID:humanID GroupID:groupID productID:productID()];
    
    [self sharedInstance].requestClient = [[HttpClient alloc] init];
    id jsonData = [[[self sharedInstance].requestClient postRequestFromURL:[kHostUrl stringByAppendingString:kBookInfo] params:params error:nil] objectFromJSONString];
    
    ResponseModel *response = [[ResponseModel alloc] init];
    response.resultInfo = [bookDAL parseBookCoverInfoByData:jsonData];
    response.error = bookDAL.error;
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
