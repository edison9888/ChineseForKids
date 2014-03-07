//
//  GameNavigationScene.m
//  ChineseForKids
//
//  Created by yang on 13-12-18.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "GameNavigationScene.h"
#import "SimpleAudioEngine.h"
#import "SceneManager.h"
#import "UIHSSettingView.h"
#import "UIIslandScrollView.h"
#import "CCParallaxNode-Extras.h"
#import "ResponseModel.h"
#import "LessonNet.h"
#import "Constants.h"
#import "cocos2d.h"

#define kGameNavigationBkg_z -1
#define kGameNavSmallCloud_z 0
#define kGameNavBigCloud_z   1
#define kGameNavIsland_z     2

#define ScrollView_Width self.boundingBox.size.width
#define ScrollView_Height self.boundingBox.size.height
#define ScrollView_Pages 3

@interface GameNavigationScene ()<UIScrollViewDelegate, UIHSSettingViewDelegate>
{
    UIButton *btnSetting;
    UIButton *btnAboutUs;
    UIButton *btnBackType;
    
    UIImage *imgSetting;
    UIImage *imgAboutUs;
    UIImage *imgBack;
    UIImage *imgFCloud1;
    UIImage *imgFCloud2;
    UIImage *imgFCloud3;
    
    UIImageView *imgvFCloud1;
    UIImageView *imgvFCloud2;
    UIImageView *imgvFCloud3;
    
    // 控制小岛移动的滚动视图
    UIIslandScrollView *svLands;
    UIScrollView *svBigCloud;
    
    CCSprite *spBkg;
    CCSprite *spSun;
    
    // 移动的小云
    CCParallaxNode *parallaxSCloud;
    // 小岛后面移动的大云
    CCParallaxNode *parallaxBCloud;
    // 小岛前面移动的大云
    //CCParallaxNode *parallaxFBCloud;
    // 移动的山
    //CCParallaxNode *parallaxIsland;
    
    UIHSSettingView *settingView;
    
    CGPoint oldOffset;
}

@end

@implementation GameNavigationScene

