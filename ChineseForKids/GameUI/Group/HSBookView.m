//
//  HSBookView.m
//  ChineseForKids
//
//  Created by yang on 13-12-23.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "HSBookView.h"
#import "Constants.h"

@implementation HSBookView
{
    CMPopTipView *popTipView;
    HSBooksListView *booksListView;
    
    UIImage *imgBackground;
    UIImage *imgCover;
    
    UIButton *btnCover;
}

@synthesize imgCover = _imgCover;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor colorWithWhite:0.3f alpha:0.6f];
        imgBackground = [UIImage imageNamed:@""];
        
        [self initInterface];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [imgBackground drawInRect:CGRectMake((self.bounds.size.width - imgBackground.size.width)*0.5f, (self.bounds.size.height - imgBackground.size.height)*0.5f, imgBackground.size.width, imgBackground.size.height)];
}

- (void)initInterface
{
    btnCover = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:btnCover];
}

- (void)setCoverCerter:(CGPoint)coverCerter
{
    _coverCerter = coverCerter;
    btnCover.center = coverCerter;
}

- (void)setImgCover:(UIImage *)aImgCover
{
    //NSLog(@"图片: %@; size: %@", aImgCover, NSStringFromCGSize(aImgCover.size));
    _imgCover = aImgCover;
    [btnCover setImage:aImgCover forState:UIControlStateNormal];
#ifdef DLITE_VERSION
    btnCover.bounds = CGRectMake(0.0f, 0.0f, aImgCover.size.width*1.0f, aImgCover.size.height*1.0f);
#else
    btnCover.bounds = CGRectMake(0.0f, 0.0f, aImgCover.size.width*0.5f, aImgCover.size.height*0.5f);
#endif
    btnCover.center = self.coverCerter;
    btnCover.userInteractionEnabled = NO;
    
    [self showPopTipView];
}

#pragma mark - CMPopTipView Show
- (void)showPopTipView
{
    if (nil == popTipView)
    {
        popTipView = [[CMPopTipView alloc] initWithCustomView:[self popTipCustomView]];
        popTipView.delegate = self;
        popTipView.disableTapToDismiss = YES;
        popTipView.dismissTapAnywhere  = YES;
        popTipView.hasGradientBackground = NO;
        popTipView.backgroundColor = [UIColor colorWithRed:238.0f/255.0f green:201.0f/255.0f blue:131.0f/255.0f alpha:0.8f];
        popTipView.animation = CMPopTipAnimationSlide;
    }
    [popTipView presentPointingAtView:btnCover inView:self animated:YES];
}

- (UIView *)popTipCustomView
{
    if (nil == booksListView)
    {
        CGRect frame = CGRectMake(0.0f, 0.0f, self.bounds.size.width*0.96f, kLIBRARY_SHELF_HEIGHT*0.9f);
        booksListView = [[HSBooksListView alloc] initWithFrame:frame];
        booksListView.delegate = self;
    }
    return booksListView;
}

#pragma mark - CMPopTipView Delegate
- (void)popTipViewWasDismissedByUser:(CMPopTipView *)aPopTipView
{
    [self hidePopTipView];
}

- (void)hidePopTipView
{
    if (popTipView)
    {
        [booksListView cancelLoad];
        [booksListView removeFromSuperview];
        booksListView = nil;
        
        [popTipView dismissAnimated:YES];
        [popTipView removeFromSuperview];
        popTipView = nil;
    }
    [self closeAction:nil];
}

#pragma mark - UIButton Action Manager
- (void)closeAction:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(bookView:close:)])
    {
        [self.delegate bookView:self close:sender];
    }
}

#pragma mark - UITouch Manager
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    //NSLog(@"%@: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    //[self closeAction:nil];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    //NSLog(@"%@: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    //[self closeAction:nil];
}

#pragma mark - BooksListView Delegate
- (void)booksListView:(HSBooksListView *)view selectedBookWithBookID:(NSInteger)bookID
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(bookView:selectedBookWithBookID:)])
    {
        [self.delegate bookView:self selectedBookWithBookID:bookID];
    }
}

#pragma mark - Memory Manager
- (void)dealloc
{
    DLog(@"%@: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    imgBackground = nil;
    
    [btnCover removeFromSuperview];
    btnCover = nil;
    
    imgCover = nil;
    
    
    _delegate = nil;
}

@end
