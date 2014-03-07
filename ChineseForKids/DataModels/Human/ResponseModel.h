//
//  ResponseModel.h
//  PinyinGame
//
//  Created by yang on 13-11-19.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  网络请求返回的数据模型。
 */

@interface ResponseModel : NSObject

@property (nonatomic, readwrite)NSInteger statuCode;
@property (nonatomic, copy)NSString *response;
@property (nonatomic, strong)id resultInfo;
@property (nonatomic, strong)NSError *error;

@end
