//
//  BookCoverNet.h
//  ChineseForKids
//
//  Created by yang on 13-12-17.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BookCoverNet : NSObject

+ (id)getBookCoverInfoWithUserID:(NSString *)userID HumanID:(NSString *)humanID GroupID:(NSString *)groupID;

+ (void)cancelRequest;

+ (BOOL)isRequestCanceled;

@end
