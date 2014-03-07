//
//  UIHSRegisterView.h
//  PinyinGame
//
//  Created by yang on 13-11-20.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTProgressHUD.h"

@protocol  UIHSRegisterViewDelegate;

@interface UIHSRegisterView : UIView<UITextFieldDelegate, HTProgressHUDDelegate>
@property (nonatomic, unsafe_unretained)id<UIHSRegisterViewDelegate>delegate;

- (id)initWithFrame:(CGRect)frame withEmalil:(NSString *)email;

@end

@protocol  UIHSRegisterViewDelegate <NSObject>

@required
- (void)registView:(UIHSRegisterView *)registView registWithUserEmail:(NSString *)email;

@end