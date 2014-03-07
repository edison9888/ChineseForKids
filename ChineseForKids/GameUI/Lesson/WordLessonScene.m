//
//  WordLessonScene.m
//  ChineseForKids
//
//  Created by 唐 希 on 13-8-15.
//  Copyright 2013年 Allen. All rights reserved.

//  Modified by yang on 13-12-12.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "WordLessonScene.h"
#import "SimpleAudioEngine.h"
#import "GameManager.h"
#import "GlobalDataHelper.h"
#import "GameLessonData.h"
#import "WordTimeControl.h"

#import "KnowledgeProgressLayer.h"

#import "UploadLessonNet.h"
#import "WordNet.h"
#import "WordModel.h"
#import "LessonModel.h"
#import "ResponseModel.h"

#import "SceneManager.h"
#import "cocos2d.h"

#import "Constants.h"
#import "CommonHelper.h"

#define kScoreColor [UIColor whiteColor]

#define kLeftBamboo @"leftBamboo"
#define kRightBamboo @"rightBamboo"

@interface WordLessonScene ()<TimeProgressControlDelegate>
{
    CCMenu *menu;
    
    CCLabelTTF *word_content;
    CCLabelTTF *labelScore;
    
    CCRenderTexture *scratchableImage;
    
    CCSprite *spBajie;
    CCSprite *spWordBord;
    CCSprite *word_mask;
    CCSprite *word_grid;
    CCSprite *bun_tray;
    CCSprite *spIcoBaozi;
    CCSprite *firstBunGas;
    CCSprite *secondBunGas;
    CCSprite *thirdBunGas;
    CCSprite *revealSprite;
    CCSprite *bgRubImage;
    //CCSprite *spLeftBamboo;
    //CCSprite *spRightBamboo;
    
    // 装载大包子精灵和字label精灵的数组
    NSMutableArray *Array_option;
    
    // 装载大包子运动轨迹的数组
    NSMutableArray *Array_option_point4;
    NSMutableArray *Array_option_point6;
    
    // 开始点击的地方
    CGPoint touchBegin;
}

@property(nonatomic, strong)CCSprite *word_mask;
@property(nonatomic, strong)CCLabelTTF *word_content;
@property(nonatomic, strong)CCSprite *revealSprite;
@property(nonatomic, copy)NSMutableArray *Array_option;
@property(nonatomic, copy)NSMutableArray *Array_option_point4;
@property(nonatomic, copy)NSMutableArray *Array_option_point6;

@end

@implementation WordLessonScene
{
    WordModel *wordModel;
    
    // 时间进度条
    WordTimeControl *timeControl;
}

@synthesize word_mask;
@synthesize word_content;
@synthesize revealSprite;
@synthesize Array_option;
@synthesize Array_option_point4;
@synthesize Array_option_point6;

int GameTouchStatus = 0;

+ (id)nodeWithLessonID:(NSString *)lessonID
{
    return [[self alloc] initWithLessonID:lessonID];
}

