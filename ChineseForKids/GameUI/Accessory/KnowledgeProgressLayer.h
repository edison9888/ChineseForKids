//
//  KnowledgeProgressLayer.h
//  PinyinGame
//
//  Created by yang on 13-11-12.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "CCLayer.h"

@protocol KnowledgeProgressDelegate;

@interface KnowledgeProgressLayer : CCLayer
@property (nonatomic, unsafe_unretained)id<KnowledgeProgressDelegate>delegate;

+ (id)nodeWithLessonID:(NSString *)lessonID;

@end

@protocol KnowledgeProgressDelegate <NSObject>

@optional
- (void)knowledgeProgress:(KnowledgeProgressLayer *)layer quit:(BOOL)quit;

@end
