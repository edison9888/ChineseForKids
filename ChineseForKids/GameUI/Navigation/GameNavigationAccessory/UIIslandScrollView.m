//
//  UIIslandScrollView.m
//  ChineseForKids
//
//  Created by yang on 13-12-20.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "UIIslandScrollView.h"
#import "UINetworkLoadingView.h"
#import "GameManager.h"
#import "GlobalDataHelper.h"
#import "LessonNet.h"
#import "LessonModel.h"
#import "ResponseModel.h"
#import "SceneManager.h"

#import "UIImage+Extra.h"

#import "cocos2d.h"
#import "Constants.h"

@interface UIIslandScrollView ()<UINetworkLoadingViewDelegate>
{
    UINetworkLoadingView *loadingView;
}

@end

@implementation UIIslandScrollView
{
    NSMutableArray *arrLesson;
    NSMutableArray *arrLessonNode;
    
    NSString *curUserID;
    NSInteger curHumanID;
    NSInteger curGroupID;
    NSInteger curBookID;
    NSInteger curTypeID;
    
    UIImage *imgLessonLocked;
    UIImage *imgLessonUnLocked;
    
    UIImage *imgIsland1;
    UIImage *imgIsland2;
    UIImage *imgIsland3;
    
    UIImageView *imgvIsland1;
    UIImageView *imgvIsland2;
    UIImageView *imgvIsland3;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        curUserID   = [GlobalDataHelper sharedManager].curUserID;
        curHumanID  = [GlobalDataHelper sharedManager].curHumanID;
        curGroupID  = [GlobalDataHelper sharedManager].curGroupID;
        curBookID   = [GlobalDataHelper sharedManager].curBookID;
        curTypeID   = [GlobalDataHelper sharedManager].curTypeID;
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:curUserID forKey:@"UserID"];
        [userDefaults setInteger:curHumanID forKey:@"HumanID"];
        [userDefaults setInteger:curGroupID forKey:@"GroupID"];
        [userDefaults setInteger:curBookID forKey:@"BookID"];
        [userDefaults setInteger:curTypeID forKey:@"TypeID"];
        [userDefaults setBool:YES forKey:@"Game"];
        
        imgLessonLocked = [UIImage imageNamed:@"lessonLocked.png"];
        imgLessonUnLocked = [UIImage imageNamed:@"lessonUnLocked.png"];
        
        imgIsland1 = [UIImage imageNamed:@"isLand1.png"];
        imgIsland2 = [UIImage imageNamed:@"isLand2.png"];
        imgIsland3 = [UIImage imageNamed:@"isLand3.png"];
        
        arrLesson = [[NSMutableArray alloc] init];
        arrLessonNode = [[NSMutableArray alloc] init];
        
        //[self performSelectorInBackground:@selector(updateGameNavigationData) withObject:nil];
        [self loadLessonNodePosition];
        [self initInterface];
        
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

#pragma mark - LoadData
- (NSArray *)loadLessonNodePosition
{
#ifdef DLITE_VERSION
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"lessonNodePosition" ofType:@"plist"];
    NSArray *arrNode = [NSArray arrayWithContentsOfFile:filePath];
    if (arrNode){
        [arrLessonNode setArray:arrNode];
    }