- (id)initWithLessonID:(NSString *)lessonID
{
    CCLOG(@"%@ : %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    if (self = [super init])
    {
        // 设置自身背景色
        glClearColor(0.2f, 0.8f, 0.2f, 255);
        
        Array_option        = [[NSMutableArray alloc] init];
        Array_option_point4 = [[NSMutableArray alloc] init];
        Array_option_point6 = [[NSMutableArray alloc] init];
        
        [self setTouchEnabled:YES];
        //[self initKnowledgeLayer];
        //[self pauseScene];
        [self initInterface];
        
        // 延迟一帧加载, 以便前一场景的数据完全清空, 达到避开场景切换时的内存使用高峰。
        [self scheduleUpdate];
    }
    return self;
}

- (void)update:(ccTime)delta
{
    [self unscheduleUpdate];
    
    [[[CCDirector sharedDirector] view] setMultipleTouchEnabled:YES];
    
    // 播放背景音乐
    [self playBackgroundAudio:@"rubimagebg.mp3"];
    
    // 初始化本关的数据模型
    [self initLessonModel];
    
    // 更新最高得分数据
    [self updateHighScore];
    
    // 加载游戏数据
    [self loadWordGameData];
    
    // 加载包子的运动轨迹
    [self loadBunAnimationPath];
    
    // 加载包子
    [self loadGameRubImage:0 ItemID:-1];

    // 循环响应刮的动作
    [self schedule:@selector(tick:)];
}

- (void)initInterface
{
     CGSize boundSize = [self boundingBox].size;
    
    // 背景
    bgRubImage = [CCSprite spriteWithSpriteFrameName:@"rubImageGameBkg.png"];
    bgRubImage.position = ccp(boundSize.width/2, boundSize.height/2);
    [self addChild:bgRubImage z:-1];
    /*
    // 左边的竹子
    spLeftBamboo = [CCSprite spriteWithSpriteFrameName:@"leftBamboo/0000"];
    spLeftBamboo.position = ccp(boundSize.width*0.2, boundSize.height*0.85);
    [self addChild:spLeftBamboo z:0];
    [self updateBambooAnimationWithKey:kLeftBamboo];
    
    // 右边的竹子
    spRightBamboo = [CCSprite spriteWithSpriteFrameName:@"rightBamboo/0000"];
    spRightBamboo.position = ccp(boundSize.width*0.88, boundSize.height*0.8);
    [self addChild:spRightBamboo z:0];
    [self updateBambooAnimationWithKey:kRightBamboo];
    */
     
    // 小包子
    spIcoBaozi = [CCSprite spriteWithSpriteFrameName:@"smallBun.png"];
    spIcoBaozi.position = ccp(boundSize.width*0.1, boundSize.height*0.93);
    [self addChild:spIcoBaozi z:1];
    
    // 分数
    labelScore=[CCLabelTTF labelWithString:@"0" fontName:@"Helvetica-Bold" fontSize:50];
    labelScore.color=ccc3(255, 255, 255);
    labelScore.position=ccp(spIcoBaozi.position.x+spIcoBaozi.boundingBox.size.width+labelScore.boundingBox.size.width/2, boundSize.height*0.93);
    [self addChild:labelScore z:1];
    
    // 时间进度条
    timeControl = [WordTimeControl timeProgressControlWithParentNode:self];
    
    // 暂停
    CCMenuItemImage *pauseItem=[CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"pause.png"] selectedSprite:nil target:self selector:@selector(gamePause)];
    pauseItem.position = ccp(self.boundingBox.size.width*0.93, self.boundingBox.size.height*0.94);
    
    menu =[CCMenu menuWithItems:pauseItem, nil];
    menu.position = CGPointZero;
    [self addChild:menu z:kLeftTree_z+1];
    
    // 一笼包子
    bun_tray = [CCSprite spriteWithSpriteFrameName:@"bunTray.png"];
    bun_tray.position = ccp(boundSize.width*0.277, boundSize.height*0.09);
    [self addChild:bun_tray z:2];
    
    // 蒸汽
    firstBunGas = [CCSprite spriteWithSpriteFrameName:@"bun_gas1.png"];
    firstBunGas.position = ccp(boundSize.width*0.15f, boundSize.height*0.32f);
    [self addChild:firstBunGas z:3];
    [self updateBunGas:firstBunGas fromIndex:1 totalCount:8];
    
    secondBunGas = [CCSprite spriteWithSpriteFrameName:@"bun_gas5.png"];
    secondBunGas.position = ccp(boundSize.width*0.30f, boundSize.height*0.32f);
    [self addChild:secondBunGas z:3];
    [self updateBunGas:secondBunGas fromIndex:4 totalCount:8];
    
    thirdBunGas = [CCSprite spriteWithSpriteFrameName:@"bun_gas8.png"];
    thirdBunGas.position = ccp(boundSize.width*0.45f, boundSize.height*0.32f);
    [self addChild:thirdBunGas z:3];
    [self updateBunGas:thirdBunGas fromIndex:7 totalCount:8];
    
    // 八戒
    spBajie = [CCSprite spriteWithSpriteFrameName:@"pigStand1.png"];
    spBajie.position = ccp(boundSize.width*0.777, boundSize.height*0.189);
    [self addChild:spBajie z:2];
    
    // 米字格
    word_grid = [CCSprite spriteWithSpriteFrameName:@"wordGrid.png"];
    word_grid.position = ccp(boundSize.width*0.285, boundSize.height*0.46);
    [self addChild:word_grid z:2];
    [self updatePigStandAnimation];
    
    // 文字内容
    word_content=[CCLabelTTF labelWithString:@"" fontName:@"Bodoni 72" fontSize:192];
    [word_content setPosition:word_grid.position];
    [word_content  setColor:ccc3(0, 0, 0)];
    [self addChild:word_content z:3];
    
    // 挂着的板
    spWordBord = [CCSprite spriteWithSpriteFrameName:@"wordBord.png"];
    spWordBord.position = ccp(boundSize.width*0.2886, boundSize.height*0.56);
    [self addChild:spWordBord z:5];
    
    // 表示雾气的蒙板(遮罩)
    word_mask = [CCSprite spriteWithSpriteFrameName:@"wordMask.png"];
    word_mask.position = word_grid.position;
    
    // Scratchable layer
    scratchableImage = [CCRenderTexture renderTextureWithWidth:boundSize.width height:boundSize.height];
    scratchableImage.position = ccp(boundSize.width * 0.5f, boundSize.height * 0.5f);
    [self addChild:scratchableImage z:4 tag:1];
    [[scratchableImage sprite] setBlendFunc: (ccBlendFunc) {GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA}];
    
    // Source image
    [self resetWordMask];
    
    //Set up the burn sprite that will "knock out" parts of the darkness layer depending on the
    //alpha value of the pixels in the image.
    // 擦除蒸汽的擦子。
    revealSprite = [CCSprite spriteWithSpriteFrameName:@"Particle.png"];
    //revealSprite.position = ccp( 512, 384);
    revealSprite.position = ccp( -10000, 0);
    [revealSprite setScale:1.6f];
    [revealSprite setBlendFunc:(ccBlendFunc){GL_ZERO, GL_ONE_MINUS_SRC_ALPHA}];
    /*
    // 当前得分
    lblScTitle = [CCLabelTTF labelWithString:@"Score" fontName:kFontNameChil fontSize:kPinyinFontSize*0.8f dimensions:CGSizeMake(kScoreLabel_Width, kScoreLabel_Height - 5) hAlignment:kCCTextAlignmentRight];
    lblScTitle.position = ccp(self.boundingBox.size.width - kScoreLabel_Width*0.5f, self.boundingBox.size.height - lblScTitle.boundingBox.size.height*0.5f);
    lblScTitle.color = ccc3(255.0f, 255.0f, 255.0f);
    [self addChild:lblScTitle z:kRightrTree_z+1];
    
    lblScore = [CCLabelTTF labelWithString:@"0" fontName:kFontNameBold fontSize:kPinyinFontSize dimensions:CGSizeMake(kScoreLabel_Width, kScoreLabel_Height) hAlignment:kCCTextAlignmentRight];
    lblScore.position = ccp(self.boundingBox.size.width - kScoreLabel_Width*0.5f, lblScTitle.position.y-lblScTitle.boundingBox.size.height*0.5f-lblScore.boundingBox.size.height*0.5f);
    lblScore.color = ccc3(255.0f, 255.0f, 255.0f);
    [self addChild:lblScore z:kRightrTree_z+1];
    
    // 历史最高分
    lblHScTitle = [CCLabelTTF labelWithString:@"HighScore" fontName:kFontNameChil fontSize:kPinyinFontSize*0.8f dimensions:CGSizeMake(kScoreLabel_Width, kScoreLabel_Height - 5) hAlignment:kCCTextAlignmentRight];
    lblHScTitle.position = ccp(self.boundingBox.size.width - kScoreLabel_Width*0.5f, lblScore.position.y-lblScore.boundingBox.size.height*0.5f-lblHScTitle.boundingBox.size.height*0.5f);
    lblHScTitle.color = ccc3(255.0f, 255.0f, 255.0f);
    [self addChild:lblHScTitle z:kRightrTree_z+1];
    
    lblHScore = [CCLabelTTF labelWithString:@"0" fontName:kFontNameBold fontSize:kPinyinFontSize dimensions:CGSizeMake(kScoreLabel_Width, kScoreLabel_Height) hAlignment:kCCTextAlignmentRight];
    lblHScore.position = ccp(self.boundingBox.size.width - kScoreLabel_Width*0.5f, lblHScTitle.position.y-lblHScTitle.boundingBox.size.height*0.5f-lblHScore.boundingBox.size.height*0.5f);
    lblHScore.color = ccc3(255.0f, 255.0f, 255.0f);
    [self addChild:lblHScore z:kRightrTree_z+1];
     */
}

