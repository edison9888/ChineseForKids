//
//  GameLibraryScene.m
//  ChineseForKids
//
//  Created by yang on 13-10-11.
//  Copyright (c) 2013年 Allen. All rights reserved.
//

#import "GameLibraryScene.h"
#import "SceneManager.h"
#import "Constants.h"

@implementation GameLibraryScene
{
    HSLibraryView *libraryView;
    
    UIButton *btnBack;
    UIImage *imgBack;
}

+(id)scene
{
    CCScene *scene=[CCScene node];
    GameLibraryScene *layer=[GameLibraryScene node];
    [scene addChild:layer];
    return scene;
}

-(id)init
{
    if((self = [super init]))
    {
        glClearColor(125.0f, 125.0f, 125.0f, 255.0f);
        
        [self initInterface];
    }
    return self;
}

- (void)initInterface
{
    CGSize winSize=[CCDirector sharedDirector].winSize;
    
    libraryView=[[HSLibraryView alloc] initWithFrame:CGRectMake(0, 0, winSize.width, winSize.height)];
    libraryView.delegate = self;
    [[[CCDirector sharedDirector] view] addSubview:libraryView];
}

#pragma mark - HSLibraryView Delegate
- (void)libraryView:(HSLibraryView *)libraryView backAction:(id)sender
{
    [SceneManager goLoginScene];
}

- (void)libraryView:(HSLibraryView *)libraryView selectedBook:(NSInteger)bookID
{
    [SceneManager loadingWithGameID:kGameTypeSceneID];
}

#pragma mark - Memory Manager
- (void)dealloc
{
    
    [libraryView removeFromSuperview];
    libraryView = nil;
    
    [btnBack removeFromSuperview];
    btnBack = nil;
    imgBack = nil;
}

@end
