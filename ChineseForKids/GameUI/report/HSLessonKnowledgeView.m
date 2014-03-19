//
//  ResultReportView.m
//  PinyinGame
//
//  Created by yang on 13-11-4.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "HSLessonKnowledgeView.h"
#import "PinyinModel.h"
#import "WordModel.h"
#import "SentencePatternModel.h"
#import "TranslationModel.h"
#import "LessonModel.h"
#import "GameLessonData.h"
#import "GameManager.h"
#import "Constants.h"
#import "FileHelper.h"

#import "HSLearnProgressCustomTableCell.h"
#import "HSLearnCircleProgressView.h"
#import "HSFontHandleManager.h"

#import "GlobalDataHelper.h"

#import "CommonHelper.h"

#import "UIImage+Extra.h"

#import <ShareSDK/ShareSDK.h>

#define kUserNameFontSize 36.0f
#define kScoreFontSize 22.0f

#define kPinyinRect CGRectMake(self.bounds.size.width*0.56f, self.bounds.size.height*0.29f, self.bounds.size.width*0.303f, self.bounds.size.height*0.1f)

#define kChineseRect CGRectMake(self.bounds.size.width*0.56f, self.bounds.size.height*0.4f, self.bounds.size.width*0.303f, self.bounds.size.height*0.135f)

#define kEnglishRect CGRectMake(self.bounds.size.width*0.55f, self.bounds.size.height*0.55f, self.bounds.size.width*0.323f, self.bounds.size.height*0.235f)

@interface HSLessonKnowledgeView ()<AVAudioPlayerDelegate>

@end

@implementation HSLessonKnowledgeView
{
    CGFloat percent;
    // 当前个数的拼音现实的区域
    CGFloat curPinyinShowWidth;
    NSString *curUserID;
    NSInteger curUnitID;
    NSInteger curHumanID;
    NSInteger curGroupID;
    NSInteger curBookID;
    NSInteger curTypeID;
    NSInteger curLessonID;
    
    NSInteger actPinyinFontSize;
    
    NSInteger cellIndex;
    NSMutableArray *arrKnowledges;
    
    NSMutableArray *arrShowData;
    
    NSString *pinyin;
    NSString *chinese;
    NSString *english;
    NSString *strAudio;
    
    HSLearnCircleProgressView *circleProView;
    
    UIImage *imgBackground;
    UIImage *imgTableBkg;
    UIImage *imgCircleBkg;
    
    UIImage *imgHighScoreBkg;
    UIImage *imgAudio;
    UIImage *imgClose;
    
    UIImage *imgShare;
    UIImage *imgBtnShare;
    
    CGSize userNameSize;
    CGSize starSize;
    
    UILabel *lblUserName;
    UILabel *lblHighScore;
    UILabel *lblCurScore;
    
    UIButton *btnQuit;
    UIButton *btnShare;
    UIButton *btnAudio;
    
    NSTimer *timer;
    
    AVAudioPlayer *player;
}

+ (void)addShadowToView:(UIView *)view
{
    [[view layer] setShadowOffset:CGSizeMake(-2, 2)];
    [[view layer] setShadowColor:[[UIColor blackColor] CGColor]];
    [[view layer] setShadowRadius:1.0f];
    [[view layer] setShadowOpacity:0.2f];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        percent = 0.0f;
        arrKnowledges = [[NSMutableArray alloc] init];
        arrShowData = [[NSMutableArray alloc] init];
        
        imgBackground = [UIImage imageNamed:@"knowledgebkg.png"];
        imgTableBkg = [UIImage imageNamed:@"knowledgeTablebkg.png"];
        imgCircleBkg = [UIImage imageNamed:@"learnRedCircleProgress.png"];
        
        imgClose = [UIImage imageNamed:@"btnClose.png"];
        imgAudio = [UIImage imageNamed:@"audio.png"];
        imgShare = [UIImage imageNamed:@"share.jpg"];
        imgBtnShare = [UIImage imageNamed:@"btnShare.png"];
        
        curUserID   = [GlobalDataHelper sharedManager].curUserID;
        curHumanID  = [GlobalDataHelper sharedManager].curHumanID;
        curGroupID  = [GlobalDataHelper sharedManager].curGroupID;
        curBookID   = [GlobalDataHelper sharedManager].curBookID;
        curTypeID   = [GlobalDataHelper sharedManager].curTypeID;
        curLessonID = [GlobalDataHelper sharedManager].curLessonID;
        
        cellIndex = -1;
        
        [self loadKnowledgeDataWithUserID:curUserID humanID:curHumanID groupID:curGroupID bookID:curBookID typeID:curTypeID lessonID:curLessonID];
        
        [self initInterface];
        
        [self startTimer];
    }
    return self;
}