#else
    CGSize boundSize = self.bounds.size;
    
    CGPoint position1 = CGPointMake(boundSize.width * 0.15f, boundSize.height*0.38f);
    NSValue *value1 = [NSValue valueWithCGPoint:position1];
    [arrLessonNode addObject:value1];
    
    CGPoint position2 = CGPointMake(boundSize.width * 0.163f, boundSize.height*0.49f);
    NSValue *value2 = [NSValue valueWithCGPoint:position2];
    [arrLessonNode addObject:value2];
    
    CGPoint position3 = CGPointMake(boundSize.width * 0.27f, boundSize.height*0.56f);
    NSValue *value3 = [NSValue valueWithCGPoint:position3];
    [arrLessonNode addObject:value3];
    
    CGPoint position4 = CGPointMake(boundSize.width * 0.38f, boundSize.height*0.56f);
    NSValue *value4 = [NSValue valueWithCGPoint:position4];
    [arrLessonNode addObject:value4];
    
    CGPoint position5 = CGPointMake(boundSize.width * 0.48f, boundSize.height*0.5f);
    NSValue *value5 = [NSValue valueWithCGPoint:position5];
    [arrLessonNode addObject:value5];
    
    CGPoint position6 = CGPointMake(boundSize.width * 0.62f, boundSize.height*0.43f);
    NSValue *value6 = [NSValue valueWithCGPoint:position6];
    [arrLessonNode addObject:value6];
    
    CGPoint position7 = CGPointMake(boundSize.width * 0.53f, boundSize.height*0.39f);
    NSValue *value7 = [NSValue valueWithCGPoint:position7];
    [arrLessonNode addObject:value7];
    
    CGPoint position8 = CGPointMake(boundSize.width * 0.42f, boundSize.height*0.38f);
    NSValue *value8 = [NSValue valueWithCGPoint:position8];
    [arrLessonNode addObject:value8];
    
    CGPoint position9 = CGPointMake(boundSize.width * 0.39f, boundSize.height*0.3f);
    NSValue *value9 = [NSValue valueWithCGPoint:position9];
    [arrLessonNode addObject:value9];
    
    CGPoint position10 = CGPointMake(boundSize.width * 0.55f, boundSize.height*0.23f);
    NSValue *value10 = [NSValue valueWithCGPoint:position10];
    [arrLessonNode addObject:value10];
    
    CGPoint position11 = CGPointMake(boundSize.width * 0.6f, boundSize.height*0.17f);
    NSValue *value11 = [NSValue valueWithCGPoint:position11];
    [arrLessonNode addObject:value11];
    
    CGPoint position12 = CGPointMake(boundSize.width * 0.5f, boundSize.height*0.15f);
    NSValue *value12 = [NSValue valueWithCGPoint:position12];
    [arrLessonNode addObject:value12];
    
    CGPoint position13 = CGPointMake(boundSize.width * 0.6f, boundSize.height*0.09f);
    NSValue *value13 = [NSValue valueWithCGPoint:position13];
    [arrLessonNode addObject:value13];
    
    CGPoint position14 = CGPointMake(boundSize.width * 0.7f, boundSize.height*0.25f);
    NSValue *value14 = [NSValue valueWithCGPoint:position14];
    [arrLessonNode addObject:value14];
    
    CGPoint position15 = CGPointMake(boundSize.width * 0.8f, boundSize.height*0.35f);
    NSValue *value15 = [NSValue valueWithCGPoint:position15];
    [arrLessonNode addObject:value15];
    
    CGPoint position16 = CGPointMake(boundSize.width * 0.82f, boundSize.height*0.46f);
    NSValue *value16 = [NSValue valueWithCGPoint:position16];
    [arrLessonNode addObject:value16];
    
    CGPoint position17 = CGPointMake(boundSize.width * 0.77f, boundSize.height*0.6f);
    NSValue *value17 = [NSValue valueWithCGPoint:position17];
    [arrLessonNode addObject:value17];
    
    CGPoint position18 = CGPointMake(boundSize.width * 0.89f, boundSize.height*0.66f);
    NSValue *value18 = [NSValue valueWithCGPoint:position18];
    [arrLessonNode addObject:value18];
    
    CGPoint position19 = CGPointMake(boundSize.width * 0.88f, boundSize.height*0.55f);
    NSValue *value19 = [NSValue valueWithCGPoint:position19];
    [arrLessonNode addObject:value19];
    
    CGPoint position20 = CGPointMake(boundSize.width * 1.0f, boundSize.height*0.59f);
    NSValue *value20 = [NSValue valueWithCGPoint:position20];
    [arrLessonNode addObject:value20];
    
    CGPoint position21 = CGPointMake(boundSize.width * 1.28f, boundSize.height*0.48f);
    NSValue *value21 = [NSValue valueWithCGPoint:position21];
    [arrLessonNode addObject:value21];
    
    CGPoint position22 = CGPointMake(boundSize.width * 1.34f, boundSize.height*0.58f);
    NSValue *value22 = [NSValue valueWithCGPoint:position22];
    [arrLessonNode addObject:value22];
    
    CGPoint position23 = CGPointMake(boundSize.width * 1.45f, boundSize.height*0.63f);
    NSValue *value23 = [NSValue valueWithCGPoint:position23];
    [arrLessonNode addObject:value23];
    
    CGPoint position24 = CGPointMake(boundSize.width * 1.42f, boundSize.height*0.54f);
    NSValue *value24 = [NSValue valueWithCGPoint:position24];
    [arrLessonNode addObject:value24];
    
    CGPoint position25 = CGPointMake(boundSize.width * 1.52f, boundSize.height*0.51f);
    NSValue *value25 = [NSValue valueWithCGPoint:position25];
    [arrLessonNode addObject:value25];
    
    CGPoint position26 = CGPointMake(boundSize.width * 1.63f, boundSize.height*0.5f);
    NSValue *value26 = [NSValue valueWithCGPoint:position26];
    [arrLessonNode addObject:value26];
    
    CGPoint position27 = CGPointMake(boundSize.width * 1.713f, boundSize.height*0.45f);
    NSValue *value27 = [NSValue valueWithCGPoint:position27];
    [arrLessonNode addObject:value27];
    
    CGPoint position28 = CGPointMake(boundSize.width * 1.68f, boundSize.height*0.33f);
    NSValue *value28 = [NSValue valueWithCGPoint:position28];
    [arrLessonNode addObject:value28];
    
    CGPoint position29 = CGPointMake(boundSize.width * 1.57f, boundSize.height*0.28f);
    NSValue *value29 = [NSValue valueWithCGPoint:position29];
    [arrLessonNode addObject:value29];
    
    CGPoint position30 = CGPointMake(boundSize.width * 1.67f, boundSize.height*0.23f);
    NSValue *value30 = [NSValue valueWithCGPoint:position30];
    [arrLessonNode addObject:value30];
    
    CGPoint position31 = CGPointMake(boundSize.width * 1.82f, boundSize.height*0.22f);
    NSValue *value31 = [NSValue valueWithCGPoint:position31];
    [arrLessonNode addObject:value31];
    
    CGPoint position32 = CGPointMake(boundSize.width * 1.92f, boundSize.height*0.22f);
    NSValue *value32 = [NSValue valueWithCGPoint:position32];
    [arrLessonNode addObject:value32];
    
    CGPoint position33 = CGPointMake(boundSize.width * 2.07f, boundSize.height*0.25f);
    NSValue *value33 = [NSValue valueWithCGPoint:position33];
    [arrLessonNode addObject:value33];
    
    CGPoint position34 = CGPointMake(boundSize.width * 1.86f, boundSize.height*0.29f);
    NSValue *value34 = [NSValue valueWithCGPoint:position34];
    [arrLessonNode addObject:value34];
    
    CGPoint position35 = CGPointMake(boundSize.width * 1.94f, boundSize.height*0.39f);
    NSValue *value35 = [NSValue valueWithCGPoint:position35];
    [arrLessonNode addObject:value35];
    
    CGPoint position36 = CGPointMake(boundSize.width * 2.01f, boundSize.height*0.33f);
    NSValue *value36 = [NSValue valueWithCGPoint:position36];
    [arrLessonNode addObject:value36];
    
    CGPoint position37 = CGPointMake(boundSize.width * 2.11f, boundSize.height*0.38f);
    NSValue *value37 = [NSValue valueWithCGPoint:position37];
    [arrLessonNode addObject:value37];
    
    CGPoint position38 = CGPointMake(boundSize.width * 2.27f, boundSize.height*0.37f);
    NSValue *value38 = [NSValue valueWithCGPoint:position38];
    [arrLessonNode addObject:value38];
    
    CGPoint position39 = CGPointMake(boundSize.width * 2.21f, boundSize.height*0.42f);
    NSValue *value39 = [NSValue valueWithCGPoint:position39];
    [arrLessonNode addObject:value39];
    
    CGPoint position40 = CGPointMake(boundSize.width * 2.14f, boundSize.height*0.46f);
    NSValue *value40 = [NSValue valueWithCGPoint:position40];
    [arrLessonNode addObject:value40];
    
    CGPoint position41 = CGPointMake(boundSize.width * 2.22f, boundSize.height*0.57f);
    NSValue *value41 = [NSValue valueWithCGPoint:position41];
    [arrLessonNode addObject:value41];
    
    CGPoint position42 = CGPointMake(boundSize.width * 2.32f, boundSize.height*0.63f);
    NSValue *value42 = [NSValue valueWithCGPoint:position42];
    [arrLessonNode addObject:value42];
    
    CGPoint position43 = CGPointMake(boundSize.width * 2.4f, boundSize.height*0.62f);
    NSValue *value43 = [NSValue valueWithCGPoint:position43];
    [arrLessonNode addObject:value43];
    
    CGPoint position44 = CGPointMake(boundSize.width * 2.47f, boundSize.height*0.56f);
    NSValue *value44 = [NSValue valueWithCGPoint:position44];
    [arrLessonNode addObject:value44];
    
    CGPoint position45 = CGPointMake(boundSize.width * 2.49f, boundSize.height*0.48f);
    NSValue *value45 = [NSValue valueWithCGPoint:position45];
    [arrLessonNode addObject:value45];
    
    CGPoint position46 = CGPointMake(boundSize.width * 2.41f, boundSize.height*0.44f);
    NSValue *value46 = [NSValue valueWithCGPoint:position46];
    [arrLessonNode addObject:value46];
