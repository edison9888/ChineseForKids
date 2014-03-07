//
//  GroupNet.h
//  ChineseForKids
//
//  Created by yang on 13-12-17.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GroupNet : NSObject

+ (id)getMaterialGroupInfoWithUserID:(NSString *)userID HumanID:(NSString *)humanID;

+ (void)cancelRequest;

+ (BOOL)isRequestCanceled;

@end
