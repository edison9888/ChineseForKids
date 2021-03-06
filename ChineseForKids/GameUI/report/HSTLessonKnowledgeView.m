//
//  HSTLessonKnowledgeView.m
//  ChineseForKids
//
//  Created by yang on 14-3-5.
//  Copyright (c) 2014年 yang. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "HSTLessonKnowledgeView.h"
#import "HSTKnowledgeCustomHeaderView.h"
#import "GlobalDataHelper.h"
#import "GameManager.h"
#import "SentencePatternModel.h"
#import "SentenceModel.h"
#import "Constants.h"
#import "FileHelper.h"

@implementation HSTLessonKnowledgeView
{
    NSMutableDictionary *dicKnowledges;
    NSMutableArray *arrKnowledges;
    NSMutableArray *arrSenPattern;
    
    UIImage *imgBackground;
    UIImage *imgTableBkg;
    UIImage *imgCircleBkg;
    UIImage *imgClose;
    
    NSString *curUserID;
    NSInteger curUnitID;
    NSInteger curHumanID;
    NSInteger curGroupID;
    NSInteger curBookID;
    NSInteger curTypeID;
    NSInteger curLessonID;
    
    NSString *strAudio;
    
    UIButton *btnQuit;
    UIButton *btnShare;
    UIButton *btnAudio;
    
    NSTimer *timer;
    
    AVAudioPlayer *player;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        dicKnowledges = [[NSMutableDictionary alloc] init];
        arrKnowledges = [[NSMutableArray alloc] init];
        arrSenPattern = [[NSMutableArray alloc] init];
        
        imgBackground = [UIImage imageNamed:@"knowledgebkg.png"];
        imgTableBkg = [UIImage imageNamed:@"knowledgeTablebkg.png"];
        imgCircleBkg = [UIImage imageNamed:@"learnRedCircleProgress.png"];
        
        imgClose = [UIImage imageNamed:@"btnClose.png"];
        
        curUserID   = [GlobalDataHelper sharedManager].curUserID;
        curHumanID  = [GlobalDataHelper sharedManager].curHumanID;
        curGroupID  = [GlobalDataHelper sharedManager].curGroupID;
        curBookID   = [GlobalDataHelper sharedManager].curBookID;
        curTypeID   = [GlobalDataHelper sharedManager].curTypeID;
        curLessonID = [GlobalDataHelper sharedManager].curLessonID;
        
        [self loadKnowledgeDataWithUserID:curUserID humanID:curHumanID groupID:curGroupID bookID:curBookID typeID:curTypeID lessonID:curLessonID];
        
        [self initInterface];
    }
    return self;
}

