//
//  GroupDAL.m
//  ChineseForKids
//
//  Created by yang on 13-12-17.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "GroupDAL.h"
#import "GroupModel.h"
#import "URLUtility.h"
#import "Constants.h"

#import "DMDataManager.h"
#import "GlobalDataHelper.h"

static GroupDAL *instance = nil;

@implementation GroupDAL

+(GroupDAL *)sharedInstance
{
    if(instance==nil)
    {
        instance=[[GroupDAL alloc] init];
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

- (NSString *)getMaterialGroupURLParamsWithSN:(NSString *)SN UserID:(NSString *)userID HumanID:(NSString *)humanID productID:(NSString *)productID
{
    return [[URLUtility sharedInstance] getURLFromParams:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:SN, humanID, nil] forKeys:[NSArray arrayWithObjects:@"SN", @"MaterialType", nil]]];
}

- (id)parseMaterialGroupByData:(id)resultData
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
        if (SN == [SN_BACK_GROUPINFO integerValue])
        {
            object = [self parseMaterialGroup:results];
        }
    }
    return object;
}

- (NSArray *)parseMaterialGroup:(id)resultData
{
    NSMutableArray *arrGroup = [[NSMutableArray alloc] init];
    if ([resultData isKindOfClass:[NSArray class]])
    {
        NSInteger count = [resultData count];
        for (int i = 0; i < count; i++)
        {
            NSDictionary *dicData = [resultData objectAtIndex:i];
            
            NSString *groupID     = [dicData objectForKey:@"MaterialID"];
            NSString *groupName   = [dicData objectForKey:@"MaterialName"];
            NSString *groupIcoURL = [dicData objectForKey:@"MaterialURL"];
            
            NSString *userID  = [GlobalDataHelper sharedManager].curUserID;
            NSInteger humanID = [GlobalDataHelper sharedManager].curHumanID;

            // 直接存入数据库中
            [[DMDataManager sharedManager] saveGroupDataWithUserID:userID humanID:humanID groupID:[groupID integerValue] groupName:groupName groupIconURL:groupIcoURL error:nil];
            
        }
    }
    return arrGroup;
}

@end
