//
//  PreLoadDataManager.h
//  PinyinGame
//
//  Created by yang on 13-10-30.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 预加载数据管理类, 该类只管理预加载的数据。
 */
@interface PreLoadDataManager : NSObject

// 根据传入的游戏ID获取对应的预加载文件名
- (NSString *)preLoadDataFileNameWithGameID:(NSString *)gameID;

// 根据传入的游戏ID获取对应的预加载数据字段
- (NSDictionary *)preLoadDataWithGameID:(NSString *)gamdID;

@end
