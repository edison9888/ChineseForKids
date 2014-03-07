//
//  LoginScene.m
//  PinyinGame
//
//  Created by yang on 13-11-20.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "LoginScene.h"
#import "cocos2d.h"
#import "UIHSLoginView.h"
#import "UIHSRegisterView.h"

#import "GlobalDataHelper.h"
#import "SceneManager.h"
#import "Constants.h"

#import "CCParallaxNode-Extras.h"
#import "CustomKeyChainHelper.h"

@interface LoginScene ()<UIHSLoginViewDelegate, UIHSRegisterViewDelegate>
{
    CCSprite *spBackground;
    
    CCSprite *spCloud1;
    CCSprite *spCloud1_1;
    CCSprite *spCloud2;
    CCSprite *spCloud3;
    CCSprite *spCloud4;
    CCSprite *spCloud5;
    CCSprite *spCloud6;
    CCSprite *spCloud7;
    CCSprite *spCloud8;
    
    CCParallaxNode *parallaxNode;
    
    CGFloat parallaxDuration;
    CGFloat paMoveFactor;
    
    UIHSLoginView *loginView;
    UIHSRegisterView *registView;
}

@end

@implementation LoginScene

- (id)init
{
    CCLOG(@"%@ : %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    if (self = [super init])
    {
        glClearColor(1.0f, 1.0f, 1.0f, 0.0f);
        parallaxDuration = 1.0f;
        paMoveFactor = 0.01;
        
        [GlobalDataHelper sharedManager].shouldPlayBackgroundAudio = YES;
        
        [self setupBatchNode];
        [self initInterface];
        [self initParallaxBackground];
        
        [self scheduleUpdate];
    }
    return self;
}

- (void)setupBatchNode
{
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"LoginBackground.plist"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"LoginCloud.plist"];
}

- (void)initInterface
{
    spBackground = [CCSprite spriteWithSpriteFrameName:@"loginBackground.png"];
    spBackground.position = ccp(self.boundingBox.size.width*0.5f, self.boundingBox.size.height*0.5f);
    [self addChild:spBackground z:-1];
    
    [self initLoginViewWithEmail:nil];
}

- (void)initLoginViewWithEmail:(NSString *)email
{
    if (!loginView)
    {
        loginView = [[UIHSLoginView alloc] initWithFrame:self.boundingBox withEmalil:email];
        loginView.delegate = self;
        loginView.backgroundColor = [UIColor clearColor];
        [[[CCDirector sharedDirector] view] addSubview:loginView];
    }
}

- (void)initRegistViewWithEmail:(NSString *)email
{
    if (!registView)
    {
        registView = [[UIHSRegisterView alloc] initWithFrame:self.boundingBox withEmalil:email];
        registView.delegate = self;
        registView.backgroundColor = [UIColor clearColor];
        [[[CCDirector sharedDirector] view] addSubview:registView];
    }
}

- (void)removeLoginView
{
    if (loginView)
    {
        [loginView removeFromSuperview];
        loginView = nil;
    }
}

- (void)removeRegistView
{
    if (registView)
    {
        [registView removeFromSuperview];
        registView = nil;
    }
}

- (void)initParallaxBackground
{
    parallaxNode = [CCParallaxNode node];
    [self addChild:parallaxNode z:0];
    
    CGSize winSize = self.boundingBox.size;
    CGPoint cloudRatio = ccp(0.5f, 1.0f);
    
    spCloud1 = [CCSprite spriteWithSpriteFrameName:@"loginCloud1.png"];
    [parallaxNode addChild:spCloud1 z:1 parallaxRatio:cloudRatio positionOffset:ccp(winSize.width*0.2f, winSize.height*0.9f)];
    
    spCloud1_1 = [CCSprite spriteWithSpriteFrameName:@"loginCloud1.png"];
    [parallaxNode addChild:spCloud1_1 z:1 parallaxRatio:cloudRatio positionOffset:ccp(winSize.width*0.4f, winSize.height*0.8f)];
    
    spCloud2 = [CCSprite spriteWithSpriteFrameName:@"loginCloud2.png"];
    spCloud2.flipY = YES;
    [parallaxNode addChild:spCloud2 z:1 parallaxRatio:cloudRatio positionOffset:ccp(winSize.width*0.5f, winSize.height*0.86f)];
    
    spCloud3 = [CCSprite spriteWithSpriteFrameName:@"loginCloud3.png"];
    spCloud3.flipY = YES;
    [parallaxNode addChild:spCloud3 z:1 parallaxRatio:cloudRatio positionOffset:ccp(winSize.width*0.7f, winSize.height*0.76f)];
    
    spCloud4 = [CCSprite spriteWithSpriteFrameName:@"loginCloud4.png"];
    [parallaxNode addChild:spCloud4 z:1 parallaxRatio:cloudRatio positionOffset:ccp(winSize.width*1.2f, winSize.height*0.82f)];
    
    spCloud5 = [CCSprite spriteWithSpriteFrameName:@"loginCloud5.png"];
    [parallaxNode addChild:spCloud5 z:1 parallaxRatio:cloudRatio positionOffset:ccp(winSize.width*0.6f, winSize.height*0.9f)];
    
    spCloud6 = [CCSprite spriteWithSpriteFrameName:@"loginCloud6.png"];
    spCloud6.flipY = YES;
    [parallaxNode addChild:spCloud6 z:1 parallaxRatio:cloudRatio positionOffset:ccp(winSize.width*0.76f, winSize.height*0.91f)];
    
    spCloud7 = [CCSprite spriteWithSpriteFrameName:@"loginCloud7.png"];
    [parallaxNode addChild:spCloud7 z:1 parallaxRatio:cloudRatio positionOffset:ccp(winSize.width*0.85f, winSize.height*0.86f)];
    
    spCloud8 = [CCSprite spriteWithSpriteFrameName:@"loginCloud8.png"];
    [parallaxNode addChild:spCloud8 z:1 parallaxRatio:cloudRatio positionOffset:ccp(winSize.width*1.1f, winSize.height*0.78f)];
}