- (id)init
{
    if (self = [super init])
    {
        CCLOG(@"%@: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
        
        glClearColor(1.0f, 1.0f, 1.0f, 1.0f);
        
        imgSetting = [UIImage imageNamed:@"btnSetting.png"];
        imgAboutUs = [UIImage imageNamed:@"btnAboutUs.png"];
        imgBack    = [UIImage imageNamed:@"btnBack.png"];
        
        imgFCloud1 = [UIImage imageNamed:@"fCloud.png"];
        imgFCloud2 = [UIImage imageNamed:@"fCloud.png"];
        imgFCloud3 = [UIImage imageNamed:@"fCloud.png"];
        
        [self initInterface];
        
        [self initParallaxSCloud];
        [self initParallaxBCloud];
        [self initParallaxFrontBigCloud];
        
        [self scheduleUpdate];
        
        // 自动滚动最上层的那个云层
        [self schedule:@selector(updateFrontBigCloudPosition:) interval:0.0f];
    }
    return self;
}

- (void)initInterface
{
    CGSize boundSize = self.boundingBox.size;
    
    spBkg = [CCSprite spriteWithSpriteFrameName:@"navigationBkg.png"];
    spBkg.position = ccp(boundSize.width*0.5f, boundSize.height*0.5f);
    [self addChild:spBkg z:kGameNavigationBkg_z];
    
    spSun = [CCSprite spriteWithSpriteFrameName:@"sun.png"];
    spSun.position = ccp(boundSize.width*0.8f, boundSize.height*0.7f);
    [self addChild:spSun z:kGameNavigationBkg_z];
    
    // 漂浮的仙岛滚动控制。
    svLands = [[UIIslandScrollView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, ScrollView_Width, ScrollView_Height)];
    svLands.delegate = self;
    svLands.backgroundColor = [UIColor clearColor];
    svLands.pagingEnabled = NO;
    svLands.scrollEnabled = YES;
    svLands.showsHorizontalScrollIndicator = NO;
    svLands.showsVerticalScrollIndicator = NO;
    svLands.contentSize = CGSizeMake(ScrollView_Width*ScrollView_Pages, 0.0f);
    [[[CCDirector sharedDirector] view] addSubview:svLands];
    
    // 大云滚动控制。
    svBigCloud = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, ScrollView_Width, ScrollView_Height)];
    svBigCloud.delegate = self;
    svBigCloud.backgroundColor = [UIColor clearColor];
    svBigCloud.pagingEnabled = NO;
    svBigCloud.scrollEnabled = YES;
    svBigCloud.userInteractionEnabled = NO;
    svBigCloud.showsHorizontalScrollIndicator = NO;
    svBigCloud.showsVerticalScrollIndicator = NO;
    svBigCloud.contentSize = CGSizeMake(ScrollView_Width*ScrollView_Pages, 0.0f);
    [[[CCDirector sharedDirector] view] addSubview:svBigCloud];
    
    // 设置
    btnSetting = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSetting.frame = CGRectMake(self.boundingBox.size.width*0.66f, self.boundingBox.size.height*0.86f, imgSetting.size.width, imgSetting.size.height);
    [btnSetting setImage:imgSetting forState:UIControlStateNormal];
    [btnSetting addTarget:self action:@selector(gameSetting:) forControlEvents:UIControlEventTouchUpInside];
    [[[CCDirector sharedDirector] view] addSubview:btnSetting];
    
    // 关于
    btnAboutUs = [UIButton buttonWithType:UIButtonTypeCustom];
    btnAboutUs.frame = CGRectMake(self.boundingBox.size.width*0.77f, self.boundingBox.size.height*0.86f, imgAboutUs.size.width, imgAboutUs.size.height);
    [btnAboutUs setImage:imgAboutUs forState:UIControlStateNormal];
    [btnAboutUs addTarget:self action:@selector(aboutUs:) forControlEvents:UIControlEventTouchUpInside];
    [[[CCDirector sharedDirector] view] addSubview:btnAboutUs];
    
    // 返回游戏种类
    btnBackType = [UIButton buttonWithType:UIButtonTypeCustom];
    btnBackType.frame = CGRectMake(self.boundingBox.size.width*0.88f, self.boundingBox.size.height*0.86f, imgAboutUs.size.width, imgAboutUs.size.height);
    //[btnBackType setTitle:@"back" forState:UIControlStateNormal];
    [btnBackType setImage:imgBack forState:UIControlStateNormal];
    [btnBackType addTarget:self action:@selector(backType:) forControlEvents:UIControlEventTouchUpInside];
    [[[CCDirector sharedDirector] view] addSubview:btnBackType];
}

- (void)initParallaxSCloud
{
    CGSize boundSize = self.boundingBox.size;
    CGPoint cloudRatio = ccp(0.4f, 1.0f);
    
    parallaxSCloud = [CCParallaxNode node];
    [self addChild:parallaxSCloud z:kGameNavSmallCloud_z];
    
    CCSprite *spCloud1 = [CCSprite spriteWithSpriteFrameName:@"sCloud1.png"];
    [parallaxSCloud addChild:spCloud1 z:kGameNavSmallCloud_z parallaxRatio:cloudRatio positionOffset:ccp(boundSize.width*0.3f, boundSize.height*0.76f)];
    
    CCSprite *spCloud2 = [CCSprite spriteWithSpriteFrameName:@"sCloud2.png"];
    [parallaxSCloud addChild:spCloud2 z:kGameNavSmallCloud_z parallaxRatio:cloudRatio positionOffset:ccp(boundSize.width*0.1f, boundSize.height*0.6f)];
    
    CCSprite *spCloud3 = [CCSprite spriteWithSpriteFrameName:@"sCloud3.png"];
    [parallaxSCloud addChild:spCloud3 z:kGameNavSmallCloud_z parallaxRatio:cloudRatio positionOffset:ccp(boundSize.width*0.5f, boundSize.height*0.9f)];
    
    CCSprite *spCloud4 = [CCSprite spriteWithSpriteFrameName:@"sCloud4.png"];
    [parallaxSCloud addChild:spCloud4 z:kGameNavSmallCloud_z parallaxRatio:cloudRatio positionOffset:ccp(boundSize.width*1.12f, boundSize.height*0.7f)];
    
    CCSprite *spCloud5 = [CCSprite spriteWithSpriteFrameName:@"sCloud5.png"];
    [parallaxSCloud addChild:spCloud5 z:kGameNavSmallCloud_z parallaxRatio:cloudRatio positionOffset:ccp(boundSize.width*1.2f, boundSize.height*0.82f)];
    
    CCSprite *spCloud6 = [CCSprite spriteWithSpriteFrameName:@"sCloud6.png"];
    [parallaxSCloud addChild:spCloud6 z:kGameNavSmallCloud_z parallaxRatio:cloudRatio positionOffset:ccp(boundSize.width*0.58f, boundSize.height*0.66f)];
    
    CCSprite *spCloud7 = [CCSprite spriteWithSpriteFrameName:@"sCloud7.png"];
    [parallaxSCloud addChild:spCloud7 z:kGameNavSmallCloud_z parallaxRatio:cloudRatio positionOffset:ccp(boundSize.width*0.88f, boundSize.height*0.7f)];
    
    CCSprite *spCloud8 = [CCSprite spriteWithSpriteFrameName:@"sCloud8.png"];
    [parallaxSCloud addChild:spCloud8 z:kGameNavSmallCloud_z parallaxRatio:cloudRatio positionOffset:ccp(boundSize.width*0.9f, boundSize.height*0.86f)];
    
    CCSprite *spCloud9 = [CCSprite spriteWithSpriteFrameName:@"sCloud9.png"];
    [parallaxSCloud addChild:spCloud9 z:kGameNavSmallCloud_z parallaxRatio:cloudRatio positionOffset:ccp(boundSize.width*1.4f, boundSize.height*0.92f)];
}

