//
//  HSLearnProgressCustomTableCell.m
//  HSChildrenLearnProgress
//
//  Created by yang on 13-9-24.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "HSLearnProgressCustomTableCell.h"
#import "HSLearnCircleProgressView.h"
#import "HSFontHandleManager.h"
#import "Constants.h"

#define DEFAULT_TEXT_FONT_SIZE 18.0f
#define DEFAULT_PERCENT_FONT_SIZE 18.0f

#define STAR_WIDTH  8
#define STAR_HEIGHT 7

#define RECT_DISTANCE self.bounds.size.width/35.0f

#define TITLE_RECT CGRectMake(0.0f, self.bounds.size.height*0.3, self.bounds.size.width/6.0f, self.bounds.size.height*0.5f)

#define PROGRESS_RECT CGRectMake(TITLE_RECT.origin.x+TITLE_RECT.size.width+RECT_DISTANCE, (self.bounds.size.height - [imgProgressBkg size].height)/2, self.bounds.size.width*5/7.0f - RECT_DISTANCE, [imgProgressBkg size].height)
#define PERCENT_RECT CGRectMake(PROGRESS_RECT.origin.x+PROGRESS_RECT.size.width+RECT_DISTANCE-10, self.bounds.size.height*0.28, self.bounds.size.width/7.0f-RECT_DISTANCE, self.bounds.size.height*0.5)

#define STAR_RECT CGRectMake(PROGRESS_RECT.origin.x+PROGRESS_RECT.size.width-STAR_WIDTH-2, PROGRESS_RECT.origin.y+2, STAR_WIDTH, STAR_HEIGHT)

#define CELL_SEPERATOR_LINE_RECT CGRectMake(0.0f, self.bounds.size.height, self.bounds.size.width, 1.0f)

@implementation HSLearnProgressCustomTableCell
{
    HSLearnCircleProgressView *circleProView;
    UIImage *imgProgressBkg;
    UIImage *imgProgressBlackStar;
    UIImage *imgProgressRedStar;
    UIImage *imgCellSeperatorLine;
    
    UIImage *imgCellHighLight;
    
    UIImageView *imgvCellHighLight;
    UIImageView *imgvProgress;
    UIImageView *imgVStar;
    
    UILabel *lbTitle;
    UILabel *lbPercent;
}
@synthesize titleText = _titleText;
@synthesize percent = _percent;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    //DLog(@"%@, %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.processAnimationDuration = 0.6f;
        imgProgressBkg = [UIImage imageNamed:@"linerLearnProgressBkg.png"];
        imgProgressRedStar = [UIImage imageNamed:@"learnProgressRedStar.png"];
        imgProgressBlackStar = [UIImage imageNamed:@"learnProgressBlackStar.png"];
        imgCellSeperatorLine = [UIImage imageNamed:@"cellSeperatorLine.png"];
        imgCellHighLight = nil;
        
        imgvCellHighLight = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:imgvCellHighLight];
        
        imgvProgress = [[UIImageView alloc] initWithImage:imgProgressBkg];
        [self addSubview:imgvProgress];
        
        circleProView = [[HSLearnCircleProgressView alloc] init];
        circleProView.backgroundColor = [UIColor clearColor];
        [self addSubview:circleProView];
        
        imgVStar = [[UIImageView alloc] initWithImage:imgProgressBlackStar];
        [self addSubview:imgVStar];
        
        lbTitle = [[UILabel alloc] initWithFrame:CGRectZero];
        lbTitle.backgroundColor = [UIColor clearColor];
        lbTitle.textAlignment = NSTextAlignmentRight;
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
    _titleText = aTitleText;
    
    lbTitle.font = [HSFontHandleManager resizableSizeFontWithFont:[UIFont fontWithName:kFontName size:DEFAULT_TEXT_FONT_SIZE] content:aTitleText width:TITLE_RECT.size.width minFontSize:10.0f lineBreakMode:NSLineBreakByCharWrapping];
    lbTitle.text = aTitleText;
    [lbTitle sizeToFit];
    //[self setNeedsDisplayInRect:TITLE_RECT];
}

