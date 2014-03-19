//
//  HSTKnowledgeCustomHeaderView.m
//  ChineseForKids
//
//  Created by yang on 14-3-19.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import "HSTKnowledgeCustomHeaderView.h"
#import "HSLearnCircleProgressView.h"
#import "HSFontHandleManager.h"
#import "Constants.h"

#define DEFAULT_TEXT_FONT_SIZE 20.0f
#define DEFAULT_PERCENT_FONT_SIZE 18.0f

#define STAR_WIDTH  8
#define STAR_HEIGHT 7

#define RECT_DISTANCE self.bounds.size.width/35.0f

#define TITLE_RECT CGRectMake(0.0f, self.bounds.size.height*0.3, self.bounds.size.width/5.0f, self.bounds.size.height*0.5f)

#define PROGRESS_RECT CGRectMake(TITLE_RECT.origin.x+TITLE_RECT.size.width+RECT_DISTANCE, (self.bounds.size.height - [imgProgressBkg size].height)/2, self.bounds.size.width*3/7.0f - RECT_DISTANCE, [imgProgressBkg size].height)
#define PERCENT_RECT CGRectMake(PROGRESS_RECT.origin.x+PROGRESS_RECT.size.width+RECT_DISTANCE-10, self.bounds.size.height*0.28, self.bounds.size.width/7.0f-RECT_DISTANCE, self.bounds.size.height*0.5)

#define STAR_RECT CGRectMake(PROGRESS_RECT.origin.x+PROGRESS_RECT.size.width-STAR_WIDTH-2, PROGRESS_RECT.origin.y+2, STAR_WIDTH, STAR_HEIGHT)

@implementation HSTKnowledgeCustomHeaderView
{
    HSLearnCircleProgressView *circleProView;
    UIImage *imgProgressBkg;
    UIImage *imgProgressBlackStar;
    UIImage *imgProgressRedStar;
    
    UIImageView *imgvProgress;
    UIImageView *imgVStar;
    
    UILabel *lbTitle;
    UILabel *lbPercent;
}
@synthesize titleText = _titleText;
@synthesize percent = _percent;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.7f];
        self.processAnimationDuration = 0.6f;
        imgProgressBkg = [UIImage imageNamed:@"linerLearnProgressBkg.png"];
        imgProgressRedStar = [UIImage imageNamed:@"learnProgressRedStar.png"];
        imgProgressBlackStar = [UIImage imageNamed:@"learnProgressBlackStar.png"];
        
        imgvProgress = [[UIImageView alloc] initWithImage:imgProgressBkg];
        [self addSubview:imgvProgress];
        
        circleProView = [[HSLearnCircleProgressView alloc] init];
        circleProView.backgroundColor = [UIColor clearColor];
        [self addSubview:circleProView];
        
        imgVStar = [[UIImageView alloc] initWithImage:imgProgressBlackStar];
        [self addSubview:imgVStar];
        
        lbTitle = [[UILabel alloc] initWithFrame:CGRectZero];
        lbTitle.backgroundColor = [UIColor clearColor];
        lbTitle.textAlignment = NSTextAlignmentLeft;
        lbTitle.numberOfLines = 0;
        [self addSubview:lbTitle];
        
        lbPercent = [[UILabel alloc] initWithFrame:CGRectZero];
        lbPercent.backgroundColor = [UIColor clearColor];
        lbPercent.textAlignment = NSTextAlignmentLeft;
        lbPercent.numberOfLines = 0;
        [self addSubview:lbPercent];
    }
    return self;
}

- (void)setTitleText:(NSString *)aTitleText
{
    NSString *tTtitle = [[NSString alloc] initWithFormat:@"   %@", aTitleText];
    _titleText = tTtitle;
    
    lbTitle.font = [HSFontHandleManager resizableSizeFontWithFont:[UIFont fontWithName:kFontName size:DEFAULT_TEXT_FONT_SIZE] content:aTitleText width:TITLE_RECT.size.width minFontSize:10.0f lineBreakMode:NSLineBreakByCharWrapping];
    lbTitle.text = tTtitle;
    [self setNeedsLayout];
}

- (void)setPercent:(CGFloat)aPercent
{
    _percent = aPercent >= 1 ? 1 : aPercent;
    [self refreshCircleProgressViewWithPercent:aPercent];
    [self refreshProgressStarWithPercent:aPercent];
    
    NSString *strTempPercent = [NSString stringWithFormat:@"%.f%%", self.percent*100];
    lbPercent.font = [HSFontHandleManager resizableSizeFontWithFont:[UIFont fontWithName:kFontName size:DEFAULT_PERCENT_FONT_SIZE] content:strTempPercent width:PERCENT_RECT.size.width minFontSize:6.0f lineBreakMode:NSLineBreakByCharWrapping];
    lbPercent.text = strTempPercent;
}

- (void)layoutSubviews
{
    if (circleProView) circleProView.frame = PROGRESS_RECT;
    if (imgvProgress) imgvProgress.frame = PROGRESS_RECT;
    if (imgVStar) imgVStar.frame = STAR_RECT;
    if (lbPercent) lbPercent.frame = PERCENT_RECT;
    
    if (lbTitle)
    {
        CGSize titleSize = [_titleText sizeWithFont:lbTitle.font];
        
        lbTitle.frame = CGRectMake(TITLE_RECT.origin.x, (self.bounds.size.height-titleSize.height)*0.5f, TITLE_RECT.size.width, titleSize.height);
    }
}

- (void)refreshCircleProgressViewWithPercent:(CGFloat)aPercent
{
    if (circleProView)
    {
        circleProView.animationDuration = self.processAnimationDuration;
        circleProView.progressTintColor = (aPercent >= 1) ? [UIColor colorWithRed:120.0f/255.0f green:249.0f/255.0f blue:117.0f/255.0f alpha:1.0f] : [UIColor colorWithRed:249.0f/255.0f green:213.0f/255.0f blue:117.0f/255.0f alpha:1.0f];
        circleProView.progressType = HSChildrenLearnProgressTypeLiner;
        [circleProView setCurrent:aPercent animated:YES];
    }
}

- (void)refreshProgressStarWithPercent:(CGFloat)aPercent
{
    if (imgVStar) imgVStar.image =  aPercent >= 1 ? imgProgressRedStar : imgProgressBlackStar;
}

#pragma mark - Memory Manager
- (void)dealloc
{
    DLog(@"%@, %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    self.titleText = nil;
    imgProgressBkg = nil;
    imgProgressRedStar = nil;
    imgProgressBlackStar = nil;
    
    [imgVStar removeFromSuperview];
    imgVStar = nil;
    
    [circleProView removeFromSuperview];
    circleProView = nil;
}

@end
