//
//  HSPageTableView.m
//  ChineseForKids
//
//  Created by yang on 13-10-12.
//  Copyright (c) 2013年 Allen. All rights reserved.
//

#import "HSPageTableView.h"

#define SHOW_SCROLLTOTOP YES

#define kTableOffset @"kTableOffset"

@implementation HSPageTableView
@synthesize tableView ;
@synthesize identifier;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setBackgroundColor:[UIColor clearColor]];
        
        tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, frame.size.width, frame.size.height)];
        tableView.alpha = 0.0f;
        [self addSubview:tableView];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.scrollsToTop = NO;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.showsVerticalScrollIndicator = YES;
        tableView.showsHorizontalScrollIndicator = NO;
        tableView.tableFooterView = [[UIView alloc] init];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
        
        [UIView animateWithDuration:0.3f animations:^{tableView.alpha = 1.0f;}];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark - overWrite
- (void)setFrame:(CGRect)aFrame
{
    [super setFrame:aFrame];
    CGRect tableViewFrame = [tableView frame];
    tableViewFrame.size.width = self.frame.size.width;
    tableViewFrame.size.height = self.frame.size.height;
    [tableView setFrame:tableViewFrame];
}

- (id)initWithIdentifier:(NSString *)aIdentifier
{
    if (self = [super init])
    {
        identifier = aIdentifier;
    }
    return self;
}

- (void)pageWillAppear
{
    [self.tableView reloadData];
    if (nil != timer)
    {
        [timer invalidate];
        timer = nil;
        [btnScrollToTop removeFromSuperview];
        btnScrollToTop = nil;
    }
}

- (void)pageDidAppear
{
    [self.tableView setScrollsToTop:YES];
}

- (void)pageWillDisappear
{
    [self.tableView setScrollsToTop:NO];
}

#pragma mark - Offset save/restore
- (void)saveTableViewOffset
{
    CGPoint contentOffset = [tableView contentOffset];
    float y = contentOffset.y;
    
    NSMutableArray *offsetArrary = [[[NSUserDefaults standardUserDefaults] objectForKey:kTableOffset] mutableCopy];
    if (!offsetArrary) {
        offsetArrary = [NSMutableArray array];
    }
    
    if ([offsetArrary count] < self.pageNumber+1) {
        [offsetArrary addObject:@(y)];
    }else{
        [offsetArrary replaceObjectAtIndex:self.pageNumber withObject:[NSNumber numberWithInt:y]];
    }
    [[NSUserDefaults standardUserDefaults] setObject:offsetArrary forKey:kTableOffset];
}

- (void)restoreTableViewOffset
{
    NSMutableArray *offsetArray = [[NSUserDefaults standardUserDefaults] objectForKey:kTableOffset];
    if (offsetArray)
    {
        if ([offsetArray count] > self.pageNumber)
        {
            float y = [[offsetArray objectAtIndex:self.pageNumber] floatValue];
            CGPoint contentOffset = CGPointMake(0, y);
            [tableView setContentOffset:contentOffset animated:NO];
        }
        else
        {
            CGPoint contentOffset = CGPointMake(0, 0);
            [tableView setContentOffset:contentOffset animated:NO];
        }
    }
}

- (void)removeTableViewOffset
{
    NSMutableArray *offsetArray = [[[NSUserDefaults standardUserDefaults] objectForKey:kTableOffset] mutableCopy];
    if (offsetArray)
    {
        if ([offsetArray count] > self.pageNumber)
        {
            [offsetArray removeObjectAtIndex:self.pageNumber];
            [[NSUserDefaults standardUserDefaults] setObject:offsetArray forKey:kTableOffset];
        }
    }
}

#pragma mark - UITableView Datasource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(pageTableView:heightForRowAtIndexPath:)])
    {
        return [self.delegate pageTableView:self heightForRowAtIndexPath:[HSPageIndexPath indexPathForPage:self.pageNumber indexPath:indexPath]];
    }
    else return 0;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(pageTableView:didSelectRowAtIndexPath:)])
    {
        return [self.delegate pageTableView:self didSelectRowAtIndexPath:[HSPageIndexPath indexPathForPage:self.pageNumber indexPath:indexPath]];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(pageTableView:cellForRowAtIndexPath:)])
    {
        return [self.delegate pageTableView:self cellForRowAtIndexPath:[HSPageIndexPath indexPathForPage:self.pageNumber indexPath:indexPath]];
    }
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.delegate respondsToSelector:@selector(pageTableView:numberOfRowsInPage:section:)])
    {
        return [self.delegate pageTableView:self numberOfRowsInPage:self.pageNumber section:section];
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([self.delegate respondsToSelector:@selector(pageTableView:numberOfSectionsInPage:)])
    {
        return [self.delegate pageTableView:self numberOfSectionsInPage:self.pageNumber];
    }
    return 0;
}

#pragma mark UITableView Delegate
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([self.delegate respondsToSelector:@selector(pageTableView:titleForHeaderInPage:section:)])
    {
        return [self.delegate pageTableView:self titleForHeaderInPage:self.pageNumber section:section];
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ([self.delegate respondsToSelector:@selector(pageTableView:viewForHeaderInPage:section:)])
    {
        return [self.delegate pageTableView:self viewForHeaderInPage:self.pageNumber section:section];
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([self.delegate respondsToSelector:@selector(pageTableView:heightForHeaderInPage:section:)])
    {
        return [self.delegate pageTableView:self heightForHeaderInPage:self.pageNumber section:section];
    }
    return 0;
}

#pragma mark UIScrollView Delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    startOffset = scrollView.contentOffset.y;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 当前偏移量
    float currentOffset = scrollView.contentOffset.y;
    
    // 向上滑动, 并且滑动超过两屏的距离, 弹出回到顶部按钮
    if ((currentOffset < startOffset - 2 * self.frame.size.height))
    {
        [self showScrollToTopButton];
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    if ([self.delegate respondsToSelector:@selector(pageTableView:scrollViewWillBeginDecelerating:)])
    {
        [self.delegate pageTableView:self scrollViewWillBeginDecelerating:scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    startOffset = scrollView.contentOffset.y;
}

//弹出回到顶部按钮
- (void)showScrollToTopButton
{
    
}

#pragma mark - Memory Manager
- (void)dealloc
{
    self.delegate = nil;
    self.identifier = nil;
    self.tableView = nil;
    if (nil != timer)
    {
        [timer invalidate];
        timer = nil;
    }
}

@end
