//
//  BaseView.h
//  ChineseForKids
//
//  Created by yang on 13-12-4.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WaitView.h"

@interface BaseView : UIView<UIGestureRecognizerDelegate, WaitViewDelegate>

- (void)initInterface;

- (void)resetLoadingViewFrame:(CGRect)frame;

- (void)showImageWithName:(NSString *)name isShow:(BOOL)animaed;

//停止隐藏加载转圈
-(void)showLoadingView;//将加载图放到最顶上
-(void)hideLoadingView;

//出错后显示错误提示图
-(void)showErrorView;
-(void)errorViewTappedGesture:(UITapGestureRecognizer *)gesture;//网络加载视图点击

@end
