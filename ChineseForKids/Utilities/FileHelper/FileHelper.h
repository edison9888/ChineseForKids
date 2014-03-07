//
//  FileHelper.h
//  ChineseForKids
//
//  Created by on 12-10-7.
//  Copyright (c) 2012年 . All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileHelper : NSObject

+(FileHelper *)sharedInstance;

-(NSString *)getDocumentPath;//得到系统Document文件夹路径

-(BOOL)isExistPath:(NSString *)path;
-(BOOL)createDirectory:(NSString *)path;
-(void)writeObject:(id)obj toDestionPath:(NSString *)destionPath;
-(id)getObjectFromPath:(NSString *)path;

-(void)archiverModel:(id)model filePath:(NSString *)filePath;
-(id)unArchiverModel:(NSString *)filePath;

-(BOOL)removeItemAtPath:(NSString *)path;//删除文件或者文件夹下的所有内容
-(int)getFileCountByPath:(NSString *)directoryPath;//获取文件夹下的文件个数，出去D.store
-(NSMutableArray *)getFilelistByPath:(NSString *)path onlyDirectory:(BOOL)flag;//得到路径下的文件夹

-(void)moveFilesFrom:(NSString *)path toDestionPath:(NSString *)destionPath;
@end