#pragma mark - 开启网络更新本课的数据
- (void)updateWordLessonData
{
    ResponseModel *response = [WordNet getWordGameInfoWithUserID:curUserID HumanID:strHumanID GroupID:strGroupID BookID:strBookID TypeID:strTypeID LessonID:strLessonID];
    if ([WordNet isRequestCanceled]) return;
    
    if (response.error.code != 0) {
        [self updateWordLessonData];
    }
}

#pragma mark - 定时器处理
// 处理刮的事件
- (void)tick:(ccTime)dt
{
    //CCRenderTexture *scratchableImage = (CCRenderTexture*)[self getChildByTag:1];
    //NSLog(@"Transparent: %f percent",[scratchableImage getPercentageTransparent]);
    // Update the render texture
    [scratchableImage begin];
    
    // Limit drawing to the alpha channel
    glColorMask(0.0f, 0.0f, 0.0f, 1.0f);
    
    // Draw
    [revealSprite visit];
    
    // Reset color mask
    glColorMask(1.0f, 1.0f, 1.0f, 1.0f);
    
    [scratchableImage end];
}

#pragma mark - 分数
// 每一游戏回合产生的分数
- (NSInteger)scorePerGameRound
{
    NSInteger lcScore = 50;
    if (keepRightNum == 3)
    {
        // 连对三次之后重置
        lcScore = 100;
        [self playSpriteAudioWithName:@"getReward.mp3"];
    }
    else if (keepRightNum > 3 && keepRightNum < 12)
    {
        keepRightNum = 0;
        lcScore = 260;
        [self playSpriteAudioWithName:@"transWrong.wav"];
    }
    return lcScore;
}

