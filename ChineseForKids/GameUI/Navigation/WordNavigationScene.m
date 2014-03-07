//
//  WordNavigationScene.m
//  ChineseForKids
//
//  Created by yang on 13-12-10.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "WordNavigationScene.h"
#import "cocos2d.h"
#import "SceneManager.h"
#import "GlobalDataHelper.h"

#import "Constants.h"

@implementation WordNavigationScene
{
    UIImage *imgSetting;
    UIImage *imgAboutUs;
    
    UIButton *btnSetting;
    UIButton *btnAboutUs;
}

- (id)init
{
    CCLOG(@"%@ : %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    if (self = [super init])
    {
        glClearColor(1.0f, 1.0f, 1.0f, 1.0f);
        
        imgSetting = [UIImage imageNamed:@"btnSetting.png"];
        imgAboutUs = [UIImage imageNamed:@"btnAboutUs.png"];
        
        [self initInterface];
        
        [self scheduleUpdate];
    }
    return self;
}

- (void)update:(ccTime)delta
{
    
}

- (void)initInterface
{
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

#pragma mark - UIButton Action Manager
- (void)gameSetting:(id)sender
{
    
}

- (void)aboutUs:(id)sender
{
    
}

#pragma mark - Memory Manager
- (void)dealloc
{
    [btnSetting removeFromSuperview];
    btnSetting = nil;
    [btnAboutUs removeFromSuperview];
    btnAboutUs = nil;
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFrames];
    [CCSpriteFrameCache purgeSharedSpriteFrameCache];
    
    [[CCTextureCache sharedTextureCache] removeAllTextures];
}

@end
