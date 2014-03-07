//
//  HSLibraryBookShelfView.m
//  ChineseForKids
//
//  Created by yang on 13-10-12.
//  Copyright (c) 2013年 Allen. All rights reserved.
//

#import "HSLibraryBookShelfView.h"
#import "HSLibraryCustomCell.h"
#import "HSComicBookCoverView.h"
#import "HSFileManager.h"
#import "UIButton+WebCache.h"
#import "GroupModel.h"
#import "Constants.h"

#define BookNumOfOneRow 5

@implementation HSLibraryBookShelfView
{
    NSInteger pageIndex;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _arrPagesDataSource = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self reloadPageTableViews];
    [self refreshPagesUI];
}

- (void)setPages:(NSInteger)pages
{
    _pages = pages;
    
    [self reloadPageTableViews];
    [self refreshPagesUI];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)clearnUserInterface
{
    for (HSPageTableView *view in _setVisiblePages)
    {
        [view removeFromSuperview];
    }
    
    [_setVisiblePages removeAllObjects];
    
    for (HSPageTableView *view in _setRecycledPages)
    {
        [view removeFromSuperview];
    }
    
    [_setRecycledPages removeAllObjects];
    
    for (int i = 0; i < [self.scrollView.subviews count]; i++)
    {
        HSPageTableView *view = [self.scrollView.subviews objectAtIndex:i];
        [view removeFromSuperview];
        view = nil;
    }
    
    //if (isNeedResetArea)
    [self jumpToPageAtIndex:currentPage animation:NO];
}

//刷新界面
- (void)refreshPagesUI
{
    //[arrRoomInCurArea removeAllObjects];
    //缓冲区
    for (HSPageTableView *pageTableView in _setRecycledPages)
    {
        [pageTableView.tableView reloadData];
    }
    
    //重新加载可视视图
    for (HSPageTableView *pageTableView in _setVisiblePages)
	{
		[pageTableView.tableView reloadData];
	}
}

#pragma mark -
#pragma mark PageTableView frame and sizes

//获取滚动视图的大小
- (CGRect)scrollViewFrame
{
    return CGRectMake(0.0f, kLIBRARY_BOARD_TITLE_HEIGHT, self.bounds.size.width, self.bounds.size.height);
}

#pragma mark -
#pragma mark panel views delegate/datasource
- (HSPageTableView *)pageTableViewForPage:(NSInteger)page
{
    //NSLog(@"%@", NSStringFromSelector(_cmd));
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
	return self.pages;
}

- (CGFloat)pageTableView:(HSPageTableView *)pageTableView heightForRowAtIndexPath:(HSPageIndexPath *)indexPath
{
    return kLIBRARY_SHELF_HEIGHT;
}

