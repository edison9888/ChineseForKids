//
//  GameTypeScene.m
//  ChineseForKids
//
//  Created by yang on 13-12-6.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "GameTypeScene.h"
#import "cocos2d.h"
#import "Constants.h"

#import "GlobalDataHelper.h"
#import "SceneManager.h"

#import "CCParallaxNode-Extras.h"

#define kTypeScene_Background_z -1
#define kTypeScene_Cloud_z 0
#define kTypeScene_Mountain_z 1
#define kTypeScene_GameNode_z 2

@implementation GameTypeScene
{
    CCSprite *spBackground;
    CCSprite *spMainLand1;
    CCSprite *spMainLand2;
    CCSprite *spMainLand3;
    
    CCSprite *spTower;
    CCSprite *spLeftCloud;
    CCSprite *spRightCloud;
    CCSprite *spHuaGuoShan;
    CCSprite *spGaoLaoZhuang;
    CCSprite *spMonsterBody;
    CCSprite *spMonsterHeader;
    CCSprite *spHuangFenglin;
    
    CCSprite *spLeftTree;
    CCSprite *spGanoderma;
    
    CCParallaxNode *cloudParallax;
    
    CGSize sceneSize;
    
    UIButton *btnBackLogin;
    UIImage *imgBack;
}

+(id)scene
{
    CCScene *scene=[CCScene node];
    GameTypeScene *layer=[GameTypeScene node];
    [scene addChild:layer];
    return scene;
}

-(id)init
{
    if((self = [super init]))
    {
        sceneSize = self.boundingBox.size;
        
        [self initInterface];
        [self scheduleUpdate];
        [self setTouchEnabled:YES];
    }
    return self;
}

- (void)update:(ccTime)delta
{
    CGPoint backgroundScrollVel = ccp(-60, 0);
    [cloudParallax runAction:[CCSequence actions:[CCMoveTo actionWithDuration:1.0f position:ccpAdd(cloudParallax.position, ccpMult(backgroundScrollVel, delta))], nil]];
    for (CCSprite *spCloud in cloudParallax.children)
    {
        if ([cloudParallax convertToWorldSpace:spCloud.position].x < - spCloud.boundingBox.size.width*0.5f)
        {
            [cloudParallax incrementOffset:ccp(sceneSize.width + spCloud.boundingBox.size.width*0.5f+400.0f, 0) forChild:spCloud];
        }
    }
}

