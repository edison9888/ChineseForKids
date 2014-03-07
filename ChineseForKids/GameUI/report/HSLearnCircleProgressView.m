//
//  HSLearnCircleProgressView.m
//  HSChildrenLearnProgress
//
//  Created by yang on 13-9-23.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "HSLearnCircleProgressView.h"
#import "HSFontHandleManager.h"

#define INNERCIRCLE_WIDTH  14
#define OUSIDECIRCLE_WIDTH 16

#define PROGRESS_INNERCIRCLE_WIDTH  207
#define PROGRESS_INNERCIRCLE_HEIGHT 207
#define PROGRESS_INNERCIRCLE_ORIGIN_X (self.bounds.size.width - PROGRESS_INNERCIRCLE_WIDTH)/2.0f
#define PROGRESS_INNERCIRCLE_ORIGIN_Y (self.bounds.size.height/2.0f - PROGRESS_INNERCIRCLE_HEIGHT)/2.0f

#define PROGRESS_OUSIDECIRCLE_WIDTH  216
#define PROGRESS_OUSIDECIRCLE_HEIGHT 216
#define PROGRESS_OUSIDECIRCLE_ORIGIN_X (self.bounds.size.width - PROGRESS_OUSIDECIRCLE_WIDTH)/2.0f
#define PROGRESS_OUSIDECIRCLE_ORIGIN_Y (self.bounds.size.height/2.0f - PROGRESS_OUSIDECIRCLE_HEIGHT)/2.0f

#define PROGRESS_PERCENT_TEXT_WIDTH  PROGRESS_INNERCIRCLE_WIDTH-INNERCIRCLE_WIDTH*2
#define PROGRESS_PERCENT_TEXT_HEIGHT 60

@implementation HSLearnCircleProgressView

+ (Class)layerClass
{
    return [HSLearnCircleProgressLayer class];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self defaultInit];
    }
    return self;
}

- (id)init
{
    self = [super init];
    if (self){
        [self defaultInit];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    //[self defaultInit];
}

- (void)defaultInit
{
    self.backgroundColor = [UIColor clearColor];
    self.opaque = NO;
    // 取得设备的像素点
    self.layer.contentsScale = [[UIScreen mainScreen] scale];
    
    self.progressType      = HSChildrenLearnProgressTypeCircle;
    self.progressTintColor = [UIColor blackColor];
    self.outlineTintColor  = nil;
    self.outlineWidth      = 0.0f;
    self.fillRadius        = 0.25f;
    self.animationDuration = 0.25f;
    self.startAngle        = -M_PI_2;
    self.gap               = 0.1f;
    [self setMax:1.0f animated:NO];
    [self setCurrent:0.0f animated:NO];
    [self setStep:0.0f];
}

- (void)startAnimating
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"startAngle"];
    animation.duration  = 1;
    animation.fromValue = [NSNumber numberWithFloat:0];
    animation.toValue   = [NSNumber numberWithFloat:(M_PI * 2)];
    animation.repeatCount = INFINITY;
    [self.layer addAnimation:animation forKey:@"startAngleAnimation"];
}

- (void)stopAnimating
{
    [self.layer removeAllAnimations];
}

- (void)setProgressType:(HSChildrenLearnProgressType)progressType
{
    if (!self.progressType == progressType)
    {
        HSLearnCircleProgressLayer *layer = (HSLearnCircleProgressLayer *)self.layer;
        layer.progressType = progressType;
        [layer setNeedsDisplay];
    }
}

- (void)setProgressTintColor:(UIColor *)progressTintColor
{
    if (![self.progressTintColor isEqual:progressTintColor])
    {
        HSLearnCircleProgressLayer *layer = (HSLearnCircleProgressLayer *)self.layer;
        layer.progressTintColor = progressTintColor;
        [layer setNeedsDisplay];
    }
}

