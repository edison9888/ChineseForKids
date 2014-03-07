//
//  CustomMenu.m
//  ChineseForKids
//
//  Created by 唐 希 on 13-8-20.
//  Copyright 2013年 Allen. All rights reserved.
//

#import "CustomMenu.h"


@implementation CustomMenu

-(void) registerWithTouchDispatcher{
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self
                                                              priority:kCCMenuHandlerPriority - 2
                                                       swallowsTouches:YES];
}


@end
