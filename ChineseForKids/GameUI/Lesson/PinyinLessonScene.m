//
//  PinyinLessonScene.m
//  ChineseForKids
//
//  Created by yang on 13-12-10.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "PinyinLessonScene.h"
#import "SimpleAudioEngine.h"
#import "GameManager.h"
#import "GlobalDataHelper.h"
#import "GameLessonData.h"

#import "Monkey.h"
#import "Peach.h"
#import "DashToneBox.h"
#import "Trees.h"
#import "Contents.h"
#import "TimeProgressControl.h"

#import "KnowledgeProgressLayer.h"

#import "PinyinNet.h"
#import "UploadLessonNet.h"

#import "PinyinModel.h"
#import "LessonModel.h"
#import "ResponseModel.h"

#import "SceneManager.h"
#import "cocos2d.h"

#import "Constants.h"
#import "CommonHelper.h"

#define SelectWrongAudio @"selectWrongTone.caf"
#define SelectRightAudio @"selectRightTone.caf"
#define PeachCorrectAudio @"peachCorrect.caf"
#define KeepRightAudio @"keepRight.caf"

/**
 * 虚线框的位置
 *
 * 因为最多情况下只会有4个字的词, 所以在这里可以提前将这四种情况下的虚线框的位置固定。
 */

#define DASHBOX_Y_FACTOR 0.892f

// 只有一个的情况
#define DASHBOX_ONLYONE_POSITION ccp(self.boundingBox.size.width*0.5f, self.boundingBox.size.height*DASHBOX_Y_FACTOR)

// 有两个的情况
#define DASHBOX_TWO_FIRST_POSITION ccp(self.boundingBox.size.width*0.4f, self.boundingBox.size.height*DASHBOX_Y_FACTOR)
#define DASHBOX_TWO_SECOND_POSITION ccp(self.boundingBox.size.width*0.6f, self.boundingBox.size.height*DASHBOX_Y_FACTOR)

// 有三个的情况
#define DASHBOX_THREE_FIRST_POSITION ccp(self.boundingBox.size.width*0.3f, self.boundingBox.size.height*DASHBOX_Y_FACTOR)
#define DASHBOX_THREE_SECOND_POSITION ccp(self.boundingBox.size.width*0.5f, self.boundingBox.size.height*DASHBOX_Y_FACTOR)
#define DASHBOX_THREE_THIRD_POSITION ccp(self.boundingBox.size.width*0.7f, self.boundingBox.size.height*DASHBOX_Y_FACTOR)

// 有四个的情况
#define DASHBOX_FOUR_FIRST_POSITION ccp(self.boundingBox.size.width*0.3f, self.boundingBox.size.height*DASHBOX_Y_FACTOR)
#define DASHBOX_FOUR_SECOND_POSITION ccp(self.boundingBox.size.width*0.4f, self.boundingBox.size.height*DASHBOX_Y_FACTOR)
#define DASHBOX_FOUR_THIRD_POSITION ccp(self.boundingBox.size.width*0.6f, self.boundingBox.size.height*DASHBOX_Y_FACTOR)
#define DASHBOX_FOUR_FOUTH_POSITION ccp(self.boundingBox.size.width*0.7f, self.boundingBox.size.height*DASHBOX_Y_FACTOR)

/**
 * 拼音的位置
 */
#define PINYIN_Y_FACTOR 0.819f
// 只有一个的情况
#define PINYIN_ONLYONE_POSITION ccp(self.boundingBox.size.width*0.5f, self.boundingBox.size.height*PINYIN_Y_FACTOR)

// 有两个的情况
#define PINYIN_TWO_FIRST_POSITION ccp(self.boundingBox.size.width*0.4f, self.boundingBox.size.height*PINYIN_Y_FACTOR)
#define PINYIN_TWO_SECOND_POSITION ccp(self.boundingBox.size.width*0.6f, self.boundingBox.size.height*PINYIN_Y_FACTOR)

// 有三个的情况
#define PINYIN_THREE_FIRST_POSITION ccp(self.boundingBox.size.width*0.3f, self.boundingBox.size.height*PINYIN_Y_FACTOR)
#define PINYIN_THREE_SECOND_POSITION ccp(self.boundingBox.size.width*0.5f, self.boundingBox.size.height*PINYIN_Y_FACTOR)
#define PINYIN_THREE_THIRD_POSITION ccp(self.boundingBox.size.width*0.7f, self.boundingBox.size.height*PINYIN_Y_FACTOR)

