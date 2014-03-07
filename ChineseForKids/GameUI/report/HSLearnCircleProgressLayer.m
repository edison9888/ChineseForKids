//
//  HSLearnCircleProgressLayer.m
//  HSChildrenLearnProgress
//
//  Created by yang on 13-9-23.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "HSLearnCircleProgressLayer.h"
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

#define TWO_PI M_PI * 2.0f

static const float k2Pi = TWO_PI;

@implementation HSLearnCircleProgressLayer

+(id)layer
{
    HSLearnCircleProgressLayer *result = [[HSLearnCircleProgressLayer alloc] init];
    return result;
}

+ (BOOL)needsDisplayForKey:(NSString *)key
{
    if ([key isEqualToString:@"progressTintColor"]
        || [key isEqualToString:@"outlineTintColor"]
        || [key isEqualToString:@"outlineWidth"]
        || [key isEqualToString:@"alwaysDrawOutline"]
        || [key isEqualToString:@"fillRadius"]
        || [key isEqualToString:@"fillRadiusPx"]
        || [key isEqualToString:@"startAngle"]
        || [key isEqualToString:@"gap"]
        || [key isEqualToString:@"step"]
        || [key isEqualToString:@"current"]
        || [key isEqualToString:@"max"])
    {
        return YES;
    }
    
    return [super needsDisplayForKey:key];
}

- (id)initWithLayer:(id)layer
{
    self = [super initWithLayer:layer];
    if (self)
    {
        if ([layer isKindOfClass:[HSLearnCircleProgressLayer class]])
        {
            HSLearnCircleProgressLayer *other = layer;
            self.progressType = other.progressType;
            self.progressTintColor = other.progressTintColor;
            self.outlineTintColor  = other.outlineTintColor;
            self.animationDuration = other.animationDuration;
            self.outlineWidth = other.outlineWidth;
            self.fillRadius = other.fillRadius;
            self.fillRadiusPx = other.fillRadiusPx;
            self.startAngle = other.startAngle;
            self.step = other.step;
            self.max = other.max;
            self.gap = other.gap;
            self.current = other.current;
            self.alwaysDrawOutline = other.alwaysDrawOutline;
        }
    }
    return self;
}

- (void)setFillRadiusPx:(CGFloat)fillRadiusPx
{
    CGFloat radius = MIN(self.bounds.size.width, self.bounds.size.height) * 0.5f - (self.outlineWidth * 2.0);
    [self setFillRadius:fillRadiusPx/radius];
}

- (CGFloat)fillRadiusPx
{
    CGFloat radius = MIN(self.bounds.size.width, self.bounds.size.height) * 0.5f - (self.outlineWidth * 2.0);
    return radius * self.fillRadius;
}

// 画环形进度条的扇形区域
- (void)drawArcInContext:(CGContextRef)context Center:(CGPoint)aCenter Radius:(CGFloat)aRadius InnerRadius:(CGFloat)aInnerRadius StartAngle:(CGFloat)aStartAngle EndAngle:(CGFloat)aEndAngle Fill:(BOOL)aFill
{
    CGContextAddArc(context, aCenter.x, aCenter.y, aRadius, aStartAngle, aEndAngle, 0);
    CGContextAddArc(context, aCenter.x, aCenter.y, aInnerRadius, aEndAngle, aStartAngle, 1);
    
    CGPathDrawingMode drawingMode = kCGPathFill;
    if (self.alwaysDrawOutline || !aFill)
    {
        if (!aFill){
            drawingMode = kCGPathStroke;
        }else{
            drawingMode = kCGPathFillStroke;
        }
    }
    CGContextClosePath(context);
    CGContextDrawPath(context, drawingMode);
}

// 画环形的进度条
- (void)drawCircleProgressInContext:(CGContextRef)context Center:(CGPoint)aCenter Radius:(CGFloat)aRadius Current:(CGFloat)aCurrent Max:(CGFloat)aMax FillRadius:(CGFloat)aFillRadius
{
    CGContextSetFillColorWithColor(context, self.progressTintColor.CGColor);
    CGContextSetStrokeColorWithColor(context, self.outlineTintColor ? self.outlineTintColor.CGColor : self.progressTintColor.CGColor);
    
    CGContextSetLineWidth(context, self.outlineWidth);
    
    CGFloat tempEndAngle = 0.0f;
    CGFloat tempInnerRadius = aRadius * (1.0f - aFillRadius);
    
    if (self.step == 0.0f)
    {
        CGFloat progress = aCurrent / aMax;
        tempEndAngle = self.startAngle + progress * k2Pi;
        [self drawArcInContext:context Center:aCenter Radius:aRadius InnerRadius:tempInnerRadius StartAngle:self.startAngle EndAngle:tempEndAngle Fill:YES];
        
        if (self.outlineWidth > 0.0f && aCurrent < aMax)
        {
            [self drawArcInContext:context Center:aCenter Radius:aRadius InnerRadius:tempInnerRadius StartAngle:tempEndAngle EndAngle:self.startAngle Fill:NO];
        }
    }
    else
    {
        CGFloat tempGap = (self.gap * self.step) / aMax;
        CGFloat tempGapAngle = tempGap * k2Pi;
        CGFloat incr = (self.step - (self.step * self.gap)) / aMax;
        CGFloat tempStepAngle = incr * k2Pi;
        CGFloat tempStartAngle = self.startAngle + (tempGapAngle * 0.5f);
        CGFloat f = 0.0f;
        
        for (; f < aCurrent; f += self.step)
        {
            tempEndAngle = tempStartAngle + tempStepAngle;
            [self drawArcInContext:context Center:aCenter Radius:aRadius InnerRadius:tempInnerRadius StartAngle:tempStartAngle EndAngle:tempEndAngle Fill:YES];
            tempStartAngle += tempStepAngle + tempGapAngle;
        }
        
        if (self.outlineWidth > 0.0f && aMax)
        {
            for (; f <= aMax; f += self.step)
            {
                tempEndAngle = tempStartAngle + tempStepAngle;
                [self drawArcInContext:context Center:aCenter Radius:aRadius InnerRadius:tempInnerRadius StartAngle:tempStartAngle EndAngle:tempEndAngle Fill:NO];
                tempStartAngle += tempStepAngle + tempGapAngle;
            }
        }
    }
}