- (void)setOutlineTintColor:(UIColor *)outlineTintColor
{
    if (![self.outlineTintColor isEqual:outlineTintColor])
    {
        HSLearnCircleProgressLayer *layer = (HSLearnCircleProgressLayer *)self.layer;
        layer.outlineTintColor = outlineTintColor;
        [layer setNeedsDisplay];
    }
}

- (void)setOutlineWidth:(CGFloat)outlineWidth
{
    if (self.outlineWidth != outlineWidth)
    {
        HSLearnCircleProgressLayer *layer = (HSLearnCircleProgressLayer *)self.layer;
        layer.outlineWidth = outlineWidth;
        [layer setNeedsDisplay];
    }
}

- (void)setAlwaysDrawOutline:(BOOL)alwaysDrawOutline
{
    if (self.alwaysDrawOutline != alwaysDrawOutline)
    {
        HSLearnCircleProgressLayer *layer = (HSLearnCircleProgressLayer *)self.layer;
        layer.alwaysDrawOutline = alwaysDrawOutline;
        [layer setNeedsDisplay];
    }
}

- (void)setFillRadius:(float)fillRadius animated:(BOOL)animated
{
    if (self.fillRadius == fillRadius){
        return;
    }
    fillRadius = MIN(MAX(0.0f, fillRadius), 1.0f);
    HSLearnCircleProgressLayer *layer = (HSLearnCircleProgressLayer *)self.layer;
    if (animated && self.animationDuration > 0.0f)
    {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"fillRadius"];
        animation.duration  = self.animationDuration;
        animation.fromValue = [NSNumber numberWithFloat:self.fillRadius];
        animation.toValue   = [NSNumber numberWithFloat:fillRadius];
        animation.timingFunction = [CAMediaTimingFunction functionWithName:@"easeInEaseOut"];
        animation.delegate  = self;
        [self.layer addAnimation:animation forKey:@"fillRadiusAnimation"];
    }
    layer.fillRadius = fillRadius;
    [layer setNeedsDisplay];
}

- (void)setFillRadius:(CGFloat)fillRadius
{
    [self setFillRadius:fillRadius animated:NO];
}

- (void)setFillRadiusPx:(CGFloat)fillRadiusPx animated:(BOOL)animated
{
    if (self.fillRadiusPx == fillRadiusPx){
        return;
    }
    fillRadiusPx = MAX(0, fillRadiusPx);
    HSLearnCircleProgressLayer *layer = (HSLearnCircleProgressLayer *)self.layer;
    if (animated && self.animationDuration > 0.0f)
    {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"fillRadiusPx"];
        animation.duration  = self.animationDuration;
        animation.fromValue = [NSNumber numberWithFloat:self.fillRadiusPx];
        animation.toValue   = [NSNumber numberWithFloat:fillRadiusPx];
        animation.timingFunction = [CAMediaTimingFunction functionWithName:@"easeInEaseOut"];
        animation.delegate  = self;
        [self.layer addAnimation:animation forKey:@"fillRadiusPxAnimation"];
    }
    layer.fillRadiusPx = fillRadiusPx;
    [layer setNeedsDisplay];
}

- (void)setFillRadiusPx:(CGFloat)fillRadiusPx
{
    [self setFillRadiusPx:fillRadiusPx animated:NO];
}

- (void)setCurrent:(float)current animated:(BOOL)animated
{
    if (self.current == current) {
        return;
    }
    current = MIN(MAX(0.0f, current), self.max);
    HSLearnCircleProgressLayer *layer = (HSLearnCircleProgressLayer *)self.layer;
    if (animated && self.animationDuration > 0.0f)
    {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"current"];
        animation.duration  = self.animationDuration;
        animation.fromValue = [NSNumber numberWithFloat:self.current];
        animation.toValue   = [NSNumber numberWithFloat:current];
        animation.timingFunction = [CAMediaTimingFunction functionWithName:@"easeInEaseOut"];
        animation.delegate  = self;
        [self.layer addAnimation:animation forKey:@"currentAnimation"];
    }
    layer.current = current;
    [layer setNeedsDisplay];
}

