//
//  TimeProgressControl.m
//  PinyinGame
//
//  Created by yang on 13-11-2.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "WordTimeControl.h"

@implementation WordTimeControl

+ (id)timeProgressControlWithParentNode:(CCNode *)parentNode
{
    return [[self alloc] initWithParentNode:parentNode];
}

- (id)initWithParentNode:(CCNode *)parentNode
{
    CCLOG(@"%@; %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    if (self = [super initWithParentNode:parentNode])
    {
        spTimer.position = ccp(parentNode.boundingBox.size.width*0.85f, parentNode.boundingBox.size.height*0.949f);//ccp(parentNode.boundingBox.size.width*0.15f, parentNode.boundingBox.size.height*0.949f);
        
        spProgressBg.rotation = 0;
        spProgressBg.position = ccp(spTimer.position.x-spProgressBg.boundingBox.size.width*0.5f-spTimer.boundingBox.size.width*0.5f, parentNode.boundingBox.size.height*0.94f);//ccp(spTimer.position.x+spProgressBg.boundingBox.size.width*0.5f+spTimer.boundingBox.size.width*0.5f, parentNode.boundingBox.size.height*0.94f);
        
        spProgressRedBg.rotation = 0;
        spProgressRedBg.position = spProgressBg.position;
        
        progress.rotation = 0;
        progress.position = spProgressBg.position;
    }
    return self;
}

#pragma mark - Memory Manager
- (void)dealloc
{
    CCLOG(@"%@: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    [spTimer removeFromParentAndCleanup:YES];
    [spProgressBg removeFromParentAndCleanup:YES];
    [spProgressRedBg removeFromParentAndCleanup:YES];
    
    [progress stopAllActions];
    [progress removeFromParentAndCleanup:YES];
    
    spTimer = nil;
    spProgressBg = nil;
    spProgressRedBg = nil;
    progress = nil;
    
    oldAudioName = nil;
}

@end