- (void)setPercent:(CGFloat)aPercent
{
    _percent = aPercent >= 1 ? 1 : aPercent;
    [self refreshCircleProgressViewWithPercent:aPercent];
    [self refreshProgressStarWithPercent:aPercent];
    
    NSString *strTempPercent = [NSString stringWithFormat:@"%.f%%", self.percent*100];
    lbPercent.font = [HSFontHandleManager resizableSizeFontWithFont:[UIFont fontWithName:kFontName size:DEFAULT_PERCENT_FONT_SIZE] content:strTempPercent width:PERCENT_RECT.size.width minFontSize:6.0f lineBreakMode:NSLineBreakByCharWrapping];
    lbPercent.text = strTempPercent;
    //[self setNeedsDisplayInRect:PERCENT_RECT];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    imgCellHighLight = selected ? [UIImage imageNamed:@"cellHighBkg.png"] : nil;
    
    [UIView animateWithDuration:0.3f animations:^{imgvCellHighLight.alpha = 0.0f;}];
    imgvCellHighLight.image = imgCellHighLight;
    [UIView animateWithDuration:0.3f animations:^{imgvCellHighLight.alpha = 1.0f;}];
}

- (void)layoutSubviews
{
    if (circleProView)
    {
        circleProView.frame = PROGRESS_RECT;
    }
    
    if (imgvCellHighLight)
    {
        imgvCellHighLight.frame = self.bounds;
    }
    if (imgvProgress)
    {
        imgvProgress.frame = PROGRESS_RECT;
    }
    
    if (imgVStar)
    {
        imgVStar.frame = STAR_RECT;
    }
    
    if (lbTitle)
    {
        CGSize titleSize = [_titleText sizeWithFont:lbTitle.font];
        
        lbTitle.frame = CGRectMake(TITLE_RECT.origin.x, (self.bounds.size.height-titleSize.height)*0.5f, TITLE_RECT.size.width, titleSize.height);
    }
    
    if (lbPercent)
    {
        lbPercent.frame = PERCENT_RECT;
    }
}

- (void)refreshCircleProgressViewWithPercent:(CGFloat)aPercent
{
    if (circleProView)
    {
        circleProView.animationDuration = self.processAnimationDuration;
        circleProView.progressTintColor = (aPercent >= 1) ? [UIColor colorWithRed:120.0f/255.0f green:249.0f/255.0f blue:117.0f/255.0f alpha:1.0f] : [UIColor colorWithRed:249.0f/255.0f green:213.0f/255.0f blue:117.0f/255.0f alpha:1.0f];
        circleProView.progressType = HSChildrenLearnProgressTypeLiner;
        //circleProView.translatesAutoresizingMaskIntoConstraints = NO;
        [circleProView setCurrent:aPercent animated:YES];
    }
}

- (void)refreshProgressStarWithPercent:(CGFloat)aPercent
{
    if (imgVStar)
    {
        imgVStar.image =  aPercent >= 1 ? imgProgressRedStar : imgProgressBlackStar;
    }
}

- (void)drawRect:(CGRect)rect
{
    //[imgCellHighLight drawInRect:rect];
    /*
    UIFont *font = [HSFontHandleManager resizableSizeFontWithFont:[UIFont fontWithName:kFontName size:DEFAULT_TEXT_FONT_SIZE] content:_titleText width:TITLE_RECT.size.width minFontSize:6.0f lineBreakMode:NSLineBreakByCharWrapping];
    CGSize titleSize = [_titleText sizeWithFont:font];
    [_titleText drawInRect:CGRectMake(TITLE_RECT.origin.x, (self.bounds.size.height-titleSize.height)*0.5f, TITLE_RECT.size.width, titleSize.height) withFont:font lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentRight];
    */
    /*
    NSString *strTempPercent = [NSString stringWithFormat:@"%.f%%", self.percent*100];
    font = [HSFontHandleManager resizableSizeFontWithFont:[UIFont fontWithName:kFontName size:DEFAULT_PERCENT_FONT_SIZE] content:strTempPercent width:PERCENT_RECT.size.width minFontSize:6.0f lineBreakMode:NSLineBreakByCharWrapping];
    [strTempPercent drawInRect:PERCENT_RECT withFont:font lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentCenter];
    */
    //[imgProgressBkg drawInRect:PROGRESS_RECT];
    [imgCellSeperatorLine drawInRect:CELL_SEPERATOR_LINE_RECT];
}

- (void)dealloc
{
    DLog(@"%@, %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    self.titleText = nil;
    imgProgressBkg = nil;
    imgProgressRedStar = nil;
    imgProgressBlackStar = nil;
    
    imgCellSeperatorLine = nil;
    imgCellHighLight = nil;
    
    [imgVStar removeFromSuperview];
    imgVStar = nil;
    
    [circleProView removeFromSuperview];
    circleProView = nil;
}

@end
