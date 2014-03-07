//
//  PinyinNavigationScene.m
//  ChineseForKids
//
//  Created by yang on 13-12-10.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "PinyinNavigationScene.h"
#import "SimpleAudioEngine.h"
#import "SceneManager.h"
#import "UIHSLandScrollView.h"
#import "UIHSSettingView.h"
#import "CCParallaxNode-Extras.h"
#import "Constants.h"
#import "cocos2d.h"
#import "Wave.h"

#define ScrollView_Width self.boundingBox.size.width
#define ScrollView_Height self.boundingBox.size.height * 0.875f
#define ScrollView_Pages 3

@interface PinyinNavigationScene ()<UIScrollViewDelegate, UIHSSettingViewDelegate>

@end

@implementation PinyinNavigationScene
{
    UIButton *btnSetting;
    UIButton *btnAboutUs;
    
    UIImage *imgSetting;
    UIImage *imgAboutUs;
    
    // 放置小岛的滚动视图
    UIScrollView *svLands;
    Wave *wave;
    
    CCSprite *spSky;
    CCSprite *spSea;
    
    CCSprite *spCloud1;
    CCSprite *spCloud1_1;
    CCSprite *spCloud2;
    CCSprite *spCloud2_2;
    CCSprite *spCloud2_3;
    CCSprite *spCloud3;
    CCSprite *spCloud4;
    CCSprite *spCloud5;
    CCSprite *spCloud6;
    CCSprite *spMountain1;
    CCSprite *spMountain2;
    CCSprite *spMountain3;
    CCSprite *spMountain3_1;
    CCSprite *spMountain4;
    CCSprite *spMountain4_1;
    CCSprite *spMountain4_2;
    CCSprite *spMountain6;
    CCSprite *spMountain7;
    CCSprite *spMountain5;
    CCSprite *spMountain5_1;
    CCSprite *spMountain5_2;
    CCSprite *spMountain8;
    
    CCParallaxNode *parallaxNode;
    
    UIHSSettingView *settingView;
    
    CGFloat parallaxDuration;
    CGFloat paMoveFactor;
    
    CGPoint oldOffset;
}

