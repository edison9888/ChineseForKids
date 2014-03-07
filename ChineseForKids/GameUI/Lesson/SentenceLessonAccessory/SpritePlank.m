//
//  SpritePlank.m
//  ChineseForKids
//
//  Created by 唐 希 on 13-8-27.
//  Copyright (c) 2013年 Allen. All rights reserved.
//

#import "SpritePlank.h"

#define valueFontSize 40
#define valueFontName @"Helvetica-Bold"

@implementation SpritePlank
@synthesize spPlankbg;
@synthesize lblValue;
@synthesize value;

-(id)initWithValue:(NSString *)paramValue{
    
    self.value = paramValue;
    int strLength = [paramValue length];
    NSInteger index = 1;
    if(strLength <= 1){
        index = 1;
    }else if (strLength <= 2){
        index = 2;
    }else if (strLength <= 3){
        index = 3;
    }else{
        index = 4;
    }
    
    spPlankbg = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"sub_plank%d.png", index]];
    
    CGFloat width  = spPlankbg.contentSize.width;
    CGSize size = [value sizeWithFont:[UIFont fontWithName:valueFontName size:valueFontSize]];
    CGFloat scaleFactor = size.width > width ? size.width/width : 1;
    [spPlankbg setScaleX:scaleFactor];
    
    lblValue = [CCLabelTTF labelWithString:value fontName:valueFontName fontSize:valueFontSize];
   
    int colorRandNum = arc4random()%9;
    switch (colorRandNum) {
        case 0:
            lblValue.color=ccc3(109, 4, 97);  
            break;
        case 1:
            lblValue.color=ccc3(70, 4, 110);
            break;
        case 2:
            lblValue.color=ccc3(17,4, 110);
            break;
        case 3:
            lblValue.color=ccc3(4, 45, 110);
            break;
        case 4:
            lblValue.color=ccc3(4, 98, 110);
            break;
        case 5:
            lblValue.color=ccc3(101, 71, 7);
            break;
        case 6:
            lblValue.color=ccc3(94, 112, 0);
            break;
        case 7:
            lblValue.color=ccc3(46, 109, 4);
            break;
        case 8:
            lblValue.color=ccc3(4, 112, 13);
            break;
        case 9:
            lblValue.color=ccc3(4, 111, 67);
            break;
        default:
            break;
    }
    
    
    return self;
}


-(void)dragPlank:(CGPoint)newPos
{
    CGSize winSize=[CCDirector sharedDirector].winSize;
    CGPoint retval = newPos;
    retval.x = spPlankbg.position.x+newPos.x;
    retval.y = spPlankbg.position.y+newPos.y;
    if(retval.x-spPlankbg.contentSize.width/2<0) retval.x=spPlankbg.contentSize.width/2;
    if(retval.x+spPlankbg.contentSize.width/2>winSize.width) retval.x=winSize.width-spPlankbg.contentSize.width/2;
    
    if(retval.y-spPlankbg.contentSize.height/2<0) retval.y=spPlankbg.contentSize.height/2;
    if(retval.y+spPlankbg.contentSize.height/2>winSize.height) retval.y=winSize.height-spPlankbg.contentSize.height/2;
    
    spPlankbg.position = retval;
    lblValue.position = spPlankbg.position;
    
}
-(void)destroy{
    [spPlankbg removeFromParentAndCleanup:YES];
    [lblValue removeFromParentAndCleanup:YES];
    
}

- (void)dealloc
{
    [spPlankbg removeFromParentAndCleanup:YES];
    spPlankbg = nil;
    
    [lblValue removeFromParentAndCleanup:YES];
    lblValue = nil;
}

@end