#endif
    
    return arrLessonNode;
}

#pragma mark - 开启网络更新本课程导航
- (void)updateGameNavigationData
{
    NSString *strBookID = [NSString stringWithFormat:@"%d", curBookID];
    NSString *strTypeID = [NSString stringWithFormat:@"%d", curTypeID];
    ResponseModel *response = [LessonNet getLessonsInfoWithUserID:curUserID HumanID:@"" GroupID:@"" BookID:strBookID TypeID:strTypeID];
    if ([LessonNet isRequestCanceled]) return;
    
    if (response.error.code != 0)
    {
        [self updateGameNavigationData];
    }
}

- (void)loadLessonData
{
    NSArray *arrTLesson = [[GameManager sharedManager] loadLessonDataWithUserID:curUserID humanID:curHumanID groupID:curGroupID bookID:curBookID typeID:curTypeID];
    if (arrTLesson && [arrTLesson count] > 0)
    {
        // 排序, 升序排列
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"lessonIndexValue" ascending:YES];
        arrTLesson = [arrTLesson sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
        
        [arrLesson setArray:arrTLesson];
        //DLog(@"导航的所有课程: %@", arrLesson);
    }
    [self initLessonNode];
}

#pragma mark - Init Manager
- (void)showLoadingView
{
    if (!loadingView)
    {
        loadingView = [[UINetworkLoadingView alloc] initWithFrame:self.superview.bounds];
        loadingView.delegate = self;
        [self.superview insertSubview:loadingView atIndex:2];
        [loadingView showLoadingView];
    }
}

