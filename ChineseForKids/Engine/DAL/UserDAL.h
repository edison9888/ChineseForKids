//
//  UserDAL.h
//  PinyinGame
//
//  Created by yang on 13-11-19.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>

//@class UserResultModel;

@interface UserDAL : NSObject
@property (nonatomic, strong, readonly)NSError *error;

+(UserDAL *)sharedInstance;

- (NSString *)getLoginURLParamsWithSN:(NSString *)SN email:(NSString *)email password:(NSString *)password productID:(NSString *)productID;

- (NSString *)getRegistURLParamsWithSN:(NSString *)SN email:(NSString *)email password:(NSString *)password productID:(NSString *)productID mcKey:(NSString *)mcKey;

- (NSString *)getPasswordBackURLParamsWithSN:(NSString *)SN email:(NSString *)email productID:(NSString *)productID;

-(id)parseUserByData:(id)resultData;

@end