- (void)initParallaxBCloud
{
    CGSize boundSize = self.boundingBox.size;
    CGPoint cloudRatio = ccp(0.2f, 1.0f);
    
    parallaxBCloud = [CCParallaxNode node];
    [self addChild:parallaxBCloud z:kGameNavBigCloud_z];
    
    CCSprite *spCloud1 = [CCSprite spriteWithSpriteFrameName:@"bCloud1.png"];
    [parallaxBCloud addChild:spCloud1 z:kGameNavBigCloud_z parallaxRatio:cloudRatio positionOffset:ccp(boundSize.width*0.5f, boundSize.height*0.3f)];
    
    CCSprite *spCloud2 = [CCSprite spriteWithSpriteFrameName:@"bCloud1.png"];
    spCloud2.flipX = YES;
    [parallaxBCloud addChild:spCloud2 z:kGameNavBigCloud_z parallaxRatio:cloudRatio positionOffset:ccp(boundSize.width*1.5f-0.3f, boundSize.height*0.3f)];
}

- (void)initParallaxFrontBigCloud
{
    CGSize boundSize = svBigCloud.bounds.size;
    // 初始化各个小岛图片
    imgvFCloud1 = [[UIImageView alloc] initWithImage:imgFCloud1];
    imgvFCloud1.frame = CGRectMake(0.0f, 0.0f, imgFCloud1.size.width, imgFCloud1.size.height);
    imgvFCloud1.center = CGPointMake(boundSize.width*0.5f, boundSize.height*0.84f);
    [svBigCloud addSubview:imgvFCloud1];
    
    imgvFCloud2 = [[UIImageView alloc] initWithImage:imgFCloud2];
    imgvFCloud2.center = CGPointMake(boundSize.width*1.5f, boundSize.height*0.84f);
    imgvFCloud2.layer.transform = CATransform3DMakeRotation(M_PI, 0, 1.0, 0);
    [svBigCloud addSubview:imgvFCloud2];
    
    imgvFCloud3 = [[UIImageView alloc] initWithImage:imgFCloud3];
    imgvFCloud3.center = CGPointMake(boundSize.width*2.5f, boundSize.height*0.84f);
    [svBigCloud addSubview:imgvFCloud3];
}

