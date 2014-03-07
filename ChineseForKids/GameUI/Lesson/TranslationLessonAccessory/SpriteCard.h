//
//  SpriteCard.h
//  ChineseForKids
//
//  Created by 唐 希 on 13-8-16.
//  Copyright 2013年 Allen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class TranslationModel;

@interface SpriteCard : NSObject {
    CCSprite *cardBack;
    CCSprite *cardOpen;
    
    CCLabelTTF *lblContent;
    
    float _cardScale;
    NSString *value;
    BOOL _canFlip;
    
    NSString *_audio;
    
}
@property (readonly) NSString *value;
@property (atomic, retain) CCSprite*   cardBack;
@property (atomic, retain) CCSprite*   cardOpen;
@property (nonatomic)BOOL canFlip;
@property (nonatomic, copy) NSString *audio;
@property (nonatomic, unsafe_unretained, readonly)TranslationModel *transModel;

- (id)initWithCard:(TranslationModel *)transModel Content:(NSString *)content;
- (void)moveToGame:(int)duration scale:(float)scale position:(CGPoint)position;
- (void)destroy;
- (void)flipCardAnimation:(BOOL)visible canFlip:(BOOL)paramCanFlip;

- (void)hideContent;

@end
