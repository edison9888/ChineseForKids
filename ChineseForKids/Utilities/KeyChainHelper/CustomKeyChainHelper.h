//
//  CustomKeyChainHelper.h
//  KtvDecisionMaking
//
//  Created by yang on 13-4-25.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const KEY_USERNAME;
extern NSString * const KEY_PASSWORD;

@interface CustomKeyChainHelper : NSObject

+ (void)saveUserName:(NSString *)userName userNameService:(NSString *)userNameService password:(NSString *)password passwordService:(NSString *)pwdService;

+ (void)deleteWithUserNameService:(NSString *)userNameService passwordService:(NSString *)pwdService;

+ (NSString *)getUserNameWithService:(NSString *)userNameService;
+ (NSString *)getPasswordWithService:(NSString *)pwdService;

@end
