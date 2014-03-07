//
//  GroupDAL.h
//  ChineseForKids
//
//  Created by yang on 13-12-17.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GroupDAL : NSObject

@property (nonatomic, strong, readonly)NSError *error;

+(GroupDAL *)sharedInstance;

- (NSString *)getMaterialGroupURLParamsWithSN:(NSString *)SN UserID:(NSString *)userID HumanID:(NSString *)humanID productID:(NSString *)productID;

-(id)parseMaterialGroupByData:(id)resultData;

@end
