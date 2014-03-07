//
//  BookCoverDAL.m
//  ChineseForKids
//
//  Created by yang on 13-12-17.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "BookCoverDAL.h"
#import "BookModel.h"
#import "URLUtility.h"
#import "Constants.h"

#import "DMDataManager.h"
#import "GlobalDataHelper.h"
#import "CommonHelper.h"

static BookCoverDAL *instance = nil;

@implementation BookCoverDAL

+(BookCoverDAL *)sharedInstance
{
    if(instance==nil)
    {
        instance=[[BookCoverDAL alloc] init];
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

- (NSString *)getBookCoverURLParamsWithSN:(NSString *)SN UserID:(NSString *)userID HumanID:(NSString *)humanID GroupID:(NSString *)groupID productID:(NSString *)productID
{
    return [[URLUtility sharedInstance] getURLFromParams:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:SN, groupID, nil] forKeys:[NSArray arrayWithObjects:@"SN", @"MaterialID", nil]]];
}

-(id)parseBookCoverInfoByData:(id)resultData
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
        if (SN == [SN_BACK_BOOKINFO integerValue])
        {
            object = [self parseBookCoverInfo:results];
        }
    }
    return object;
}

- (NSArray *)parseBookCoverInfo:(id)resultData
{
    //NSMutableArray *arrBook = [[NSMutableArray alloc] init];
    if ([resultData isKindOfClass:[NSArray class]])
    {
        NSInteger count = [resultData count];
        for (int i = 0; i < count; i++)
        {
            NSDictionary *dicData = [resultData objectAtIndex:i];
            
            NSString *bookID     = [dicData objectForKey:@"BookID"];
            NSString *bookName   = [dicData objectForKey:@"BookName"];
            NSString *bookIcoURL = [dicData objectForKey:@"BookIconURL"];
            NSString *bookAuthor = [dicData objectForKey:@"BookAuthor"];
            NSString *bookIntro  = [dicData objectForKey:@"BookIntro"];
            NSString *bookPublishDate = [dicData objectForKey:@"BookPublishDate"];
            
            NSString *userID  = [GlobalDataHelper sharedManager].curUserID;
            NSInteger humanID = [GlobalDataHelper sharedManager].curHumanID;
            NSInteger groupID = [GlobalDataHelper sharedManager].curGroupID;
            
            // 直接存入数据库中
            [[DMDataManager sharedManager] saveBookDataWithUserID:userID humanID:humanID groupID:groupID bookID:[bookID integerValue] bookName:bookName bookIconURL:bookIcoURL bookAuthor:bookAuthor bookIntro:bookIntro bookPublishDate:[CommonHelper dateFromString:bookPublishDate] error:nil];
        }
    }
    return nil;
}

@end
