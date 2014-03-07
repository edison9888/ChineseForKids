//
//  HSLibraryView.m
//  ChineseForKids
//
//  Created by yang on 13-10-11.
//  Copyright (c) 2013年 Allen. All rights reserved.
//

#import "HSLibraryView.h"
#import "HSLibraryCustomCell.h"
#import "HSComicBookCoverView.h"
#import "GlobalDataHelper.h"
#import "GroupNet.h"
#import "GroupModel.h"
#import "ResponseModel.h"
#import "GameManager.h"
#import "HSBookView.h"
#import "Constants.h"

@interface HSLibraryView ()<HSBookViewDelegate>

@end

@implementation HSLibraryView
{
    UIScrollView *scrollView;
    //UITableView *tbvLibrary;
    HSLibraryBookShelfView *tbvLibraryShelf;
    HSBookView *bookView;
    
    UIButton *btnSlideToRight;
    UIButton *btnSlideToLeft;
    UIButton *btnBack;
    
    UIImage *imgBackground;
    UIImage *imgLibraryTitle;
    UIImage *imgBookSeriTitle;
    
    UIImage *imgSlideToRight;
    UIImage *imgSlideToLeft;
    UIImage *imgBack;
    
    CGRect lbBookSeriTitleRect;
    
    NSInteger pages;
    NSMutableArray *arrGroup;
    
    NSString *curUserID;
    NSInteger curHumanID;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        arrGroup = [[NSMutableArray alloc] init];
        pages    = 1;
        curHumanID = 0;
        
        [GlobalDataHelper sharedManager].curHumanID = curHumanID;
        curUserID  = [GlobalDataHelper sharedManager].curUserID;
        
        [self initInterface];
        //[self showLoadingView];
        //[self loadGroupData];
        [self performSelector:@selector(loadGroupData) withObject:nil afterDelay:0.5f];
    }
    return self;
}

- (void)loadGroupData
{
#ifdef DLITE_VERSION
    [self initGroupWithGroupData:arrGroup];
#else
    NSString *strHumanID = [NSString stringWithFormat:@"%d", curHumanID];
    NSArray *arrTGroup = [[GameManager sharedManager] loadGroupDataWithUserID:curUserID humanID:curHumanID];
    
    if (arrTGroup && ([arrTGroup count] > 0))
    {
        [self initGroupWithGroupData:arrTGroup];
    }
    else
    {
        [self performSelectorOnMainThread:@selector(showLoadingView) withObject:nil waitUntilDone:NO];
        
        [GroupNet getMaterialGroupInfoWithUserID:curUserID HumanID:strHumanID];
        if ([GroupNet isRequestCanceled]) return;
        
        NSArray *arrTGroup = [[GameManager sharedManager] loadGroupDataWithUserID:curUserID humanID:curHumanID];
        
        if (arrTGroup && ([arrTGroup count] > 0))
        {
            [self initGroupWithGroupData:arrTGroup];
        }
        else
        {
            [self showErrorView];
        }
    }
    
    [GroupNet getMaterialGroupInfoWithUserID:curUserID HumanID:strHumanID];
    
#endif
}