- (void)initInterface
{
    CGSize scrollSize = self.bounds.size;
    // 初始化各个小岛图片
    imgvIsland1 = [[UIImageView alloc] initWithImage:imgIsland1];
    imgvIsland1.center = CGPointMake(scrollSize.width*0.46f, scrollSize.height*0.54f);
    [self addSubview:imgvIsland1];
    
    imgvIsland2 = [[UIImageView alloc] initWithImage:imgIsland2];
    imgvIsland2.center = CGPointMake(scrollSize.width*0.9f, scrollSize.height*0.77f);
    [self addSubview:imgvIsland2];
    
    imgvIsland3 = [[UIImageView alloc] initWithImage:imgIsland3];
    imgvIsland3.center = CGPointMake(scrollSize.width*1.9f, scrollSize.height*0.54f);
    [self addSubview:imgvIsland3];
}

- (void)initLessonNode
{
    // 初始化各个课程节点
    NSInteger positionCount = [arrLessonNode count];
    //NSLog(@"课程数目: %d", positionCount);
#ifdef DLITE_VERSION
    for (int i = 0; i < positionCount; i++)
    {
        UIButton *btnLesson = [self buttonWithTag:i lockedStatu:NO starsNum:0];
        //NSValue *value = [arrLessonNode objectAtIndex:i];
        NSString *strValue = [arrLessonNode objectAtIndex:i];
        
        CGPoint position = CGPointFromString(strValue);//[value CGPointValue];
        
        [btnLesson addTarget:self action:@selector(goLesson:) forControlEvents:UIControlEventTouchUpInside];
        btnLesson.center = position;
        [self addSubview:btnLesson];
    }
#else
    NSInteger lessonCount = [arrLesson count];
    for (int i = 0; i < lessonCount; i++)
    {
        LessonModel *lessonModel = [arrLesson objectAtIndex:i];
        UIButton *btnLesson = [self buttonWithTag:lessonModel.lessonIDValue lockedStatu:lessonModel.lockedValue starsNum:lessonModel.starAmountValue];
        if (positionCount > i)
        {
            NSValue *value = [arrLessonNode objectAtIndex:i];
            CGPoint position = [value CGPointValue];
            
            [btnLesson addTarget:self action:@selector(goLesson:) forControlEvents:UIControlEventTouchUpInside];
            btnLesson.center = position;
            [self addSubview:btnLesson];
        }
    }
#endif
}

