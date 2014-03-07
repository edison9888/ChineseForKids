//
//  GameResultsLayer.h
//  PinyinGame
//
//  Created by yang on 13-10-30.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "CCLayer.h"
/**
 * 游戏结算界面包括两部分内容
 *  -- 星级评定
 *  -- 分数
 *
 * 在这个界面查看当前关卡的得分情况, 以判断是否要解锁下一关。
 * 同时统计当前单元的总的得分情况, 以判断是否解锁下一单元(当然要判断是否玩完了本单元的游戏)。
 *
 */

@protocol GameResultsLayerProtocol;

@interface GameResultsLayer : CCLayerColor
@property(nonatomic, unsafe_unretained)id<GameResultsLayerProtocol> delegate;


@end

@protocol GameResultsLayerProtocol <NSObject>

@required
- (void)didRecieveQuitEvent:(GameResultsLayer *)layer;
- (void)didRecieveRestartEvent:(GameResultsLayer *)layer;
- (void)didRecieveEnterNextLessonEvent:(GameResultsLayer *)layer;
- (void)didRecieveShowKnowledgeProgressEvent:(GameResultsLayer *)layer;

@end
