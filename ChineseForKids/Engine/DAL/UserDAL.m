//
//  UserDAL.m
//  PinyinGame
//
//  Created by yang on 13-11-19.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "UserDAL.h"
#import "UserModel.h"
#import "URLUtility.h"
#import "DMDataManager.h"
#import "Constants.h"

static UserDAL *instance = nil;

@implementation UserDAL

+(UserDAL *)sharedInstance
{
    if(instance==nil)
    {
        instance=[[UserDAL alloc] init];
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

-(void)dealloc
{
    instance = nil;
}

/*
 Method = UserLogin & SN = 8000 & UDID = XXX & Random = 130101010101 & SoftWareID = 1 & Version = 1.0
 */



- (NSString *)getLoginURLParamsWithSN:(NSString *)SN email:(NSString *)email password:(NSString *)password productID:(NSString *)productID
{
    return [[URLUtility sharedInstance] getURLFromParams:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:SN, email, password, productID, nil] forKeys:[NSArray arrayWithObjects:@"SN", @"Email", @"Password", @"ProductID", nil]]];
}

- (NSString *)getRegistURLParamsWithSN:(NSString *)SN email:(NSString *)email password:(NSString *)password productID:(NSString *)productID mcKey:(NSString *)mcKey
{
    return [[URLUtility sharedInstance] getURLFromParams:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:SN, email, password, productID, mcKey, nil] forKeys:[NSArray arrayWithObjects:@"SN", @"Email", @"Password", @"ProductID", @"MCKEY", nil]]];
}

- (NSString *)getPasswordBackURLParamsWithSN:(NSString *)SN email:(NSString *)email productID:(NSString *)productID
{
    return [[URLUtility sharedInstance] getURLFromParams:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:SN, email, productID, nil] forKeys:[NSArray arrayWithObjects:@"SN", @"Email", @"ProductID", nil]]];
}

- (id)parseUserByData:(id)resultData
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
        // 目前根据协议, 只有用户登陆才会返回有具体信息。
        if (SN == [SN_BACK_USERLOGIN integerValue])
        {
            object = [self parseUserLogin:results];
        }
    }
    return object;
}

- (UserModel *)parseUserLogin:(id)resultData
{
    UserModel *userModel = nil;
    if ([resultData isKindOfClass:[NSDictionary class]])
    {
        NSString *userID    = [resultData objectForKey:@"UserID"];
        NSString *userEmail = [resultData objectForKey:@"Email"];
        NSString *userName  = [resultData objectForKey:@"UserName"];
        
        [[DMDataManager sharedManager] saveUserDataWithUserID:userID userName:userName userEmail:userEmail error:nil];
        
        userModel = (UserModel *)[[DMDataManager sharedManager] queryUserInfoWithUserID:userID];
    }
    return userModel;
}

@end