- (UITableViewCell *)pageTableView:(HSPageTableView *)pageTableView cellForRowAtIndexPath:(HSPageIndexPath *)indexPath
{
	static NSString *gameLibraryIdentifier = @"gameLibraryCell";
    HSLibraryCustomCell *cell = (HSLibraryCustomCell *)[pageTableView.tableView dequeueReusableCellWithIdentifier:gameLibraryIdentifier];
    if (cell == nil)
    {
        cell = [[HSLibraryCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:gameLibraryIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    for (HSComicBookCoverView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
#ifdef DLITE_VERSION
    if (0 == indexPath.row)
    {
        //GroupModel *groupModel = [self.arrPagesDataSource objectAtIndex:0];
        
        UIImage *imgCover = [UIImage imageNamed:@"groupCoverPh.png"];
        HSComicBookCoverView *tempBookCoverView = [[HSComicBookCoverView alloc] initWithFrame:CGRectZero GroupID:1 ImageURL:nil];
        tempBookCoverView.userInteractionEnabled = YES;
        [tempBookCoverView addTarget:self action:@selector(bookClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [tempBookCoverView setImage:imgCover forState:UIControlStateNormal];
        //NSLog(@"URL:%@", [NSURL URLWithString:groupModel.groupIconURL]);
        //[tempBookCoverView setImageWithURL:[NSURL URLWithString:groupModel.groupIconURL] placeholderImage:imgCover];
        tempBookCoverView.tag = 1;
        tempBookCoverView.backgroundColor = [UIColor clearColor];
        tempBookCoverView.exclusiveTouch = YES; //独占点击事件
        
        //计算frame
        CGFloat origin = pageTableView.frame.size.width / BookNumOfOneRow;
        CGFloat width  = imgCover.size.width;
        
        CGFloat x = origin;
        CGFloat y = kLIBRARY_SHELF_HEIGHT / 14;
        CGFloat heigh = kLIBRARY_SHELF_HEIGHT - (kLIBRARY_SHELF_HEIGHT / 14) * 2.5;
        [tempBookCoverView setFrame:CGRectMake(x, y, width, heigh)];
        [cell.contentView addSubview:tempBookCoverView];
    }
#else
    for (NSInteger i = indexPath.row * 3 , j = 0; (i < (indexPath.row + 1)*3)&&(i < [self.arrPagesDataSource count]); ++i, ++j)
    {
        GroupModel *groupModel = [self.arrPagesDataSource objectAtIndex:i];
        
        UIImage *imgCover = [UIImage imageNamed:@"groupCoverPh.png"];
        
        HSComicBookCoverView *tempBookCoverView = [[HSComicBookCoverView alloc] initWithFrame:CGRectZero GroupID:groupModel.groupIDValue ImageURL:groupModel.groupIconURL];
        tempBookCoverView.userInteractionEnabled = YES;
        [tempBookCoverView addTarget:self action:@selector(bookClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [tempBookCoverView setImageWithURL:[NSURL URLWithString:groupModel.groupIconURL] placeholderImage:imgCover];
        tempBookCoverView.tag = groupModel.groupIDValue;
        tempBookCoverView.backgroundColor = [UIColor clearColor];
        tempBookCoverView.exclusiveTouch = YES; //独占点击事件
        
        //计算frame
        CGFloat origin = pageTableView.frame.size.width / BookNumOfOneRow;
        CGFloat width  = imgCover.size.width;
        
        CGFloat x = j*origin + width + j*origin/3;
        CGFloat y = kLIBRARY_SHELF_HEIGHT / 14;
        CGFloat heigh = kLIBRARY_SHELF_HEIGHT - (kLIBRARY_SHELF_HEIGHT / 14) * 2.5;
        [tempBookCoverView setFrame:CGRectMake(x, y, width, heigh)];
        [cell.contentView addSubview:tempBookCoverView];
    }
#endif
    
    return cell;
}

- (NSInteger)pageTableView:(HSPageTableView *)pageTableView numberOfRowsInPage:(NSInteger)page section:(NSInteger)section
{
    NSInteger bookCount = [self.arrPagesDataSource count];
	int count = bookCount/3 < 3 ? 3 : (bookCount % 3 == 0 ? bookCount/3 : bookCount/3+1);
	return count;
}

- (void)pageTableView:(HSPageTableView *)pageTableView didSelectRowAtIndexPath:(HSPageIndexPath *)indexPath
{
    //不做处理
    //return;
}

- (NSInteger)pageTableView:(id)panelView numberOfSectionsInPage:(NSInteger)pageNumber
{
	return 1;
}

- (NSString *)pageTableView:(id)panelView titleForHeaderInPage:(NSInteger)pageNumber section:(NSInteger)section
{
    
	return nil;
}

#pragma mark - Button Action Manager
- (void)bookClickAction:(id)sender
{
    HSPageTableView *pageView = (HSPageTableView *)[self pageTableViewAtPage:self.currentPage];
    if ([pageView.tableView isDragging] || [pageView.tableView isDecelerating])
    {
        return;
    }
    HSComicBookCoverView *coverButton = (HSComicBookCoverView *)sender;
    if (self.delegate && [self.delegate respondsToSelector:@selector(libraryBookShelfView:selectedBook:)])
    {
        [self.delegate libraryBookShelfView:self selectedBook:coverButton];
    }
}

#pragma mark - Memory Manager
- (void)dealloc
{
    self.delegate = nil;
    self.arrPagesDataSource = nil;
}

@end