#pragma mark - initScene Manager
- (void)initInterface
{
    CGSize winSize=[CCDirector sharedDirector].winSize;
    
    // 背景
    spBackground = [CCSprite spriteWithSpriteFrameName:@"sky.png"];
    spBackground.position=ccp(winSize.width*0.5f,winSize.height*0.5f);
    [self addChild:spBackground z:kTypeScene_Background_z];
    
    imgBack = [UIImage imageNamed:@"btnBack.png"];
    // 返回登陆界面
    btnBackLogin = [UIButton buttonWithType:UIButtonTypeCustom];
    btnBackLogin.frame = CGRectMake(self.boundingBox.size.width*0.88f, self.boundingBox.size.height*0.86f, imgBack.size.width, imgBack.size.height);
    //[btnBackLogin setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    //[btnBackLogin setTitle:@"back" forState:UIControlStateNormal];
    [btnBackLogin setImage:imgBack forState:UIControlStateNormal];
    [btnBackLogin addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [[[CCDirector sharedDirector] view] addSubview:btnBackLogin];
    
    [self initClouds];
    [self initMountains];
    [self initGameTypeNode];
}

- (void)initClouds
{
    cloudParallax = [CCParallaxNode node];
    [self addChild:cloudParallax z:kTypeScene_Cloud_z];
    
    CGPoint nodePoint = ccp(1,1);
    
    CCSprite *spCloud1 = [CCSprite spriteWithSpriteFrameName:@"cloud1.png"];
    [cloudParallax addChild:spCloud1 z:kTypeScene_Cloud_z parallaxRatio:nodePoint positionOffset:ccp(sceneSize.width/9.062, sceneSize.height/22.2)];
    
    CCSprite *spCloud2 = [CCSprite spriteWithSpriteFrameName:@"cloud2.png"];
    [cloudParallax addChild:spCloud2 z:kTypeScene_Cloud_z parallaxRatio:nodePoint positionOffset:ccp(sceneSize.width/2.535, sceneSize.height/1.172)];
    
    CCSprite *spCloud3 = [CCSprite spriteWithSpriteFrameName:@"cloud3.png"];
    [cloudParallax addChild:spCloud3 z:kTypeScene_Cloud_z parallaxRatio:nodePoint positionOffset:ccp(sceneSize.width/1.082, sceneSize.height/1.48)];
    
    CCSprite *spCloud4 = [CCSprite spriteWithSpriteFrameName:@"cloud4.png"];
    [cloudParallax addChild:spCloud4 z:kTypeScene_Cloud_z parallaxRatio:nodePoint positionOffset:ccp(sceneSize.width/1.16, sceneSize.height/6.218)];
    
    CCSprite *spCloud5 = [CCSprite spriteWithSpriteFrameName:@"cloud5.png"];
    [cloudParallax addChild:spCloud5 z:kTypeScene_Cloud_z parallaxRatio:nodePoint positionOffset:ccp(sceneSize.width/9.022, sceneSize.height/1.591)];
    
    CGPoint backgroundScrollVel = ccp(-20, 0);
    [cloudParallax runAction:[CCSequence actions:[CCMoveTo actionWithDuration:0.6f position:ccpAdd(cloudParallax.position, backgroundScrollVel)], nil]];
}

- (void)initMountains
{
    spMainLand1 = [CCSprite spriteWithSpriteFrameName:@"mountain1.png"];
    spMainLand1.position=ccp(sceneSize.width*0.5f, sceneSize.height*0.5f);
    [self addChild:spMainLand1 z:kTypeScene_Mountain_z];
    
    spMainLand2 = [CCSprite spriteWithSpriteFrameName:@"mountain2.png"];
    spMainLand2.position=ccp(sceneSize.width/5.208, sceneSize.height/4.77);
    [self addChild:spMainLand2 z:kTypeScene_Mountain_z];
    
    spMainLand3 = [CCSprite spriteWithSpriteFrameName:@"mountain3.png"];
    spMainLand3.position=ccp(sceneSize.width/2.508, sceneSize.height/12.77);
    [self addChild:spMainLand3 z:kTypeScene_Mountain_z];
    
    id animMainLand2=[CCSequence actions:[CCMoveTo actionWithDuration:0.5 position:ccpAdd(spMainLand2.position, ccp(0, spMainLand2.contentSize.height/80))],[CCMoveTo actionWithDuration:1 position:ccpAdd(spMainLand2.position, ccp(0, -spMainLand2.contentSize.height/80))],[CCMoveTo actionWithDuration:0.5 position:spMainLand2.position], nil];
    
    [spMainLand2 runAction:[CCRepeatForever actionWithAction:animMainLand2]];
    
    id animMainLand3=[CCSequence actions:[CCMoveTo actionWithDuration:0.5 position:ccpAdd(spMainLand3.position, ccp(0, -spMainLand3.contentSize.height/30))],[CCMoveTo actionWithDuration:1 position:ccpAdd(spMainLand3.position, ccp(0, spMainLand3.contentSize.height/30))],[CCMoveTo actionWithDuration:0.5 position:spMainLand3.position], nil];
    
    [spMainLand3 runAction:[CCRepeatForever actionWithAction:animMainLand3]];
}

- (void)initGameTypeNode
{
    // 花果山
    spHuaGuoShan = [CCSprite spriteWithSpriteFrameName:@"huaguoshan/0000"];
    spHuaGuoShan.position = ccp(sceneSize.width*0.18f, sceneSize.height*0.63f);
    [self addChild:spHuaGuoShan z:kTypeScene_GameNode_z];
    
    // 灵芝草
    spGanoderma = [CCSprite spriteWithSpriteFrameName:@"ganoderma.png"];
    spGanoderma.position = ccp(sceneSize.width/4.15, sceneSize.height/1.82);
    [self addChild:spGanoderma z:kTypeScene_GameNode_z];
    
    // 五指山
    spTower = [CCSprite spriteWithSpriteFrameName:@"tower.png"];
    spTower.position=ccp(sceneSize.width*0.376f, sceneSize.height*0.52f);
    [self addChild:spTower z:kTypeScene_GameNode_z];
    
    // 左边的一排树
    spLeftTree = [CCSprite spriteWithSpriteFrameName:@"trees.png"];
    spLeftTree.position = ccp(sceneSize.width*0.13f, sceneSize.height*0.54f);
    [self addChild:spLeftTree z:kTypeScene_GameNode_z];
    
    // 高老庄
    spGaoLaoZhuang = [CCSprite spriteWithSpriteFrameName:@"pig/0000"];
    spGaoLaoZhuang.position = ccp(sceneSize.width*0.52f, sceneSize.height*0.685f);
    [self addChild:spGaoLaoZhuang z:kTypeScene_GameNode_z];
    
    // 黄风岭
    spMonsterBody = [CCSprite spriteWithSpriteFrameName:@"monsterBody.png"];
    spMonsterBody.position = ccp(sceneSize.width*0.703f, sceneSize.height*0.578f);
    [self addChild:spMonsterBody z:kTypeScene_GameNode_z];
    
    spMonsterHeader = [CCSprite spriteWithSpriteFrameName:@"monsterHeader.png"];
    spMonsterHeader.position = ccp(sceneSize.width*0.707f, sceneSize.height*0.593f);
    spMonsterHeader.anchorPoint = ccp(0.5f, 0.0f);
    [self addChild:spMonsterHeader z:kTypeScene_GameNode_z];
    
    spHuangFenglin = [CCSprite spriteWithSpriteFrameName:@"huangfengling.png"];
    spHuangFenglin.position = ccp(sceneSize.width*0.726f, sceneSize.height*0.54f);
    [self addChild:spHuangFenglin z:kTypeScene_GameNode_z];
    
    // 花果山动画
    [self huaGuoShanAnimate];
    
    // 五指山动画
    [self wuZhiShanAnimate];
    
    // 高老庄动画
    [self gaoLaoZhuangAnimate];
    
    // 黄风怪动画
    [self monsterAnimate];
}

#pragma mark - GameTypeNode Animation Manager
- (void)huaGuoShanAnimate
{
    NSMutableArray *arrAnimation=[NSMutableArray arrayWithCapacity:6];
    for(int i = 0; i <= 9; i++)
    {
        NSString *frameName=[NSString stringWithFormat:@"huaguoshan/%04d",i];
        CCSpriteFrame *frame=[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName];
        [arrAnimation addObject:frame];
    }
    
    CCAnimation *animation = [CCAnimation animationWithSpriteFrames:arrAnimation delay:0.12];
    [spHuaGuoShan runAction:[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:animation]]];
}

