//
//  HSPageTableView.h
//  ChineseForKids
//
//  Created by yang on 13-10-12.
//  Copyright (c) 2013年 Allen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSPageIndexPath.h"

@class HSPageTableView;

@protocol PageTableViewDelegate <NSObject>

#pragma mark - Table 相关的协议
- (NSInteger)pageTableView:(HSPageTableView *)pageTableView numberOfRowsInPage:(NSInteger)page section:(NSInteger)section;
- (CGFloat)pageTableView:(HSPageTableView *)pageTableView heightForRowAtIndexPath:(HSPageIndexPath *)indexPath;
- (void)pageTableView:(HSPageTableView *)pageTableView didSelectRowAtIndexPath:(HSPageIndexPath *)indexPath;
- (UITableViewCell *)pageTableView:(HSPageTableView *)pageTableView cellForRowAtIndexPath:(HSPageIndexPath *)indexPath;
- (NSInteger)pageTableView:(HSPageTableView *)pageTableView numberOfSectionsInPage:(NSInteger)pageNumber;
- (NSString *)pageTableView:(HSPageTableView *)pageTableView titleForHeaderInPage:(NSInteger)pageNumber section:(NSInteger)section;
- (UIView *)pageTableView:(HSPageTableView *)pageTableView viewForHeaderInPage:(NSInteger)pageNumber section:(NSInteger)section;
- (CGFloat)pageTableView:(HSPageTableView *)pageTableView heightForHeaderInPage:(NSInteger)pageNumber section:(NSInteger)section;

@optional

#pragma mark - Scroll 相关的协议
- (void)pageTableView:(HSPageTableView *)pageTableView scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)pageTableView:(HSPageTableView *)pageTableView scrollViewWillBeginDragging:(UIScrollView *)scrollView;
- (void)pageTableView:(HSPageTableView *)pageTableView scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset NS_AVAILABLE_IOS(5_0);
- (void)pageTableView:(HSPageTableView *)pageTableView scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
- (void)pageTableView:(HSPageTableView *)pageTableView scrollViewWillBeginDecelerating:(UIScrollView *)scrollView;
- (void)pageTableView:(HSPageTableView *)pageTableView scrollViewDidEndDecelerating:(UIScrollView *)scrollView;
- (void)pageTableView:(HSPageTableView *)pageTableView scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView;
- (void)pageTableView:(HSPageTableView *)pageTableView scrollViewDidScrollToTop:(UIScrollView *)scrollView;

- (BOOL)respondsToSelector:(SEL)selector;
@end

@interface HSPageTableView : UIView<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *tableView;
    UIButton *btnScrollToTop;
    NSTimer *timer;
    
    NSString *identifier;
    float startOffset;
    BOOL isStop;
}

@property (nonatomic, unsafe_unretained)id<PageTableViewDelegate>delegate;
@property (nonatomic, readwrite)int pageNumber;
@property (nonatomic, strong)NSString *identifier;
@property (nonatomic, strong)UITableView *tableView;

- (id)initWithIdentifier:(NSString *)aIdentifier;

- (void)pageWillAppear;
- (void)pageDidAppear;
- (void)pageWillDisappear;

#pragma mark offset save/restore
- (void)saveTableViewOffset;
- (void)restoreTableViewOffset;
- (void)removeTableViewOffset;

@end