- (id)init
{
    CCLOG(@"%@ : %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    if (self = [super init])
    {
        glClearColor(1.0f, 1.0f, 1.0f, 1.0f);
        parallaxDuration = 1.0f;
        paMoveFactor = 0.01;
        
        imgSetting = [UIImage imageNamed:@"btnSetting.png"];
        imgAboutUs = [UIImage imageNamed:@"btnAboutUs.png"];
        
        [self initInterface];
        [self initParallaxBackground];
        
        [self scheduleUpdate];
    }
    return self;
}

- (void)update:(ccTime)delta
{
    //NSLog(@"%@ : %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    //[self unscheduleUpdate];
    CGPoint backgroundScrollVel = ccp(-60, 0);
    [parallaxNode runAction:[CCSequence actions:[CCMoveTo actionWithDuration:parallaxDuration position:ccpAdd(parallaxNode.position, ccpMult(backgroundScrollVel, paMoveFactor))], nil]];
    //parallaxNode.position = ccpAdd(parallaxNode.position, ccpMult(backgroundScrollVel, 0.02));
    for (CCSprite *sprite in parallaxNode.children)
    {
        if ([parallaxNode convertToWorldSpace:sprite.position].x < - sprite.boundingBox.size.width/2)
        {
            [parallaxNode incrementOffset:ccp(self.boundingBox.size.width+sprite.boundingBox.size.width/2+fabsf((float)backgroundScrollVel.x), 0) forChild:sprite];
        }
    }
    [self updateWaveOffsetWithScrollVew:svLands];
}

- (void)initInterface
{
    spSky = [CCSprite spriteWithSpriteFrameName:@"sky.png"];
    spSky.position = ccp(self.boundingBox.size.width*0.5f, self.boundingBox.size.height-spSky.boundingBox.size.height*0.5f);
    [self addChild:spSky z:-1 tag:kMainMapSkyTag];
    
    spSea = [CCSprite spriteWithSpriteFrameName:@"sea.png"];
    spSea.position = ccp(self.boundingBox.size.width*0.5f, self.boundingBox.size.height*0.366f);
    [spSea.texture setAliasTexParameters];
    [self addChild:spSea z:kMainMapSea_z tag:kMainMapSeaTag];
    
    wave = [Wave waveWithParentNode:self];
    
    svLands = [[UIHSLandScrollView alloc] initWithFrame:CGRectMake(0.0f, self.boundingBox.size.height - ScrollView_Height, ScrollView_Width, ScrollView_Height)];
    svLands.delegate = self;
    svLands.backgroundColor = [UIColor clearColor];
    svLands.pagingEnabled = NO;
    svLands.scrollEnabled = YES;
    svLands.showsHorizontalScrollIndicator = NO;
    svLands.showsVerticalScrollIndicator = NO;
    svLands.contentSize = CGSizeMake(ScrollView_Width*ScrollView_Pages, 0.0f);
    [[[CCDirector sharedDirector] view] addSubview:svLands];
    
    btnSetting = [UIButton buttonWithType:UIButtonTypeCustom];
    btnSetting.frame = CGRectMake(self.boundingBox.size.width*0.06f, self.boundingBox.size.height*0.86f, imgSetting.size.width, imgSetting.size.height);
    [btnSetting setImage:imgSetting forState:UIControlStateNormal];
    [btnSetting addTarget:self action:@selector(gameSetting:) forControlEvents:UIControlEventTouchUpInside];
    [[[CCDirector sharedDirector] view] addSubview:btnSetting];
    
    btnAboutUs = [UIButton buttonWithType:UIButtonTypeCustom];
    btnAboutUs.frame = CGRectMake(self.boundingBox.size.width*0.17f, self.boundingBox.size.height*0.86f, imgAboutUs.size.width, imgAboutUs.size.height);
    [btnAboutUs setImage:imgAboutUs forState:UIControlStateNormal];
    [btnAboutUs addTarget:self action:@selector(aboutUs:) forControlEvents:UIControlEventTouchUpInside];
    [[[CCDirector sharedDirector] view] addSubview:btnAboutUs];
}

- (void)initParallaxBackground
{
    parallaxNode = [CCParallaxNode node];
    [self addChild:parallaxNode z:0];
    
    CGSize winSize = self.boundingBox.size;
    // 山要比云移动快
    CGPoint cloudRatio = ccp(0.2f, 1.0f);
    CGPoint mountainRatio = ccp(0.5f, 1.0f);
    
    spCloud1 = [CCSprite spriteWithSpriteFrameName:@"cloud1.png"];
    [parallaxNode addChild:spCloud1 z:1 parallaxRatio:cloudRatio positionOffset:ccp(winSize.width*0.2f, winSize.height*0.9f)];
    
    spCloud1_1 = [CCSprite spriteWithSpriteFrameName:@"cloud1.png"];
    [parallaxNode addChild:spCloud1_1 z:1 parallaxRatio:cloudRatio positionOffset:ccp(winSize.width*0.4f, winSize.height*0.8f)];
    
    spCloud2 = [CCSprite spriteWithSpriteFrameName:@"cloud2.png"];
    [parallaxNode addChild:spCloud2 z:1 parallaxRatio:cloudRatio positionOffset:ccp(winSize.width*0.5f, winSize.height*0.86f)];
    
    spCloud2_2 = [CCSprite spriteWithSpriteFrameName:@"cloud2.png"];
    [parallaxNode addChild:spCloud2_2 z:1 parallaxRatio:cloudRatio positionOffset:ccp(winSize.width*0.7f, winSize.height*0.82f)];
    
    spCloud2_3 = [CCSprite spriteWithSpriteFrameName:@"cloud2.png"];
    [parallaxNode addChild:spCloud2_3 z:1 parallaxRatio:cloudRatio positionOffset:ccp(winSize.width*1.2f, winSize.height*0.82f)];
    
    spCloud3 = [CCSprite spriteWithSpriteFrameName:@"cloud3.png"];
    spCloud3.flipX = YES;
    spCloud3.flipY = YES;
    [parallaxNode addChild:spCloud3 z:1 parallaxRatio:cloudRatio positionOffset:ccp(winSize.width*0.6f, winSize.height*0.9f)];
    
    spCloud4 = [CCSprite spriteWithSpriteFrameName:@"cloud4.png"];
    spCloud4.flipY = YES;
    [parallaxNode addChild:spCloud4 z:1 parallaxRatio:cloudRatio positionOffset:ccp(winSize.width*0.8f, winSize.height*0.91f)];
    
    spCloud5 = [CCSprite spriteWithSpriteFrameName:@"cloud5.png"];
    [parallaxNode addChild:spCloud5 z:1 parallaxRatio:cloudRatio positionOffset:ccp(winSize.width*0.8f, winSize.height*0.86f)];
    
    spCloud6 = [CCSprite spriteWithSpriteFrameName:@"cloud6.png"];
    [parallaxNode addChild:spCloud6 z:1 parallaxRatio:cloudRatio positionOffset:ccp(winSize.width*0.95f, winSize.height*0.88f)];
    
    // 各种山
    spMountain1 = [CCSprite spriteWithSpriteFrameName:@"mountain1.png"];
    [parallaxNode addChild:spMountain1 z:2 parallaxRatio:mountainRatio positionOffset:ccp(winSize.width*0.33f, winSize.height*0.73f)];
    
    spMountain2 = [CCSprite spriteWithSpriteFrameName:@"mountain2.png"];
    [parallaxNode addChild:spMountain2 z:3 parallaxRatio:mountainRatio positionOffset:ccp(winSize.width*0.36f, winSize.height*0.73f)];
    
    spMountain3 = [CCSprite spriteWithSpriteFrameName:@"mountain3.png"];
    [parallaxNode addChild:spMountain3 z:4 parallaxRatio:mountainRatio positionOffset:ccp(winSize.width*0.4f, winSize.height*0.74f)];
    
    spMountain3_1 = [CCSprite spriteWithSpriteFrameName:@"mountain3.png"];
    [parallaxNode addChild:spMountain3_1 z:4 parallaxRatio:mountainRatio positionOffset:ccp(winSize.width*0.96f, winSize.height*0.74f)];
    
    spMountain4 = [CCSprite spriteWithSpriteFrameName:@"mountain4.png"];
    [parallaxNode addChild:spMountain4 z:5 parallaxRatio:mountainRatio positionOffset:ccp(winSize.width*0.45f, winSize.height*0.74f)];
    
    spMountain4_1 = [CCSprite spriteWithSpriteFrameName:@"mountain4.png"];
    [parallaxNode addChild:spMountain4_1 z:5 parallaxRatio:mountainRatio positionOffset:ccp(winSize.width*0.16f, winSize.height*0.74f)];
    
    spMountain4_2 = [CCSprite spriteWithSpriteFrameName:@"mountain4.png"];
    [parallaxNode addChild:spMountain4_2 z:5 parallaxRatio:mountainRatio positionOffset:ccp(winSize.width*1.1f, winSize.height*0.74f)];
    
    spMountain6 = [CCSprite spriteWithSpriteFrameName:@"mountain6.png"];
    [parallaxNode addChild:spMountain6 z:7 parallaxRatio:mountainRatio positionOffset:ccp(winSize.width*0.25f, winSize.height*0.76f)];
    
    spMountain7 = [CCSprite spriteWithSpriteFrameName:@"mountain7.png"];
    [parallaxNode addChild:spMountain7 z:6 parallaxRatio:mountainRatio positionOffset:ccp(winSize.width*0.48f, winSize.height*0.76f)];
    
    spMountain5 = [CCSprite spriteWithSpriteFrameName:@"mountain5.png"];
    [parallaxNode addChild:spMountain5 z:7 parallaxRatio:mountainRatio positionOffset:ccp(winSize.width*0.58f, winSize.height*0.76f)];
    
    spMountain5_1 = [CCSprite spriteWithSpriteFrameName:@"mountain5.png"];
    [parallaxNode addChild:spMountain5_1 z:7 parallaxRatio:mountainRatio positionOffset:ccp(winSize.width*0.1f, winSize.height*0.76f)];
    
    spMountain5_2 = [CCSprite spriteWithSpriteFrameName:@"mountain5.png"];
    [parallaxNode addChild:spMountain5_2 z:7 parallaxRatio:mountainRatio positionOffset:ccp(winSize.width*0.9f, winSize.height*0.76f)];
    
    spMountain8 = [CCSprite spriteWithSpriteFrameName:@"mountain8.png"];
    [parallaxNode addChild:spMountain8 z:6 parallaxRatio:mountainRatio positionOffset:ccp(winSize.width*0.66f, winSize.height*0.78f)];
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

#pragma mark - SettinView Delegate
- (void)settingView:(UIHSSettingView *)view close:(id)sender
{
    [settingView removeFromSuperview];
    settingView = nil;
}

#pragma mark - UIScrollView Delegate
// 将要拖动的时候
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //paMoveFactor = 0.025f;
    oldOffset = scrollView.contentOffset;
    [wave waveHideWithAnimate:YES];
}

// 拖动结束
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //paMoveFactor = 0.05f;
    [wave waveShowWithAnimate:YES];
}

