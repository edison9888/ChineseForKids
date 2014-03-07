//
//  HSLearnCircleProgressView.h
//  HSChildrenLearnProgress
//
//  Created by yang on 13-9-23.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSLearnCircleProgressLayer.h"

@interface HSLearnCircleProgressView : UIView

/**
 * Type of the progress
 */
@property (nonatomic, assign)HSChildrenLearnProgressType progressType;

/**
 * Color of the progress circular bar
 */
@property (nonatomic, strong) UIColor *progressTintColor UI_APPEARANCE_SELECTOR;

/**
 * Color of the outline
 */
@property (nonatomic, strong) UIColor *outlineTintColor UI_APPEARANCE_SELECTOR;

/**
 * Width of the outline
 */
@property (nonatomic, assign) CGFloat outlineWidth UI_APPEARANCE_SELECTOR;

/**
 * Determines whether the outline is always drawn, even for full segments.
 */
@property (nonatomic, assign) BOOL alwaysDrawOutline UI_APPEARANCE_SELECTOR;

/**
 * Duration of the animation
 */
@property (nonatomic, assign) CFTimeInterval animationDuration UI_APPEARANCE_SELECTOR;

/**
 * Percentage of the circle that will be filled (1 draws a full circle, ]0..1[ draws a ring).
 */
@property (nonatomic, assign) CGFloat fillRadius UI_APPEARANCE_SELECTOR;

/**
 * Amount of the circle that will be filled in pixels (thickness of the ring).
 */
@property (nonatomic, assign) CGFloat fillRadiusPx UI_APPEARANCE_SELECTOR;

/**
 * Angle, in radius, where the progress starts.
 */
@property (nonatomic, assign) CGFloat startAngle UI_APPEARANCE_SELECTOR;


/**
 * Value between 0 and 1 determining the gap between 2 segments. Only used if the step parameter is used.
 */
@property (nonatomic, assign) CGFloat gap UI_APPEARANCE_SELECTOR;

/**
 * If 0 it will draw a single progression circle. If not it will draw ceil(max / concentricStep) concentric circles progressing one after another.
 */
@property (nonatomic, assign) CGFloat concentricStep;

/**
 * Value between 0 and 1 determining the gap between 2 concentric circles.
 * Only used if the concentricStep parameter is used.
 */
@property (nonatomic, assign) CGFloat concentricGap;


/**
 * If 0 then it will be a continuous progress. If not, it will be a discrete progress view with (max/step) markers.
 */
@property (nonatomic, assign) CGFloat step;

/**
 * Maximum value.
 */
@property (nonatomic, assign) CGFloat max;

/**
 * Current value.
 */
@property (nonatomic, assign) CGFloat current;

- (void)setFillRadius:(float)fillRadius animated:(BOOL)animated;

- (void)setCurrent:(float)current animated:(BOOL)animated;

- (void)setMax:(float)max animated:(BOOL)animated;

/**
 * Starts an animation that rotates indefinitely the circular view clockwise (by changing the startAngle value).
 */
- (void)startAnimating;

/**
 * Stops all animations.
 */
- (void)stopAnimating;

@end
