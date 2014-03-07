//
//  UIHSSettingView.h
//  PinyinGame
//
//  Created by yang on 13-11-25.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum  {
	SettingViewContentTypeSetting = 0,
    SettingViewContentTypeAboutUs = 1
} SettingViewContentType;

@protocol UIHSSettingViewDelegate;

@interface UIHSSettingView : UIView
@property (nonatomic, unsafe_unretained)id<UIHSSettingViewDelegate>delegate;

- (id)initWithFrame:(CGRect)frame key:(SettingViewContentType)key;

@end

@protocol UIHSSettingViewDelegate <NSObject>

@required
- (void)settingView:(UIHSSettingView *)view close:(id)sender;

@end
