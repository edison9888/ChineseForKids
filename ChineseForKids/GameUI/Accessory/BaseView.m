//
//  BaseView.m
//  ChineseForKids
//
//  Created by yang on 13-12-4.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "BaseView.h"
#import "CommonHelper.h"
#import "WaitView.h"

#define kButtonShareTag 500//分享
#define kButtonBackTag 501//返回
#define kButtoSearchTag 502//搜索
#define kButtonNetSettingTag 503 //网络设置按钮

@interface BaseView ()
{
    UIImage *imgBackground;
    UIImage *imgNoNetwork;
    UIImage *imgSetNetwork;
}

@property (nonatomic, strong)WaitView *loadingView;
@property (nonatomic, strong)UIImageView *bgImageView;
@property (nonatomic, strong)UIView *errorView;

@end

@implementation BaseView

@synthesize loadingView;
@synthesize errorView;
@synthesize bgImageView = _bgImageView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        //[self initInterface];
    }
    return self;
}

- (void)initInterface
{
    self.loadingView = [[WaitView alloc] init];
    self.loadingView.frame = CGRectMake(0.0f, 0.0f, self.bounds.size.width*0.918f, self.bounds.size.height);
    self.loadingView.center = CGPointMake(self.bounds.size.width*0.5f, self.bounds.size.height*0.602f);
    self.loadingView.backgroundColor = [UIColor colorWithWhite:0.3f alpha:0.3f];
    [self.loadingView setDelegate:self];
    [self addSubview:self.loadingView];
    self.loadingView.hidden = YES;
    self.loadingView.userInteractionEnabled = YES;
    
    // 加载失败视图
    imgBackground = [UIImage imageNamed:@"background.png"];
    errorView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.bounds.size.width, self.bounds.size.height)];
    [errorView setBackgroundColor:[UIColor colorWithPatternImage:imgBackground]];
    [errorView setHidden:YES];
    [self addSubview:errorView];
    
    UITapGestureRecognizer *errorTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(errorViewTappedGesture:)];
    [errorTap setDelegate:self];
    [errorView addGestureRecognizer:errorTap];
    
    // 没有网络的提示
    imgNoNetwork = [UIImage imageNamed:@"NoNetwork.png"];
    UIImageView *errorImgView = [[UIImageView alloc] initWithImage:imgNoNetwork];
    [errorImgView setFrame:CGRectMake(0.0f, 0.0f, imgNoNetwork.size.width, imgNoNetwork.size.height)];
    [errorImgView setCenter:CGPointMake((self.bounds.size.width - imgNoNetwork.size.width)*0.5f, (self.bounds.size.height - imgNoNetwork.size.height)*0.25f)];
    [errorView addSubview:errorImgView];
}

- (void)resetLoadingViewFrame:(CGRect)frame
{
    self.loadingView.frame = frame;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
#pragma mark - GEsturesDelegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if([touch.view isKindOfClass:[UIButton class]])
    {
        return NO;
    }
    return YES;
}

#pragma mark - waitView delegate
- (void)waitViewTap:(NSString *)url
{
    [self errorViewTappedGesture:nil];
}

#pragma mark - private method Manager
- (void)showLoadingView
{
    [self bringSubviewToFront:loadingView];
    [loadingView setHidden:NO];
}

- (void)hideLoadingView
{
    [loadingView setTitleText:@"" url:nil];
    [loadingView setHidden:YES];
}

- (void)errorViewTappedGesture:(UITapGestureRecognizer *)gesture
{
    [errorView setHidden:YES];
    [self showLoadingView];
}

- (void)showErrorView
{
    [loadingView setTitleText:nil];
}

- (void)showImageWithName:(NSString *)name isShow:(BOOL)animaed
{
    [self bringSubviewToFront:self.bgImageView];
    self.bgImageView.image = [UIImage imageNamed:name];
    self.bgImageView.hidden = !animaed;
}

#pragma mark - Memory Manager
- (void)dealloc
{
    self.loadingView.delegate = nil;
    self.loadingView = nil;
    self.errorView = nil;
    self.bgImageView = nil;
}

@end