- (void)update:(ccTime)delta
{
    CGPoint backgroundScrollVel = ccp(-60, 0);
    [parallaxNode runAction:[CCSequence actions:[CCMoveTo actionWithDuration:parallaxDuration position:ccpAdd(parallaxNode.position, ccpMult(backgroundScrollVel, paMoveFactor))], nil]];
    for (CCSprite *sprite in parallaxNode.children)
    {
        if ([parallaxNode convertToWorldSpace:sprite.position].x < - sprite.boundingBox.size.width*0.5f)
        {
            [parallaxNode incrementOffset:ccp(self.boundingBox.size.width*1.3f/*+sprite.boundingBox.size.width+fabsf((float)backgroundScrollVel.x)*/, 0) forChild:sprite];
        }
    }
}

#pragma mark - Login Delegate
- (void)loginView:(UIHSLoginView *)aLoginView registWithUserEmail:(NSString *)email
{
    if (email)
    {
        [self removeLoginView];
        [self initRegistViewWithEmail:email];
    }
}

- (void)loginView:(UIHSLoginView *)loginView loginWithUserEmail:(NSString *)email
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    BOOL needToGame = [userDefaults boolForKey:@"Game"];
    BOOL sameUser = [email isEqualToString:[CustomKeyChainHelper getUserNameWithService:KEY_USERNAME]];
    //保存用户名密码
    [CustomKeyChainHelper saveUserName:email userNameService:KEY_USERNAME password:@""passwordService:KEY_PASSWORD];
    if (needToGame && sameUser)
    {
        [GlobalDataHelper sharedManager].curUserID  = [userDefaults objectForKey:@"UserID"];
        [GlobalDataHelper sharedManager].curHumanID = [userDefaults integerForKey:@"HumanID"];
        [GlobalDataHelper sharedManager].curGroupID = [userDefaults integerForKey:@"GroupID"];
        [GlobalDataHelper sharedManager].curBookID  = [userDefaults integerForKey:@"BookID"];
        [GlobalDataHelper sharedManager].curTypeID  = [userDefaults integerForKey:@"TypeID"];
        
        [SceneManager loadingWithGameID:kCommonNavigationSceneID];
    }
    else
    {
        [SceneManager goGroupScene];
    }
    
    //[SceneManager loadingWithGameID:kGameTypeSceneID];
}

- (void)registView:(UIHSRegisterView *)aRegistView registWithUserEmail:(NSString *)email
{
    if (email)
    {
        [self removeRegistView];
        [self initLoginViewWithEmail:email];
    }
}

#pragma mark - Memory Manager
- (void)dealloc
{
    [self removeLoginView];
    [self removeRegistView];
    
    [spCloud1 removeFromParentAndCleanup:YES];
    [spCloud1_1 removeFromParentAndCleanup:YES];
    [spCloud2 removeFromParentAndCleanup:YES];
    [spCloud3 removeFromParentAndCleanup:YES];
    [spCloud4 removeFromParentAndCleanup:YES];
    [spCloud5 removeFromParentAndCleanup:YES];
    [spCloud6 removeFromParentAndCleanup:YES];
    [spCloud7 removeFromParentAndCleanup:YES];
    [spCloud8 removeFromParentAndCleanup:YES];
    
    spCloud1 = nil;
    spCloud1_1 = nil;
    spCloud2 = nil;
    spCloud3 = nil;
    spCloud4 = nil;
    spCloud5 = nil;
    spCloud6 = nil;
    spCloud7 = nil;
    spCloud8 = nil;
    
    [parallaxNode removeAllChildrenWithCleanup:YES];
    [parallaxNode removeFromParentAndCleanup:YES];
    parallaxNode = nil;
    
    [spBackground removeFromParentAndCleanup:YES];
    spBackground = nil;
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:@"LoginBackground.plist"];
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:@"LoginCloud.plist"];
    
    [CCSpriteFrameCache purgeSharedSpriteFrameCache];
    
    [[CCTextureCache sharedTextureCache] removeAllTextures];
    [CCTextureCache purgeSharedTextureCache];
}


@end