- (void)update:(ccTime)delta
{
    CGPoint backgroundScrollVel = ccp(-60, 0);
    
    parallaxSCloud.position = ccpAdd(parallaxSCloud.position, ccpMult(backgroundScrollVel, 0.01f));
    for (CCSprite *sprite in parallaxSCloud.children)
    {
        if ([parallaxSCloud convertToWorldSpace:sprite.position].x <= - sprite.boundingBox.size.width*0.5f)
        {
            [parallaxSCloud incrementOffset:ccp(self.boundingBox.size.width+sprite.boundingBox.size.width + arc4random()%((NSInteger)(self.boundingBox.size.width*0.5f)), 0) forChild:sprite];
        }
    }
    
    parallaxBCloud.position = ccpAdd(parallaxBCloud.position, ccpMult(backgroundScrollVel, 0.01f));
    for (CCSprite *sprite in parallaxBCloud.children)
    {
        if ([parallaxBCloud convertToWorldSpace:sprite.position].x <= - sprite.boundingBox.size.width*0.5f)
        {
            [parallaxBCloud incrementOffset:ccp(self.boundingBox.size.width*2.0f-0.4f, 0) forChild:sprite];
        }
    }
}

- (void)updateFrontBigCloudPosition:(ccTime)delta
{
    CGFloat xOffset = svBigCloud.contentOffset.x+1.0f;
    CGFloat yOffset = svBigCloud.contentOffset.y;
    if (xOffset >= ScrollView_Width*(ScrollView_Pages - 1))
    {
        [svBigCloud setContentOffset:CGPointZero animated:NO];
    }
    else
    {
        CGPoint offset = CGPointMake(xOffset, yOffset);
        [svBigCloud setContentOffset:offset];
    }
}

#pragma mark - Enter/Exit
- (void)onEnter
{
    [super onEnter];
    
    [svLands loadLessonData];
}

- (void)onExit
{
    [super onExit];
}

#pragma mark - UIScrollView Delegate
// 将要拖动的时候
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
}

// 拖动结束
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
}

// 正在滚动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}

// 将要开始减速的时候
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    
    
}

// 减速结束的时候
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    
}

#pragma mark - UIButton Action Manager
- (void)gameSetting:(id)sender
{
    settingView = [[UIHSSettingView alloc] initWithFrame:self.boundingBox key:SettingViewContentTypeSetting];
    settingView.delegate = self;
    [[[CCDirector sharedDirector] view] addSubview:settingView];
}

- (void)aboutUs:(id)sender
{
    settingView = [[UIHSSettingView alloc] initWithFrame:self.boundingBox key:SettingViewContentTypeAboutUs];
    settingView.delegate = self;
    [[[CCDirector sharedDirector] view] addSubview:settingView];
}

- (void)backType:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"Game"];
    [SceneManager loadingWithGameID:kGameTypeSceneID];
}

#pragma mark - SettinView Delegate
- (void)settingView:(UIHSSettingView *)view close:(id)sender
{
    [settingView removeFromSuperview];
    settingView = nil;
}

#pragma mark - Memory Manager
- (void)dealloc
{
    imgAboutUs = nil;
    imgSetting = nil;
    imgBack    = nil;
    imgFCloud1 = nil;
    imgFCloud2 = nil;
    imgFCloud3 = nil;
    
    [imgvFCloud1 removeFromSuperview];
    imgvFCloud1 = nil;
    [imgvFCloud2 removeFromSuperview];
    imgvFCloud2 = nil;
    [imgvFCloud3 removeFromSuperview];
    imgvFCloud3 = nil;
    
    [btnSetting removeFromSuperview];
    btnSetting = nil;
    
    [btnAboutUs removeFromSuperview];
    btnAboutUs = nil;
    
    [btnBackType removeFromSuperview];
    btnBackType = nil;
    
    [svLands removeFromSuperview];
    svLands = nil;
    
    [svBigCloud removeFromSuperview];
    svBigCloud = nil;
    
    [parallaxBCloud removeAllChildrenWithCleanup:YES];
    [parallaxBCloud removeFromParentAndCleanup:YES];
    parallaxBCloud = nil;
    
    [parallaxSCloud removeAllChildrenWithCleanup:YES];
    [parallaxSCloud removeFromParentAndCleanup:YES];
    parallaxSCloud = nil;
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFrames];
    [CCSpriteFrameCache purgeSharedSpriteFrameCache];
    
    [[CCTextureCache sharedTextureCache] removeAllTextures];
    [CCTextureCache purgeSharedTextureCache];
}

@end
