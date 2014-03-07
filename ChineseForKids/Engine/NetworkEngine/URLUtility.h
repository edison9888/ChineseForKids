//
//  URLUtility.h
//  PinyinGame
//
//  Created by yang on 13-11-19.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface URLUtility : NSObject

+(URLUtility *)sharedInstance;

/**
 *  根据传入的参数列表params, 构造出服务器需要的数据格式: key1=value1 & key2=value2.
 *  然后再返回给HttpClient, 然后根据请求类型组合url。
 *    -- 如果是 GET 请求, 那么直接将这里返回的字符串附在url的后面。
 *    -- 如果是 POST 请求, 那么将这里返回的字符串放到postbody中去。
 *
 *  @param params 网络请求的参数列表
 *
 *  @return 返回根据参数列表组装成的特殊格式的字符串。
 */
-(NSString *)getURLFromParams:(NSDictionary *)params;

@end
