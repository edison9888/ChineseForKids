//
//  PredicateHelper.h
//  PinyinGame
//
//  Created by yang on 13-11-21.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PredicateHelper : NSObject

/**
 *  检查email地址是否合法
 *
 *  @param email 传入的email地址
 *
 *  @return 返回是否合法
 */
+ (BOOL)validateEmail:(NSString *)email;

/**
 *  检查密码格式是否合法
 *
 *  @param passWord 密码
 *
 *  @return 返回是否合法
 */
+ (BOOL)validatePassword:(NSString *)passWord;

@end
