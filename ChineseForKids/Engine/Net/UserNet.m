//
//  UserNet.m
//  PinyinGame
//
//  Created by yang on 13-11-20.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "UserNet.h"
#import "JSONKit.h"
#import "HttpClient.h"
#import "UserDAL.h"
#import "ResponseModel.h"
#import "CommonHelper.h"
#import "Constants.h"
static UserNet *instance = nil;

@interface UserNet ()
@property (nonatomic, strong)HttpClient *requestClient;

@end

@implementation UserNet
+(UserNet *)sharedInstance
{
    if(instance==nil)
    {
        instance=[[UserNet alloc] init];
    }
    return instance;
}

-(void)dealloc
{
    self.requestClient=nil;
    instance=nil;
}

+ (id)startLoginWithUserEmail:(NSString *)email password:(NSString *)password
{
    UserDAL *userDAL = [[UserDAL alloc] init];
    NSString *params = [userDAL getLoginURLParamsWithSN:SN_SEND_USERLOGIN email:email password:password productID:productID()];
    
    [self sharedInstance].requestClient = [[HttpClient alloc] init];
    id jsonData = [[[self sharedInstance].requestClient postRequestFromURL:[kHostUrl stringByAppendingString:kLoginMethod] params:params error:nil] objectFromJSONString];
    
    ResponseModel *response = [[ResponseModel alloc] init];
    response.resultInfo = [userDAL parseUserByData:jsonData];
    response.error = userDAL.error;
    return response;
}

+ (id)startRegistWithUserEmail:(NSString *)email password:(NSString *)password
{
    UserDAL *userDAL = [[UserDAL alloc] init];
    NSString *params = [userDAL getRegistURLParamsWithSN:SN_SEND_REGISTER email:email password:password productID:productID() mcKey:macAddress()];
    
    [self sharedInstance].requestClient = [[HttpClient alloc] init];
    id jsonData = [[[self sharedInstance].requestClient postRequestFromURL:[kHostUrl stringByAppendingString:kRegistMethod] params:params error:nil] objectFromJSONString];
    
    ResponseModel *response = [[ResponseModel alloc] init];
    response.resultInfo = [userDAL parseUserByData:jsonData];
    response.error = userDAL.error;
    return response;
}

+ (id)startGetPasswordBackWithUserEmail:(NSString *)email
{
    UserDAL *userDAL = [[UserDAL alloc] init];
    NSString *params = [userDAL getPasswordBackURLParamsWithSN:SN_SEND_GETPWDBACK email:email productID:productID()];
    
    [self sharedInstance].requestClient = [[HttpClient alloc] init];
    id jsonData = [[[self sharedInstance].requestClient postRequestFromURL:[kHostUrl stringByAppendingString:kGetPWdBack] params:params error:nil] objectFromJSONString];
    
    ResponseModel *response = [[ResponseModel alloc] init];
    response.resultInfo = [userDAL parseUserByData:jsonData];
    response.error = userDAL.error;
    return response;
}

+ (void)cancelLogin
{
    [[self sharedInstance].requestClient cancelRequest];
}

@end
