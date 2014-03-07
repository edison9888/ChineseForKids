//
//  GameRubImageParser.m
//  ChineseForKids
//
//  Created by 唐 希 on 13-8-29.
//  Copyright (c) 2013年 Allen. All rights reserved.
//

#import "WordXMLDataParser.h"
#import "DMDataManager.h"
#import "HSFileManager.h"
#import "GDataXMLNode.h"

@implementation WordXMLDataParser

- (void)loadWordXMLDataToCoreDataWithUserID:(NSString *)userID humanID:(NSInteger)humanID groupID:(NSInteger)groupID bookID:(NSInteger)bookID typeID:(NSInteger)typeID lessonID:(NSInteger)lessonID error:(NSError *__autoreleasing *)err
{
    NSString *fileName = [NSString stringWithFormat:@"ChnWord_L%d", lessonID];
    NSString *path = [HSFileManager xmlFilePathInBundleDirectory:@"WordXMLData" fileName:fileName];
    if (nil == path)
    {
        NSAssert(path != nil, @"擦图猜字的XML数据文件路径不存在!");
        return;
    }
    NSData *dataProgress = [NSData dataWithContentsOfFile:path options:NSDataReadingMappedIfSafe error:err];
    GDataXMLDocument *xmlDoc = [[GDataXMLDocument alloc] initWithData:dataProgress options:0 error:err];
    if (nil == xmlDoc /*|| (*err).code != 0*/)
    {
        NSAssert(xmlDoc != nil, @"擦图猜字的XML数据文件不存在!");
        return;
    }
    
    DMDataManager *dataManager = [DMDataManager sharedManager];
    NSArray *arrData = [xmlDoc nodesForXPath:@"//RubImage/GuessWord/items" error:nil];
    NSInteger dataCount = [arrData count];
    
    for (int i = 0; i < dataCount; i++)
    {
        GDataXMLElement *element = [arrData objectAtIndex:i];
        NSArray *items = [element elementsForName:@"item"];
        
        NSString *rightWord = @"";
        NSString *obstruction = @"";
        for (GDataXMLElement *element in items)
        {
            NSArray *correctAnswerArray = [element elementsForName:@"correctAnswer"];
            NSArray *WordArray = [element elementsForName:@"Word"];
            
            NSInteger correctAnswer = 0;
            NSString *word = @"";
            
            if ([correctAnswerArray count] > 0) {
                GDataXMLElement *knowledgeElement = (GDataXMLElement *) [correctAnswerArray objectAtIndex:0];
                correctAnswer = [[knowledgeElement stringValue] integerValue];
            }
            if (WordArray.count > 0) {
                GDataXMLElement *sentenceElement = (GDataXMLElement *) [WordArray objectAtIndex:0];
                word = [sentenceElement stringValue];
            }
            if (1 == correctAnswer){
                rightWord = word;
            }else{
                obstruction = [obstruction stringByAppendingFormat:@"%@|", word];
            }
        }
        obstruction = [obstruction substringToIndex:[obstruction length]-1];
        
        [dataManager saveWordDataWithUserID:userID humanID:humanID groupID:groupID bookID:bookID typeID:typeID lessonID:lessonID knowledgeID:i rightWord:rightWord pinyin:@"" english:@"" obstruction:obstruction progress:0.0f audio:@"" error:nil];
    }
}

@end
