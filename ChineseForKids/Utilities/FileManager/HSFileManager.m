//
//  HSFileManager.m
//  HSChildrenLearnCard
//
//  Created by yang on 13-9-12.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "HSFileManager.h"
#import "Constants.h"
#import "cocos2d.h"


@implementation HSFileManager

+ (NSString *)DocumetPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

+ (NSString *)BundleResourcePath
{
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    return resourcePath;
}

+ (NSArray *)allXMLFilesInBundleDirectory:(NSString *)directory
{
    NSArray *arrPaths = [[NSBundle mainBundle] pathsForResourcesOfType:XML_EXTENSION inDirectory:directory];
    return arrPaths;
}

+ (NSString *)xmlFilePathInBundleDirectory:(NSString *)directory fileName:(NSString *)fileName
{
    NSString *filePath = [NSString stringWithFormat:@"%@/%@.%@", directory, fileName, XML_EXTENSION];
    NSString *path = [[self BundleResourcePath] stringByAppendingPathComponent:filePath];
    return path;
}


@end
