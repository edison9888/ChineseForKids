//
//  HSTLessonKnowledgeView.h
//  ChineseForKids
//
//  Created by yang on 14-3-5.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HSLessonKnowledgeViewDelegate;

@interface HSTLessonKnowledgeView : UIView<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *tbvProgress;
}

@property (nonatomic, unsafe_unretained)id<HSLessonKnowledgeViewDelegate>delegate;

@end

@protocol HSLessonKnowledgeViewDelegate <NSObject>

@optional

- (void)lessonKnowledgeView:(HSTLessonKnowledgeView *)view quit:(BOOL)quit;

@end
