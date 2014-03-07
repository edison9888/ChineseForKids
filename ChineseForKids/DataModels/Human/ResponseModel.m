//
//  ResponseModel.m
//  PinyinGame
//
//  Created by yang on 13-11-19.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "ResponseModel.h"

@implementation ResponseModel
@synthesize statuCode;
@synthesize response;
@synthesize resultInfo;
@synthesize error;

#pragma mark - Memory Manager
- (void)dealloc
{
    self.response = nil;
    self.resultInfo = nil;
    self.error = nil;
}

@end