// 画直线型进度条的直方形区域
- (void)drawRectangleInContext:(CGContextRef)context StartX:(CGFloat)aStartX EndX:(CGFloat)aEndX Fill:(BOOL)aFill
{
    CGRect rect = CGRectMake(aStartX, 0.0f, aEndX-aStartX, self.bounds.size.height);
    CGContextAddRect(context, rect);
    
    CGPathDrawingMode drawingMode = kCGPathFill;
    if (self.alwaysDrawOutline || !aFill)
    {
        if (!aFill){
            drawingMode = kCGPathStroke;
        }else{
            drawingMode = kCGPathFillStroke;
        }
    }
    CGContextClosePath(context);
    CGContextDrawPath(context, drawingMode);
}

// 画直线型的进度条
- (void)drawLinerProgressInContext:(CGContextRef)context Origin:(CGPoint)aOrigin Height:(CGFloat)height Current:(CGFloat)aCurrent Max:(CGFloat)aMax
{
    CGContextSetFillColorWithColor(context, self.progressTintColor.CGColor);
    CGContextSetStrokeColorWithColor(context, self.outlineTintColor ? self.outlineTintColor.CGColor : self.progressTintColor.CGColor);
    
    CGContextSetLineWidth(context, self.outlineWidth);
    
    CGFloat tempEndX = 0.0f;
    
    if (self.step == 0.0f)
    {
        CGFloat progress = aCurrent / aMax;
        tempEndX = self.bounds.origin.x + progress * self.bounds.size.width;
        [self drawRectangleInContext:context StartX:self.bounds.origin.x EndX:tempEndX Fill:YES];
        
        if (self.outlineWidth > 0.0f && aCurrent < aMax)
        {
            [self drawRectangleInContext:context StartX:tempEndX EndX:self.bounds.origin.x Fill:NO];
        }
    }
    else
    {
        CGFloat tempGap = (self.gap * self.step) / aMax;
        CGFloat tempGapDistance = tempGap * self.bounds.size.width;
        CGFloat incr = (self.step - (self.step * self.gap)) / aMax;
        CGFloat tempStepDistance = incr * self.bounds.size.width;
        CGFloat tempStartX = self.bounds.origin.x + (tempGapDistance * 0.5f);
        CGFloat f = 0.0f;
        
        for (; f < aCurrent; f += self.step)
        {
            tempEndX= tempStartX + tempStepDistance;
            [self drawRectangleInContext:context StartX:tempStartX EndX:tempEndX Fill:YES];
            tempStartX += tempStepDistance + tempGapDistance;
        }
        
        if (self.outlineWidth > 0.0f && aMax)
        {
            for (; f <= aMax; f += self.step)
            {
                tempEndX = tempStartX + tempStepDistance;
                [self drawRectangleInContext:context StartX:tempStartX EndX:tempEndX Fill:NO];
                tempStartX += tempStepDistance + tempGapDistance;
            }
        }
    }
}

- (void)drawInContext:(CGContextRef)ctx
{
    if (self.progressType == HSChildrenLearnProgressTypeCircle)
    {
        CGFloat radius = MIN(self.bounds.size.width, self.bounds.size.height) * 0.5f - (self.outlineWidth * 2.0f);
        CGPoint center = CGPointMake(self.bounds.size.width * 0.5f, self.bounds.size.height * 0.5f);
        [self drawCircleProgressInContext:ctx Center:center Radius:radius Current:self.current Max:self.max FillRadius:self.fillRadius];
    }
    else
    {
        [self drawLinerProgressInContext:ctx Origin:CGPointZero Height:self.bounds.size.height Current:self.current Max:self.max];
    }
}

#pragma mark - Memory Manager
- (void)dealloc
{
    //DLog(@"%@, %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    self.progressTintColor = nil;
    self.outlineTintColor  = nil;
}


@end
