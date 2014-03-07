//
//  PauseLayer.h
//  ChineseForKids
//
//  Created by 唐 希 on 13-8-19.
//  Copyright 2013年 Allen. All rights reserved.
//

#import "CCLayer.h"

@protocol PauseLayerProtocol;

@interface PauseLayer : CCLayerColor

@property(nonatomic, unsafe_unretained)id<PauseLayerProtocol> delegate;

@end

@protocol PauseLayerProtocol <NSObject>

@required
- (void)didRecieveResumeEvent:(PauseLayer *)layer;
- (void)didRecieveRestartEvent:(PauseLayer *)layer;
- (void)didRecieveQuitEvent:(PauseLayer *)layer;

@end

