//
//  SpritePlank.h
//  ChineseForKids
//
//  Created by 唐 希 on 13-8-27.
//  Copyright (c) 2013年 Allen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface SpritePlank : NSObject{
    CCSprite *_spPlankbg;
    CCLabelTTF *_lblValue;
    
    NSString *_value;
    
}

@property(atomic, retain) CCSprite *spPlankbg;
@property(atomic, retain) CCLabelTTF *lblValue;
@property(atomic, copy) NSString* value;

-(id)initWithValue:(NSString*) paramValue;
-(void)dragPlank:(CGPoint)newPos;
-(void)destroy;
@end