- (void)loadKnowledgeDataWithUserID:(NSString *)userID humanID:(NSInteger)humanID groupID:(NSInteger)groupID bookID:(NSInteger)bookID typeID:(NSInteger)typeID lessonID:(NSInteger)lessonID
{
    //NSArray *arrPinyin = [[GameManager sharedManager] loadPinyinDataWithUserID:userID humanID:humanID groupID:groupID bookID:bookID typeID:typeID lessonID:lessonID];
    //if (arrPinyin) [arrKnowledges setArray:arrPinyin];
    NSArray *arrData = [[GameManager sharedManager] loadDataWithUserID:userID humanID:humanID groupID:groupID bookID:bookID typeID:typeID lessonID:lessonID];
    
    if (arrData) [arrKnowledges setArray:arrData];
}

- (void)initInterface
{
    tbvProgress = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tbvProgress.dataSource = self;
    tbvProgress.delegate   = self;
    tbvProgress.indicatorStyle = UIScrollViewIndicatorStyleBlack;
    tbvProgress.tableFooterView = [[UIView alloc] init];
    tbvProgress.backgroundView  = [[UIView alloc] init];
    tbvProgress.backgroundColor = [UIColor clearColor];
    // 去除group形态下cell的边框线。
    tbvProgress.separatorStyle = UITableViewCellSeparatorStyleNone;
    tbvProgress.separatorColor = [UIColor clearColor];
    [self addSubview:tbvProgress];
    /*
    circleProView = [[HSLearnCircleProgressView alloc] init];
    circleProView.backgroundColor = [UIColor clearColor];
    [self addSubview:circleProView];
    [ResultReportView addShadowToView:circleProView];
     */
    
    // 声音
    btnAudio = [UIButton buttonWithType:UIButtonTypeCustom];
    btnAudio.hidden = YES;
    [btnAudio setBackgroundImage:imgAudio forState:UIControlStateNormal];
    [btnAudio addTarget:self action:@selector(playSelectedAudio:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnAudio];
    
    // 退出
    btnQuit = [UIButton buttonWithType:UIButtonTypeCustom];
    //[btnQuit setTitle:@"quit" forState:UIControlStateNormal];
    [btnQuit setImage:imgClose forState:UIControlStateNormal];
    [btnQuit addTarget:self action:@selector(quitAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnQuit];
    
    // 分享
    btnShare = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnShare setImage:imgBtnShare forState:UIControlStateNormal];
    [btnShare addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnShare];
}

#pragma mark - NSTimer
- (void)startTimer
{
    if ([GlobalDataHelper sharedManager].curTypeID != 3)
    {
        timer = [NSTimer scheduledTimerWithTimeInterval:4.0f target:self selector:@selector(autoSelectTableRow:) userInfo:nil repeats:YES];
    }
}

- (void)stopTimer
{
    if (timer)
    {
        [timer invalidate];
        timer = nil;
    }
}

- (void)autoSelectTableRow:(NSTimer *)timer
{
    @autoreleasepool
    {
        [self performSelectorOnMainThread:@selector(autoSelectKnowledge) withObject:nil waitUntilDone:YES];
    }
}

- (void)autoSelectKnowledge
{
    cellIndex++;
    //NSIndexPath *indexPath = [tbvProgress indexPathForSelectedRow];
    if (cellIndex < [arrKnowledges count])
    {
        NSIndexPath *nextIndexPath = [NSIndexPath indexPathForRow:cellIndex inSection:0];
        [self selectIndexPath:nextIndexPath];
        [tbvProgress selectRowAtIndexPath:nextIndexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
        [tbvProgress scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionMiddle animated:NO];
    }
}

#pragma mark - UIButton Action Manager
- (void)playSelectedAudio:(id)sender
{
    [self stopAudio];
    [self initAudioPlayerWithSource:strAudio];
    [self playAudio];
}

- (void)quitAction:(id)sender
{
    [self stopTimer];
    if (self.delegate && [self.delegate respondsToSelector:@selector(lessonKnowledgeView:quit:)])
    {
        [self.delegate lessonKnowledgeView:self quit:YES];
    }
}

- (void)shareAction:(id)sender
{
    id<ISSContainer> container = [ShareSDK container];
    [container setIPadContainerWithView:sender arrowDirect:UIPopoverArrowDirectionDown];
    
    //NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"share@2x" ofType:@"jpg"];

    NSString *content = [NSString stringWithFormat:@"#西游汉语乐园# 邀您一起来学习!"];
    
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:content
                                       defaultContent:@"默认分享内容，没内容时显示"
                                                image:[ShareSDK jpegImageWithImage:imgShare quality:1]
                                                title:@"我的拼音小游戏"
                                                  url:@"http://www.hschinese.com"
                                          description:@"学习汉语的好乐园"
                                            mediaType:SSPublishContentMediaTypeImage];
    
    //弹出分享菜单
    
    [ShareSDK showShareActionSheet:container
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state == SSResponseStateSuccess)
                                {
                                    //NSLog(@"分享成功");
                                    [CommonHelper makeToastWithMessage:NSLocalizedString(@"分享成功", @"") view:self];
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    //NSLog(@"分享失败,错误码:%d,错误描述:%@", [error errorCode], [error errorDescription]);
                                    [CommonHelper makeToastWithMessage:[error errorDescription] view:self];
                                }
                            }];
}

