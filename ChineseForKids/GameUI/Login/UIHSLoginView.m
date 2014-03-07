//
//  UIHSLoginView.m
//  PinyinGame
//
//  Created by yang on 13-11-20.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "UIHSLoginView.h"
#import "GameManager.h"
#import "UserNet.h"
#import "UserModel.h"
#import "PredicateHelper.h"
#import "CommonHelper.h"
#import "CustomKeyChainHelper.h"
#import "Constants.h"
#import "ResponseModel.h"

#import <ShareSDK/ShareSDK.h>

@implementation UIHSLoginView
{
    UIImage *imgBorder;
    UIImage *imgLogin;
    UIImage *imgRegist;
    UIImage *imgForgetPwd;
    
    UIButton *btnLogin;
    UIButton *btnRegist;
    UIButton *btnForgetPwd;
    
    UITextField *tfEmail;
    UITextField *tfPassword;
    NSString *strEmail;
    
    CGFloat border_x;
    CGFloat border_y;
    
    CGPoint center;
    
    HTProgressHUD *progressManager;
}

- (id)initWithFrame:(CGRect)frame withEmalil:(NSString *)email
{
    self = [super initWithFrame:frame];
    if (self)
    {
        strEmail = email;
        imgBorder = [UIImage imageNamed:@"loginBorder.png"];
        imgLogin = [UIImage imageNamed:@"btnLogin.png"];
        imgRegist = [UIImage imageNamed:@"btnRegist.png"];
        imgForgetPwd = [UIImage imageNamed:@"btnForgetPwd.png"];
        
        border_x = (frame.size.width - imgBorder.size.width)*0.5f;
        border_y = (frame.size.height - imgBorder.size.height)*0.5f;
        
        center = self.center;
        
        [self initInterface];
        [self initKeyBorderNotification];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [imgBorder drawInRect:CGRectMake(border_x, border_y, imgBorder.size.width, imgBorder.size.height)];
}

- (void)initInterface
{
    CGSize size = self.bounds.size;
    NSString *aUserEmail = [CustomKeyChainHelper getUserNameWithService:KEY_USERNAME];
    tfEmail = [[UITextField alloc] initWithFrame:CGRectMake(size.width*0.4f, size.height*0.4f, size.width*0.314f, size.height*0.063f)];
    tfEmail.delegate = self;
    tfEmail.backgroundColor = [UIColor clearColor];
    tfEmail.placeholder = @"example@mail.com";
    tfEmail.keyboardType = UIKeyboardTypeEmailAddress;
    tfEmail.clearButtonMode = UITextFieldViewModeWhileEditing;
    tfEmail.font = [UIFont fontWithName:kFontNameChil size:27.0f];
    tfEmail.text = strEmail ? strEmail : aUserEmail;
    [self addSubview:tfEmail];
    
    tfPassword = [[UITextField alloc] initWithFrame:CGRectMake(size.width*0.4f, size.height*0.506f, size.width*0.314f, size.height*0.063f)];
    tfPassword.delegate = self;
    tfPassword.backgroundColor = [UIColor clearColor];
    tfPassword.placeholder = NSLocalizedString(@"6-20 字符(数字或字母)", @"");
    tfPassword.keyboardType = UIKeyboardTypeDefault;
    tfPassword.secureTextEntry = YES;
    tfPassword.clearButtonMode = UITextFieldViewModeWhileEditing;
    tfPassword.font = [UIFont fontWithName:kFontNameChil size:27.0f];
    tfPassword.text = @"";
    [self addSubview:tfPassword];
    
    btnRegist = [UIButton buttonWithType:UIButtonTypeCustom];
    btnRegist.frame = CGRectMake(size.width*0.277f, size.height*0.643f, imgRegist.size.width, imgRegist.size.height);
    [btnRegist setImage:imgRegist forState:UIControlStateNormal];
    [btnRegist addTarget:self action:@selector(userRegist:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnRegist];
    
    btnLogin = [UIButton buttonWithType:UIButtonTypeCustom];
    btnLogin.frame = CGRectMake(size.width*0.53f, size.height*0.643f, imgLogin.size.width, imgLogin.size.height);
    [btnLogin setImage:imgLogin forState:UIControlStateNormal];
    [btnLogin addTarget:self action:@selector(userLogin:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnLogin];
    
    btnForgetPwd = [UIButton buttonWithType:UIButtonTypeCustom];
    btnForgetPwd.frame = CGRectMake(size.width*0.66f, size.height*0.59f, imgForgetPwd.size.width, imgForgetPwd.size.height);
    [btnForgetPwd setImage:imgForgetPwd forState:UIControlStateNormal];
    [btnForgetPwd addTarget:self action:@selector(userForgetPassword:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnForgetPwd];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

#pragma mark - KeyBorder Notification
- (void)initKeyBorderNotification
{
    //加入键盘事件的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];//键盘显示触发
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];//键盘显示触发
}

//-------------> 响应键盘显示事件 <------------------------
//    【主要思想是:将整体的view随键盘往上移动】
//------------------------------------------------------
- (void)keyboardWillShow:(NSNotification *)notification
{
    //先设定一个低于键盘顶部的阈值.
    NSInteger startOriginY = tfPassword.frame.origin.y + tfPassword.frame.size.height*2.0f;
    NSDictionary *userInfo = [notification userInfo];
    
    //在键盘出现时,获取键盘的顶部坐标
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self convertRect:keyboardRect fromView:nil];
    CGFloat keyboardTop = keyboardRect.origin.y;
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    //根据键盘出现时的动画动态地改变输入区域的显示位置.(即把整个view上下移动)
    [UIView beginAnimations:@"animation" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //将视图整体往上移动
    //根据键盘的顶部坐标,使输入框自适应,从而不被键盘遮挡.
    CGRect newViewFrame = CGRectMake(0.0f, self.frame.origin.y+(keyboardTop - startOriginY), self.frame.size.width, self.frame.size.height);
    self.center = CGPointMake(CGRectGetMidX(newViewFrame), CGRectGetMidY(newViewFrame));
    [UIView commitAnimations];
}

//-------------> 响应键盘关闭事件 <------------------------
//    【主要思想是:将整体的view随键盘移动到正常位置】
//------------------------------------------------------
- (void)keyboardWillHide:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    //获取键盘上下移动时动画的时间
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    //将视图向下恢复到正常位置,并使用动画
    [UIView beginAnimations:@"animation" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.center = center;
    [UIView commitAnimations];
}

#pragma mark - Touch Manager
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (tfEmail) {
        [tfEmail resignFirstResponder];
    }
    if (tfPassword){
        [tfPassword resignFirstResponder];
    }
}

#pragma mark - UIButton Action Manager
- (void)userRegist:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(loginView:registWithUserEmail:)])
    {
        NSString *email = nil;
        if (tfEmail && tfEmail.text) email = tfEmail.text;
        
        [self.delegate loginView:self registWithUserEmail:email];
    }
}

