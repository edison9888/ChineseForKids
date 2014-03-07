//
//  KnowledgeProgressLayer.m
//  PinyinGame
//
//  Created by yang on 13-11-12.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "KnowledgeProgressLayer.h"
#import "HSLessonKnowledgeView.h"
#import "HSTLessonKnowledgeView.h"
#import "GlobalDataHelper.h"
//#import "GameLevelData.h"
#import "SceneManager.h"
#import "Constants.h"
#import "cocos2d.h"

@interface KnowledgeProgressLayer ()<HSLessonKnowledgeViewDelegate>
{
    NSString *curUserID;
}

@end

@implementation KnowledgeProgressLayer
{
    HSLessonKnowledgeView *lessonKnowledgeView;
    HSTLessonKnowledgeView *lessonTKnowledgeView;
}

+(id)nodeWithLessonID:(NSString *)lessonID
{
    
    return [[self alloc] initWithLessonID:lessonID];
}

- (id)initWithLessonID:(NSString *)lessonID
{
    CCLOG(@"%@ : %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    if (self = [super init])
    {
        // 设置自身背景色
        glClearColor(0.2f, 0.2f, 0.2f, 255);
        
        if (3 == [GlobalDataHelper sharedManager].curTypeID)
        {
            lessonTKnowledgeView = [[HSTLessonKnowledgeView alloc] init];
            lessonTKnowledgeView.frame = self.boundingBox;
            lessonTKnowledgeView.delegate = self;
            lessonTKnowledgeView.alpha = 0;
            lessonTKnowledgeView.layer.shouldRasterize = YES;
            [[[CCDirector sharedDirector] view] addSubview:lessonTKnowledgeView];
            
            lessonTKnowledgeView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.96, 0.96);
            [UIView animateWithDuration:0.5f animations:^{
                lessonTKnowledgeView.alpha = 1;
                lessonTKnowledgeView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.01, 1.01);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.1f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    lessonTKnowledgeView.alpha = 1;
                    lessonTKnowledgeView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
                } completion:^(BOOL finished2) {
                    lessonTKnowledgeView.layer.shouldRasterize = NO;
                }];
            }];
        }
        else
        {
            lessonKnowledgeView = [[HSLessonKnowledgeView alloc] init];
            lessonKnowledgeView.frame = self.boundingBox;
            lessonKnowledgeView.delegate = self;
            lessonKnowledgeView.alpha = 0;
            lessonKnowledgeView.layer.shouldRasterize = YES;
            [[[CCDirector sharedDirector] view] addSubview:lessonKnowledgeView];
            
            lessonKnowledgeView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.96, 0.96);
            [UIView animateWithDuration:0.5f animations:^{
                lessonKnowledgeView.alpha = 1;
                lessonKnowledgeView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.01, 1.01);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.1f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    lessonKnowledgeView.alpha = 1;
                    lessonKnowledgeView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
                } completion:^(BOOL finished2) {
                    lessonKnowledgeView.layer.shouldRasterize = NO;
                }];
            }];
        }
        
    }
    return self;
}

#pragma - ResultReportView Delegate
- (void)lessonKnowledgeView:(HSLessonKnowledgeView *)view quit:(BOOL)quit
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(knowledgeProgress:quit:)])
    {
        [self.delegate knowledgeProgress:self quit:quit];
    }
}

#pragma mark - Memory Manager
- (void)dealloc
{
    if (lessonKnowledgeView)
    {
        [lessonKnowledgeView removeFromSuperview];
        lessonKnowledgeView = nil;
    }
    
    if (lessonTKnowledgeView)
    {
        [lessonTKnowledgeView removeFromSuperview];
        lessonTKnowledgeView = nil;
    }
    
    self.delegate = nil;
    
    /*
    [CCSpriteFrameCache purgeSharedSpriteFrameCache];
    
    [[CCTextureCache sharedTextureCache] removeAllTextures];
    [CCTextureCache purgeSharedTextureCache];
     */
}

@end