+ (void)addShadowToView:(UIView *)view
{
    [[view layer] setShadowOffset:CGSizeMake(-2, 2)];
    [[view layer] setShadowColor:[[UIColor blackColor] CGColor]];
    [[view layer] setShadowRadius:1.0f];
    [[view layer] setShadowOpacity:0.2f];
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
    tbvProgress.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tbvProgress.separatorColor = [UIColor colorWithWhite:0.0f alpha:0.3f];
    [self addSubview:tbvProgress];
    
    // 退出
    btnQuit = [UIButton buttonWithType:UIButtonTypeCustom];
    //[btnQuit setTitle:@"quit" forState:UIControlStateNormal];
    [btnQuit setImage:imgClose forState:UIControlStateNormal];
    [btnQuit addTarget:self action:@selector(quitAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnQuit];
}

- (void)loadKnowledgeDataWithUserID:(NSString *)userID humanID:(NSInteger)humanID groupID:(NSInteger)groupID bookID:(NSInteger)bookID typeID:(NSInteger)typeID lessonID:(NSInteger)lessonID
{
    NSArray *arrData = [[GameManager sharedManager] loadDataWithUserID:userID humanID:humanID groupID:groupID bookID:bookID typeID:typeID lessonID:lessonID];
    [arrSenPattern setArray:arrData];
    
    [arrKnowledges removeAllObjects];
    for (int i = 0; i < [arrData count]; i++)
    {
        SentencePatternModel *senPatternModel = (SentencePatternModel *)[arrData objectAtIndex:i];
        
        NSArray *arrSen = [[GameManager sharedManager] loadSentenceDataWithUserID:userID humanID:humanID groupID:groupID bookID:bookID typeID:typeID lessonID:lessonID senPatternID:senPatternModel.knowledgeIDValue];
        NSString *senPatternID = [[NSString alloc] initWithFormat:@"%d", senPatternModel.knowledgeIDValue];
        
        [dicKnowledges setObject:arrSen forKey:senPatternID];
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
    if (self.delegate && [self.delegate respondsToSelector:@selector(lessonKnowledgeView:quit:)])
    {
        [self.delegate lessonKnowledgeView:self quit:YES];
    }
}

#pragma mark - Audio Player Manager

- (void)initAudioPlayerWithSource:(NSString *)source
{
    //NSString *path = [[NSBundle mainBundle] pathForResource:source ofType:nil];
    NSString *lessonAudio = [NSString stringWithFormat:@"%d", curLessonID];
    NSString *path = [[kDownloadedPath stringByAppendingPathComponent:lessonAudio] stringByAppendingPathComponent:source];
    if (path)
    {
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path isDirectory:NO] error:nil];
        [player prepareToPlay];
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

#pragma mark - Subviews Manager
- (void)layoutSubviews
{
    if (tbvProgress)
    {
        tbvProgress.frame  = (curTypeID == 3) ? CGRectMake(self.bounds.size.width*0.125f, self.bounds.size.height*0.308f, self.bounds.size.width*0.754f, self.bounds.size.height*0.41f) : CGRectMake(self.bounds.size.width*0.125f, self.bounds.size.height*0.308f, self.bounds.size.width*0.404f, self.bounds.size.height*0.41f);
    }
    
    if (btnQuit)
    {
        btnQuit.frame = CGRectMake(self.bounds.size.width*0.89f, self.bounds.size.height*0.12f, imgClose.size.width, imgClose.size.height);
    }
}

- (void)drawRect:(CGRect)rect
{
	[imgBackground drawInRect:self.bounds];
    [imgTableBkg drawInRect:tbvProgress.frame];
    
}


#pragma mark - UITableView Dadasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [arrSenPattern count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    SentencePatternModel *senPatternModel = (SentencePatternModel *)[arrSenPattern objectAtIndex:section];
    NSString *strTSenPID = [[NSString alloc] initWithFormat:@"%d", senPatternModel.knowledgeIDValue];
    NSArray *arrTKnowledges = [dicKnowledges objectForKey:strTSenPID];
    return [arrTKnowledges count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ProgressCell  = @"ProgressCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ProgressCell];
    if (nil == cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ProgressCell];
        
        cell.selectionStyle  = UITableViewCellSelectionStyleGray;
        cell.backgroundColor = [UIColor clearColor];
        cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cellHighBkg.png"]];
        
        UIImage *imgAudio = [UIImage imageNamed:@"audio.png"];
        UIImageView *imgvAudio = [[UIImageView alloc] initWithImage:imgAudio];
        imgvAudio.backgroundColor = [UIColor clearColor];
        cell.accessoryView = imgvAudio;
    }
    
    NSInteger row = [indexPath row];
    NSInteger section = [indexPath section];
    
    SentencePatternModel *senPatternModel = (SentencePatternModel *)[arrSenPattern objectAtIndex:section];
    NSString *strTSenPID = [[NSString alloc] initWithFormat:@"%d", senPatternModel.knowledgeIDValue];
    NSArray *arrTKnowledges = [dicKnowledges objectForKey:strTSenPID];
    
    SentenceModel *senModel = (SentenceModel *)[arrTKnowledges objectAtIndex:row];
    cell.textLabel.text = senModel.sentence;
    
    return cell;
}

#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    NSInteger section = [indexPath section];
    
    SentencePatternModel *senPatternModel = (SentencePatternModel *)[arrSenPattern objectAtIndex:section];
    NSString *strTSenPID = [[NSString alloc] initWithFormat:@"%d", senPatternModel.knowledgeIDValue];
    NSArray *arrTKnowledges = [dicKnowledges objectForKey:strTSenPID];
    
    SentenceModel *senModel = (SentenceModel *)[arrTKnowledges objectAtIndex:row];
    
    strAudio = senModel.audio;
    [self stopAudio];
    [self initAudioPlayerWithSource:strAudio];
    [self playAudio];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return tableView.sectionHeaderHeight*3.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    SentencePatternModel *senPatternModel = (SentencePatternModel *)[arrSenPattern objectAtIndex:section];
    HSTKnowledgeCustomHeaderView *tKnowledgeView = [[HSTKnowledgeCustomHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, tableView.bounds.size.width, tableView.sectionHeaderHeight)];
    tKnowledgeView.titleText = senPatternModel.sentencePattern;
    tKnowledgeView.percent   = senPatternModel.progressValue;
    
    return tKnowledgeView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return tableView.rowHeight*1.5f;
}

#pragma mark - Memory Manager
- (void)dealloc
{
    curUserID = nil;
    strAudio = nil;
    
    [tbvProgress removeFromSuperview];
    tbvProgress = nil;
    
    [btnAudio removeFromSuperview];
    btnAudio = nil;
    
    [btnQuit removeFromSuperview];
    btnQuit = nil;
    
    [btnShare removeFromSuperview];
    btnShare = nil;
    
    [self stopAudio];
    
    [arrKnowledges removeAllObjects];
    arrKnowledges = nil;
    
    [arrSenPattern removeAllObjects];
    arrSenPattern = nil;
    
    imgBackground = nil;
    imgCircleBkg  = nil;
    
    imgClose = nil;
    
    self.delegate = nil;
}

@end