#pragma mark - Audio Player Manager

- (void)initAudioPlayerWithSource:(NSString *)source
{
    //NSString *path = [[NSBundle mainBundle] pathForResource:source ofType:nil];
    NSString *lessonAudio = [NSString stringWithFormat:@"%d", curLessonID];
    NSString *path = [[kDownloadedPath stringByAppendingPathComponent:lessonAudio] stringByAppendingPathComponent:source];
    
    //NSArray *arrAudio = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:[kDownloadedPath stringByAppendingPathComponent:lessonAudio]  error:nil];
    //NSLog(@"所有的音频文件: %@", arrAudio);
    NSError *err;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        DLog(@"存在文件: path: %@", path);
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:&err];
        player.delegate = self;
        [player prepareToPlay];
        //NSLog(@"错误信息: %@ ; ds:%@", err.domain, err.localizedDescription);
    }
}

- (void)playAudio
{
    if (player)
    {
        [player play];
    }
}

- (void)stopAudio
{
    if (player)
    {
        [player stop];
        player = nil;
    }
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
{
    DLog(@"播放错误: %@; %@; %@", error.domain, error.userInfo, error.description);
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    DLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player
{
    DLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player
{
    DLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withFlags:(NSUInteger)flags
{
    DLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withOptions:(NSUInteger)flags
{
    DLog(@"%@", NSStringFromSelector(_cmd));
}

#pragma mark - Subviews Manager
- (void)layoutSubviews
{
    if (tbvProgress)
    {
        tbvProgress.frame  = (curTypeID == 3) ? CGRectMake(self.bounds.size.width*0.125f, self.bounds.size.height*0.308f, self.bounds.size.width*0.754f, self.bounds.size.height*0.41f) : CGRectMake(self.bounds.size.width*0.125f, self.bounds.size.height*0.308f, self.bounds.size.width*0.404f, self.bounds.size.height*0.41f);
    }
    
    if (btnAudio)
    {
        btnAudio.frame = CGRectMake(self.bounds.size.width*0.817f, self.bounds.size.height*0.622f, imgAudio.size.width, imgAudio.size.height);
    }
    
    if (btnQuit)
    {
        btnQuit.frame = CGRectMake(self.bounds.size.width*0.89f, self.bounds.size.height*0.12f, imgClose.size.width, imgClose.size.height);
    }
    
    if (btnShare)
    {
        btnShare.frame = CGRectMake(self.bounds.size.width*0.86f, self.bounds.size.height*0.838f, imgBtnShare.size.width, imgBtnShare.size.height);
    }
    
    //[self refreshCircleProgressViewWithPercent:percent];
}

- (void)drawRect:(CGRect)rect
{
	[imgBackground drawInRect:self.bounds];
    [imgTableBkg drawInRect:tbvProgress.frame];

    NSInteger typeID = [GlobalDataHelper sharedManager].curTypeID;
    switch (typeID)
    {
        case 1:
        {
            [self drawPinyinDataWithRect:rect];
            break;
        }
        case 2:
        {
            [self drawWordDataWithRect:rect];
            break;
        }
        case 3:
        {
            //[self drawSenPatternDataWithRect:rect];
            break;
        }
        case 4:
        {
            [self drawTranslateDataWithRect:rect];
            break;
        }
            
        default:
            break;
    }
    /*
	[imgCircleBkg drawInRect:CGRectMake(circleProView.frame.origin.x-1, circleProView.frame.origin.y+2, circleProView.bounds.size.width, circleProView.bounds.size.height)];
    */
    
    
    /*
    [[UIColor redColor] set];
    NSString *strPercent = [NSString stringWithFormat:@"%.f%%", percent*100];
    UIFont *font = [HSFontHandleManager resizableSizeFontWithFont:[UIFont fontWithName:kFontName size:32] content:strPercent width:circleProView.frame.size.width-56 minFontSize:6 lineBreakMode:NSLineBreakByCharWrapping];
    CGRect textRect = CGRectMake(circleProView.frame.origin.x, circleProView.center.y-circleProView.bounds.size.height*0.0625f, circleProView.bounds.size.width, circleProView.bounds.size.height*0.5f);
    [strPercent drawInRect:textRect withFont:font lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentCenter];
    */
    
}

- (void)drawPinyinDataWithRect:(CGRect)rect
{
    if ([arrShowData count] <= 0)
    {
        UIFont *font = [HSFontHandleManager resizableSizeFontWithFont:[UIFont fontWithName:kFontName size:kReportChineseFontSize*0.6f] content:pinyin width:kPinyinRect.size.width minFontSize:6 lineBreakMode:NSLineBreakByCharWrapping];
        [pinyin drawInRect:kPinyinRect withFont:font lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentCenter];
        
        font = [HSFontHandleManager resizableSizeFontWithFont:[UIFont fontWithName:kFontName size:kReportChineseFontSize] content:chinese width:kChineseRect.size.width minFontSize:6 lineBreakMode:NSLineBreakByCharWrapping];
        
        [chinese drawInRect:kChineseRect withFont:font lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentCenter];
    }
    
    UIFont *font = [HSFontHandleManager resizableSizeFontWithFont:[UIFont fontWithName:kFontName size:kReportChineseFontSize*0.6f] content:english width:kEnglishRect.size.width minFontSize:10 lineBreakMode:NSLineBreakByCharWrapping];
    [english drawInRect:kEnglishRect withFont:font lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentCenter];
    
    
    // 计算出已经保存的拼音所占的区域。
    // 判断该区域的中心点是否和拼音显示的中心点一致。
    //   - 如果不一致, 那么调整总体显示的中心点。相当于将整个文本进行中点对齐。
    CGFloat pcfX = CGRectGetMidX(CGRectMake(kPinyinRect.origin.x, kPinyinRect.origin.y, curPinyinShowWidth, kPinyinRect.size.height));//(kPinyinRect.origin.x+curPinyinShowWidth) * 0.5f;
    CGFloat pcrX = CGRectGetMidX(kPinyinRect);
    CGFloat xdistance = pcrX - pcfX;
    
    for (int i = 0; i < [arrShowData count]; i++)
    {
        NSDictionary *dicAChar = [arrShowData objectAtIndex:i];
        NSArray *arrKey = [dicAChar allKeys];
        for (int j = 0; j < [arrKey count]; j++)
        {
            NSString *key    = [arrKey objectAtIndex:j];
            NSValue *value   = [dicAChar objectForKey:key];
            CGRect valueRect = [value CGRectValue];
            
            CGFloat size = (valueRect.origin.y == kChineseRect.origin.y) ? kReportChineseFontSize*0.7f : actPinyinFontSize;
            
            //NSLog(@"key : %@", key);
            
            CGRect keyRect = CGRectMake(valueRect.origin.x+xdistance, valueRect.origin.y, valueRect.size.width, valueRect.size.height);
            
            [key drawInRect:keyRect withFont:[UIFont fontWithName:kFontName size:size] lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentCenter];
        }
    }
}

- (void)drawWordDataWithRect:(CGRect)rect
{
    [arrShowData removeAllObjects];
    [self drawPinyinDataWithRect:rect];
}

- (void)drawSenPatternDataWithRect:(CGRect)rect
{
    [arrShowData removeAllObjects];
    [self drawPinyinDataWithRect:rect];
}

- (void)drawTranslateDataWithRect:(CGRect)rect
{
    //[arrShowData removeAllObjects];
    [self drawPinyinDataWithRect:rect];
}

#pragma mark - Refresh Manager

- (void)refreshCircleProgressViewWithPercent:(CGFloat)aPercent
{
    if (circleProView)
    {
        circleProView.animationDuration = 1.2f;
        circleProView.fillRadiusPx = 32.0f;
        circleProView.progressTintColor = [UIColor colorWithRed:120.0f/255.0f green:249.0f/255.0f blue:117.0f/255.0f alpha:1.0f];
        //circleProView.translatesAutoresizingMaskIntoConstraints = NO;
        [circleProView setCurrent:aPercent animated:YES];
    }
}

#pragma mark - ScrollView Delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (scrollView == tbvProgress)
    {
        // 在滚动的过程中不让进度条以动画的形式表现
        NSArray *arrVisibleCells = [tbvProgress visibleCells];
        for (int i = 0; i < [arrVisibleCells count]; i++)
        {
            HSLearnProgressCustomTableCell *cell = (HSLearnProgressCustomTableCell *)[arrVisibleCells objectAtIndex:i];
            cell.processAnimationDuration = 0.0f;
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == tbvProgress)
    {
        // 在停止后恢复进度条的动画。
        NSArray *arrVisibleCells = [tbvProgress visibleCells];
        for (int i = 0; i < [arrVisibleCells count]; i++)
        {
            HSLearnProgressCustomTableCell *cell = (HSLearnProgressCustomTableCell *)[arrVisibleCells objectAtIndex:i];
            cell.processAnimationDuration = 0.6f;
        }
    }
}

#pragma mark - Load TableViewCell Data
- (void)loadPinyinDataWithCell:(HSLearnProgressCustomTableCell *)cell IndexPath:(NSIndexPath *)indexPath
{
    PinyinModel *pinyinModel = (PinyinModel *)[arrKnowledges objectAtIndex:indexPath.row];
    cell.titleText = [pinyinModel.chinese isEqualToString:@""] ? pinyinModel.pinyin : pinyinModel.chinese;
    cell.percent   = pinyinModel.progressValue;
}

- (void)loadWordDataWithCell:(HSLearnProgressCustomTableCell *)cell IndexPath:(NSIndexPath *)indexPath
{
    WordModel *wordModel = (WordModel *)[arrKnowledges objectAtIndex:indexPath.row];
    cell.titleText = wordModel.rightWord;
    cell.percent   = wordModel.progressValue;
}

- (void)loadSenPatternDataWithCell:(HSLearnProgressCustomTableCell *)cell IndexPath:(NSIndexPath *)indexPath
{
    SentencePatternModel *senPatternModel = (SentencePatternModel *)[arrKnowledges objectAtIndex:indexPath.row];
    cell.titleText = senPatternModel.sentencePattern;
    cell.percent   = senPatternModel.progressValue;
}

- (void)loadTranslationDataWithCell:(HSLearnProgressCustomTableCell *)cell IndexPath:(NSIndexPath *)indexPath
{
    TranslationModel *translateModel = (TranslationModel *)[arrKnowledges objectAtIndex:indexPath.row];
    cell.titleText = translateModel.chinese;
    cell.percent   = translateModel.progressValue;
}

#pragma mark - Select TableViewCell Data
- (void)didSelectPinyinDataRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (btnAudio.hidden) btnAudio.hidden = NO;
    
    NSInteger row = [indexPath row];
    
    PinyinModel *pinyinModel = (PinyinModel *)[arrKnowledges objectAtIndex:row];
    
    NSLog(@"拼音数据: %@, 声音文件: %@", pinyinModel.audio, pinyinModel.audio);
    strAudio = pinyinModel.audio;
    
    [self stopAudio];
    [self initAudioPlayerWithSource:strAudio];
    [self playAudio];
    
    //NSLog(@"pinyin: %@; chinese: %@", pinyinModel.pinyin, pinyinModel.chinese);
    
    NSArray *arrPinyinS = [pinyinModel.pinyin componentsSeparatedByString:@"|"];
    
    BOOL isExistChinese = [pinyinModel.chinese isEqualToString:@""] ? NO : YES;
    
    BOOL isPinyinCountMoreThanOne = [arrPinyinS count] > 1 ? YES : NO;
    
    if (isPinyinCountMoreThanOne)
    {
        [self decodeDataWithPinyinModel:pinyinModel];
    }
    else
    {
        [arrShowData removeAllObjects];
        
        pinyin  = isExistChinese ? [arrPinyinS componentsJoinedByString:@""] : @"";
        chinese = (!isExistChinese) ? pinyinModel.pinyin : pinyinModel.chinese;
    }
    english = pinyinModel.english;
    
    //CGRect drawRect = CGRectUnion(kPinyinRect, kChineseRect);
    //drawRect = CGRectUnion(drawRect, kEnglishRect);
    
    //[self setNeedsDisplayInRect:kPinyinRect];
    //[self setNeedsDisplayInRect:kChineseRect];
    //[self setNeedsDisplayInRect:kEnglishRect];
    [self setNeedsDisplay];
}

- (void)didSelectWordDataRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (btnAudio.hidden) btnAudio.hidden = NO;
    
    NSInteger row = [indexPath row];
    
    WordModel *wordModel = (WordModel *)[arrKnowledges objectAtIndex:row];
    
    strAudio = wordModel.audio;
    [self stopAudio];
    [self initAudioPlayerWithSource:strAudio];
    [self playAudio];
    
    pinyin = wordModel.pinyin;
    english = wordModel.english;
    chinese = wordModel.rightWord;
    
    [self setNeedsDisplayInRect:kPinyinRect];
    [self setNeedsDisplayInRect:kChineseRect];
    [self setNeedsDisplayInRect:kEnglishRect];
}

- (void)didSelectSenPatternDataRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    SentencePatternModel *senPatternModel = (SentencePatternModel *)[arrKnowledges objectAtIndex:row];
    
    english = senPatternModel.english;
    chinese = senPatternModel.sentencePattern;
    
    [self setNeedsDisplayInRect:kChineseRect];
    [self setNeedsDisplayInRect:kEnglishRect];
}

- (void)didSelectTranslateDataRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (btnAudio.hidden) btnAudio.hidden = NO;
    
    NSInteger row = [indexPath row];
    TranslationModel *translateModel = (TranslationModel *)[arrKnowledges objectAtIndex:row];
    
    strAudio = translateModel.audio;
    [self stopAudio];
    [self initAudioPlayerWithSource:strAudio];
    [self playAudio];
    /*
    pinyin = translateModel.pinyin;
    english = translateModel.english;
    chinese = translateModel.chinese;
    */
    NSArray *arrPinyinS = [translateModel.pinyin componentsSeparatedByString:@"|"];
    
    BOOL isExistChinese = [translateModel.chinese isEqualToString:@""] ? NO : YES;
    
    BOOL isPinyinCountMoreThanOne = [arrPinyinS count] > 1 ? YES : NO;
    
    if (isPinyinCountMoreThanOne)
    {
        [self decodeDataWithTranslationModel:translateModel];
    }
    else
    {
        [arrShowData removeAllObjects];
        
        pinyin  = isExistChinese ? [arrPinyinS componentsJoinedByString:@""] : @"";
        chinese = (!isExistChinese) ? translateModel.pinyin : translateModel.chinese;
    }
    english = translateModel.english;
    //[self setNeedsDisplayInRect:kPinyinRect];
    //[self setNeedsDisplayInRect:kChineseRect];
    //[self setNeedsDisplayInRect:kEnglishRect];
    [self setNeedsDisplay];
}

#pragma mark - Custom TableViewCell
- (UITableViewCell *)cellForProgressWithTableView:(UITableView *)tableView IndexPath:(NSIndexPath *)indexPath
{
    static NSString *ProgressCell  = @"ProgressCellIdentifier";
    HSLearnProgressCustomTableCell *cell = [tableView dequeueReusableCellWithIdentifier:ProgressCell];
    if (nil == cell)
    {
        cell = [[HSLearnProgressCustomTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ProgressCell];
        cell.selectionStyle  = UITableViewCellSelectionStyleGray;
        cell.backgroundColor = [UIColor clearColor];
    }
    
    NSInteger typeID = [GlobalDataHelper sharedManager].curTypeID;
    switch (typeID)
    {
        case 1:
        {
            [self loadPinyinDataWithCell:cell IndexPath:indexPath];
            break;
        }
        case 2:
        {
            [self loadWordDataWithCell:cell IndexPath:indexPath];
            break;
        }
        case 3:
        {
            [self loadSenPatternDataWithCell:cell IndexPath:indexPath];
            break;
        }
        case 4:
        {
            [self loadTranslationDataWithCell:cell IndexPath:indexPath];
            break;
        }
            
        default:
            break;
    }
    
    return cell;
}

#pragma mark - UITableView Dadasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrKnowledges count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self cellForProgressWithTableView:tableView IndexPath:indexPath];
    return cell;
}

#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self stopTimer];
    [self selectIndexPath:indexPath];
}

