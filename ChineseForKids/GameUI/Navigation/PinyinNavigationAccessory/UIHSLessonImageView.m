//
//  UIHSLevelImageView.m
//  PinyinGame
//
//  Created by yang on 13-11-11.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "UIHSLessonImageView.h"
//#import "LevelPlaceManager.h"
#import "GlobalDataHelper.h"
#import "GameManager.h"
#import "SceneManager.h"
#import "Constants.h"

@implementation UIHSLessonImageView
{
    //LevelPlaceManager *levelPlace;
    
    UIImage *imgLessonUnLocked;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
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

- (void)setTag:(NSInteger)tag
{
    //levelPlace = [LevelPlaceManager levelPlaceWithUnitID:tag unitRect:self.frame];
    //[self initLevelButton];
    
    [super setTag:tag];
}

- (void)initLessonOneButton
{
    imgLessonUnLocked = [UIImage imageNamed:@"levelUnLocked"];
    UIButton *btnLesson = [UIButton buttonWithType:UIButtonTypeCustom];
    btnLesson.tag = 0;
    btnLesson.bounds = CGRectMake(0.0f, 0.0f, imgLessonUnLocked.size.width, imgLessonUnLocked.size.height);
    [btnLesson setBackgroundImage:imgLessonUnLocked forState:UIControlStateNormal];
    
    NSString *strStar = [NSString stringWithFormat:@"stars%d.png", 0];
    UIImage *imgStars = [UIImage imageNamed:strStar];
    CGSize imgSize = [imgStars size];
    CGSize btnSize = [imgLessonUnLocked size];

    [btnLesson setImage:imgStars forState:UIControlStateNormal];
    [btnLesson setImageEdgeInsets:UIEdgeInsetsMake(btnSize.height + imgSize.height*0.5f, -(imgSize.width - btnSize.width)*0.25f, -(imgSize.height - btnSize.height)*0.25f, -(imgSize.width - btnSize.width)*0.25f)];
    CGFloat x = btnLesson.center.x + self.frame.origin.x;
    CGFloat y = btnLesson.center.y + self.frame.origin.y;
    btnLesson.center = CGPointMake(x, y);
    [btnLesson addTarget:self action:@selector(goGameLesson:) forControlEvents:UIControlEventTouchUpInside];
    [[self superview] addSubview:btnLesson];
}

- (void)initLessonButton
{
    NSArray *arrLessons = nil;//[levelPlace levelButtons];
    NSInteger count = [arrLessons count];
    for (int i = 0; i < count; i++)
    {
        UIButton *btnLesson = (UIButton *)[arrLessons objectAtIndex:i];
        [btnLesson addTarget:self action:@selector(goGameLesson:) forControlEvents:UIControlEventTouchUpInside];
        [[self superview] addSubview:btnLesson];
        
        CGFloat x = btnLesson.frame.origin.x + self.frame.origin.x;
        CGFloat y = btnLesson.frame.origin.y + self.frame.origin.y;
        CGFloat w = btnLesson.bounds.size.width;
        CGFloat h = btnLesson.bounds.size.height;
        btnLesson.frame = CGRectMake(x, y, w, h);
    }
}

- (void)layoutSubviews
{
    DLog(@"%@ %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    //[self initLessonButton];
    [self initLessonOneButton];
}

#pragma mark - Button Action Manager
- (void)goGameLesson:(id)sender
{
    // ImageView的tag存的是Unit的ID.
    // Button存的是level的ID.

    UIButton *btn = (UIButton *)sender;
    [GlobalDataHelper sharedManager].curLessonID = btn.tag;
    
    [self enterLessonSceneWithID:kPinyinGameSceneID];
    
    /*
    [GlobalDataManager sharedManager].curUnitID = 4;
    NSString *levelID = [NSString stringWithFormat:@"%d", 13];
    [self enterLevelSceneWithID:levelID];
     */
}

- (void)enterLessonSceneWithID:(NSString *)ID
{
    [SceneManager loadingWithGameID:ID];
}

#pragma mark - Memory Manager
- (void)dealloc
{
    for (UIButton *subBtn in self.subviews)
    {
        subBtn.imageView.image = nil;
        [subBtn removeFromSuperview];
    }
    imgLessonUnLocked = nil;
}

@end