// 正在滚动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //paMoveFactor = 0.07f;
}

// 将要开始减速的时候
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    //paMoveFactor = 0.05f;
    
}

// 减速结束的时候
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //paMoveFactor = 0.02f;
    
}

- (void)updateWaveOffsetWithScrollVew:(UIScrollView *)scrollView
{
    CGPoint offset = scrollView.contentOffset;
    CGFloat offset_x = oldOffset.x - offset.x;
    [wave waveMoveWithDistance:offset_x];
    oldOffset = offset;
}

#pragma mark - Memory Manager
- (void)dealloc
{
    CCLOG(@"%@ : %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    imgSetting = nil;
    imgAboutUs = nil;
    wave = nil;
    
    [btnSetting removeFromSuperview];
    btnSetting = nil;
    
    [btnAboutUs removeFromSuperview];
    btnAboutUs = nil;
    
    [svLands removeFromSuperview];
    svLands = nil;
    
    [spSky removeFromParentAndCleanup:YES];
    spSky = nil;
    
    [spSea removeFromParentAndCleanup:YES];
    spSea = nil;
    
    [spCloud1 removeFromParentAndCleanup:YES];
    [spCloud1_1 removeFromParentAndCleanup:YES];
    [spCloud2 removeFromParentAndCleanup:YES];
    [spCloud2_2 removeFromParentAndCleanup:YES];
    [spCloud2_3 removeFromParentAndCleanup:YES];
    [spCloud3 removeFromParentAndCleanup:YES];
    [spCloud4 removeFromParentAndCleanup:YES];
    [spCloud5 removeFromParentAndCleanup:YES];
    [spCloud6 removeFromParentAndCleanup:YES];
    [spMountain1 removeFromParentAndCleanup:YES];
    [spMountain2 removeFromParentAndCleanup:YES];
    [spMountain3 removeFromParentAndCleanup:YES];
    [spMountain3_1 removeFromParentAndCleanup:YES];
    [spMountain4 removeFromParentAndCleanup:YES];
    [spMountain4_1 removeFromParentAndCleanup:YES];
    [spMountain4_2 removeFromParentAndCleanup:YES];
    [spMountain6 removeFromParentAndCleanup:YES];
    [spMountain7 removeFromParentAndCleanup:YES];
    [spMountain5 removeFromParentAndCleanup:YES];
    [spMountain5_1 removeFromParentAndCleanup:YES];
    [spMountain5_2 removeFromParentAndCleanup:YES];
    [spMountain8 removeFromParentAndCleanup:YES];
    
    spCloud1 = nil;
    spCloud1_1 = nil;
    spCloud2 = nil;
    spCloud2_2 = nil;
    spCloud2_3 = nil;
    spCloud3 = nil;
    spCloud4 = nil;
    spCloud5 = nil;
    spCloud6 = nil;
    spMountain1 = nil;
    spMountain2 = nil;
    spMountain3 = nil;
    spMountain3_1 = nil;
    spMountain4 = nil;
    spMountain4_1 = nil;
    spMountain4_2 = nil;
    spMountain6 = nil;
    spMountain7 = nil;
    spMountain5 = nil;
    spMountain5_1 = nil;
    spMountain5_2 = nil;
    spMountain8 = nil;
    
    [parallaxNode removeAllChildrenWithCleanup:YES];
    [parallaxNode removeFromParentAndCleanup:YES];
    parallaxNode = nil;
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFrames];
    [CCSpriteFrameCache purgeSharedSpriteFrameCache];
    
    [[CCTextureCache sharedTextureCache] removeAllTextures];
    [CCTextureCache purgeSharedTextureCache];
}

@end