#pragma mark - 加载游戏数据及处理游戏逻辑
-(void)loadWordGameData
{
    CCLOG(@"%@ : %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    wordModel = (WordModel *)[[GameManager sharedManager] pickOutWordInfoWithUserID:curUserID humanID:curHumanID groupID:curGroupID bookID:curBookID typeID:curTypeID lessonID:curLessonID];
    //NSLog(@"进度: %@, %d, %f", wordModel.rightWord, wordModel.rightTimesValue, wordModel.progressValue);
}

// 包子运动路径
- (void)loadBunAnimationPath
{
    float x,y,w,h;
    
    x=566;y=140;w=160;h=141;
    [Array_option_point4 addObject:[NSValue valueWithCGPoint:ccp(x+w/2,768-(y+h/2))]];
    
    x=801;y=140;w=160;h=141;
    [Array_option_point4 addObject:[NSValue valueWithCGPoint:ccp(x+w/2,768-(y+h/2))]];
    
    x=566;y=316;w=160;h=141;
    [Array_option_point4 addObject:[NSValue valueWithCGPoint:ccp(x+w/2,768-(y+h/2))]];
    
    x=801;y=316;w=160;h=141;
    [Array_option_point4 addObject:[NSValue valueWithCGPoint:ccp(x+w/2,768-(y+h/2))]];
    
    x=566;y=140;w=160;h=122;
    [Array_option_point6 addObject:[NSValue valueWithCGPoint:ccp(x+w/2,768-(y+h/2))]];
    
    x=801;y=140;w=160;h=122;
    [Array_option_point6 addObject:[NSValue valueWithCGPoint:ccp(x+w/2,768-(y+h/2))]];
    
    x=566;y=287;w=160;h=122;
    [Array_option_point6 addObject:[NSValue valueWithCGPoint:ccp(x+w/2,768-(y+h/2))]];
    
    x=801;y=287;w=160;h=122;
    [Array_option_point6 addObject:[NSValue valueWithCGPoint:ccp(x+w/2,768-(y+h/2))]];
    
    x=566;y=428;w=160;h=122;
    [Array_option_point6 addObject:[NSValue valueWithCGPoint:ccp(x+w/2,768-(y+h/2))]];
    
    x=801;y=428;w=160;h=122;
    [Array_option_point6 addObject:[NSValue valueWithCGPoint:ccp(x+w/2,768-(y+h/2))]];
}

- (void)loadGameRubImage:(int)ArrayID ItemID:(int)ItemID
{
    GameTouchStatus = 1;
    
    for (int i = 0; i < [Array_option count]; i++)
    {
        // 答错时的处理
        if (ItemID != i)
        {
            // 错的包子以渐渐隐藏的方式处理
            CCNode* node_item=[Array_option objectAtIndex:i];
            CCSprite *item = (CCSprite*)node_item;
            // 包子渐渐消失。
            [self fadeScaleOutWithSprite:item fadeTime:0.7f scaleTime:0.7f scaleFactor:0.7f];
        }
        // 答对时的处理
        else
        {
            // 对的那个包子还是以抛物线的形式处理。
            if ((i % 2) == 0)
            {
                CCNode* node_item = [Array_option objectAtIndex:i+1];
                CCLabelTTF* lb =(CCLabelTTF*)node_item;
                [lb setString:@""];
                
                CCSprite *item = (CCSprite *)[Array_option objectAtIndex:i];
                //[self fadeScaleOutWithSprite:item fadeTime:0.7f scaleTime:0.7f scaleFactor:2.0f];
                [self moveWithParabola:item startP:item.position endP:spIcoBaozi.position startA:item.rotation endA:item.rotation dirTime:0.8f selected:YES];
            }
        }
    }
    [word_content setString:@""];
    
    // 将包子从笼子里放出来, 加到右边的视图中。
    CCCallBlock *callB = [CCCallBlock actionWithBlock:^{
        CGPoint bun_tray_point = ccpAdd(bun_tray.position, ccp(0.0f, 10.0f));
        [Array_option removeAllObjects];
        
        NSMutableArray *arrWordData = [[NSMutableArray alloc] init];
        
        NSString *orderWorder = [wordModel.obstruction stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSArray *arrObstruct = [orderWorder componentsSeparatedByString:@"|"];
        [arrWordData setArray:arrObstruct];
        NSString *rightWord = [[NSString stringWithFormat:@"%@", wordModel.rightWord] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [arrWordData addObject:rightWord];
        
        NSInteger bunCount = [arrWordData count];
        NSInteger tmpIndex = (bunCount > 0 ? arc4random() % bunCount : 0);
        // 获取每一组字的信息
        for (int i = 0, j = 0; i < bunCount; i++)
        {
            // 大包子精灵
            CCSprite *hanzi = [CCSprite spriteWithSpriteFrameName:@"bigBun.png"];
            if (bunCount > 4) [hanzi setScaleY:0.86];
            hanzi.position = bun_tray_point;
            [self addChild:hanzi z:2];
            [Array_option addObject:hanzi];
            
            // 每次将大包子加载到视图的时候以一种基于随机数的乱序的方式。
            j = (tmpIndex + i) % bunCount;
            // 将大包子精灵以抛物线运动方式移动到右边视图区域。
            CGPoint hanzi_position = CGPointZero;
            if (bunCount <= 4 )
            {
                hanzi_position = [[Array_option_point4 objectAtIndex:j] CGPointValue];
                [self moveWithParabola:hanzi startP:bun_tray_point endP:hanzi_position startA:hanzi.rotation endA:hanzi.rotation dirTime:0.6f selected:NO];
            }
            else
            {
                hanzi_position = [[Array_option_point6 objectAtIndex:j] CGPointValue];
                [self moveWithParabola:hanzi startP:bun_tray_point endP:hanzi_position startA:hanzi.rotation endA:hanzi.rotation dirTime:0.6f selected:NO];
            }
            
            NSString *strWord = [arrWordData objectAtIndex:i];
            // 大包子上的字
            CCLabelTTF *lb1=[CCLabelTTF labelWithString:strWord fontName:@"STHeitiTC-Medium" fontSize:50];
            [lb1 setPosition:ccpAdd(hanzi_position, ccp(0, -16.0f))];
            [lb1 setColor:ccc3(0, 0, 0)];
            [lb1 setVisible:NO];
            [self addChild:lb1 z:3];
            [Array_option addObject:lb1];
            
            // 正确的答案
            if ([strWord isEqualToString:rightWord]) [word_content setString:strWord];
            
        }
    }];
    
    CCCallBlock *callC = [CCCallBlock actionWithBlock:^{
        for (int i=0; i < [Array_option count]; i++)
        {
            CCNode* node_item = [Array_option objectAtIndex:i];
            [node_item setVisible:YES];
        }
        GameTouchStatus = 0;
    }];
    
    id dt = [CCDelayTime actionWithDuration:0.3f] ;
    CCSequence *sequence = [CCSequence actions:callB, dt, dt, callC,nil];
    [self runAction:sequence];
}

// 分数
- (void)showScoreWithPosition:(CGPoint)position
{
    //NSString *strAddScore = [NSString stringWithFormat:@"+%d", [self scorePerGameRound]];
    CCLabelTTF *lblAddScore = [CCLabelTTF labelWithString:@"" fontName:@"Helvetica" fontSize:30];
    lblAddScore.scale = 0.8f;
    lblAddScore.color = ccc3(231, 101, 110);
    lblAddScore.position = position;
    [self addChild:lblAddScore z:10];
    
    id callback=[CCCallBlock actionWithBlock:^{
        [lblAddScore removeFromParentAndCleanup:YES];
        [labelScore setString:[NSString stringWithFormat:@"%d", score]];
    }];
    
    CCScaleTo *scale = [CCScaleTo actionWithDuration:0.5f scale:1.6f];
    CCSequence *sequence = [CCSequence actions:[CCMoveTo actionWithDuration:0.7f position:ccpAdd(position, ccp(0, 0))],callback, nil];
    
    CCSpawn *spawn = [CCSpawn actions:scale, sequence, nil];
    [lblAddScore runAction:spawn];
}

// 重设字的遮罩
- (void)resetWordMask
{
    // ask director the the window size
    [scratchableImage setVisible:YES];
    
    [scratchableImage begin];
    [word_mask visit];
    [scratchableImage end];
}

#pragma mark - 精灵的动画及动作处理
- (void)moveWithParabola:(CCSprite*)mSprite startP:(CGPoint)startPoint endP:(CGPoint)endPoint startA:(float)startAngle endA:(float)endAngle dirTime:(float)time selected:(BOOL)selected
{
    float sx = startPoint.x;
    float sy = startPoint.y;
    float ex =endPoint.x+50;
    float ey =endPoint.y+150;
    /////int h = [mSprite contentSize].height*0.5;
    //设置精灵的起始角度
    mSprite.rotation=startAngle;
    ccBezierConfig bezier; // 创建贝塞尔曲线
    bezier.controlPoint_1 = ccp(sx, sy); // 起始点
    bezier.controlPoint_2 = ccp(sx+(ex-sx)*0.5, sy+(ey-sy)*0.5+200); //控制点
    //bezier.endPosition = ccp(endPoint.x-30, endPoint.y+h); // 结束位置
    bezier.endPosition = ccp(endPoint.x, endPoint.y); // 结束位置
    CCBezierTo *actionMove = [CCBezierTo actionWithDuration:time bezier:bezier];
    //创建精灵旋转的动作
    CCRotateTo *actionRotate =[CCRotateTo actionWithDuration:time angle:endAngle];
    
    CCScaleTo *scaleTo = [CCScaleTo actionWithDuration:time scale:0.5f];
    
    //将两个动作封装成一个同时播放进行的动作
    CCSpawn *spawnSelect = [CCSpawn actions:actionMove, actionRotate, scaleTo, nil];
    CCSpawn *spawnNormal = [CCSpawn actions:actionMove, actionRotate, nil];
    
    CCCallBlockO *callBackO = [CCCallBlockO actionWithBlock:^(id object){
        CCSprite *spObj = (CCSprite *)object;
        [spObj removeFromParentAndCleanup:YES];
        spObj = nil;
    } object:mSprite];
    
    CCSequence *seqSelected = [CCSequence actions:spawnSelect, callBackO, nil];
    CCSequence *seqNormal  = [CCSequence actions:spawnNormal, nil];
    
    [mSprite runAction:(selected ? seqSelected : seqNormal)];
}

// 以渐变的形式退出
- (void)fadeScaleOutWithSprite:(CCSprite *)aSprite fadeTime:(CGFloat)fadeTime scaleTime:(CGFloat)scaleTime scaleFactor:(CGFloat)scaleFactor
{
    CCFadeOut *fadeOut = [CCFadeOut actionWithDuration:fadeTime];
    CCScaleTo *scaleTo = [CCScaleTo actionWithDuration:scaleTime scale:scaleFactor];
    
    CCCallBlockO *callBackO = [CCCallBlockO actionWithBlock:^(id object){
        CCSprite *spObj = (CCSprite *)object;
        [spObj removeFromParentAndCleanup:YES];
        spObj = nil;
    } object:aSprite];
    
    CCSpawn *spawn = [CCSpawn actions:fadeOut, scaleTo, nil];
    CCSequence *sequence = [CCSequence actions:spawn, callBackO, nil];
    [aSprite runAction:sequence];
}

// 蒸汽的动画处理
- (void)updateBunGas:(CCSprite *)spBunGas fromIndex:(NSInteger)index totalCount:(NSInteger)count
{
    NSMutableArray *arrFirstFrames  = [[NSMutableArray alloc] initWithCapacity:8];
    NSMutableArray *arrSecondFrames = [[NSMutableArray alloc] initWithCapacity:8];
    NSInteger startIndex = index == 1 ? index : 1;
    
    for (int i = index; i <= count; i++)
    {
        NSString *strFrameName = [NSString stringWithFormat:@"bun_gas%d.png", i];
        CCSpriteFrame *spFrame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:strFrameName];
        [arrFirstFrames addObject:spFrame];
    }
    
    CCAnimation *animationFirst = [CCAnimation animationWithSpriteFrames:arrFirstFrames delay:0.15f];
    
    for (int i = startIndex; i < index; i++)
    {
        NSString *strFrameName = [NSString stringWithFormat:@"bun_gas%d.png", i];
        CCSpriteFrame *spFrame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:strFrameName];
        [arrSecondFrames addObject:spFrame];
    }
    
    CCAnimation *animationSecond = [CCAnimation animationWithSpriteFrames:arrSecondFrames delay:0.15f];
    
    CCSequence *sequence = [CCSequence actions:[CCAnimate actionWithAnimation:animationFirst], [CCAnimate actionWithAnimation:animationSecond], nil];
    
    id action = [CCRepeatForever actionWithAction:sequence];
    [spBunGas runAction:action];
}

// 竹子的动画
- (void)updateBambooAnimationWithKey:(NSString *)key
{
    /*
    NSMutableArray *arrAnimation = [NSMutableArray arrayWithCapacity:6];
    for(int i = 0; i <= 9; i++)
    {
        NSString *frameName = [NSString stringWithFormat:@"%@/%04d", key, i];
        CCSpriteFrame *frame=[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName];
        [arrAnimation addObject:frame];
    }
    
    CCAnimation *animation = [CCAnimation animationWithSpriteFrames:arrAnimation delay:0.26];
    
    CCRepeatForever *repeat = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:animation]];
    [key isEqualToString:kLeftBamboo] ? [spLeftBamboo runAction:repeat] : [spRightBamboo runAction:repeat];
     */
}

// 猪八戒的系列动画
- (void)updatePigStandAnimation
{
    NSMutableArray *arrAnimation = [NSMutableArray arrayWithCapacity:6];
    for(int i = 1;i <= 5; i++)
    {
        NSString *frameName=[NSString stringWithFormat:@"pigStand%d.png",i];
        CCSpriteFrame *frame=[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName];
        [arrAnimation addObject:frame];
    }
    
    CCAnimation *animation = [CCAnimation animationWithSpriteFrames:arrAnimation delay:0.22];
    CCRepeatForever *repeat   = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:animation]];
    [spBajie stopAllActions];
    [spBajie runAction:repeat];
}

