//
//  HSLibraryBookShelfView.h
//  ChineseForKids
//
//  Created by yang on 13-10-12.
//  Copyright (c) 2013年 Allen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSPageTableScrollView.h"
@class HSComicBookCoverView;

@protocol HSLibraryBookShelfDelegate;

@interface HSLibraryBookShelfView : HSPageTableScrollView

@property (nonatomic, unsafe_unretained)id<HSLibraryBookShelfDelegate>delegate;
@property (nonatomic, strong)NSMutableArray *arrPagesDataSource;
@property (nonatomic, readwrite)NSInteger pages;

@end


@protocol HSLibraryBookShelfDelegate <NSObject>

@required

- (void)libraryBookShelfView:(HSLibraryBookShelfView *)view selectedBook:(HSComicBookCoverView *)book;

@end