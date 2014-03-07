//
//  SentenceXMLDataParser.m
//  ChineseForKids
//
//  Created by yang on 13-12-13.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "SentenceXMLDataParser.h"
#import "DMDataManager.h"
#import "HSFileManager.h"
#import "GDataXMLNode.h"

@implementation SentenceXMLDataParser

- (void)loadSentenceXMLDataToCoreDataWithUserID:(NSString *)userID humanID:(NSInteger)humanID groupID:(NSInteger)groupID bookID:(NSInteger)bookID typeID:(NSInteger)typeID lessonID:(NSInteger)lessonID error:(NSError *__autoreleasing *)err
{
    NSString *fileName = [NSString stringWithFormat:@"ChnSentence_L%d", lessonID];
    NSString *path = [HSFileManager xmlFilePathInBundleDirectory:@"SentenceXMLData" fileName:fileName];
    if (nil == path)
    {
        NSAssert(path != nil, @"连词成句游戏的XML数据文件路径不存在!");
        return;
    }
    NSData *dataProgress = [NSData dataWithContentsOfFile:path options:NSDataReadingMappedIfSafe error:err];
    GDataXMLDocument *xmlDoc = [[GDataXMLDocument alloc] initWithData:dataProgress options:0 error:err];
    if (nil == xmlDoc /*|| (*err).code != 0*/)
    {
        NSAssert(xmlDoc != nil, @"连词成句游戏的XML数据文件不存在!");
        return;
    }
    
    DMDataManager *dataManager = [DMDataManager sharedManager];
    NSArray *arrData = [xmlDoc nodesForXPath:@"//GameOrderWords/GameOrderWord" error:nil];
    NSInteger dataCount = [arrData count];
    
    for (int i = 0; i < dataCount; i++)
    {
        NSInteger knowledgeID = 0;
        NSString *senPattern = nil;
        
        GDataXMLElement *element = [arrData objectAtIndex:i];
        NSArray *arrKnowledgeID = [element elementsForName:@"KnowledgeID"];
        NSArray *arrSentencePattern = [element elementsForName:@"SentencePattern"];
        NSArray *arrSentences = [element elementsForName:@"Sentences"];
        
        NSInteger count = [arrKnowledgeID count];
        if (count > 0)
        {
            GDataXMLElement *knowledgeIDElement = (GDataXMLElement *) [arrKnowledgeID objectAtIndex:0];
            knowledgeID = [[knowledgeIDElement stringValue] integerValue];
        }
        
        count = [arrSentencePattern count];
        if (count > 0)
        {
            GDataXMLElement *senPatternElement = (GDataXMLElement *) [arrSentencePattern objectAtIndex:0];
            senPattern = [senPatternElement stringValue];
        }
        
        NSInteger sentenCount = [arrSentences count];
        for (int j = 0; j < sentenCount; j++)
        {
            NSInteger sentenceID = 0;
            NSString *sentence   = nil;
            NSString *wordOrder  = nil;
            NSString *audio      = nil;
            
            GDataXMLElement *elementSenten = [arrSentences objectAtIndex:j];
            NSArray *arrSentenceID    = [elementSenten elementsForName:@"SentenceID"];
            NSArray *arrSentence      = [elementSenten elementsForName:@"Sentence"];
            NSArray *arrOrderSentence = [elementSenten elementsForName:@"OrderSentence"];
            
            NSInteger senCount = [arrSentenceID count];
            if (senCount > 0)
            {
                GDataXMLElement *sentenceIDElement = (GDataXMLElement *) [arrSentenceID objectAtIndex:0];
                sentenceID = [[sentenceIDElement stringValue] integerValue];
            }
            
            senCount = [arrSentence count];
            if (senCount > 0)
            {
                GDataXMLElement *sentenceElement = (GDataXMLElement *) [arrSentence objectAtIndex:0];
                sentence = [sentenceElement stringValue];
            }
            
            senCount = [arrOrderSentence count];
            if (senCount > 0)
            {
                GDataXMLElement *wordOrderElement = (GDataXMLElement *) [arrOrderSentence objectAtIndex:0];
                wordOrder = [wordOrderElement stringValue];
            }
            
            audio = [NSString stringWithFormat:@"%@.mp3", sentence];
            
            [dataManager saveSentenceDataWithUserID:userID humanID:humanID groupID:groupID bookID:bookID typeID:typeID lessonID:lessonID knowledgeID:knowledgeID sentenceID:sentenceID sentence:sentence worderOrder:wordOrder audio:audio error:nil];
        }
        
        [dataManager saveSentencePatternDataWithUserID:userID humanID:humanID groupID:groupID bookID:bookID typeID:typeID lessonID:lessonID knowledgeID:knowledgeID sentencePattern:senPattern english:@"" progress:0.0f error:nil];
    }
}

@end