- (void)updatePigEatBunAnimation
{
    NSMutableArray *arrAnimation = [NSMutableArray arrayWithCapacity:6];
    for(int i = 0; i <= 23; i++)
    {
        //NSString *frameName=[NSString stringWithFormat:@"pigEatBun%d.png",i];
        NSString *frameName = [NSString stringWithFormat:@"pigEatBun/%04d", i];
        CCSpriteFrame *frame=[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName];
        [arrAnimation addObject:frame];
    }
    
    CCAnimation *animation = [CCAnimation animationWithSpriteFrames:arrAnimation delay:0.05];
    CCCallBlock *callBlock = [CCCallBlock actionWithBlock:^{[self updatePigStandAnimation];}];
    CCSequence *sequence   = [CCSequence actions:[CCAnimate actionWithAnimation:animation], callBlock, nil];
    [spBajie stopAllActions];
    [spBajie runAction:sequence];
}

- (void)updatePigLostBunAnimation
{
    NSMutableArray *arrAnimation = [NSMutableArray arrayWithCapacity:6];
    for(int i = 0; i <= 14; i++)
    {
        //NSString *frameName=[NSString stringWithFormat:@"pigLostBun%d.png",i];
        NSString *frameName = [NSString stringWithFormat:@"pigLostBun/%04d", i];
        CCSpriteFrame *frame=[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName];
        [arrAnimation addObject:frame];
    }
    
    CCAnimation *animation = [CCAnimation animationWithSpriteFrames:arrAnimation delay:0.07];
    CCCallBlock *callBlock = [CCCallBlock actionWithBlock:^{[self updatePigStandAnimation];}];
    CCSequence *sequence   = [CCSequence actions:[CCAnimate actionWithAnimation:animation], callBlock, nil];
    [spBajie stopAllActions];
    [spBajie runAction:sequence];
}

