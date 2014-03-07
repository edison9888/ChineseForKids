//
//  UIHSSettingView.m
//  PinyinGame
//
//  Created by yang on 13-11-25.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "UIHSSettingView.h"
#import "GlobalDataHelper.h"

@implementation UIHSSettingView
{
    UIImage *imgBackground;
    UIImage *imgChoiseAudio;
    UIImage *imgUnChoiseAudio;
    UIImage *imgClose;
    
    UIButton *btnBackgroundAudio;
    UIButton *btnClose;
    
    BOOL audioChoised;
}

- (id)initWithFrame:(CGRect)frame key:(SettingViewContentType)key
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor colorWithWhite:0.3f alpha:0.6f];
        imgClose = [UIImage imageNamed:@"btnClose.png"];
        btnClose = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnClose setImage:imgClose forState:UIControlStateNormal];
        [btnClose addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnClose];
        
        if (SettingViewContentTypeSetting == key)
        {
            imgBackground = [UIImage imageNamed:@"settingBorder.png"];
            [self initSettingInterface];
        }
        else
        {
            imgBackground = [UIImage imageNamed:@"aboutUsBorder_EN.png"];
            [self initAboutUsInterface];
        }
        
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [imgBackground drawInRect:CGRectMake((self.bounds.size.width - imgBackground.size.width)*0.5f, (self.bounds.size.height - imgBackground.size.height)*0.5f, imgBackground.size.width, imgBackground.size.height)];
}

- (void)initSettingInterface
{
    audioChoised = YES;
    imgChoiseAudio = [UIImage imageNamed:@"btnChoise.png"];
    imgUnChoiseAudio = [UIImage imageNamed:@"btnUnChoise.png"];
    btnBackgroundAudio = [UIButton buttonWithType:UIButtonTypeCustom];
    btnBackgroundAudio.frame = CGRectMake(self.bounds.size.width*0.7f, self.bounds.size.height*0.46f, imgChoiseAudio.size.width, imgChoiseAudio.size.height);
    [btnBackgroundAudio setImage:imgChoiseAudio forState:UIControlStateNormal];
    [btnBackgroundAudio addTarget:self action:@selector(choiseAudio:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnBackgroundAudio];
    
    btnClose.frame = CGRectMake(self.bounds.size.width*0.765f, self.bounds.size.height*0.215f, imgClose.size.width, imgClose.size.height);
}

- (void)initAboutUsInterface
{
    btnClose.frame = CGRectMake(self.bounds.size.width*0.76f, self.bounds.size.height*0.18f, imgClose.size.width, imgClose.size.height);
}

- (void)choiseAudio:(id)sender
{
    audioChoised = !audioChoised;
    if (audioChoised)
    {
        [btnBackgroundAudio setImage:imgChoiseAudio forState:UIControlStateNormal];
    }
    else
    {
        [btnBackgroundAudio setImage:imgUnChoiseAudio forState:UIControlStateNormal];
    }
    [GlobalDataHelper sharedManager].shouldPlayBackgroundAudio = audioChoised;
}

- (void)closeAction:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(settingView:close:)])
    {
        [self.delegate settingView:self close:sender];
    }
}

#pragma mark - Memory Manager

- (void)dealloc
{
    imgBackground = nil;
    imgChoiseAudio = nil;
    imgUnChoiseAudio = nil;
    imgClose = nil;
    
    [btnBackgroundAudio removeFromSuperview];
    btnBackgroundAudio = nil;
    [btnClose removeFromSuperview];
    btnClose = nil;
    
    _delegate = nil;
}

@end
