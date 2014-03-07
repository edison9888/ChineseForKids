//
//  UINetworkLoadingView.m
//  ChineseForKids
//
//  Created by yang on 13-12-25.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "UINetworkLoadingView.h"

@implementation UINetworkLoadingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        //self.backgroundColor = [UIColor colorWithWhite:0.3f alpha:0.6f];
        
        [self initInterface];
        [self resetLoadingViewFrame:frame];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark - 错误视图点击后重新加载数据
-(void)errorViewTappedGesture:(UITapGestureRecognizer *)gesture
{
    [super errorViewTappedGesture:gesture];
    if (self.delegate && [self.delegate respondsToSelector:@selector(loadingView:errorViewTapped:)])
    {
        [self.delegate loadingView:self errorViewTapped:gesture];
    }
}

#pragma mark - Memory Manager

@end
