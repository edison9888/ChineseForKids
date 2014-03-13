//
//  Constants.h
//  PinyinGame
//
//  Created by yang on 13-10-29.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#ifndef PinyinGame_Constants_h
#define PinyinGame_Constants_h

#import "HSFileManager.h"

//#define kHostUrl @"http://192.168.10.89/hellohsk/js/app/fileaddress/"
//#define kHostUrl @"http://www.hschinese.com/app/api/"
#define kHostUrl @"http://192.168.10.180/journeywest/app/api/"

//#define kDownloadingPath [[[FileHelper sharedInstance] getDocumentPath] stringByAppendingPathComponent:@"Downloading"]
//#define kDownloadedPath [[[FileHelper sharedInstance] getDocumentPath] stringByAppendingPathComponent:@"Downloaded"]
#define kDownloadingPath [[HSFileManager cachePath] stringByAppendingPathComponent:@"Downloading"]
#define kDownloadedPath [[HSFileManager cachePath] stringByAppendingPathComponent:@"Downloaded"]

#define kLoginMethod  @"user/login"
#define kRegistMethod @"user/regist"
#define kChangePwd    @"user/password"
#define kGetPWdBack   @"user/passwordBack"
// 教材种类及图片
#define kGroupInfo                    @"teachMaterial"
// 书本种类及图片
#define kBookInfo                     @"book"
// 获取某类型游戏下的所有课程数据
#define kGetLessons                   @"lessons"
// 获取声调游戏下指定课程的所有数据
#define kGetToneLessonDetailInfo      @"toneLesson"
// 获取擦图猜字游戏下指定课程的所有数据
#define kGetRubImageLessonDetailInfo  @"rubImageLesson"
// 获取连词成句游戏下指定课程的所有数据
#define kGetOrderWordLessonDetailInfo @"orderWordLesson"
// 获取中英互译游戏下指定课程的所有数据
#define kGetTransLessonDetailInfo     @"translationLesson"
// 提交指定课程的数据
#define kUpdateLessonDetailInfo       @"updateLesson"
// 课程数据更新心跳包
#define kLessonUpdateData             @"downloadLessonData"


#define SN_SEND_USERLOGIN      @"8000"
#define SN_BACK_USERLOGIN      @"8001"
#define SN_SEND_CHANGEPASSWORD @"8002"
#define SN_BACK_CHANGEPASSWORD @"8003"
#define SN_SEND_REGISTER       @"8004"
#define SN_BACK_REGISTER       @"8005"
#define SN_SEND_GETPWDBACK     @"8006"
#define SN_BACK_GETPWDBACK     @"8007"
#define SN_SEND_GROUPINFO      @"8008"
#define SN_BACK_GROUPINFO      @"8009"
#define SN_SEND_BOOKINFO       @"8010"
#define SN_BACK_BOOKINFO       @"8011"
#define SN_SEND_LESSONINFO     @"8012"
#define SN_BACK_LESSONINFO     @"8013"

#define SN_SEND_TONELESSONINFO      @"8014"
#define SN_BACK_TONELESSONINFO      @"8015"
#define SN_SEND_WORDLESSONINFO      @"8016"
#define SN_BACK_WORDLESSONINFO      @"8017"
#define SN_SEND_SENTENCELESSONINFO  @"8018"
#define SN_BACK_SENTENCELESSONINFO  @"8019"
#define SN_SEND_TRANSLESSONINFO     @"8020"
#define SN_BACK_TRANSLESSONINFO     @"8021"
#define SN_SEND_UPLOADLESSONINFO    @"8022"
#define SN_BACK_UPLOADLESSONINFO    @"8023"
#define SN_SEND_DOWNLOADLESSONDATA  @"8024"
#define SN_BACK_DOWNLOADLESSONDATA  @"8025"

#pragma mark - Screen Frame and Size

#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define STATUBAR_HEIGHT 22      //(([[UIApplication sharedApplication] statusBarFrame]).size.height)
#define SHOWAREA_HEIGHT (SCREEN_HEIGHT - STATUBAR_HEIGHT)
#define NAVIGATIONBAR_HEIGHT 44.0
#define TABBAR_HEIGHT 49.0

#pragma mark - Library Frame and Size

#define kLIBRARY_BOARD_WIDTH 16.0f
#define kLIBRARY_BOARD_TITLE_HEIGHT 78.0f
#define kLIBRARY_SHELF_HEIGHT 235.0f

#define kScoreLabel_Width 160.0f
#define kScoreLabel_Height 36.0f
/**
 * 计算每个拼音出现的算法:
 *  -- 每个拼音初始概率都是100%
 *  -- 随机选出数组中的一个值(拼音模型)。
 *  -- 再产生一个1到10之间的随机数。
 *  -- 查看选出的拼音模型所携带的概率上限是否包含这个随机数。
 *  -- 如果包含, 那么就将这个拼音模型的数据显示出来。
 *  -- 如果不包含, 那么重新随机选出一个值(拼音模型), 再去判断。
 *  -- 如果该次随机选出的值与上一次随机选出的值相同, 那么再重新选。
 *  -- 在游戏中选对一个那么该拼音模型的概率上限减1。
 */