- (void)wuZhiShanAnimate
{
    spLeftCloud = [CCSprite spriteWithSpriteFrameName:@"cloud1.png"];
    spLeftCloud.position = ccp(spTower.position.x+spLeftCloud.boundingBox.size.width*0.5f, spTower.position.y+spLeftCloud.boundingBox.size.height*0.5f);
    [self addChild:spLeftCloud z:kTypeScene_GameNode_z+1];
    
    id animLeftCloud = [CCSequence actions:[CCMoveTo actionWithDuration:7 position:ccpAdd(spLeftCloud.position, ccp(spLeftCloud.contentSize.width*0.5f, 0))],[CCMoveTo actionWithDuration:10 position:ccpAdd(spLeftCloud.position, ccp(-spLeftCloud.contentSize.width, 0))], [CCMoveTo actionWithDuration:8 position:spLeftCloud.position], nil];
    
    [spLeftCloud runAction:[CCRepeatForever actionWithAction:animLeftCloud]];
    
    spRightCloud = [CCSprite spriteWithSpriteFrameName:@"cloud2.png"];
    spRightCloud.position = ccp(spTower.position.x-spRightCloud.boundingBox.size.width*0.5f, spTower.position.y+spRightCloud.boundingBox.size.height*0.75f);
    [self addChild:spRightCloud z:kTypeScene_GameNode_z-1];
    
    id animRightCloud = [CCSequence actions:[CCMoveTo actionWithDuration:8 position:ccpAdd(spRightCloud.position, ccp(-spRightCloud.contentSize.width*0.5f, 0))],[CCMoveTo actionWithDuration:12 position:ccpAdd(spRightCloud.position, ccp(spRightCloud.contentSize.width, 0))], [CCMoveTo actionWithDuration:9 position:spRightCloud.position], nil];
    
    [spRightCloud runAction:[CCRepeatForever actionWithAction:animRightCloud]];
}

- (void)gaoLaoZhuangAnimate
{
    NSMutableArray *arrAnimation = [NSMutableArray arrayWithCapacity:6];
    for(int i = 0; i <= 29; i++)
    {
        NSString *frameName=[NSString stringWithFormat:@"pig/%04d",i];
        CCSpriteFrame *frame=[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName];
        [arrAnimation addObject:frame];
    }
    
    CCAnimation *animation = [CCAnimation animationWithSpriteFrames:arrAnimation delay:0.08];
    [spGaoLaoZhuang runAction:[CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:animation]]];
}