// 有四个的情况
#define PINYIN_FOUR_FIRST_POSITION ccp(self.boundingBox.size.width*0.3f, self.boundingBox.size.height*PINYIN_Y_FACTOR)
#define PINYIN_FOUR_SECOND_POSITION ccp(self.boundingBox.size.width*0.4f, self.boundingBox.size.height*PINYIN_Y_FACTOR)
#define PINYIN_FOUR_THIRD_POSITION ccp(self.boundingBox.size.width*0.6f, self.boundingBox.size.height*PINYIN_Y_FACTOR)
#define PINYIN_FOUR_FOUTH_POSITION ccp(self.boundingBox.size.width*0.7f, self.boundingBox.size.height*PINYIN_Y_FACTOR)

#define kScoreColor [UIColor orangeColor]

@interface PinyinLessonScene ()<MonkeyDelegate, TimeProgressControlDelegate, PeachTouchDelegate, DashToneBoxDelegate>

@end

@implementation PinyinLessonScene
{
    // 拼音的索引值, 如有的一次数据中是词的话, 就会有多个拼音。那么要判断是否将该词中的所有的拼音都处理完了。
    NSInteger phonemeIndex;
    // 开始触摸的点
    //CGPoint locationBegin;
    
    NSArray *arrTouchBegin;
    
    // 桃子数组
    NSMutableArray *arrPeach;
    // 当桃子被选对的时候, 判断哪几个桃子是选对的
    NSMutableIndexSet *peachIndexSet;
    
    PinyinModel *mdPinyin;
    // 虚线框数组
    NSMutableArray *arrDashBox;
    // 内容
    NSMutableArray *arrContents;
    
    // 因为一组数据中可能是单个的字也可能是词。所以要区分开来。
    // 汉字分词后的数组
    NSMutableArray *arrChinese;
    // 拼音分词后的数组
    NSMutableArray *arrPinyin;
    // 不带声调的拼音的数组
    NSMutableArray *arrPinyinNoPhoneme;
    
    // 声调分词后的数组
    NSMutableArray *arrPhoneme;
    
    CCMenu *menu;
    CCSprite *spBackground;
    
    // 猴王
    Monkey *monkey;
    
    // 时间进度条
    TimeProgressControl *timeControl;
    
    // 虚线框
    //DashToneBox *dashBox;
    
    // 两边倒退的树
    Trees *trees;
    
    CCSpriteBatchNode *batchNode;
}

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
        
        phonemeIndex = 0;
        
        peachIndexSet = [[NSMutableIndexSet alloc] init];
        arrPeach = [[NSMutableArray alloc] init];
        arrDashBox = [[NSMutableArray alloc] init];
        arrContents = [[NSMutableArray alloc] init];
        
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
    [self playBackgroundAudio:@"levelBackgroundAudio.mp3"];
    
    // 初始化本关的数据模型
    [self initLessonModel];
    
    // 更新最高得分数据
    [self updateHighScore];
    
    // 更新拼音数据
    [self updatePinyinData];
}