- (void)updatePigKeepRightAnimation
{
    NSMutableArray *arrAnimation = [NSMutableArray arrayWithCapacity:6];
    for(int i = 0; i <= 7; i++)
    {
        NSString *frameName = [NSString stringWithFormat:@"pigKeepRight/%04d", i];
        CCSpriteFrame *frame=[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName];
        [arrAnimation addObject:frame];
    }
    
    CCAnimation *animation = [CCAnimation animationWithSpriteFrames:arrAnimation delay:0.07];
    CCCallBlock *callBlock = [CCCallBlock actionWithBlock:^{[self updatePigStandAnimation];}];
    CCSequence *sequence   = [CCSequence actions:[CCAnimate actionWithAnimation:animation], callBlock, nil];
    [spBajie stopAllActions];
    [spBajie runAction:sequence];
}

#pragma mark - 处理点击事件
- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch=[touches anyObject];
    CGPoint location=[touch locationInView:[touch view]];
    location=[[CCDirector sharedDirector] convertToGL:location];
    touchBegin = location;
    if (CGRectContainsPoint(word_mask.boundingBox, location)) {
        revealSprite.position = CGPointMake(location.x, location.y);
    }
}

-(void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch=[touches anyObject] ;
    CGPoint location=[touch locationInView:[touch view]];
    location=[[CCDirector sharedDirector] convertToGL:location];
    
    if (CGRectContainsPoint(word_mask.boundingBox, location)) {
        revealSprite.position = CGPointMake(location.x, location.y);
    }
}
- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:[touch view]];
    location=[[CCDirector sharedDirector] convertToGL:location];
    
    revealSprite.position = ccp( -10000, 0);
    
    if (GameTouchStatus == 1) return;
    
    for (int i = 0; i < [Array_option count]; i++)
    {
        if ((i % 2) == 0)
        {
            CCSprite *item = (CCSprite*)[Array_option objectAtIndex:i];
            if (CGRectContainsPoint(item.boundingBox, location) && CGRectContainsPoint(item.boundingBox, touchBegin))
            {
                CCLabelTTF *lb = (CCLabelTTF*)[Array_option objectAtIndex:i+1];
                if ([lb.string isEqualToString:word_content.string])
                {
                    // 1、连对
                    keepRightNum++;
                    // 2、更新该知识点对的次数
                    wordModel.rightTimesValue += wordModel.rightTimesValue < PINYIN_SHOW_PROBABILITY ? 1 : 0;
                    // 3、更新该知识点的进度.所有这些数据都以概率为参考。
                    wordModel.progressValue = wordModel.rightTimesValue/(CGFloat)PINYIN_SHOW_PROBABILITY;
                    // 4、本课程总体进度
                    lessonProgress += wordModel.progressValue;
                    // 5、保存这种更改
                    [wordModel saveData];
                    // 6、播放选对的音效
                    [self playSpriteAudioWithName:@"pigLaugh.mp3"];
                    // 7、显示八戒吃包子的动画
                    keepRightNum >= 5 ? [self updatePigKeepRightAnimation] : [self updatePigEatBunAnimation];
                    // 8、显示分数的动画
                    [self showScoreWithPosition:ccpAdd(lb.position, ccp(-5.0f, 10.0f)) Color:ccc3(255.0f, 60.0f, 0.0f)];
                    // 9、加载下一组数据
                    [self loadWordGameData];
                    // 10、加载动画
                    [self loadGameRubImage:0 ItemID:i];
                    // 11、显示分数
                    [self showScoreWithPosition:spIcoBaozi.position];
                }
                else
                {
                    // 1、答错时, 重置连对次数.
                    keepRightNum = 0;
                    // 2、更新该知识点错的次数
                    wordModel.wrongTimesValue += wordModel.wrongTimesValue < PINYIN_SHOW_PROBABILITY ? 1 : 0;
                    // 3、保存这种更改
                    [wordModel saveData];
                    // 4、播放选错的音效
                    [self playSpriteAudioWithName:@"pigLostBun.mp3"];
                    // 5、显示包子掉了的动画
                    [self updatePigLostBunAnimation];
                    // 6、加载下一组数据
                    [self loadWordGameData];
                    // 7、加载动画
                    [self loadGameRubImage:0 ItemID:-1];
                }
                [self resetWordMask];
                break;
            }
        }
    }
}


