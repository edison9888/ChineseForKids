//
//  ResultReportView.h
//  PinyinGame
//
//  Created by yang on 13-11-4.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HSLessonKnowledgeViewDelegate;

@interface HSLessonKnowledgeView : UIView<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *tbvProgress;
}

@property (nonatomic, unsafe_unretained)id<HSLessonKnowledgeViewDelegate>delegate;

//- (id)initWithUserID:(NSString *)userID;

@end

@protocol HSLessonKnowledgeViewDelegate <NSObject>

@optional

- (void)lessonKnowledgeView:(HSLessonKnowledgeView *)view quit:(BOOL)quit;

@end
