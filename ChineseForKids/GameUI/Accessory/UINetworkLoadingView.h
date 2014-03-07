//
//  UINetworkLoadingView.h
//  ChineseForKids
//
//  Created by yang on 13-12-25.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "BaseView.h"

@protocol UINetworkLoadingViewDelegate;

@interface UINetworkLoadingView : BaseView

@property (nonatomic, unsafe_unretained)id<UINetworkLoadingViewDelegate>delegate;

@end

@protocol UINetworkLoadingViewDelegate <NSObject>

@optional
- (void)loadingView:(UINetworkLoadingView *)view errorViewTapped:(UITapGestureRecognizer *)gesture;

@end
