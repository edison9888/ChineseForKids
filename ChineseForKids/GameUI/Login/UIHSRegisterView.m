//
//  UIHSRegisterView.m
//  PinyinGame
//
//  Created by yang on 13-11-20.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "UIHSRegisterView.h"
#import "UserNet.h"
#import "PredicateHelper.h"
#import "CommonHelper.h"
#import "Constants.h"
#import "ResponseModel.h"

@implementation UIHSRegisterView
{
    UIImage *imgBorder;
    UIImage *imgReturn;
    UIImage *imgDetermine;
    
    UIButton *btnDetermine;
    UIButton *btnReturn;
    
    UITextField *tfEmail;
    UITextField *tfPassword;
    UITextField *tfConfirm;
    
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
        imgBorder = [UIImage imageNamed:@"registerBorder.png"];
        imgReturn = [UIImage imageNamed:@"btnReturn.png"];
        imgDetermine = [UIImage imageNamed:@"btnDetermine.png"];
        
        border_x = (frame.size.width - imgBorder.size.width)*0.5f;
        border_y = (frame.size.height - imgBorder.size.height)*0.3f;
        
        center = self.center;
        
        [self initInterface];
        [self initKeyBorderNotification];
    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
}

- (void)drawRect:(CGRect)rect
{
    [imgBorder drawInRect:CGRectMake(border_x, border_y, imgBorder.size.width, imgBorder.size.height)];
}

- (void)initInterface
{
    CGSize size = self.bounds.size;
    tfEmail = [[UITextField alloc] initWithFrame:CGRectMake(size.width*0.428f, size.height*0.302f, size.width*0.314f, size.height*0.063f)];
    tfEmail.delegate = self;
    tfEmail.backgroundColor = [UIColor clearColor];
    tfEmail.placeholder = @"example@mail.com";
    tfEmail.keyboardType = UIKeyboardTypeEmailAddress;
    tfEmail.clearButtonMode = UITextFieldViewModeWhileEditing;
    tfEmail.font = [UIFont fontWithName:kFontNameChil size:27.0f];
    tfEmail.text = strEmail ? strEmail : @"";
    
    [self addSubview:tfEmail];
    
    tfPassword = [[UITextField alloc] initWithFrame:CGRectMake(size.width*0.428f, size.height*0.41f, size.width*0.314f, size.height*0.063f)];
    tfPassword.delegate = self;
    tfPassword.backgroundColor = [UIColor clearColor];
    tfPassword.placeholder = NSLocalizedString(@"6-20 字符(数字或字母)", @"");
    tfPassword.keyboardType = UIKeyboardTypeDefault;
    tfPassword.secureTextEntry = YES;
    tfPassword.clearButtonMode = UITextFieldViewModeWhileEditing;
    tfPassword.font = [UIFont fontWithName:kFontNameChil size:27.0f];
    tfPassword.text = @"";
    [self addSubview:tfPassword];
    
    tfConfirm = [[UITextField alloc] initWithFrame:CGRectMake(size.width*0.428f, size.height*0.522f, size.width*0.314f, size.height*0.063f)];
    tfConfirm.delegate = self;
    tfConfirm.backgroundColor = [UIColor clearColor];
    tfConfirm.placeholder = NSLocalizedString(@"6-20 字符(数字或字母)", @"");
    tfConfirm.keyboardType = UIKeyboardTypeDefault;
    tfConfirm.secureTextEntry = YES;
    tfConfirm.clearButtonMode = UITextFieldViewModeWhileEditing;
    tfConfirm.font = [UIFont fontWithName:kFontNameChil size:27.0f];
    tfConfirm.text = @"";
    [self addSubview:tfConfirm];
    
    btnReturn = [UIButton buttonWithType:UIButtonTypeCustom];
    btnReturn.frame = CGRectMake(size.width*0.277f, size.height*0.68f, imgReturn.size.width, imgReturn.size.height);
    [btnReturn setImage:imgReturn forState:UIControlStateNormal];
    [btnReturn addTarget:self action:@selector(registReturn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnReturn];
    
    btnDetermine = [UIButton buttonWithType:UIButtonTypeCustom];
    btnDetermine.frame = CGRectMake(size.width*0.531f, size.height*0.68f, imgDetermine.size.width, imgDetermine.size.height);
    [btnDetermine setImage:imgDetermine forState:UIControlStateNormal];
    [btnDetermine addTarget:self action:@selector(registDetermine:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnDetermine];
    
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
    NSInteger startOriginY = tfConfirm.frame.origin.y + tfConfirm.frame.size.height*2.0f;
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
    if (tfConfirm) {
        [tfConfirm resignFirstResponder];
    }
}

#pragma mark - UIButton Action Manager
- (void)registReturn:(id)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(registView:registWithUserEmail:)])
    {
        NSString *email = nil;
        if (tfEmail && tfEmail.text) email = tfEmail.text;
        
        [self.delegate registView:self registWithUserEmail:email];
    }
}

- (void)registDetermine:(id)sender
{
    if (![PredicateHelper validateEmail:tfEmail.text])
    {
        [CommonHelper makeToastWithMessage:NSLocalizedString(@"Email不正确!", @"") view:self];
        return;
    }
    if (![PredicateHelper validatePassword:tfPassword.text])
    {
        [CommonHelper makeToastWithMessage:NSLocalizedString(@"密码至少6位以上数字或字母!", @"") view:self];
        return;
    }
    if (![self isPasswordSameWithConfirm])
    {
        [CommonHelper makeToastWithMessage:NSLocalizedString(@"两次密码不一致!", @"") view:self];
        return;
    }
    
    progressManager = [CommonHelper addNetworkRequestProgressToView:self withDelegate:self content:NSLocalizedString(@"注册中...", @"")];
    
    ResponseModel *response = [UserNet startRegistWithUserEmail:tfEmail.text password:tfPassword.text];;
    [self hideProgressHUD];
    
    [CommonHelper makeToastWithMessage:response.error.domain view:self];
}

- (BOOL)isPasswordSameWithConfirm
{
    if (tfPassword && tfConfirm && [tfPassword.text isEqualToString:tfConfirm.text])
    {
        return YES;
    }
    return NO;
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
    }else if (textField == tfPassword){
        [tfConfirm becomeFirstResponder];
    }else{
        [tfConfirm resignFirstResponder];
    }
    return YES;
}

#pragma mark - Memeory Manager
- (void)dealloc
{
    imgBorder = nil;
    imgDetermine = nil;
    imgReturn = nil;
    
    [btnDetermine removeFromSuperview];
    btnDetermine = nil;
    
    [btnReturn removeFromSuperview];
    btnReturn = nil;
    
    [tfEmail removeFromSuperview];
    tfEmail = nil;
    
    [tfPassword removeFromSuperview];
    tfPassword = nil;
    
    [tfConfirm removeFromSuperview];
    tfConfirm = nil;
    
    strEmail = nil;
    
    _delegate = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