#pragma mark - 准备退出本界面时的处理
- (void)prepareToQuit
{
    [[[CCDirector sharedDirector] scheduler] unscheduleAllForTarget:timeControl];
    
    [super prepareToQuit];
}

- (void)updateLessonData
{
    [self performSelectorInBackground:@selector(updateWordLessonData) withObject:nil];
}

- (void)uploadLessonData
{
    NSArray *arrData = [[GameManager sharedManager] loadWordDataWithUserID:curUserID humanID:curHumanID groupID:curGroupID bookID:curBookID typeID:curTypeID lessonID:curLessonID];
    
    NSString *knowledges = @"";
    for (int i = 0; i < [arrData count]; i++)
    {
        WordModel *wordTModel = [arrData objectAtIndex:i];
        knowledges = [knowledges stringByAppendingFormat:@"%d|%.2f,", wordTModel.knowledgeIDValue, wordTModel.progressValue];
    }
    knowledges = [knowledges substringToIndex:[knowledges length]-1];
    
    NSString *strScore = [NSString stringWithFormat:@"%d", lessonModel.scoreValue];
    NSString *strStarNum = [NSString stringWithFormat:@"%d", lessonModel.starAmountValue];
    NSString *strProgress = [NSString stringWithFormat:@"%.2f", lessonModel.progressValue];
    NSString *strDataVersion = [NSString stringWithFormat:@"%f", lessonModel.dataVersionValue];
    NSString *strTimeStamp = [NSString stringWithFormat:@"%@", lessonModel.updateTime];
    // 上传更新数据，locked为0：因为本关既然能进来玩说明是已经解锁了的。
    [UploadLessonNet uploadLessonInfoWithUserID:curUserID HumanID:strHumanID GroupID:strGroupID BookID:strBookID TypeID:strTypeID LessonID:strLessonID Score:strScore StarAmount:strStarNum Progress:strProgress Locked:@"0" UpdateTime:strTimeStamp DataVersion:strDataVersion Knowledges:knowledges];
}

