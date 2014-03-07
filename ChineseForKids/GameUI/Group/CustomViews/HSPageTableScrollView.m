//
//  HSPageTableScrollView.m
//  ChineseForKids
//
//  Created by yang on 13-10-12.
//  Copyright (c) 2013年 Allen. All rights reserved.
//

#import "HSPageTableScrollView.h"
#import "Constants.h"

#define KEY_CURRENTROW      @"CURRENTROW"
#define KEY_CURRENTSECTION  @"CURRENTSECTION"


@interface HSPageTableScrollView ()
- (void)tilePages;
- (void)configurePage:(HSPageTableView *)page forIndex:(int)index;
- (BOOL)isDisplayingPageForIndex:(int)index;
- (HSPageTableView *)pageTableViewForPage:(NSInteger)page;
- (void)updateContentSize;
@end


@implementation HSPageTableScrollView
@synthesize scrollView = _scrollView;
@synthesize setRecycledPages = _setRecycledPages;
@synthesize setVisiblePages = _setVisiblePages;
@synthesize currentPage;
@synthesize lastDisplayedPage;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        _setRecycledPages = [[NSMutableSet alloc] init];
        _setVisiblePages = [[NSMutableSet alloc] init];
        
        [self initInterface];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    HSPageTableView *pageTableView = [self pageTableViewAtPage:currentPage];
    [pageTableView pageWillAppear];

    [pageTableView pageDidAppear];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)initInterface
{
    CGRect frame = [self scrollViewFrame];
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, frame.size.width,frame.size.height)];
    _scrollView.backgroundColor = [UIColor clearColor];
	[_scrollView setScrollsToTop:NO];
	[_scrollView setDelegate:self];
	[_scrollView setShowsHorizontalScrollIndicator:NO];
	[_scrollView setPagingEnabled:YES];
    [self addSubview:_scrollView];
    
    [self updateContentSize];
    [self tilePages];
}

#pragma mark - Frame and sizes
//设置滚动视图都ContentSize
- (void)updateContentSize
{
    CGFloat wv = ([self pageTableViewSize].width + 2*GAP) * [self numberOfPageTableViews];
    self.scrollView.contentSize = CGSizeMake(wv, 1);
}

//获取滚动视图的大小
- (CGRect)scrollViewFrame
{
    return CGRectMake(0.0f, 45, SCREEN_WIDTH, SHOWAREA_HEIGHT - NAVIGATIONBAR_HEIGHT - 45 - TABBAR_HEIGHT - 12);
}

//获取页面表格视图的大小
- (CGSize)pageTableViewSize
{
    CGRect rectScroll = [self scrollViewFrame];
	float width = rectScroll.size.width;
    int numberOfVisiblePages = [self numberOfVisiblePageTableViews];
	if (numberOfVisiblePages > 1)
	{
		width = (rectScroll.size.width - 2*GAP*(numberOfVisiblePages-1))/numberOfVisiblePages;
	}
    
	return CGSizeMake(width, rectScroll.size.height);
}

//侧函数用于页面可以同时显示的页面数:暂时禁止修改
- (int)numberOfVisiblePageTableViews
{
	return 1;
}

#pragma mark - UIScrollViewDelegate Method

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView_
{
	HSPageTableView *pageTableView = (HSPageTableView *)[self.scrollView viewWithTag:KEY_PAGETAG + self.currentPage];
	[pageTableView pageWillDisappear];
}

