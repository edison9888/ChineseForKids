//
//  BookCoverDAL.h
//  ChineseForKids
//
//  Created by yang on 13-12-17.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BookCoverDAL : NSObject

@property (nonatomic, strong, readonly)NSError *error;

+(BookCoverDAL *)sharedInstance;

- (NSString *)getBookCoverURLParamsWithSN:(NSString *)SN UserID:(NSString *)userID HumanID:(NSString *)humanID GroupID:(NSString *)groupID productID:(NSString *)productID;

-(id)parseBookCoverInfoByData:(id)resultData;

@end
