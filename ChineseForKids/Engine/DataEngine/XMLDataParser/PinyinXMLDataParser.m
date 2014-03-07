//
//  PinyinXMLDataParser.m
//  PinyinGame
//
//  Created by yang on 13-10-29.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "PinyinXMLDataParser.h"
#import "DMDataManager.h"
#import "HSFileManager.h"
#import "GDataXMLNode.h"
//#import "Constants.h"

@implementation PinyinXMLDataParser

- (void)loadPinyinXMLDataToCoreDataWithUserID:userID humanID:(NSInteger)humanID groupID:(NSInteger)groupID bookID:(NSInteger)bookID typeID:(NSInteger)typeID lessonID:(NSInteger)lessonID error:(NSError **)err
{
    NSString *fileName = [NSString stringWithFormat:@"ChnPinyin_L%d", lessonID];
    NSString *path = [HSFileManager xmlFilePathInBundleDirectory:@"PinyinXMLData" fileName:fileName];
    if (nil == path)
    {
        NSAssert(path != nil, @"拼音的XML数据文件路径不存在!");
        return;
    }
    NSData *dataProgress = [NSData dataWithContentsOfFile:path options:NSDataReadingMappedIfSafe error:err];
    GDataXMLDocument *xmlDoc = [[GDataXMLDocument alloc] initWithData:dataProgress options:0 error:err];
    if (nil == xmlDoc /*|| (*err).code != 0*/)
    {
        NSAssert(xmlDoc != nil, @"拼音的XML数据文件不存在!");
        return;
    }
    
    DMDataManager *dataManager = [DMDataManager sharedManager];
    NSArray *arrData = [xmlDoc nodesForXPath:@"//ChnPinyins/ChnPinyin" error:nil];
    NSInteger dataCount = [arrData count];
    
    DLog(@"%@, %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    for (int i = 0; i < dataCount; i++)
    {
        // 拼音ID从2000开始
        NSInteger pinyinID = 2000;
        // 关卡等级ID从0开始
        //NSInteger levelID  = 0;
        // 单元ID从1开始
        //NSInteger unitID   = 1;
        // 声调: 0、平声; 1、阴平; 2、阳平; 3、上声; 4、去声
        NSString *phoneme = nil;
        
        NSString *strChinese = nil;
        NSString *strEnglish = nil;
        NSString *strPinyin  = nil;
        NSString *strPinyinN = nil;
        NSString *strAudio   = nil;
        
        GDataXMLElement *element = (GDataXMLElement *)[arrData objectAtIndex:i];
        
        NSArray *arrPinyinID = [element elementsForName:@"PinyinID"];
        //NSArray *arrLevelID  = [element elementsForName:@"LevelID"];
        //NSArray *arrUnitID   = [element elementsForName:@"UnitID"];
        NSArray *arrPhoneme  = [element elementsForName:@"Phoneme"];
        NSArray *arrChinese  = [element elementsForName:@"Chinese"];
        NSArray *arrEnglish  = [element elementsForName:@"English"];
        NSArray *arrPinyin   = [element elementsForName:@"Pinyin"];
        NSArray *arrPinyinN  = [element elementsForName:@"PinyinNoPhoneme"];
        NSArray *arrAudio    = [element elementsForName:@"Audio"];
        
        NSInteger count = [arrPinyinID count];
        if (count > 0)
        {
            GDataXMLElement *pinyinIDElement = (GDataXMLElement *) [arrPinyinID objectAtIndex:0];
            pinyinID = [[pinyinIDElement stringValue] integerValue];
        }
        /*
        count = [arrLevelID count];
        if (count > 0)
        {
            GDataXMLElement *levelIDElement = (GDataXMLElement *) [arrLevelID objectAtIndex:0];
            levelID = [[levelIDElement stringValue] integerValue];
        }
        
        count = [arrUnitID count];
        if (count > 0)
        {
            GDataXMLElement *unitIDElement = (GDataXMLElement *) [arrUnitID objectAtIndex:0];
            unitID = [[unitIDElement stringValue] integerValue];
        }
        */
        count = [arrPhoneme count];
        NSInteger phonemeCount = 0;
        if (count > 0)
        {
            GDataXMLElement *phonemeElement = (GDataXMLElement *)[arrPhoneme objectAtIndex:0];
            phoneme = [phonemeElement stringValue];
            NSArray *arrPhoneme = [phoneme componentsSeparatedByString:@"|"];
            if (arrPhoneme)
            {
                phonemeCount = [arrPhoneme count];
            }
        }
        
        count = [arrChinese count];
        if (count > 0)
        {
            GDataXMLElement *chineseElement = (GDataXMLElement *)[arrChinese objectAtIndex:0];
            strChinese = [chineseElement stringValue];
        }
        
        count = [arrEnglish count];
        if (count > 0)
        {
            GDataXMLElement *englishElement = (GDataXMLElement *)[arrEnglish objectAtIndex:0];
            strEnglish = [englishElement stringValue];
        }
        
        count = [arrPinyin count];
        if (count > 0)
        {
            GDataXMLElement *pinyinElement = (GDataXMLElement *)[arrPinyin objectAtIndex:0];
            strPinyin = [pinyinElement stringValue];
        }
        
        count = [arrPinyinN count];
        if (count > 0)
        {
            GDataXMLElement *pinyinNElement = (GDataXMLElement *)[arrPinyinN objectAtIndex:0];
            strPinyinN = [pinyinNElement stringValue];
        }
        
        count = [arrAudio count];
        if (count > 0)
        {
            GDataXMLElement *audioElement = (GDataXMLElement *)[arrAudio objectAtIndex:0];
            strAudio = [audioElement stringValue];
        }
        
        //NSInteger probMini = 0;
        //NSInteger probMax  = PINYIN_SHOW_PROBABILITY;
        [dataManager savePinyinDataWithUserID:userID humanID:humanID groupID:groupID bookID:bookID typeID:typeID lessonID:lessonID knowledgeID:pinyinID chinese:strChinese pinyin:strPinyin english:strEnglish tone:phoneme phoneme:strPinyinN phonemeCount:phonemeCount progress:0.0f audio:strAudio error:nil];
    }
}

@end
