//
//  HSLearnCircleProgressLayer.h
//  HSChildrenLearnProgress
//
//  Created by yang on 13-9-23.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

typedef NS_ENUM(NSInteger, HSChildrenLearnProgressType) {
    HSChildrenLearnProgressTypeCircle,
    HSChildrenLearnProgressTypeLiner
};

@interface HSLearnCircleProgressLayer : CALayer

@property (nonatomic, strong)UIColor *progressTintColor;
@property (nonatomic, strong)UIColor *outlineTintColor;
@property (nonatomic, assign)NSTimeInterval animationDuration;
@property (nonatomic, assign)CGFloat outlineWidth;
@property (nonatomic, assign)CGFloat fillRadius;
@property (nonatomic, assign)CGFloat fillRadiusPx;
@property (nonatomic, assign)CGFloat startAngle;
@property (nonatomic, assign)CGFloat step;
@property (nonatomic, assign)CGFloat max;
@property (nonatomic, assign)CGFloat gap;
@property (nonatomic, assign)CGFloat current;
@property (nonatomic, assign)BOOL alwaysDrawOutline;
@property (nonatomic, assign)HSChildrenLearnProgressType progressType;

@end