- (void)setCurrent:(CGFloat)current
{
    [self setCurrent:current animated:YES];
}

- (void)setStartAngle:(CGFloat)startAngle
{
    if (self.startAngle != startAngle)
    {
        HSLearnCircleProgressLayer *layer = (HSLearnCircleProgressLayer *)self.layer;
        layer.startAngle = startAngle;
        [layer setNeedsDisplay];
    }
}

- (void)setGap:(CGFloat)gap
{
    if (self.gap != gap)
    {
        HSLearnCircleProgressLayer *layer = (HSLearnCircleProgressLayer *)self.layer;
        layer.gap = gap;
        [layer setNeedsDisplay];
    }
}

- (void)setStep:(CGFloat)step
{
    if (self.step != step)
    {
        HSLearnCircleProgressLayer *layer = (HSLearnCircleProgressLayer *)self.layer;
        layer.step = step;
        [layer setNeedsDisplay];
    }
}

- (void)setMax:(float)max animated:(BOOL)animated
{
    if (self.max == max) {
        return;
    }
    HSLearnCircleProgressLayer *layer = (HSLearnCircleProgressLayer *)self.layer;
    if (animated && self.animationDuration > 0.0f)
    {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"current"];
        animation.duration  = self.animationDuration;
        animation.fromValue = [NSNumber numberWithFloat:layer.max];
        animation.toValue   = [NSNumber numberWithFloat:max];
        animation.timingFunction = [CAMediaTimingFunction functionWithName:@"easeInEaseOut"];
        animation.delegate  = self;
        [self.layer addAnimation:animation forKey:@"currentAnimation"];
    }
    layer.max = max;
    [layer setNeedsDisplay];
}

- (void)setMax:(CGFloat)max
{
    [self setMax:max animated:YES];
}

- (UIColor *)progressTintColor
{
    HSLearnCircleProgressLayer *layer = (HSLearnCircleProgressLayer *)self.layer;
    return layer.progressTintColor;
}

- (UIColor *)outlineTintColor
{
    HSLearnCircleProgressLayer *layer = (HSLearnCircleProgressLayer *)self.layer;
    return layer.outlineTintColor;
}

- (BOOL)alwaysDrawOutline
{
    HSLearnCircleProgressLayer *layer = (HSLearnCircleProgressLayer *)self.layer;
    return layer.alwaysDrawOutline;
}

- (CGFloat)outlineWidth
{
    HSLearnCircleProgressLayer *layer = (HSLearnCircleProgressLayer *)self.layer;
    return layer.outlineWidth;
}

- (CGFloat)fillRadius
{
    HSLearnCircleProgressLayer *layer = (HSLearnCircleProgressLayer *)self.layer;
    return layer.fillRadius;
}

- (CGFloat)fillRadiusPx
{
    HSLearnCircleProgressLayer *layer = (HSLearnCircleProgressLayer *)self.layer;
    return layer.fillRadiusPx;
}

- (CGFloat)startAngle
{
    HSLearnCircleProgressLayer *layer = (HSLearnCircleProgressLayer *)self.layer;
    return layer.startAngle;
}

- (CGFloat)gap
{
    HSLearnCircleProgressLayer *layer = (HSLearnCircleProgressLayer *)self.layer;
    return layer.gap;
}

- (CGFloat)step
{
    HSLearnCircleProgressLayer *layer = (HSLearnCircleProgressLayer *)self.layer;
    return layer.step;
}

- (CGFloat)max
{
    HSLearnCircleProgressLayer *layer = (HSLearnCircleProgressLayer *)self.layer;
    return layer.max;
}

- (CGFloat)current
{
    HSLearnCircleProgressLayer *layer = (HSLearnCircleProgressLayer *)self.layer;
    return layer.current;
}

#pragma mark - Memory Manager
- (void)dealloc
{
    DLog(@"%@", NSStringFromSelector(_cmd));
}


@end
