//
//  UIHSLandScrollView.m
//  PinyinGame
//
//  Created by yang on 13-11-7.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "UIHSLandScrollView.h"
#import "UIHSLessonImageView.h"
#import "GameManager.h"
#import "GlobalDataHelper.h"
#import "LessonModel.h"

#import "UIImage+Extra.h"

#import "cocos2d.h"
#import "Constants.h"

#define Unit_Locked_Alpha 0.5f
#define Unit_UnLocked_Alpha 1.0f

#define LAND_ONE_RECT CGRectMake(self.bounds.size.width * 0.05f, self.bounds.size.height*0.2f, imgUnitOne.size.width, imgUnitOne.size.height)

#define LAND_TWO_RECT CGRectMake(self.bounds.size.width * 0.58f, self.bounds.size.height*0.278f, imgUnitTwo.size.width, imgUnitTwo.size.height)

#define LAND_THREE_RECT CGRectMake(self.bounds.size.width * 0.947f, self.bounds.size.height*0.0162f, imgUnitThree.size.width, imgUnitThree.size.height)

#define LAND_FOUR_RECT CGRectMake(self.bounds.size.width * 1.66f, self.bounds.size.height*0.3f, imgUnitFour.size.width, imgUnitFour.size.height)

#define LAND_FIVE_RECT CGRectMake(self.bounds.size.width * 1.888f, self.bounds.size.height*0.039f, imgUnitFive.size.width, imgUnitFive.size.height)

#define LAND_SIX_RECT CGRectMake(self.bounds.size.width * 2.165f, self.bounds.size.height*0.292f, imgUnitSix.size.width, imgUnitSix.size.height)

@implementation UIHSLandScrollView
{
    UIImage *imgUnitOne;
    UIImage *imgUnitTwo;
    UIImage *imgUnitThree;
    UIImage *imgUnitFour;
    UIImage *imgUnitFive;
    UIImage *imgUnitSix;
    
    UIHSLessonImageView *imgvUnitOne;
    UIHSLessonImageView *imgvUnitTwo;
    UIHSLessonImageView *imgvUnitThree;
    UIHSLessonImageView *imgvUnitFour;
    UIHSLessonImageView *imgvUnitFive;
    UIHSLessonImageView *imgvUnitSix;
    
    NSMutableArray *arrUnits;
    NSMutableArray *arrLevels;
    
    GameManager *gameManager;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        arrUnits = [[NSMutableArray alloc] initWithCapacity:6];
        arrLevels = [[NSMutableArray alloc] initWithCapacity:6];
        
        gameManager = [GameManager sharedManager];

        [self initUnts];
    }
    return self;
}

- (void)initUnts
{
    for (int i = 0; i < 6; i++)
    {
        UIImage *imgUnit = [self unitImageWithUnitID:i+1 locked:NO];
        CGRect unitFrame = [self unitFrameWithUnitID:i+1];
        
        UIHSLessonImageView *imgvUnit = [self unitImageViewWithUnitID:i+1];
        imgvUnit.image = imgUnit;
        imgvUnit.frame = unitFrame;
        imgvUnit.userInteractionEnabled = YES;
        //NSLog(@"unitID: %d; i: %d", unitID, i);
        //(i >= unitCount-1) ? [self insertSubview:imgvUnit belowSubview:[self viewWithTag:unitID-1]] : [self addSubview:imgvUnit];
        if (i >= 5)
        {
            //UIHSLevelImageView *view = (UIHSLevelImageView *)[self viewWithTag:unitID-1];
            //NSLog(@"倒数第二个view: %@", view);
            [self insertSubview:imgvUnit atIndex:i-1];
        }
        else
        {
            [self addSubview:imgvUnit];
        }
    }
}

- (UIImage *)unitImageWithUnitID:(NSInteger)unitID locked:(BOOL)locked
{
    switch (unitID)
    {
        case 1:
        {
            return imgUnitOne = locked ? [UIImage imageNamed:@"landUnitLocked1.png"] : [UIImage imageNamed:@"landUnit1.png"];
            break;
        }
        case 2:
        {
            return imgUnitTwo = locked ? [UIImage imageNamed:@"landUnitLocked2.png"] : [UIImage imageNamed:@"landUnit2.png"];
            break;
        }
        case 3:
        {
            return imgUnitThree = locked ? [UIImage imageNamed:@"landUnitLocked3.png"] : [UIImage imageNamed:@"landUnit3.png"];
            break;
        }
        case 4:
        {
            return imgUnitFour = locked ? [UIImage imageNamed:@"landUnitLocked4.png"] : [UIImage imageNamed:@"landUnit4.png"];
            break;
        }
        case 5:
        {
            return imgUnitFive = locked ? [UIImage imageNamed:@"landUnitLocked5.png"] : [UIImage imageNamed:@"landUnit5.png"];
            break;
        }
        case 6:
        {
            return imgUnitSix = locked ? [UIImage imageNamed:@"landUnitLocked6.png"] : [UIImage imageNamed:@"landUnit6.png"];
            break;
        }
            
        default:
            return nil;
            break;
    }
}

- (CGRect)unitFrameWithUnitID:(NSInteger)unitID
{
    switch (unitID)
    {
        case 1:
        {
            return LAND_ONE_RECT;
            break;
        }
        case 2:
        {
            return LAND_TWO_RECT;
            break;
        }
        case 3:
        {
            return LAND_THREE_RECT;
            break;
        }
        case 4:
        {
            return LAND_FOUR_RECT;
            break;
        }
        case 5:
        {
            return LAND_FIVE_RECT;
            break;
        }
        case 6:
        {
            return LAND_SIX_RECT;
            break;
        }
            
        default:
            return CGRectZero;
            break;
    }
}

- (UIHSLessonImageView *)unitImageViewWithUnitID:(NSInteger)unitID
{
    switch (unitID)
    {
        case 1:
        {
            return imgvUnitOne = [[UIHSLessonImageView alloc] init];
            break;
        }
        case 2:
        {
            return imgvUnitTwo = [[UIHSLessonImageView alloc] init];
            break;
        }
        case 3:
        {
            return imgvUnitThree = [[UIHSLessonImageView alloc] init];
            break;
        }
        case 4:
        {
            return imgvUnitFour = [[UIHSLessonImageView alloc] init];
            break;
        }
        case 5:
        {
            return imgvUnitFive = [[UIHSLessonImageView alloc] init];
            break;
        }
        case 6:
        {
            return imgvUnitSix = [[UIHSLessonImageView alloc] init];
            break;
        }
            
        default:
            return nil;
            break;
    }
}

#pragma mark - Memory Manager
- (void)dealloc
{
    imgUnitOne = nil;
    imgUnitTwo = nil;
    imgUnitThree = nil;
    imgUnitFour = nil;
    imgUnitFive = nil;
    imgUnitSix = nil;
    
    [imgvUnitOne removeFromSuperview];
    imgvUnitOne = nil;
    
    [imgvUnitTwo removeFromSuperview];
    imgvUnitTwo = nil;
    
    [imgvUnitThree removeFromSuperview];
    imgvUnitThree = nil;
    
    [imgvUnitFour removeFromSuperview];
    imgvUnitFour = nil;
    
    [imgvUnitFive removeFromSuperview];
    imgvUnitFive = nil;
    
    [imgvUnitSix removeFromSuperview];
    imgvUnitSix = nil;
    
    [arrUnits removeAllObjects];
    arrUnits = nil;
    
    [arrLevels removeAllObjects];
    arrLevels = nil;
}

@end