- (void)monsterAnimate
{
    CCRotateTo *rotateLeft = [CCRotateTo actionWithDuration:0.6f angle:-7];
    CCEaseBounce *bounceLeft = [CCEaseBounce actionWithAction:rotateLeft];
    
    CCRotateTo *rotateBack = [CCRotateTo actionWithDuration:0.6f angle:0];
    
    CCRotateTo *rotateRight = [CCRotateTo actionWithDuration:0.6f angle:7];
    CCEaseBounce *bounceRight = [CCEaseBounce actionWithAction:rotateRight];
    
    CCSequence *seq = [CCSequence actions:bounceLeft, rotateBack, bounceRight, rotateBack, nil];
    CCRepeatForever *repeat = [CCRepeatForever actionWithAction:seq];
    
    [spMonsterHeader runAction:repeat];
}

#pragma mark - Touch Manager
- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch=[touches anyObject] ;
    CGPoint location=[touch locationInView:[touch view]];
    location=[[CCDirector sharedDirector] convertToGL:location];
    
    // 花果山: 声调 typeID: 1
    if (CGRectContainsPoint(spHuaGuoShan.boundingBox, location))
    {
        [GlobalDataHelper sharedManager].curTypeID = 1;
        //[SceneManager loadingWithGameID:kPinyinNavigationSceneID];
        [SceneManager loadingWithGameID:kCommonNavigationSceneID];
    }
    // 高老庄: 擦图猜字 typeID: 2
    else if (CGRectContainsPoint(spGaoLaoZhuang.boundingBox, location))
    {
        [GlobalDataHelper sharedManager].curTypeID = 2;
        //[SceneManager loadingWithGameID:kWordNavigationSceneID];
        [SceneManager loadingWithGameID:kCommonNavigationSceneID];
    }
    // 五指山: 连词成句 typeID: 3
    else if (CGRectContainsPoint(spTower.boundingBox, location))
    {
        [GlobalDataHelper sharedManager].curTypeID = 3;
        //[SceneManager loadingWithGameID:kSentenceNavigationSceneID];
        [SceneManager loadingWithGameID:kCommonNavigationSceneID];
    }
    // 黄风岭: 中英互译 typeID: 4
    else if (CGRectContainsPoint(spHuangFenglin.boundingBox, location))
    {
        [GlobalDataHelper sharedManager].curTypeID = 4;
        //[SceneManager loadingWithGameID:kTranslateNavigationSceneID];
        [SceneManager loadingWithGameID:kCommonNavigationSceneID];
    }
}

#pragma mark - UIButton Action Manager
- (void)backAction:(id)sender
{
    //[SceneManager goLoginScene];
    [SceneManager goGroupScene];
}

#pragma mark - Memory Manager
-(void)dealloc
{
    [spBackground removeFromParentAndCleanup:YES];
    spBackground = nil;
    
    [spMainLand1 removeFromParentAndCleanup:YES];
    spMainLand1 = nil;
    
    [spMainLand2 removeFromParentAndCleanup:YES];
    spMainLand2 = nil;
    
    [spMainLand3 removeFromParentAndCleanup:YES];
    spMainLand3 = nil;
    
    [spHuaGuoShan removeFromParentAndCleanup:YES];
    spHuaGuoShan = nil;
    
    [spGanoderma removeFromParentAndCleanup:YES];
    spGanoderma = nil;
    
    [spTower removeFromParentAndCleanup:YES];
    spTower = nil;
    
    [spLeftCloud removeFromParentAndCleanup:YES];
    spLeftCloud = nil;
    
    [spRightCloud removeFromParentAndCleanup:YES];
    spRightCloud = nil;
    
    [spLeftTree removeFromParentAndCleanup:YES];
    spLeftTree = nil;
    
    [spGaoLaoZhuang removeFromParentAndCleanup:YES];
    spGaoLaoZhuang = nil;
    
    [spHuangFenglin removeFromParentAndCleanup:YES];
    spHuangFenglin = nil;
    
    [cloudParallax removeAllChildrenWithCleanup:YES];
    [cloudParallax removeFromParentAndCleanup:YES];
    cloudParallax = nil;
    
    [btnBackLogin removeFromSuperview];
    btnBackLogin = nil;
    imgBack = nil;
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFrames];
    [CCSpriteFrameCache purgeSharedSpriteFrameCache];
    
    [[CCTextureCache sharedTextureCache] removeAllTextures];
}

@end