// 总共30个游戏
#define TOTAL_LEVEL 30
// 每5个为一个单元
#define LEVEL_PER_UNIT 5

// 每个拼音出现的初始概率都是100%
#define PINYIN_SHOW_PROBABILITY 10
// 每对一次要减去的概率值
#define PINYIN_GAP_PROBABILITY 1

// 每对一组拼音得10分
#define SCORE_PER_ROUND 10
// 连对5个
#define KEEP_RIGHT_NUM 5
// 连对5个之后得额外100分
#define SCORE_KEEP_RIGHT 100

//每一关的时间是60秒
#define TIME_PER_LEVEL 60

// Box2D的模拟现实世界:32个像素为1米
#define PTM_RATIO 32

// 关卡和单元
#define kLevel_Index @"LevelIndex"
#define kUnit_Index @"UnitIndex"

// 统一游戏中字体的名称: 黑体-简
#define kFontName      @"Heiti SC"
#define kFontNameChil  @"迷你简少儿"
#define kFontNameBold  @"Helvetica-Bold"
#define kFontNameArial @"Arial"
#define kPinyinFontSize 36.0f
#define kContentsChineseFontSize 70.0f
#define kReportChineseFontSize 100.0f
#define kPinyinColor ccc3(255, 100, 100)

// 拼音分词之间的分割符
#define kPinyinSeperateKey @"|"

#pragma mark - GameScene ID (游戏场景的ID)
#define kGameTypeSceneID            @"10000"
#define kPinyinNavigationSceneID    @"10001"
#define kWordNavigationSceneID      @"10002"
#define kSentenceNavigationSceneID  @"10003"
#define kTranslateNavigationSceneID @"10004"
#define kCommonNavigationSceneID    @"10005"

#pragma mark - GameLevel ID (各个游戏模块的游戏ID)

#define kPinyinGameSceneID    @"20001"
#define kWordGameSceneID      @"20002"
#define kSentenceGameSceneID  @"20003"
#define kTranslateGameSceneID @"20004"

#pragma mark - PreLoad Plist Key Name(预加载plist数据文件中各个key的名称)

#define kPreSpriteSheets @"SpriteSheets"
#define kPreImages @"Images"
#define kPreSoundFX @"SoundFX"
#define kPreMusic @"Music"
#define kPreAssets @"Assets"

#pragma mark - Tags Manager

#define kMonkeyTag      100
#define kPeachTag       101
#define kPeachToneTag   102
#define kDashBoxTag     103
#define kDashBoxToneTag 104

#define kTimerTag 105
#define kTimerProgressBkgTag 106
#define kTimerProgressRedBkgTag 107
#define kTimerProgressTag 108

#define kMainMapSkyTag 200
#define kMainMapSeaTag 201

#pragma mark - sprite z Manager（精灵的z轴管理）
// 游戏界面的精灵z轴管理
#define kPeach_z 100
#define kPeach_Tone_z 101
#define kDashBox_z 102
#define kDashBox_Tone_z 103
#define kPeach_Worm_z 104
#define kLeftMoveTreeParallaxNode_z 150
#define kRightMoveTreeParallaxNode_z 152
#define kLeftMoveFlowerParallaxNode_z 151
#define kRightMoveFlowerParallaxNode_z 153

#define kLeftTree_z 152
#define kRightrTree_z 153
#define kMonkey_z 160

#define kTempScore_z 170

#define kMainMapSea_z 10
#define kMainMapLandWave_z 11
#define kMainMapWaterWave_z 12

#pragma mark - 位置和3D旋转
#define DEGREES_TO_RADIANS(d) (d * M_PI / 180)


#define APPDELEGATE ((AppController *)[[UIApplication sharedApplication] delegate])

typedef enum{
    ClientiPhone4=1,
    ClientiPod1G=2,
    ClientiPhone4S=3,
    ClientiPad1=4,
    ClientiPhone5=5,
    ClientiPhone1G=6,
    ClientiPhone2G=7,
    ClientiPhone3GS=8,
    ClientiPod2G=9,
    ClientiPod3G=10,
    ClientiPod4G=11,
    ClientiPad2=12,
    ClientiPad3=13,
    
} ClientType;//客户端机器型号

static CGPoint midPoint(CGRect r) {
    return CGPointMake(CGRectGetMidX(r), CGRectGetMidY(r));
}

static CATransform3D CATransform3DMakePerspective(CGFloat z) {
    CATransform3D t = CATransform3DIdentity;
    t.m34 = - 1.0 / z;
    return t;
}

#endif