- (void)userLogin:(id)sender
{
#ifdef DLITE_VERSION
    [[GameManager sharedManager] loginWithUserID:@"1" userName:@"小明" userEmail:@""];
    if (self.delegate && [self.delegate respondsToSelector:@selector(loginView:loginWithUserEmail:)])
    {
        NSString *email = nil;
        if (tfEmail && tfEmail.text) email = tfEmail.text;
        
        [self.delegate loginView:self loginWithUserEmail:email];
    }
#else
    if (![PredicateHelper validateEmail:tfEmail.text])
    {
        [CommonHelper makeToastWithMessage:NSLocalizedString(@"Email不正确!", @"") view:self];
        return;
    }
    if (![PredicateHelper validatePassword:tfPassword.text])
    {
        [CommonHelper makeToastWithMessage:NSLocalizedString(@"密码为6到20位的数字或字母!", @"") view:self];
        return;
    }
    
    progressManager = [CommonHelper addNetworkRequestProgressToView:self withDelegate:self content:@"登陆中..."];
    
    ResponseModel *response = [UserNet startLoginWithUserEmail:tfEmail.text password:tfPassword.text];
    [self hideProgressHUD];
    
    // 正确请求之后, 才登陆。
    if (response.error.code == 0)
    {
        UserModel *userMode = (UserModel *)response.resultInfo;
        [[GameManager sharedManager] loginWithUserID:userMode.userID userName:userMode.userName userEmail:userMode.userEmail];
        if (self.delegate && [self.delegate respondsToSelector:@selector(loginView:loginWithUserEmail:)])
        {
            NSString *email = nil;
            if (tfEmail && tfEmail.text) email = tfEmail.text;
            
            [self.delegate loginView:self loginWithUserEmail:email];
        }
    }
    else
    {
        [CommonHelper makeToastWithMessage:response.error.domain view:self];
    }
    
#endif
}

- (void)userForgetPassword:(id)sender
{
    if (![PredicateHelper validateEmail:tfEmail.text])
    {

        [CommonHelper makeToastWithMessage:NSLocalizedString(@"Email不正确!", @"") view:self];
        return;
    }
    
    progressManager = [CommonHelper addNetworkRequestProgressToView:self withDelegate:self content:@"发送邮件中..."];
    
    ResponseModel *response = [UserNet startGetPasswordBackWithUserEmail:tfEmail.text];
    [self hideProgressHUD];
    
    [CommonHelper makeToastWithMessage:response.error.domain view:self];
}

#pragma mark - HTProgressHUD Manager
- (void)progressHUD:(HTProgressHUD *)progress cancelButtonClicked:(id)sender
{
    [self cancelNetworkRequest];
    if (progressManager == progress) {
        [self hideProgressHUD];
    }
}

- (void)hideProgressHUD
{
    if (progressManager)
    {
        [progressManager hide:YES];
        progressManager = nil;
    }
}

- (void)cancelNetworkRequest
{
    [UserNet cancelLogin];
}


#pragma mark - UITextField Delegate Manager
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == tfEmail) {
        [tfPassword becomeFirstResponder];
    }else{
        [tfPassword resignFirstResponder];
    }
    return YES;
}

#pragma mark - Memeory Manager
- (void)dealloc
{
    imgBorder = nil;
    imgLogin = nil;
    imgRegist = nil;
    imgForgetPwd = nil;
    
    [btnLogin removeFromSuperview];
    btnLogin = nil;
    
    [btnRegist removeFromSuperview];
    btnRegist = nil;
    
    [btnForgetPwd removeFromSuperview];
    btnForgetPwd = nil;
    
    [tfEmail removeFromSuperview];
    tfEmail = nil;
    
    [tfPassword removeFromSuperview];
    tfPassword = nil;
    
    _delegate = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
