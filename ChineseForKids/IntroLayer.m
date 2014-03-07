//
//  IntroLayer.m
//  ChineseForKids
//
//  Created by yang on 13-12-2.
//  Copyright yang 2013年. All rights reserved.
//


// Import the interfaces
#import "IntroLayer.h"
#import "SceneManager.h"
#import "CrashLogHelper.h"

#pragma mark - IntroLayer

// HelloWorldLayer implementation
@implementation IntroLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	IntroLayer *layer = [IntroLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// 
-(id) init
{
	if( (self=[super init])) {

		// ask director for the window size
		CGSize size = [[CCDirector sharedDirector] winSize];

		CCSprite *background;
		
		if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ) {
			background = [CCSprite spriteWithFile:@"Default.png"];
			background.rotation = 90;
		} else {
			background = [CCSprite spriteWithFile:@"Default-Landscape~ipad.png"];
		}
		background.position = ccp(size.width/2, size.height/2);

		// add the label as a child to this Layer
		[self addChild: background];
        
        [self scheduleUpdate];
	}
	
	return self;
}

- (void)update:(ccTime)delta
{
    [self unscheduleUpdate];
    [NSThread sleepForTimeInterval:1.0f];
    [SceneManager goLoginScene];
    
    // 开启崩溃报告日志功能。
    //[CrashLogHelper startLog];
}

- (void) onEnter
{
	[super onEnter];
}

- (void)onExit
{
    [super onExit];
}

- (void)dealloc
{
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFrames];
    [CCSpriteFrameCache purgeSharedSpriteFrameCache];
    
    [[CCTextureCache sharedTextureCache] removeAllTextures];
    [CCTextureCache purgeSharedTextureCache];
}

@end
