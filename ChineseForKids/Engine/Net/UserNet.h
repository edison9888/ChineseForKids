//
//  UserNet.h
//  PinyinGame
//
//  Created by yang on 13-11-20.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserNet : NSObject

+ (id)startLoginWithUserEmail:(NSString *)email password:(NSString *)password;
+ (id)startRegistWithUserEmail:(NSString *)email password:(NSString *)password;
+ (id)startGetPasswordBackWithUserEmail:(NSString *)email;

+ (void)cancelLogin;

@end