- (void)initInterface
{
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    spBackground = [CCSprite spriteWithSpriteFrameName:@"levelBackground.png"];
    spBackground.position = ccp(winSize.width*0.5f, winSize.height*0.5f);
    [self addChild:spBackground z:-1];
    
    // 倒退的树
    trees = [Trees treesWithParentNode:self];
    
    // 悟空
    monkey = [Monkey monkeyWithParentNode:self];
    
    // 1声调
    CGPoint position = ccp(winSize.width*0.329f, winSize.height*0.636f);
    Peach *peachToneOne  = [Peach peachWithParentNode:self phoneme:1 position:position];
    peachToneOne.delegate = self;
    peachToneOne.touchEnabled = YES;
    [arrPeach addObject:peachToneOne];
    // 2声调
    position = ccp(winSize.width*0.492f, winSize.height*0.636f);
    Peach *peachToneTwo  = [Peach peachWithParentNode:self phoneme:2 position:position];
    peachToneTwo.delegate = self;
    peachToneTwo.touchEnabled = YES;
    [arrPeach addObject:peachToneTwo];
    // 3声调
    position = ccp(winSize.width*0.644f, winSize.height*0.636f);
    Peach *peachToneThree = [Peach peachWithParentNode:self phoneme:3 position:position];
    peachToneThree.delegate = self;
    peachToneThree.touchEnabled = YES;
    [arrPeach addObject:peachToneThree];
    // 4声调
    position = ccp(winSize.width*0.426f, winSize.height*0.465f);
    Peach *peachToneFour = [Peach peachWithParentNode:self phoneme:4 position:position];
    peachToneFour.delegate = self;
    peachToneFour.touchEnabled = YES;
    [arrPeach addObject:peachToneFour];
    // 0声调
    position = ccp(winSize.width*0.572f, winSize.height*0.468f);
    Peach *peachToneZero = [Peach peachWithParentNode:self phoneme:0 position:position];
    peachToneZero.delegate = self;
    peachToneZero.touchEnabled = YES;
    [arrPeach addObject:peachToneZero];
    
    // 时间进度条
    timeControl = [TimeProgressControl timeProgressControlWithParentNode:self];
    
    // 暂停
    CCMenuItemImage *pauseItem=[CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"pause.png"] selectedSprite:nil target:self selector:@selector(gamePause)];
    pauseItem.position = ccp(self.boundingBox.size.width*0.06, self.boundingBox.size.height*0.94);
    
    menu =[CCMenu menuWithItems:pauseItem, nil];
    menu.position = CGPointZero;
    [self addChild:menu z:kLeftTree_z+1];
    
    // 当前得分
    lblScTitle = [CCLabelTTF labelWithString:@"Score" fontName:kFontNameChil fontSize:kPinyinFontSize*0.8f dimensions:CGSizeMake(kScoreLabel_Width, kScoreLabel_Height - 5) hAlignment:kCCTextAlignmentRight];
    lblScTitle.position = ccp(self.boundingBox.size.width - kScoreLabel_Width*0.5f, self.boundingBox.size.height - lblScTitle.boundingBox.size.height*0.5f);
    lblScTitle.color = ccc3(255.0f, 255.0f*0.5f, 0.0f);
    [self addChild:lblScTitle z:kRightrTree_z+1];
    
    lblScore = [CCLabelTTF labelWithString:@"0" fontName:kFontNameBold fontSize:kPinyinFontSize dimensions:CGSizeMake(kScoreLabel_Width, kScoreLabel_Height) hAlignment:kCCTextAlignmentRight];
    lblScore.position = ccp(self.boundingBox.size.width - kScoreLabel_Width*0.5f, lblScTitle.position.y-lblScTitle.boundingBox.size.height*0.5f-lblScore.boundingBox.size.height*0.5f);
    lblScore.color = ccc3(255.0f, 255.0f*0.5f, 0.0f);
    [self addChild:lblScore z:kRightrTree_z+1];
    
    // 历史最高分
    lblHScTitle = [CCLabelTTF labelWithString:@"HighScore" fontName:kFontNameChil fontSize:kPinyinFontSize*0.8f dimensions:CGSizeMake(kScoreLabel_Width, kScoreLabel_Height - 5) hAlignment:kCCTextAlignmentRight];
    lblHScTitle.position = ccp(self.boundingBox.size.width - kScoreLabel_Width*0.5f, lblScore.position.y-lblScore.boundingBox.size.height*0.5f-lblHScTitle.boundingBox.size.height*0.5f);
    lblHScTitle.color = ccc3(255.0f, 255.0f*0.5f, 0.0f);
    [self addChild:lblHScTitle z:kRightrTree_z+1];
    
    lblHScore = [CCLabelTTF labelWithString:@"0" fontName:kFontNameBold fontSize:kPinyinFontSize dimensions:CGSizeMake(kScoreLabel_Width, kScoreLabel_Height) hAlignment:kCCTextAlignmentRight];
    lblHScore.position = ccp(self.boundingBox.size.width - kScoreLabel_Width*0.5f, lblHScTitle.position.y-lblHScTitle.boundingBox.size.height*0.5f-lblHScore.boundingBox.size.height*0.5f);
    lblHScore.color = ccc3(255.0f, 255.0f*0.5f, 0.0f);
    [self addChild:lblHScore z:kRightrTree_z+1];
     
}