- (void)scrollViewDidScroll:(UIScrollView*)scrollView_
{
	[self tilePages];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView_
{
	if (self.currentPage != self.lastDisplayedPage)
	{
		HSPageTableView *pageTableView = (HSPageTableView *)[self.scrollView viewWithTag:KEY_PAGETAG + self.currentPage];
		[pageTableView pageDidAppear];
	}
	self.lastDisplayedPage = self.currentPage;
    
    /*
     //测试代码
     DLog(@"1当前可视的视图:%d, 当前缓冲区的个数为:%d", [self.setVisiblePages count], [self.setRecycledPages count]);
     DLog(@"-------------------------------");
     for (JWPageTableView *view in self.setVisiblePages)
     {
     DLog(@"可视页码为:%d", view.pageNumber);
     }
     for (JWPageTableView *view in self.setRecycledPages)
     {
     DLog(@"缓冲页码为:%d", view.pageNumber);
     }
     NSLog(@"-------------------------------");
     */
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (self.currentPage != self.lastDisplayedPage)
	{
		HSPageTableView *pageTableView = (HSPageTableView *)[self.scrollView viewWithTag:KEY_PAGETAG + self.currentPage];
		[pageTableView pageDidAppear];
	}
	self.lastDisplayedPage = self.currentPage;
}

#pragma mark -
#pragma mark reuse table views
- (void)reloadPageTableViews
{
    [self updateContentSize];
    [self tilePages];
}

- (void)jumpToPageAtIndex:(int)aPage animation:(BOOL)isAnimation
{
    //超过可显示的页面
    if (aPage >= [self numberOfPageTableViews] || aPage < 0)
    {
        return;
    }
    
    //跳转到指定页码
    int offsetX = ([self pageTableViewSize].width + 2*GAP) * aPage + GAP;
    int offsetY = 0.0f;
    [_scrollView setContentOffset:CGPointMake(offsetX, offsetY) animated:isAnimation];
}

- (void)tilePages
{
	CGRect visibleBounds = [self.scrollView bounds];
	int firstNeededPageIndex = floorf(CGRectGetMinX(visibleBounds) / CGRectGetWidth(visibleBounds)) * [self numberOfVisiblePageTableViews];
	int lastNeededPageIndex = floorf((CGRectGetMaxX(visibleBounds)-1) / CGRectGetWidth(visibleBounds)) * [self numberOfVisiblePageTableViews];
    
	firstNeededPageIndex = MAX(firstNeededPageIndex,0);
	lastNeededPageIndex = MIN(lastNeededPageIndex, [self numberOfPageTableViews]-1) + [self numberOfVisiblePageTableViews];
	
	//if (self.isEditing) firstNeededPageIndex -= 1;
	
	if (firstNeededPageIndex<0) firstNeededPageIndex = 0;
	if (lastNeededPageIndex >= [self numberOfPageTableViews]) lastNeededPageIndex = [self numberOfPageTableViews]-1;
	
	self.currentPage = firstNeededPageIndex;
	
	for (HSPageTableView *page in self.setVisiblePages)
	{
		if (page.pageNumber < firstNeededPageIndex || page.pageNumber > lastNeededPageIndex)
		{
			[self.setRecycledPages addObject:page];
			[page removeFromSuperview];
		}
	}
	[self.setVisiblePages minusSet:self.setRecycledPages];
	
	for (int index=firstNeededPageIndex; index<=lastNeededPageIndex; index++)
	{
		if (![self isDisplayingPageForIndex:index])
		{
			HSPageTableView *panel = [self pageTableViewForPage:index];
			//int x = ([self pageTableViewSize].width+2*GAP)*index + GAP;
            float x = ([self pageTableViewSize].width+2*GAP)*index + GAP;
			CGRect panelFrame = CGRectMake(x, 1.5f, [self pageTableViewSize].width,[self scrollViewFrame].size.height - 1.5f);
			[panel setFrame:panelFrame];
			[panel setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
			[panel setDelegate:self];
			[panel setTag:KEY_PAGETAG+index];
			[panel setPageNumber:index];
			[panel pageWillAppear];
            
			[self.scrollView addSubview:panel];
			[self.setVisiblePages addObject:panel];
		}
	}
}

- (BOOL)isDisplayingPageForIndex:(int)index
{
	for (HSPageTableView *tempView in self.setVisiblePages)
	{
		if (tempView.pageNumber==index) return YES;
	}
	return NO;
}

- (void)configurePage:(HSPageTableView *)page forIndex:(int)index
{
	int x = ([self bounds].size.width+2*GAP)*index + GAP;
	CGRect pageFrame = CGRectMake(x,0,[self bounds].size.width,[self bounds].size.height);
	[page setFrame:pageFrame];
	[page setPageNumber:index];
	[page pageWillAppear];
}

- (HSPageTableView *)dequeueReusablePageWithIdentifier:(NSString*)identifier
{
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.identifier == %@", identifier];
	NSSet *filteredSet =[self.setRecycledPages filteredSetUsingPredicate:predicate];
	HSPageTableView *page = [filteredSet anyObject];
	if (page)
	{
		[self.setRecycledPages removeObject:page];
	}
	return page;
}

#pragma mark -
#pragma mark panel views
- (HSPageTableView *)pageTableViewAtPage:(NSInteger)page
{
	HSPageTableView *pageTableView = (HSPageTableView *)[self.scrollView viewWithTag:KEY_PAGETAG + page];
	return pageTableView;
}

- (HSPageTableView *)pageTableViewForPage:(NSInteger)page
{
	static NSString *identifier = @"PageTableView";
	HSPageTableView *pageTableView = (HSPageTableView *)[self dequeueReusablePageWithIdentifier:identifier];
	if (pageTableView == nil)
	{
		pageTableView = [[HSPageTableView alloc] initWithIdentifier:identifier];
	}
	return pageTableView;
}

- (NSInteger)numberOfPageTableViews;
{
	return 0;
}

- (CGFloat)pageTableView:(HSPageTableView *)pageTableView heightForRowAtIndexPath:(HSPageTableView *)indexPath
{
    return 55;
}

- (UITableViewCell *)pageTableView:(HSPageTableView *)pageTableView cellForRowAtIndexPath:(HSPageTableView *)indexPath
{
	static NSString *identity = @"UITableViewCell";
	UITableViewCell *cell = (UITableViewCell*)[pageTableView.tableView dequeueReusableCellWithIdentifier:identity];
	if (cell == nil)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identity];
	}
	return cell;
}

- (NSInteger)pageTableView:(HSPageTableView *)pageTableView numberOfRowsInPage:(NSInteger)page section:(NSInteger)section
{
	return 0;
}

- (void)pageTableView:(HSPageTableView *)pageTableView didSelectRowAtIndexPath:(HSPageTableView *)indexPath
{
	
}

- (NSInteger)pageTableView:(id)panelView numberOfSectionsInPage:(NSInteger)pageNumber
{
	return 1;
}

- (NSString*)pageTableView:(id)panelView titleForHeaderInPage:(NSInteger)pageNumber section:(NSInteger)section
{
	return [NSString stringWithFormat:@"Page %i Section %i", pageNumber, section];
}

- (UIView *)pageTableView:(HSPageTableView *)pageTableView viewForHeaderInPage:(NSInteger)pageNumber section:(NSInteger)section
{
    return nil;
}

- (CGFloat)pageTableView:(HSPageTableView *)pageTableView heightForHeaderInPage:(NSInteger)pageNumber section:(NSInteger)section
{
    return 0;
}

- (void)pageTableView:(HSPageTableView *)pageTableView scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
	return [super respondsToSelector:aSelector];
}

#pragma mark - Memory Manager
- (void)dealloc
{
    HSPageTableView *pageTableView = [self pageTableViewAtPage:currentPage];
	[pageTableView pageWillDisappear];
    
    [_scrollView removeFromSuperview];
    self.scrollView = nil;
    
    [_setRecycledPages removeAllObjects];
    _setRecycledPages = nil;
    
    [_setVisiblePages removeAllObjects];
    _setVisiblePages = nil;
}

@end
