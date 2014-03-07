//
//  HSFileManager.h
//  HSChildrenLearnCard
//
//  Created by yang on 13-9-12.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import <Foundation/Foundation.h>

#define XML_EXTENSION  @"xml"


@interface HSFileManager : NSObject

/**
 * 获取Document目录的路径.
 * @return Document目录的路径。
 */
+ (NSString *)DocumetPath;

/**
 * 获取Bundle目录的路径.
 * @return Bundle目录的路径。
 */
+ (NSString *)BundleResourcePath;

/**
 * 获取Bundle里某个目录下面的所有xml文件路径.
 * @param directory:目录.
 * @return 所有文件的路径。
 */
+ (NSArray *)allXMLFilesInBundleDirectory:(NSString *)directory;

/**
 * 获取Bundle里某个目录下面的指定xml文件路径.
 * @param directory:目录.
 * @param fileName:不带扩展名的文件名称。
 * @return 指定文件的路径。
 */
+ (NSString *)xmlFilePathInBundleDirectory:(NSString *)directory fileName:(NSString *)fileName;

/**
 *  社会化分享时的图片地址
 *
 *  @param path 图片的存储地址
 */
//+ (NSString *)shareImagePath:(NSString *)path;

@end
