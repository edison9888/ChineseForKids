//
//  HSBooksListView.h
//  ChineseForKids
//
//  Created by yang on 13-12-31.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "BaseView.h"

@protocol HSBooksListViewDelegate;

@interface HSBooksListView : BaseView<UIScrollViewDelegate>

@property (nonatomic, unsafe_unretained)id<HSBooksListViewDelegate>delegate;

- (void)loadBookData;
- (void)cancelLoad;

@end

@protocol HSBooksListViewDelegate <NSObject>

@required
- (void)booksListView:(HSBooksListView *)view selectedBookWithBookID:(NSInteger)bookID;

@end