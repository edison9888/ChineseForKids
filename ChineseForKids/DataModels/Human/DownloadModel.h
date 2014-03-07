//
//  DownloadModel.h
//  ChineseForKids
//
//  Created by yang on 13-12-18.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DownloadModel : NSObject

@property (nonatomic, readwrite)NSInteger lessonID;
@property (nonatomic, readwrite)CGFloat progress;
@property (nonatomic, copy)NSString *updateTime;
@property (nonatomic, readwrite)CGFloat dataVersion;
@property (nonatomic, copy)NSString *dataURL;

@end