#pragma mark - 开启网络更新本课的数据
- (void)updateToneLessonData
{
    ResponseModel *response = [PinyinNet getPinyinGameInfoWithUserID:curUserID HumanID:strHumanID GroupID:strGroupID BookID:strBookID TypeID:strTypeID LessonID:strLessonID];
    if ([PinyinNet isRequestCanceled]) return;
    
    if (response.error.code != 0) {
        [self updateToneLessonData];
    }
}

#pragma mark - 更新获取的数据
// 更新拼音数据
- (void)updatePinyinData
{
    CCLOG(@"%@ : %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    // 释放旧的拼音数据
    [self cleanOldPinyinData];
    // 加载拼音数据
    [self loadPinyinData];
    // 更新内容显示
    [self updateContentsShow];
    // 播放声音
    [self playAudioWithName:mdPinyin.audio];
}

// 清除旧的数据
- (void)cleanOldPinyinData
{
    CCLOG(@"%@ : %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    mdPinyin = nil;
    
    [arrChinese removeAllObjects];
    [arrPinyin removeAllObjects];
    [arrPhoneme removeAllObjects];
    [arrPinyinNoPhoneme removeAllObjects];
    
    arrChinese = nil;
    arrPinyin = nil;
    arrPhoneme = nil;
    arrPinyinNoPhoneme = nil;
}

// 加载拼音数据
- (void)loadPinyinData
{
    CCLOG(@"%@ : %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    mdPinyin = (PinyinModel *)[[GameManager sharedManager] pickOutPinyinInfoWithUserID:curUserID humanID:curHumanID groupID:curGroupID bookID:curBookID typeID:curTypeID lessonID:curLessonID];
    if ([mdPinyin.chinese isEqualToString:mdPinyin.phoneme]){
        arrChinese = (NSMutableArray *)[CommonHelper separateComponents:mdPinyin.chinese key:@"|"];
    }else{
        arrChinese = (NSMutableArray *)[CommonHelper separateComponents:mdPinyin.chinese key:nil];
    }
    
    //NSLog(@"Chinese: %@", arrChinese);
    arrPinyin  = (NSMutableArray *)[CommonHelper separateComponents:mdPinyin.pinyin key:kPinyinSeperateKey];
    arrPhoneme = (NSMutableArray *)[CommonHelper separateComponents:mdPinyin.tone key:kPinyinSeperateKey];
    arrPinyinNoPhoneme = (NSMutableArray *)[CommonHelper separateComponents:mdPinyin.phoneme key:kPinyinSeperateKey];
}

// 更新内容显示
- (void)updateContentsShow
{
    CCLOG(@"%@ : %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    // 清除旧的内容
    [self cleanOldContents];
    [self loadContents];
    
    // 只在每次不一样时去更新虚线框的位置, 以避免每一次操作都要更新一次。
    if (mdPinyin.phonemeCountValue != [arrDashBox count])
    {
        [self performSelector:@selector(reloadDashBox) withObject:nil afterDelay:0.001f];
    }
}

- (void)reloadDashBox
{
    @autoreleasepool
    {
        [self cleanDashBox];
        [self updateDashBox];
    }
}

// 清理旧的内容
- (void)cleanOldContents
{
    [arrContents removeAllObjects];
}

// 加载内容
- (void)loadContents
{
    // 如果是声母、韵母等的练习,那么是没有汉语的.
    BOOL shouldShowChinese = YES;
    NSInteger count = [arrChinese count];
    if (count <= 0) {
        shouldShowChinese = NO;
    }
    
    switch (mdPinyin.phonemeCountValue)
    {
        case 1:
        {
            NSString *strPinyin = [NSString stringWithFormat:@"%@", [arrPinyinNoPhoneme objectAtIndex:0]];
            NSString *strChinese = shouldShowChinese ? [NSString stringWithFormat:@"%@", [arrChinese objectAtIndex:0]] : @"";
            
            Contents *contents = [Contents contentWithParentNode:self pinyin:strPinyin chinese:strChinese position:PINYIN_ONLYONE_POSITION];
            [arrContents addObject:contents];
            break;
        }
        case 2:
        {
            NSString *strPinyin = [NSString stringWithFormat:@"%@", [arrPinyinNoPhoneme objectAtIndex:0]];
            NSString *strChinese = shouldShowChinese ? [NSString stringWithFormat:@"%@", [arrChinese objectAtIndex:0]] : @"";
            Contents *contentsOne = [Contents contentWithParentNode:self pinyin:strPinyin chinese:strChinese position:PINYIN_TWO_FIRST_POSITION];
            [arrContents addObject:contentsOne];
            
            strPinyin = [NSString stringWithFormat:@"%@", [arrPinyinNoPhoneme objectAtIndex:1]];
            strChinese = shouldShowChinese ? [NSString stringWithFormat:@"%@", [arrChinese objectAtIndex:1]] : @"";
            Contents *contentsTwo = [Contents contentWithParentNode:self pinyin:strPinyin chinese:strChinese position:PINYIN_TWO_SECOND_POSITION];
            [arrContents addObject:contentsTwo];
            break;
        }
        case 3:
        {
            NSString *strPinyin = [NSString stringWithFormat:@"%@", [arrPinyinNoPhoneme objectAtIndex:0]];
            NSString *strChinese = shouldShowChinese ? [NSString stringWithFormat:@"%@", [arrChinese objectAtIndex:0]] : @"";
            Contents *contentsOne = [Contents contentWithParentNode:self pinyin:strPinyin chinese:strChinese position:PINYIN_THREE_FIRST_POSITION];
            [arrContents addObject:contentsOne];
            
            strPinyin = [NSString stringWithFormat:@"%@", [arrPinyinNoPhoneme objectAtIndex:1]];
            strChinese = shouldShowChinese ? [NSString stringWithFormat:@"%@", [arrChinese objectAtIndex:1]] : @"";
            Contents *contentsTwo = [Contents contentWithParentNode:self pinyin:strPinyin chinese:strChinese position:PINYIN_THREE_SECOND_POSITION];
            [arrContents addObject:contentsTwo];
            
            strPinyin = [NSString stringWithFormat:@"%@", [arrPinyinNoPhoneme objectAtIndex:2]];
            strChinese = shouldShowChinese ? [NSString stringWithFormat:@"%@", [arrChinese objectAtIndex:2]] : @"";
            Contents *contentsThree = [Contents contentWithParentNode:self pinyin:strPinyin chinese:strChinese position:PINYIN_THREE_THIRD_POSITION];
            [arrContents addObject:contentsThree];
            break;
        }
        case 4:
        {
            NSString *strPinyin = [NSString stringWithFormat:@"%@", [arrPinyinNoPhoneme objectAtIndex:0]];
            NSString *strChinese = shouldShowChinese ? [NSString stringWithFormat:@"%@", [arrChinese objectAtIndex:0]] : @"";
            Contents *contentsOne = [Contents contentWithParentNode:self pinyin:strPinyin chinese:strChinese position:PINYIN_FOUR_FIRST_POSITION];
            [arrContents addObject:contentsOne];
            
            strPinyin = [NSString stringWithFormat:@"%@", [arrPinyinNoPhoneme objectAtIndex:1]];
            strChinese = shouldShowChinese ? [NSString stringWithFormat:@"%@", [arrChinese objectAtIndex:1]] : @"";
            Contents *contentsTwo = [Contents contentWithParentNode:self pinyin:strPinyin chinese:strChinese position:PINYIN_FOUR_SECOND_POSITION];
            [arrContents addObject:contentsTwo];
            
            strPinyin = [NSString stringWithFormat:@"%@", [arrPinyinNoPhoneme objectAtIndex:2]];
            strChinese = shouldShowChinese ? [NSString stringWithFormat:@"%@", [arrChinese objectAtIndex:2]] : @"";
            Contents *contentsThree = [Contents contentWithParentNode:self pinyin:strPinyin chinese:strChinese position:PINYIN_FOUR_THIRD_POSITION];
            [arrContents addObject:contentsThree];
            
            strPinyin = [NSString stringWithFormat:@"%@", [arrPinyinNoPhoneme objectAtIndex:3]];
            strChinese = shouldShowChinese ? [NSString stringWithFormat:@"%@", [arrChinese objectAtIndex:3]] : @"";
            Contents *contentsFour = [Contents contentWithParentNode:self pinyin:strPinyin chinese:strChinese position:PINYIN_FOUR_FOUTH_POSITION];
            [arrContents addObject:contentsFour];
            break;
        }
            
        default:
            break;
    }
}

- (void)cleanDashBox
{
    [arrDashBox removeAllObjects];
}

- (void)updateDashBox
{
    switch (mdPinyin.phonemeCountValue)
    {
        case 1:
        {
            DashToneBox *dashBox = [DashToneBox dashToneBoxWithParentNode:self postion:DASHBOX_ONLYONE_POSITION];
            [arrDashBox addObject:dashBox];
            break;
        }
        case 2:
        {
            DashToneBox *dashBoxOne = [DashToneBox dashToneBoxWithParentNode:self postion:DASHBOX_TWO_FIRST_POSITION];
            [arrDashBox addObject:dashBoxOne];
            DashToneBox *dashBoxTwo = [DashToneBox dashToneBoxWithParentNode:self postion:DASHBOX_TWO_SECOND_POSITION];
            [arrDashBox addObject:dashBoxTwo];
            break;
        }
        case 3:
        {
            DashToneBox *dashBoxOne = [DashToneBox dashToneBoxWithParentNode:self postion:DASHBOX_THREE_FIRST_POSITION];
            [arrDashBox addObject:dashBoxOne];
            DashToneBox *dashBoxTwo = [DashToneBox dashToneBoxWithParentNode:self postion:DASHBOX_THREE_SECOND_POSITION];
            [arrDashBox addObject:dashBoxTwo];
            DashToneBox *dashBoxThree = [DashToneBox dashToneBoxWithParentNode:self postion:DASHBOX_THREE_THIRD_POSITION];
            [arrDashBox addObject:dashBoxThree];
            break;
        }
        case 4:
        {
            DashToneBox *dashBoxOne = [DashToneBox dashToneBoxWithParentNode:self postion:DASHBOX_FOUR_FIRST_POSITION];
            [arrDashBox addObject:dashBoxOne];
            DashToneBox *dashBoxTwo = [DashToneBox dashToneBoxWithParentNode:self postion:DASHBOX_FOUR_SECOND_POSITION];
            [arrDashBox addObject:dashBoxTwo];
            DashToneBox *dashBoxThree = [DashToneBox dashToneBoxWithParentNode:self postion:DASHBOX_FOUR_THIRD_POSITION];
            [arrDashBox addObject:dashBoxThree];
            DashToneBox *dashBoxFour = [DashToneBox dashToneBoxWithParentNode:self postion:DASHBOX_FOUR_FOUTH_POSITION];
            [arrDashBox addObject:dashBoxFour];
            
            break;
        }
            
        default:
            break;
    }
}

#pragma mark - UITouch Manager



#pragma mark - 准备退出本界面时的处理
- (void)prepareToQuit
{
    for (Peach *peach in arrPeach) [peach setTouchEnabled:NO];
    [[[CCDirector sharedDirector] scheduler] unscheduleAllForTarget:monkey];
    [[[CCDirector sharedDirector] scheduler] unscheduleAllForTarget:timeControl];
    [[[CCDirector sharedDirector] scheduler] unscheduleAllForTarget:trees];
    
    [super prepareToQuit];
}

#pragma mark - 音调框内音调的处理
- (void)hideToneOfAllDashBox
{
    // 隐藏所有的音调
    for (DashToneBox *dashBox in arrDashBox)
    {
        [dashBox hideTone];
    }
}

#pragma mark - DashBox Delegate
- (void)dashToneBox:(DashToneBox *)dashToneBox toneSHowCompleteWithRightAnser:(BOOL)right
{
    CCLOG(@"%@; %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    //if ((right && [dashToneBox isEqual:[arrDashBox objectAtIndex:[arrDashBox count]-1]]) || !right)
    if ([dashToneBox isEqual:[arrDashBox objectAtIndex:[arrDashBox count]-1]])
    {
        // 1、隐藏所有的虚线框内的声调
        [self hideToneOfAllDashBox];
        // 2、获取下一组数据
        [self updatePinyinData];
        // 3、设置桃子恢复可以点击
        [self setPeachTouchEnabled:YES];
    }
}

/*
- (void)reloadGameData
{
    // 1、隐藏所有的虚线框内的声调
    [self hideToneOfAllDashBox];
    // 2、获取下一组数据
    [self updatePinyinData];
    // 3、设置桃子恢复可以点击
    [self setPeachTouchEnabled:YES];
}
*/
#pragma mark - Peach Touch Enabled Manager
- (void)setPeachTouchEnabled:(BOOL)enabled
{
    for (Peach *peach in arrPeach)
    {
        [peach setTouchEnabled:enabled];
    }
}

#pragma mark - Peach Touch Delegate
- (void)peach:(Peach *)peach touchEnd:(UITouch *)touch
{
    if (phonemeIndex < mdPinyin.phonemeCountValue)
    {
        Contents *content = [arrContents objectAtIndex:phonemeIndex];
        [content setRightPinyin:[arrPinyin objectAtIndex:phonemeIndex]];
        
        DashToneBox *dashBox = [arrDashBox objectAtIndex:phonemeIndex];
        NSInteger rightPhoneme = [[arrPhoneme objectAtIndex:phonemeIndex] integerValue];
        // 所点击的声调桃子的声调和当前正确答案一致。
        if (peach.phoneme == rightPhoneme)
        {
            // 1、当前桃子执行选对的动画.
            peach.isRightPhoneme = YES;
            // 2、播放选对的声效
            [self playSpriteAudioWithName:PeachCorrectAudio];
            // 3、对应虚线框内执行动画
            [dashBox showToneWithPhoneme:rightPhoneme rightAnswer:YES animated:YES];
            // 4、保留选对的peach的索引值, 以便peach的集中动画处理
            NSInteger peachIndex = [arrPeach indexOfObject:peach];
            [peachIndexSet addIndex:peachIndex];
            // 5、加一次表示处理了一次声调, 且只有处理正确了才往下走。
            phonemeIndex++;
        }
        // 所点击的声调桃子的声调和当前正确答案不一致。
        else
        {
            // 1、连对置为初始值
            keepRightNum = 0;
            // 6、更新该知识点错的次数
            mdPinyin.wrongTimesValue += mdPinyin.wrongTimesValue < PINYIN_SHOW_PROBABILITY ? 1 : 0;
            // 7、保存这种更改
            [mdPinyin saveData];
            // 3、对应虚线框内执行动画
            [dashBox showToneWithPhoneme:rightPhoneme rightAnswer:NO animated:YES];
            for (int i = phonemeIndex+1; i < [arrPhoneme count]; i++)
            {
                Contents *tContent = [arrContents objectAtIndex:i];
                [tContent setRightPinyin:[arrPinyin objectAtIndex:i]];
                
                DashToneBox *tDashBox = [arrDashBox objectAtIndex:i];
                NSInteger tRightPhoneme = [[arrPhoneme objectAtIndex:i] integerValue];
                [tDashBox showToneWithPhoneme:tRightPhoneme rightAnswer:NO animated:YES];
            }
            // 2、声调索引置为初始值
            phonemeIndex = 0;
            // 4、当前桃子执行选错的动画
            peach.isRightPhoneme = NO;
            // 5、播放选对的声效
            [self playSpriteAudioWithName:SelectWrongAudio];
            // 8、只要选错一次,那么就将所有的选对的peach的索引都删除, 且执行所有的peach不可点击.
            [peachIndexSet removeAllIndexes];
            [self setPeachTouchEnabled:NO];
            // 9、提前结束该函数
            return;
        }
    }// end if (phonemeIndex < mdPinyin.phonemeCountValue)
    
    // 该次的所有声调数据都处理完了。
    if (phonemeIndex == mdPinyin.phonemeCountValue && mdPinyin)
    {
        // 1、连对次数加1.
        keepRightNum++;
        // 2、更新该知识点对的次数
        mdPinyin.rightTimesValue += mdPinyin.rightTimesValue  < PINYIN_SHOW_PROBABILITY ? 1 : 0;
        // 3、更新该知识点的进度.所有这些数据都以概率为参考。
        mdPinyin.progressValue = mdPinyin.rightTimesValue/(CGFloat)PINYIN_SHOW_PROBABILITY;
        // 4、本课程总体进度
        lessonProgress += mdPinyin.progressValue;
        // 5、保存这种更改
        [mdPinyin saveData];
        // 6、播放选对的声效
        [self playSpriteAudioWithName:SelectRightAudio];
        // 7、当前所有被选择过的桃子执行选对的动画.
        NSArray *peachs = [arrPeach objectsAtIndexes:peachIndexSet];
        for (Peach *peach in peachs)
        {
            peach.isMoveRightPeach = YES;
        }
        // 8、分数
        [self showScoreWithPosition:ccp(self.boundingBox.size.width*0.75f, self.boundingBox.size.height*0.36f) Color:ccc3(255.0f, 125.0f, 0.0f)];
        // 9、播放连对的声效
        if (keepRightNum >= 5) [self playSpriteAudioWithName:KeepRightAudio];
        (keepRightNum >= 5 ? (monkey.shouldSomersault = YES) : (monkey.shouldFly = YES));
        // 10、悟空执行跳或飞的动作时, 设置所有的peach不可继续点击.
        [self setPeachTouchEnabled:NO];
        // 11、所有的选对的peach执行飞到悟空手中的动画.
        
        // 12、本组数据全部完成后声调索引回到初始化状态
        phonemeIndex = 0;
        [peachIndexSet removeAllIndexes];
    }
}

#pragma mark - TimerProgress Delegate
- (void)timeProgressControl:(TimeProgressControl *)control timeOut:(BOOL)timeOut
{
    if (timeOut)
    {
        // 显示分数和进度界面
        [self gameFinished];
    }
}

- (void)updateLessonData
{
    [self performSelectorInBackground:@selector(updateToneLessonData) withObject:nil];
}

- (void)uploadLessonData
{
    NSArray *arrData = [[GameManager sharedManager] loadPinyinDataWithUserID:curUserID humanID:curHumanID groupID:curGroupID bookID:curBookID typeID:curTypeID lessonID:curLessonID];
    
    NSString *knowledges = @"";
    for (int i = 0; i < [arrData count]; i++)
    {
        PinyinModel *pinyinModel = [arrData objectAtIndex:i];
        knowledges = [knowledges stringByAppendingFormat:@"%d|%.2f,", pinyinModel.knowledgeIDValue, pinyinModel.progressValue];
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

#pragma mark - Monkey Delegate
- (void)monkey:(Monkey *)monkey animationFinished:(BOOL)finished
{
    /*
     CCLOG(@"%@ : %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
     // 1、获取下一组数据
     [self updatePinyinData];
     // 2、设置恢复可以点击
     //[self setTouchEnabled:YES];
     [self setPeachTouchEnabled:YES];
     // 3、隐藏所有的虚线框内的声调
     [self hideToneOfAllDashBox];
     */
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
    
    [SceneManager loadingWithGameID:kPinyinGameSceneID];
}

// 返回(主导航)
- (void)didRecieveQuitEvent:(CCLayer *)layer
{
    [super didRecieveQuitEvent:layer];
    
    //[SceneManager loadingWithGameID:kPinyinNavigationSceneID];
    [SceneManager loadingWithGameID:kCommonNavigationSceneID];
}

// 进入下一关
- (void)didRecieveEnterNextLessonEvent:(CCLayer *)layer;
{
    [super didRecieveEnterNextLessonEvent:layer];
    
    [SceneManager loadingWithGameID:kPinyinGameSceneID];
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
    [PinyinNet cancelRequest];
    [self cleanOldPinyinData];
    
    [spBackground removeFromParentAndCleanup:YES];
    spBackground = nil;
    
    [lblScTitle removeFromParentAndCleanup:YES];
    lblScTitle = nil;
    
    [lblScore removeFromParentAndCleanup:YES];
    lblScore = nil;
    
    [lblHScTitle removeFromParentAndCleanup:YES];
    lblHScTitle = nil;
    
    [lblHScore removeFromParentAndCleanup:YES];
    lblHScore = nil;
    
    [knowledgeLayer removeFromParentAndCleanup:YES];
    knowledgeLayer = nil;
    
    timeControl = nil;
    mdPinyin = nil;
    lessonModel = nil;
    oldAudioName = nil;
    oldSpriteAnimateAudioName = nil;
    
    monkey = nil;
    timeControl = nil;
    
    [arrContents removeAllObjects];
    [arrDashBox removeAllObjects];
    [arrPeach removeAllObjects];
    [peachIndexSet removeAllIndexes];
    
    arrContents = nil;
    arrDashBox = nil;
    arrPeach = nil;
    peachIndexSet = nil;
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFrames];
    [CCSpriteFrameCache purgeSharedSpriteFrameCache];
    
    [[CCTextureCache sharedTextureCache] removeAllTextures];
    [CCTextureCache purgeSharedTextureCache];
    
    // 释放所有音效和背景音乐
    [SimpleAudioEngine end];
    CCLOG(@"%@ : %@; 结束! ", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
}

@end
