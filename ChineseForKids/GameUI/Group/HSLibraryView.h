//
//  HSLibraryView.h
//  ChineseForKids
//
//  Created by yang on 13-10-11.
//  Copyright (c) 2013年 Allen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"
#import "HSLibraryBookShelfView.h"

@protocol HSLibraryViewDelegate;

@interface HSLibraryView : BaseView<HSLibraryBookShelfDelegate>
@property (nonatomic, unsafe_unretained)id<HSLibraryViewDelegate>delegate;

- (void)loadGroupData;

@end

@protocol HSLibraryViewDelegate <NSObject>

@optional
- (void)libraryView:(HSLibraryView *)libraryView backAction:(id)sender;

- (void)libraryView:(HSLibraryView *)libraryView selectedBook:(NSInteger)bookID;

@end