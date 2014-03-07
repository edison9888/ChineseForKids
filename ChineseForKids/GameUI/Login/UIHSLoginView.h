//
//  UIHSLoginView.h
//  PinyinGame
//
//  Created by yang on 13-11-20.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTProgressHUD.h"

@protocol  UIHSLoginViewDelegate;

@interface UIHSLoginView : UIView<UITextFieldDelegate, HTProgressHUDDelegate>

@property (nonatomic, unsafe_unretained)id<UIHSLoginViewDelegate>delegate;

- (id)initWithFrame:(CGRect)frame withEmalil:(NSString *)email;

@end

@protocol  UIHSLoginViewDelegate <NSObject>

@required
- (void)loginView:(UIHSLoginView *)loginView registWithUserEmail:(NSString *)email;
- (void)loginView:(UIHSLoginView *)loginView loginWithUserEmail:(NSString *)email;

@end