#pragma mark - TimerProgress Delegate

- (void)timeProgressControl:(WordTimeControl *)control timeOut:(BOOL)timeOut
{
    if (timeOut)
    {
        // 显示分数和进度界面
        [self gameFinished];
    }
}
#pragma mark - pauseLayer/gameresult Delegate
// 继续
-(void)didRecieveResumeEvent:(CCLayer *)layer
{
    [super didRecieveResumeEvent:layer];
}

// 重开
-(void)didRecieveRestartEvent:(CCLayer *)layer
{
    [super didRecieveRestartEvent:layer];
    
    [SceneManager loadingWithGameID:kWordGameSceneID];
}

// 返回(主导航)
- (void)didRecieveQuitEvent:(CCLayer *)layer
{
    [super didRecieveQuitEvent:layer];
    //[SceneManager loadingWithGameID:kWordNavigationSceneID];
    [SceneManager loadingWithGameID:kCommonNavigationSceneID];
}

// 进入下一关
- (void)didRecieveEnterNextLessonEvent:(CCLayer *)layer;
{
    [super didRecieveEnterNextLessonEvent:layer];
    
    [SceneManager loadingWithGameID:kWordGameSceneID];
}

// 分数显示结束, 显示知识点进度。
- (void)didRecieveShowKnowledgeProgressEvent:(CCLayer *)layer
{
    [super didRecieveShowKnowledgeProgressEvent:layer];
}

#pragma mark - Memory Manager
- (void)dealloc
{
    CCLOG(@"%@ : %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    [[self class] cancelPreviousPerformRequestsWithTarget:self];
    [WordNet cancelRequest];
    
    [SimpleAudioEngine end];
    
    [Array_option removeAllObjects];
    Array_option = nil;
    
    [Array_option_point4 removeAllObjects];
    Array_option_point4 = nil;
    
    [Array_option_point6 removeAllObjects];
    Array_option_point6 = nil;
    
    [spIcoBaozi removeFromParentAndCleanup:YES];
    spIcoBaozi = nil;
    
    [bgRubImage removeFromParentAndCleanup:YES];
    bgRubImage = nil;
    
    [lblScore removeFromParentAndCleanup:YES];
    lblScore = nil;
    
    [lblScTitle removeFromParentAndCleanup:YES];
    lblScTitle = nil;
    
    [lblHScore removeFromParentAndCleanup:YES];
    lblHScore = nil;
    
    [lblHScTitle removeFromParentAndCleanup:YES];
    lblHScTitle = nil;
    
    [menu removeFromParentAndCleanup:YES];
    menu = nil;
    
    /*
    [spLeftBamboo removeFromParentAndCleanup:YES];
    spLeftBamboo = nil;
    
    [spRightBamboo removeFromParentAndCleanup:YES];
    spRightBamboo = nil;
     */
    
    [spBajie stopAllActions];
    [spBajie removeFromParentAndCleanup:YES];
    spBajie = nil;
    
    [bun_tray removeFromParentAndCleanup:YES];
    bun_tray = nil;
    
    [firstBunGas stopAllActions];
    [firstBunGas removeFromParentAndCleanup:YES];
    firstBunGas = nil;
    
    [secondBunGas stopAllActions];
    [secondBunGas removeFromParentAndCleanup:YES];
    secondBunGas = nil;
    
    [thirdBunGas stopAllActions];
    [thirdBunGas removeFromParentAndCleanup:YES];
    thirdBunGas = nil;
    
    [word_grid removeFromParentAndCleanup:YES];
    word_grid = nil;
    
    [word_content removeFromParentAndCleanup:YES];
    word_content = nil;
    
    [word_mask removeFromParentAndCleanup:YES];
    word_mask = nil;
    
    [scratchableImage removeFromParentAndCleanup:YES];
    scratchableImage = nil;
    
    [revealSprite removeFromParentAndCleanup:YES];
    revealSprite = nil;
    
    [knowledgeLayer removeFromParentAndCleanup:YES];
    knowledgeLayer = nil;
    
    timeControl = nil;
    wordModel = nil;
    lessonModel = nil;
    oldAudioName = nil;
    oldSpriteAnimateAudioName = nil;
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFrames];
    [CCSpriteFrameCache purgeSharedSpriteFrameCache];
    
    [[CCTextureCache sharedTextureCache] removeAllTextures];
    [CCTextureCache purgeSharedTextureCache];
    
    // 释放所有音效和背景音乐
    [SimpleAudioEngine end];
    CCLOG(@"%@ : %@; 结束! ", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
}

@end
