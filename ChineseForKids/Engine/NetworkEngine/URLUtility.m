//
//  URLUtility.m
//  PinyinGame
//
//  Created by yang on 13-11-19.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "URLUtility.h"

static URLUtility *instance;

@implementation URLUtility

// 2、构造实例
+ (URLUtility *)sharedInstance
{
    @synchronized(self)
    {
        if (nil == instance)
        {
            instance = [[self alloc] init];
        }
    }
    return instance;
}


// 3、重写allocwithzone，保证只有一个实例
+ (id)allocWithZone:(struct _NSZone *)zone
{
    @synchronized(self)
    {
        if (nil == instance)
        {
            instance = [super allocWithZone:zone];
            return instance;
        }
    }
    return nil;
}

// 4、重写copywithzone
- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)init
{
    @synchronized(self)
    {
        self = [super init];
        
        
        return self;
    }
}


#pragma mark - 
- (NSString *)getURLFromParams:(NSDictionary *)params
{
    NSString *url = @"";
    for (NSString *key in [params allKeys])
    {
        NSString *value = [params objectForKey:key];
        url = [url stringByAppendingFormat:@"%@=%@&", key, value];
    }
    return [url substringToIndex:[url length]-1];
}

#pragma mark - Memory Manager
- (void)dealloc
{
    instance = nil;
}

@end