- (void)initGroupWithGroupData:(NSArray *)groupData
{
    [arrGroup setArray:groupData];
    // 加载新的书架数据
    [tbvLibraryShelf.arrPagesDataSource setArray:arrGroup];
    tbvLibraryShelf.pages = pages;
    
    [self hideLoadingView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (pages > 1) [self showSlideToRightButton:YES];
}

- (void)drawRect:(CGRect)rect
{
    imgBackground = [UIImage imageNamed:@"libraryBorder.png"];
	[imgBackground drawInRect:self.bounds];
    
    imgLibraryTitle = [UIImage imageNamed:@"libraryTitle.png"];
    CGSize imgSize = [imgLibraryTitle size];
    CGRect lbTitleRect = CGRectMake((self.bounds.size.width - imgSize.width)/2, (kLIBRARY_BOARD_TITLE_HEIGHT - imgSize.height)/2, imgSize.width, imgSize.height);
    [imgLibraryTitle drawInRect:lbTitleRect];
    
    [imgBookSeriTitle drawInRect:lbBookSeriTitleRect];
}

- (void)initInterface
{
    [super initInterface];
    
    tbvLibraryShelf = [[HSLibraryBookShelfView alloc] initWithFrame:CGRectMake(kLIBRARY_BOARD_WIDTH, kLIBRARY_BOARD_TITLE_HEIGHT, self.bounds.size.width-kLIBRARY_BOARD_WIDTH*2, self.bounds.size.height-kLIBRARY_BOARD_TITLE_HEIGHT)];
    tbvLibraryShelf.delegate = self;
    [self addSubview:tbvLibraryShelf];
    
    imgSlideToRight = [UIImage imageNamed:@"btnSlideToRight.png"];
    CGSize imgSize = [imgSlideToRight size];
    btnSlideToRight = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSlideToRight.hidden = YES;
    [btnSlideToRight setFrame:CGRectMake(self.bounds.size.width-kLIBRARY_BOARD_WIDTH-imgSize.width*2, (self.bounds.size.height - imgSize.height)/2, imgSize.width, imgSize.height)];
    [btnSlideToRight setBackgroundImage:imgSlideToRight forState:UIControlStateNormal];
    [btnSlideToRight addTarget:self action:@selector(slideToRight) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnSlideToRight];
    
    imgSlideToLeft = [UIImage imageNamed:@"btnSlideToLeft.png"];
    imgSize = [imgSlideToRight size];
    btnSlideToLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSlideToLeft.hidden = YES;
    [btnSlideToLeft setFrame:CGRectMake(kLIBRARY_BOARD_WIDTH+imgSize.width, (self.bounds.size.height - imgSize.height)/2, imgSize.width, imgSize.height)];
    [btnSlideToLeft setBackgroundImage:imgSlideToLeft forState:UIControlStateNormal];
    [btnSlideToLeft addTarget:self action:@selector(slideToLeft) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnSlideToLeft];

    imgBack = [UIImage imageNamed:@"groupBack.png"];
    imgSize = [imgBack size];
    btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    btnBack.bounds = CGRectMake(0.0f, 0.0f, imgSize.width, imgSize.height);
    btnBack.center = CGPointMake(self.bounds.size.width*0.102, self.bounds.size.height*0.058);
    //[btnBack setTitle:@"back" forState:UIControlStateNormal];
    //[btnBack setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnBack setImage:imgBack forState:UIControlStateNormal];
    //[btnBack setBackgroundImage:imgBack forState:UIControlStateNormal];
    [btnBack addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnBack];
}

- (void)backAction:(id)sender
{
    [GroupNet cancelRequest];
    if (self.delegate && [self.delegate respondsToSelector:@selector(libraryView:backAction:)])
    {
        [self.delegate libraryView:self backAction:sender];
    }
}

- (void)slideToRight
{
    NSInteger pageIndex = tbvLibraryShelf.currentPage+1;
    [self showSlideToLeftButton:YES];
    if (pageIndex >= pages){
        return;
    }else if (pageIndex == pages - 1){
        [self showSlideToRightButton:NO];
    }
    [tbvLibraryShelf jumpToPageAtIndex:pageIndex animation:YES];
    imgBookSeriTitle = [UIImage imageNamed:[NSString stringWithFormat:@"bookSeri%d", pageIndex+1]];
    [self setNeedsDisplayInRect:lbBookSeriTitleRect];
}

- (void)slideToLeft
{
    NSInteger pageIndex = tbvLibraryShelf.currentPage-1;
    [self showSlideToRightButton:YES];
    if (pageIndex < 0){
        return;
    }else if (pageIndex == 0){
        [self showSlideToLeftButton:NO];
    }
    [tbvLibraryShelf jumpToPageAtIndex:pageIndex animation:YES];
    imgBookSeriTitle = [UIImage imageNamed:[NSString stringWithFormat:@"bookSeri%d", pageIndex+1]];
    [self setNeedsDisplayInRect:lbBookSeriTitleRect];
}

- (void)showSlideToRightButton:(BOOL)show
{
    btnSlideToRight.hidden = !show;
    [UIView animateWithDuration:0.5f animations:^{btnSlideToRight.alpha = show ? 1.0f : 0.0f;}];
}

- (void)showSlideToLeftButton:(BOOL)show
{
    btnSlideToLeft.hidden = !show;
    [UIView animateWithDuration:0.5f animations:^{btnSlideToLeft.alpha = show ? 1.0f : 0.0f;}];
}

#pragma mark - HSBookViewDelegate
- (void)bookView:(HSBookView *)view close:(id)sender
{
    [self removeBookView];
}

- (void)bookView:(HSBookView *)view selectedBookWithBookID:(NSInteger)bookID
{
    [self removeBookView];
    
    [GlobalDataHelper sharedManager].curBookID = bookID;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(libraryView:selectedBook:)])
    {
        [self.delegate libraryView:self selectedBook:bookID];
    }
}

- (void)removeBookView
{
    if (bookView)
    {
        [bookView removeFromSuperview];
        bookView = nil;
    }
}

#pragma mark - HSLibraryBookShelfDelegate
- (void)libraryBookShelfView:(HSLibraryBookShelfView *)view selectedBook:(HSComicBookCoverView *)book
{
    // 在这里弹出选择课本的视图。
    [GlobalDataHelper sharedManager].curGroupID = book.groupID;
    
    if (!bookView)
    {
        bookView = [[HSBookView alloc] initWithFrame:self.bounds];
        bookView.delegate = self;
        bookView.alpha = 0.0f;
        bookView.layer.shouldRasterize = YES;
        
        //NSLog(@"原来的center: %@", NSStringFromCGPoint(book.center));
        CGPoint tmpCenter = [self convertPoint:book.center fromView:book.superview];
        //NSLog(@"转换后的tmpCenter: %@", NSStringFromCGPoint(tmpCenter));
        //CGPoint newCenter = [self convertPoint:tmpCenter toView:bookView];
        //NSLog(@"转换后的newCenter: %@", NSStringFromCGPoint(newCenter));
        bookView.coverCerter = tmpCenter;
#ifdef DLITE_VERSION
        bookView.imgCover = book.currentImage;
#else
        bookView.imgCover = book.currentBackgroundImage;
#endif
        [self addSubview:bookView];
        
        [UIView animateWithDuration:0.5f animations:^{
            bookView.alpha = 1;
        }];
    }
}

-(void)errorViewTappedGesture:(UITapGestureRecognizer *)gesture
{
    [super errorViewTappedGesture:gesture];
    [self loadGroupData];
}

#pragma mark - Memory Manager
- (void)dealloc
{
    [[self class] cancelPreviousPerformRequestsWithTarget:self];
    
    imgBackground = nil;
    imgLibraryTitle = nil;
    imgSlideToRight = nil;
    imgSlideToLeft = nil;
    imgBack = nil;
    
    [arrGroup removeAllObjects];
    arrGroup = nil;
    
    [tbvLibraryShelf removeFromSuperview];
    tbvLibraryShelf = nil;
    
    [btnSlideToRight removeFromSuperview];
    btnSlideToRight = nil;
    
    [btnSlideToLeft removeFromSuperview];
    btnSlideToLeft = nil;
    
    [btnBack removeFromSuperview];
    btnBack = nil;
    self.delegate = nil;
}

@end
