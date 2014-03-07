//
//  TranslateXMLDataParser.m
//  ChineseForKids
//
//  Created by yang on 13-12-13.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "TranslateXMLDataParser.h"
#import "DMDataManager.h"
#import "HSFileManager.h"
#import "GDataXMLNode.h"

@implementation TranslateXMLDataParser

- (void)loadTranslateXMLDataToCoreDataWithUserID:(NSString *)userID humanID:(NSInteger)humanID groupID:(NSInteger)groupID bookID:(NSInteger)bookID typeID:(NSInteger)typeID lessonID:(NSInteger)lessonID error:(NSError *__autoreleasing *)err
{
    NSString *fileName = [NSString stringWithFormat:@"ChnTranslate_L%d", lessonID];
    NSString *path = [HSFileManager xmlFilePathInBundleDirectory:@"TranslateXMLData" fileName:fileName];
    if (nil == path)
    {
        NSAssert(path != nil, @"中英互译游戏的XML数据文件路径不存在!");
        return;
    }
    NSData *dataProgress = [NSData dataWithContentsOfFile:path options:NSDataReadingMappedIfSafe error:err];
    GDataXMLDocument *xmlDoc = [[GDataXMLDocument alloc] initWithData:dataProgress options:0 error:err];
    if (nil == xmlDoc /*|| (*err).code != 0*/)
    {
        NSAssert(xmlDoc != nil, @"中英互译游戏的XML数据文件不存在!");
        return;
    }
    
    DMDataManager *dataManager = [DMDataManager sharedManager];
    NSArray *arrData = [xmlDoc nodesForXPath:@"//GameWordImages/GameWordImage" error:nil];
    NSInteger dataCount = [arrData count];
    
    for (int i = 0; i < dataCount; i++)
    {
        NSString *oid = nil;
        NSString *word = nil;
        NSString *audio = nil;
        NSString *english = nil;
        
        GDataXMLElement *element = [arrData objectAtIndex:i];
        
        NSArray *oidArray = [element elementsForName:@"Oid"];
        NSArray *wordArray = [element elementsForName:@"Word"];
        NSArray *audioArray = [element elementsForName:@"Audio"];
        NSArray *englishArray = [element elementsForName:@"English"];
        
        if (oidArray.count > 0) {
            GDataXMLElement *oidElement = (GDataXMLElement *) [oidArray objectAtIndex:0];
            oid = [oidElement stringValue];
        }
        
        if (wordArray.count > 0) {
            GDataXMLElement *wordElement = (GDataXMLElement *) [wordArray objectAtIndex:0];
            word = [wordElement stringValue];
        }
        if (audioArray.count > 0) {
            GDataXMLElement *audioElement = (GDataXMLElement *) [audioArray objectAtIndex:0];
            audio = [audioElement stringValue];
        }
        if (englishArray.count > 0) {
            GDataXMLElement *englishElement = (GDataXMLElement *)[englishArray objectAtIndex:0];
            english = [englishElement stringValue];
        }
        
        [dataManager saveTranslationDataWithUserID:userID humanID:humanID groupID:groupID bookID:bookID typeID:typeID lessonID:lessonID knowledgeID:[oid integerValue] chinese:word pinyin:@"" english:english progress:0.0f audio:audio error:nil];
    }
}

@end
