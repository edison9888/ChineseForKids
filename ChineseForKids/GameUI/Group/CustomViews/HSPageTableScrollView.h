//
//  HSPageTableScrollView.h
//  ChineseForKids
//
//  Created by yang on 13-10-12.
//  Copyright (c) 2013年 Allen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSPageTableView.h"

#define GAP 0
#define KEY_PAGETAG         11000

@interface HSPageTableScrollView : UIView<UIScrollViewDelegate, PageTableViewDelegate>
{
    UIScrollView *_scrollView;
    NSMutableSet *_setRecycledPages;
    NSMutableSet *_setVisiblePages;
    
    int currentPage;                                                            //当前页
    int lastDisplayedPage;
}

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableSet *setRecycledPages;
@property (nonatomic, strong) NSMutableSet *setVisiblePages;
@property (nonatomic, readwrite) int currentPage;
@property (nonatomic, readwrite) int lastDisplayedPage;

#pragma mark frame and sizes
- (CGRect)scrollViewFrame;
- (CGSize)pageTableViewSize;
- (int)numberOfVisiblePageTableViews;
- (NSInteger)numberOfPageTableViews;

- (HSPageTableView *)dequeueReusablePageWithIdentifier:(NSString*)identifier;
- (HSPageTableView *)pageTableViewAtPage:(NSInteger)page;

- (void)reloadPageTableViews;
- (void)jumpToPageAtIndex:(int)aPage animation:(BOOL)isAnimation;

@end