- (void)selectIndexPath:(NSIndexPath *)indexPath
{
    NSInteger typeID = [GlobalDataHelper sharedManager].curTypeID;
    switch (typeID)
    {
        case 1:
        {
            [self didSelectPinyinDataRowAtIndexPath:indexPath];
            break;
        }
        case 2:
        {
            [self didSelectWordDataRowAtIndexPath:indexPath];
            break;
        }
        case 3:
        {
            //[self didSelectSenPatternDataRowAtIndexPath:indexPath];
            break;
        }
        case 4:
        {
            [self didSelectTranslateDataRowAtIndexPath:indexPath];
            break;
        }
            
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return tableView.sectionHeaderHeight*3.0f;
}

#pragma mark - DecodeData Manager
- (void)decodeDataWithPinyinModel:(PinyinModel *)pinyinModel
{
    CGFloat pinyinAreaWidth   = kPinyinRect.size.width;
    CGFloat pinyinAreaHeight  = kPinyinRect.size.height;
    
    CGFloat chineseAreaWidth  = kChineseRect.size.width;
    CGFloat chineseAreaHeight = kChineseRect.size.height;
    
    CGFloat pinyinOriginX  = kPinyinRect.origin.x;
    CGFloat pinyinOriginY  = kPinyinRect.origin.y;
    
    //CGFloat chineseOriginX = kChineseRect.origin.x;
    CGFloat chineseOriginY = kChineseRect.origin.y;
    // 取出中文
    NSString *strTempChinese = [pinyinModel.chinese stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    // 分割拼音
    NSArray *arrTempPinyin   = [[pinyinModel.pinyin stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] componentsSeparatedByString:@"|"];
    NSMutableArray *arrTempChinese  = [[NSMutableArray alloc] init];
    
    size_t length = [strTempChinese length];
    for (size_t i = 0; i < length; i++)
    {
        //UniChar c = [strTempChinese characterAtIndex:i];
        NSString *strC = [strTempChinese substringWithRange:NSMakeRange(i, 1)];
        [arrTempChinese addObject:strC];
    }
    
    // 计算出一个例词中拼音的个数,相当于同时计算出例词中字的个数.
    NSInteger pinYinCount  = [arrTempPinyin count];
    // 计算出一个拼音所占的宽度
    //CGFloat onePinyinWidth = pinyinAreaWidth/pinYinCount-2;
    
    // 拼音之间的总的间隔
    CGFloat totalSpace = (pinYinCount - 1) * 12.0f;
    // 除去空格之后拼音总的占据的宽度
    CGFloat pinyinShowWidth = pinyinAreaWidth - totalSpace;
    // 计算出所有拼音拼接在一起之后在这有限的宽度内能显示的最大的字体值。
    CGFloat actFontSize;
    NSString *totalPinyin = [arrTempPinyin componentsJoinedByString:@""];
    [totalPinyin sizeWithFont:[UIFont fontWithName:kFontName size:kReportChineseFontSize*0.7f] minFontSize:6.0f actualFontSize:&actFontSize forWidth:pinyinShowWidth lineBreakMode:NSLineBreakByCharWrapping];
    actPinyinFontSize = actFontSize;
    //NSLog(@"size: %f", actFontSize);
    
    NSInteger chineseCount = [arrTempChinese count];
    
    CGFloat oneChineseWidth = chineseAreaWidth/chineseCount;
    
    [arrShowData removeAllObjects];
    
    // 以前已经保存的拼音加起来的宽度总和。
    NSInteger oldPinyinWidth = 0;
    
    NSMutableArray *arrPinyinFrames = [[NSMutableArray alloc] init];
    NSMutableArray *arrChineseFrames = [[NSMutableArray alloc] init];
    
    // 计算出每一个拼音的位置以及对应的字的位置
    for (int j = 0; j < pinYinCount; j++)
    {
        NSString *strTempPinyin = [arrTempPinyin objectAtIndex:j];
        CGFloat onePinyinWidth = [strTempPinyin sizeWithFont:[UIFont fontWithName:kFontName size:actFontSize]].width;
        
        CGRect pinyinRect  = CGRectMake(pinyinOriginX + oldPinyinWidth, pinyinOriginY, onePinyinWidth, pinyinAreaHeight);
        NSValue *pinyinValue = [NSValue valueWithCGRect:pinyinRect];
        [arrPinyinFrames addObject:pinyinValue];
        
        CGFloat pcX = CGRectGetMidX(pinyinRect);
        NSString *strTempChinese = [arrTempChinese objectAtIndex:j];
        CGFloat tcpX = pcX - oneChineseWidth*0.5f;
        CGRect chineseRect = CGRectMake(tcpX, chineseOriginY , oneChineseWidth, chineseAreaHeight);
        NSValue *chineseValue = [NSValue valueWithCGRect:chineseRect];
        [arrChineseFrames addObject:chineseValue];
        
        NSDictionary *dicAChar = [NSDictionary dictionaryWithObjectsAndKeys:pinyinValue, strTempPinyin, chineseValue, strTempChinese, nil];
        [arrShowData addObject:dicAChar];
        oldPinyinWidth += onePinyinWidth+12;
    }
    curPinyinShowWidth = oldPinyinWidth;
}

- (void)decodeDataWithTranslationModel:(TranslationModel *)translateModel
{
    CGFloat pinyinAreaWidth   = kPinyinRect.size.width;
    CGFloat pinyinAreaHeight  = kPinyinRect.size.height;
    
    CGFloat chineseAreaWidth  = kChineseRect.size.width;
    CGFloat chineseAreaHeight = kChineseRect.size.height;
    
    CGFloat pinyinOriginX  = kPinyinRect.origin.x;
    CGFloat pinyinOriginY  = kPinyinRect.origin.y;
    
    //CGFloat chineseOriginX = kChineseRect.origin.x;
    CGFloat chineseOriginY = kChineseRect.origin.y;
    // 取出中文
    NSString *strTempChinese = [translateModel.chinese stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    // 分割拼音
    NSArray *arrTempPinyin   = [[translateModel.pinyin stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] componentsSeparatedByString:@"|"];
    NSMutableArray *arrTempChinese  = [[NSMutableArray alloc] init];
    
    size_t length = [strTempChinese length];
    for (size_t i = 0; i < length; i++)
    {
        //UniChar c = [strTempChinese characterAtIndex:i];
        NSString *strC = [strTempChinese substringWithRange:NSMakeRange(i, 1)];
        [arrTempChinese addObject:strC];
    }
    
    // 计算出一个例词中拼音的个数,相当于同时计算出例词中字的个数.
    NSInteger pinYinCount  = [arrTempPinyin count];
    // 计算出一个拼音所占的宽度
    //CGFloat onePinyinWidth = pinyinAreaWidth/pinYinCount-2;
    
    // 拼音之间的总的间隔
    CGFloat totalSpace = (pinYinCount - 1) * 12.0f;
    // 除去空格之后拼音总的占据的宽度
    CGFloat pinyinShowWidth = pinyinAreaWidth - totalSpace;
    // 计算出所有拼音拼接在一起之后在这有限的宽度内能显示的最大的字体值。
    CGFloat actFontSize;
    NSString *totalPinyin = [arrTempPinyin componentsJoinedByString:@""];
    [totalPinyin sizeWithFont:[UIFont fontWithName:kFontName size:kReportChineseFontSize*0.7f] minFontSize:6.0f actualFontSize:&actFontSize forWidth:pinyinShowWidth lineBreakMode:NSLineBreakByCharWrapping];
    actPinyinFontSize = actFontSize;
    //NSLog(@"size: %f", actFontSize);
    
    NSInteger chineseCount = [arrTempChinese count];
    
    CGFloat oneChineseWidth = chineseAreaWidth/chineseCount;
    
    [arrShowData removeAllObjects];
    
    // 以前已经保存的拼音加起来的宽度总和。
    NSInteger oldPinyinWidth = 0;
    
    NSMutableArray *arrPinyinFrames = [[NSMutableArray alloc] init];
    NSMutableArray *arrChineseFrames = [[NSMutableArray alloc] init];
    
    // 计算出每一个拼音的位置以及对应的字的位置
    for (int j = 0; j < pinYinCount; j++)
    {
        NSString *strTempPinyin = [arrTempPinyin objectAtIndex:j];
        CGFloat onePinyinWidth = [strTempPinyin sizeWithFont:[UIFont fontWithName:kFontName size:actFontSize]].width;
        
        CGRect pinyinRect  = CGRectMake(pinyinOriginX + oldPinyinWidth, pinyinOriginY, onePinyinWidth, pinyinAreaHeight);
        NSValue *pinyinValue = [NSValue valueWithCGRect:pinyinRect];
        [arrPinyinFrames addObject:pinyinValue];
        
        CGFloat pcX = CGRectGetMidX(pinyinRect);
        NSString *strTempChinese = [arrTempChinese objectAtIndex:j];
        CGFloat tcpX = pcX - oneChineseWidth*0.5f;
        CGRect chineseRect = CGRectMake(tcpX, chineseOriginY , oneChineseWidth, chineseAreaHeight);
        NSValue *chineseValue = [NSValue valueWithCGRect:chineseRect];
        [arrChineseFrames addObject:chineseValue];
        
        NSDictionary *dicAChar = [NSDictionary dictionaryWithObjectsAndKeys:pinyinValue, strTempPinyin, chineseValue, strTempChinese, nil];
        [arrShowData addObject:dicAChar];
        oldPinyinWidth += onePinyinWidth+12;
    }
    curPinyinShowWidth = oldPinyinWidth;
}

#pragma mark - Memory Manager
- (void)dealloc
{
    curUserID = nil;
    pinyin = nil;
    chinese = nil;
    english = nil;
    strAudio = nil;
    
    [tbvProgress removeFromSuperview];
    tbvProgress = nil;

    /*
    [circleProView removeFromSuperview];
    circleProView = nil;
    */
    /*
    [lblUserName removeFromSuperview];
    lblUserName = nil;
     */
    
    [btnAudio removeFromSuperview];
    btnAudio = nil;
    
    [btnQuit removeFromSuperview];
    btnQuit = nil;
    
    [btnShare removeFromSuperview];
    btnShare = nil;
    
    [lblUserName removeFromSuperview];
    lblUserName = nil;
    
    [lblHighScore removeFromSuperview];
    lblHighScore = nil;
    
    [lblCurScore removeFromSuperview];
    lblCurScore = nil;
    
    [self stopAudio];
    
    [arrKnowledges removeAllObjects];
    arrKnowledges = nil;
    
    [arrShowData removeAllObjects];
    arrShowData = nil;
    
    imgBackground = nil;
    imgCircleBkg  = nil;
    
    imgClose = nil;
    imgAudio = nil;
    imgShare = nil;
    imgBtnShare = nil;
    
    self.delegate = nil;
}

@end
