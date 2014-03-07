//
//  SpriteCard.m
//  ChineseForKids
//
//  Created by 唐 希 on 13-8-16.
//  Copyright 2013年 Allen. All rights reserved.
//

#import "SpriteCard.h"
#import "TranslationModel.h"
#import "HSFontHandleManager.h"

@implementation SpriteCard
@synthesize value;
@synthesize cardBack;
@synthesize cardOpen;
@synthesize canFlip;
@synthesize audio;

- (id)initWithCard:(TranslationModel *)transModel Content:(NSString *)content
{
    if (self = [super init])
    {
        _transModel = transModel;
        value = transModel.chinese;
        audio = transModel.audio;
        cardBack = [CCSprite spriteWithSpriteFrameName:@"cardBack.png"];
        cardBack.scale = 0.1f;
        cardOpen = [CCSprite spriteWithSpriteFrameName:@"cardFront.png"];
        
        CGSize dimens = CGSizeMake(cardOpen.boundingBox.size.width*0.8f, cardOpen.boundingBox.size.height);
        // 计算所需的字体大小。
        NSInteger fontSize = [HSFontHandleManager resizableFontSizeWithFont:[UIFont fontWithName:@"Helvetica-Bold" size:66] content:content width:dimens.width minFontSize:2.0f lineBreakMode:NSLineBreakByCharWrapping];
        
        // 需要显示的内容
        lblContent = [CCLabelTTF labelWithString:content fontName:@"Helvetica-Bold" fontSize:fontSize dimensions:dimens hAlignment:kCCTextAlignmentCenter vAlignment:kCCVerticalTextAlignmentCenter lineBreakMode:kCCLineBreakModeWordWrap];
        lblContent.position = ccp(cardOpen.boundingBox.size.width*0.5f, cardOpen.boundingBox.size.height*0.5f);
        lblContent.color = ccc3(0.0f, 0.0f, 0.0f);
        [cardOpen addChild:lblContent];
        
        canFlip = NO;
    }
    return self;
}

- (void)moveToGame:(int)duration scale:(float)scale position:(CGPoint)position
{
    cardOpen.position = position;
    cardOpen.scale = scale;
    cardOpen.scaleX = -scale;
    cardOpen.visible = NO;
    _cardScale = scale;
    
    id callback1 = [CCCallBlock actionWithBlock:^{
        [self flipCardAnimation:NO canFlip:NO];
    }];
    
    id callback2 = [CCCallBlock actionWithBlock:^{
        [self flipCardAnimation:YES canFlip:YES];
    }];
    
    [cardBack runAction:[CCSequence actions:[CCMoveTo actionWithDuration:duration position:position],callback1,[CCDelayTime actionWithDuration:2], callback2, nil]];
    [cardBack runAction:[CCScaleTo actionWithDuration:duration scale:scale]];
}

-(void)flipCardAnimation:(BOOL)visible canFlip:(BOOL)paramCanFlip
{
    canFlip=NO;
    id cardBackAction1=[CCScaleTo actionWithDuration:0.075 scaleX:-_cardScale/2 scaleY:_cardScale];
    id cardBackAction2=[CCScaleTo actionWithDuration:0.075 scaleX:-_cardScale scaleY:_cardScale];
    id cardOpenAction=[CCScaleTo actionWithDuration:0.15 scaleX:_cardScale scaleY:_cardScale];
    id scaleCall = [CCCallBlock actionWithBlock:^{
        BOOL tempVisible=cardBack.visible;
        cardBack.visible=cardOpen.visible;
        cardOpen.visible=tempVisible;
    }];
    id callbackEnd=[CCCallBlock actionWithBlock:^{
        if(paramCanFlip)
        canFlip=YES;
    }];
    if(visible){
        
        [cardOpen runAction:[CCSequence actions:cardBackAction1,scaleCall,cardBackAction2,callbackEnd, nil]];
        cardBack.scaleX=-_cardScale;
        [cardBack runAction:cardOpenAction];
    }else{
        
        [cardBack runAction:[CCSequence actions:cardBackAction1,scaleCall,cardBackAction2,callbackEnd, nil]];
        cardOpen.scaleX=-_cardScale;
        [cardOpen runAction:cardOpenAction];
    }
}

-(void)destroy
{
    [cardBack removeFromParentAndCleanup:YES];
    cardBack = nil;
    [cardOpen removeFromParentAndCleanup:YES];
    cardOpen = nil;
}

- (void)hideContent
{
    lblContent.string = @"";
    [lblContent removeFromParentAndCleanup:YES];
    lblContent = nil;
}

- (void)dealloc
{
    _transModel = nil;
}

@end
