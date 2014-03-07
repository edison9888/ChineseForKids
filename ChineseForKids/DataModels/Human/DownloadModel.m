//
//  DownloadModel.m
//  ChineseForKids
//
//  Created by yang on 13-12-18.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "DownloadModel.h"

@implementation DownloadModel
@synthesize lessonID;
@synthesize progress;
@synthesize updateTime;
@synthesize dataVersion;
@synthesize dataURL;

#pragma mark - Memory Manager
- (void)dealloc
{
    self.updateTime = nil;
    self.dataURL = nil;
}

@end
