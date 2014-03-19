//
//  HSBooksListView.m
//  ChineseForKids
//
//  Created by yang on 13-12-31.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "HSBooksListView.h"
#import "BookCoverNet.h"
#import "BookModel.h"
#import "ResponseModel.h"
#import "GlobalDataHelper.h"
#import "GameManager.h"
#import "Constants.h"
#import "UIButton+WebCache.h"

@implementation HSBooksListView
{
    NSString *curUserID;
    NSInteger curHumanID;
    NSInteger curGroupID;
    
    NSMutableArray *arrBook;
    UIImage *imgCover;
    UIScrollView *svBookList;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        arrBook = [[NSMutableArray alloc] init];
        
        curUserID  = [GlobalDataHelper sharedManager].curUserID;
        curHumanID = [GlobalDataHelper sharedManager].curHumanID;
        curGroupID = [GlobalDataHelper sharedManager].curGroupID;
        
        [self initInterface];
        
        //[self showLoadingView];
    }
    return self;
}

- (void)initInterface
{
    //NSLog(@"%@: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    [super initInterface];
    [self resetLoadingViewFrame:self.bounds];
    [self performSelector:@selector(loadBookData) withObject:nil afterDelay:0.5f];
    
    svBookList = [[UIScrollView alloc] initWithFrame:self.bounds];
    svBookList.delegate = self;
    svBookList.backgroundColor = [UIColor clearColor];
    svBookList.pagingEnabled = YES;
    svBookList.scrollEnabled = YES;
    //svBookList.showsHorizontalScrollIndicator = YES;
    svBookList.showsVerticalScrollIndicator = YES;
    [self addSubview:svBookList];
}

- (void)showLoadingView
{
    [super showLoadingView];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark - LoadData
- (void)loadBookData
{
#ifdef DLITE_VERSION
    [self initBookWithBookData:arrBook];
    [self hideLoadingView];
#else
    NSString *strHumanID = [NSString stringWithFormat:@"%d", curHumanID];
    NSString *strGroupID = [NSString stringWithFormat:@"%d", curGroupID];
    // 这一步去检查本地, 是因为如果本地有数据的话, 那么就直接用本地的数据。这样就可以达到离线可用的目的。
    NSArray *arrTBook = [[GameManager sharedManager] loadBookDataWithUserID:curUserID humanID:curHumanID groupID:curGroupID];
    if (arrTBook && ([arrTBook count] > 0))
    {
        // 初始书籍列表界面
        [self initBookWithBookData:arrTBook];
        [self hideLoadingView];
    }
    else
    {
        [self performSelectorOnMainThread:@selector(showLoadingView) withObject:nil waitUntilDone:NO];
        
        [BookCoverNet getBookCoverInfoWithUserID:curUserID HumanID:strHumanID GroupID:strGroupID];
        if ([BookCoverNet isRequestCanceled]) return;
        
        arrTBook = [[GameManager sharedManager] loadBookDataWithUserID:curUserID humanID:curHumanID groupID:curGroupID];
        if (arrTBook && ([arrTBook count] > 0))
        {
            // 初始书籍列表界面
            [self initBookWithBookData:arrTBook];
            [self hideLoadingView];
        }
        else
        {
            [self showErrorView];
        }
    }
    
    [BookCoverNet getBookCoverInfoWithUserID:curUserID HumanID:strHumanID GroupID:strGroupID];
#endif
}

- (void)cancelLoad
{
    [BookCoverNet cancelRequest];
}

- (void)initBookWithBookData:(NSArray *)bookData
{
    [arrBook setArray:bookData];

    CGFloat pageWidth  = svBookList.bounds.size.width;
    CGFloat pageHeight = svBookList.bounds.size.height;
    
#ifdef DLITE_VERSION
    NSInteger bookCount = 3;//[arrBook count];
#else
    NSInteger bookCount = [arrBook count];
#endif
    NSInteger page = bookCount/3 + (bookCount%3 > 0 ? 1 : 0);
    //NSLog(@"page: %d", page);
    
    svBookList.contentSize = CGSizeMake(pageWidth*page, pageHeight);
    
    for (int i = 0, j = 0; i < bookCount; i++, j++)
    {
#ifndef DLITE_VERSION
        BookModel *bookModel = (BookModel *)[arrBook objectAtIndex:i];
#endif
        imgCover = [UIImage imageNamed:@"bookCoverPh.png"];
        UIButton *btnBook = [[UIButton alloc] initWithFrame:CGRectZero];
        [btnBook addTarget:self action:@selector(bookClickAction:) forControlEvents:UIControlEventTouchUpInside];
        //[btnBook setImage:imgCover forState:UIControlStateNormal];
#ifdef DLITE_VERSION
        [btnBook setImageWithURL:[NSURL URLWithString:@"bookCoverPh.png"] placeholderImage:imgCover];
        btnBook.tag = i+1;
#else
        [btnBook setImageWithURL:[NSURL URLWithString:bookModel.bookIconURL] placeholderImage:imgCover];
        btnBook.tag = bookModel.bookIDValue;
#endif
        btnBook.backgroundColor = [UIColor clearColor];
        btnBook.exclusiveTouch = YES; //独占点击事件
        
        //计算frame
        CGFloat origin = self.frame.size.width / 7;
        CGFloat width = imgCover.size.width;
        CGFloat heigh = kLIBRARY_SHELF_HEIGHT - (kLIBRARY_SHELF_HEIGHT / 14) * 2.5;
        
        // 每一页的书本都从本页开始算初始位置，与上一页无关。
        j = (i%3 == 0 ? 0 : j);
        
        CGFloat x = j*width + (j+1)*origin + (i/3)*pageWidth;
        CGFloat y = kLIBRARY_SHELF_HEIGHT / 14;
        [btnBook setFrame:CGRectMake(x, y, width, heigh)];
        [svBookList addSubview:btnBook];
        
        break;
    }
}

#pragma mark - UIButton Action Manager
- (void)bookClickAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if (self.delegate && [self.delegate respondsToSelector:@selector(booksListView:selectedBookWithBookID:)])
    {
        [self.delegate booksListView:self selectedBookWithBookID:btn.tag];
    }
}

#pragma mark - 错误视图点击后重新加载数据
-(void)errorViewTappedGesture:(UITapGestureRecognizer *)gesture
{
    [super errorViewTappedGesture:gesture];
    [self loadBookData];
}

#pragma mark - Memory Manager
- (void)dealloc
{
    [[self class] cancelPreviousPerformRequestsWithTarget:self];
    
    _delegate = nil;
    curUserID = nil;
    
    [arrBook removeAllObjects];
    arrBook = nil;
}

@end