- (UIButton *)buttonWithTag:(NSInteger)tag lockedStatu:(BOOL)locked starsNum:(NSInteger)stars
{
    UIButton *btnLesson = [UIButton buttonWithType:UIButtonTypeCustom];
    btnLesson.tag = tag;
    btnLesson.bounds = CGRectMake(0.0f, 0.0f, imgLessonUnLocked.size.width, imgLessonUnLocked.size.height);
    btnLesson.enabled = !locked;
    
    [btnLesson setBackgroundImage:(locked ? imgLessonLocked : imgLessonUnLocked) forState:UIControlStateNormal];
    NSString *strStar = [NSString stringWithFormat:@"stars%d.png", stars];
    UIImage *imgStars = [UIImage imageNamed:strStar];
    CGSize imgSize = [imgStars size];
    CGSize btnSize = [imgLessonUnLocked size];
     
    [btnLesson setImage:imgStars forState:UIControlStateNormal];
    [btnLesson setImageEdgeInsets:UIEdgeInsetsMake(btnSize.height + imgSize.height*0.5f, -(imgSize.width - btnSize.width)*0.25f, -(imgSize.height - btnSize.height)*0.25f, -(imgSize.width - btnSize.width)*0.25f)];
    return btnLesson;
}

#pragma mark - UIButton Action Manager
- (void)goLesson:(id)sender
{
#ifdef DLITE_VERSION
    [GlobalDataHelper sharedManager].curLessonID = 0;
#else
    UIButton *btn = (UIButton *)sender;
    [GlobalDataHelper sharedManager].curLessonID = btn.tag;
#endif
    [SceneManager loadingWithGameID:[self gameSceneID]];
}

- (NSString *)gameSceneID
{
    NSInteger typeID = [GlobalDataHelper sharedManager].curTypeID;
    NSString *gameSceneID = kPinyinGameSceneID;
    switch (typeID)
    {
        case 1:
        {
            gameSceneID = kPinyinGameSceneID;
            break;
        }
        case 2:
        {
            gameSceneID = kWordGameSceneID;
            break;
        }
        case 3:
        {
            gameSceneID = kSentenceGameSceneID;
            break;
        }
        case 4:
        {
            gameSceneID = kTranslateGameSceneID;
            break;
        }
        default:
            break;
    }
    return gameSceneID;
}

#pragma mark - NetworkLoadingViewDelegate
- (void)loadingView:(UINetworkLoadingView *)view errorViewTapped:(UITapGestureRecognizer *)gesture
{
    [self loadLessonData];
}

- (void)removeLoadingView
{
    if (loadingView)
    {
        [loadingView hideLoadingView];
        [loadingView removeFromSuperview];
        loadingView = nil;
    }
}

#pragma mark - Memory Manager
- (void)dealloc
{
    [[self class] cancelPreviousPerformRequestsWithTarget:self];
    [LessonNet cancelRequest];
    
    curUserID = nil;
    imgLessonLocked = nil;
    imgLessonUnLocked = nil;
    
    arrLesson = nil;
    arrLessonNode = nil;
    
    [LessonNet cancelRequest];
    [self removeLoadingView];
    
    for (UIView *view in [self subviews]) [view removeFromSuperview];
}

@end
