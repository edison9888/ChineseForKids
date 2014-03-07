//
//  HTProgressHUD.m
//  HTProgressHUD
//
//  Created by yang junfeng on 13-5-23.
//  Copyright (c) 2013年 yang junfeng. All rights reserved.
//

#import "HTProgressHUD.h"
#import "MBSpinningCircle.h"

#if __has_feature(objc_arc)
#define MB_AUTORELEASE(exp) exp
#define MB_RELEASE(exp) exp
#define MB_RETAIN(exp) exp
#else
#define MB_AUTORELEASE(exp) [exp autorelease]
#define MB_RELEASE(exp) [exp release]
#define MB_RETAIN(exp) [exp retain]
#endif

static const CGFloat kPadding = 4.f;
static const CGFloat kLabelFontSize = 16.f;

@interface HTProgressHUD()

@property (strong) NSTimer *graceTimer;
@property (strong) NSTimer *minShowTimer;
@property (strong) NSDate *showStarted;
@property (strong) UIView *indicator;
@property (assign) CGSize size;

@end

@implementation HTProgressHUD
{
    CGAffineTransform rotationTransform;
    BOOL useAnimation;
    BOOL isFinished;
    UILabel *label;
    
    CGRect vLineFrame;
    CGRect deleteFrame;
}

@synthesize delegate;

@synthesize graceTimer;
@synthesize graceTime;
@synthesize minShowTime;
@synthesize minShowTimer;
@synthesize showStarted;
@synthesize animationType;
@synthesize indicator;

@synthesize xOffset;
@synthesize yOffset;
@synthesize margin;

@synthesize square;
@synthesize minSize;
@synthesize size;

@synthesize dimBackground;
@synthesize color;
@synthesize opacity;

@synthesize taskInProgress;
@synthesize mode;

@synthesize labelFont;

#pragma mark - Lifecycle

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		// Set default values for properties
		self.animationType = MBProgressHUDAnimationFade;
		self.mode = MBProgressHUDModeIndeterminate;
		self.labelText = nil;
		self.opacity = 0.6f;
        self.color = [UIColor blackColor];
		self.labelFont = [UIFont fontWithName:@"迷你简少儿" size:kLabelFontSize];
		self.xOffset = 10.0f;
		self.yOffset = 0.0f;
		self.dimBackground = NO;
		self.margin = 20.0f;
		self.graceTime = 0.0f;
		self.minShowTime = 0.0f;
		self.minSize = CGSizeZero;
		self.square = NO;
		self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin
        | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
		// Transparent background
		self.opaque = NO;
		self.backgroundColor = [UIColor colorWithWhite:0.2f alpha:0.7f];
		// Make it invisible for now
		self.alpha = 0.0f;
		
		taskInProgress = NO;
		rotationTransform = CGAffineTransformIdentity;
		
		[self setupLabels];
		[self updateIndicators];
		[self registerForKVO];
		[self registerForNotifications];
	}
	return self;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint pTouch = [touch locationInView:self];
    if (CGRectContainsPoint(deleteFrame, pTouch)) {
        [self cancelNetworkRequest:nil];
    }
}

#pragma mark - UI

- (void)setupLabels {
	label = [[UILabel alloc] initWithFrame:self.bounds];
	label.adjustsFontSizeToFitWidth = NO;
	label.textAlignment = NSTextAlignmentCenter;
	label.opaque = NO;
	label.backgroundColor = [UIColor clearColor];
	label.textColor = [UIColor whiteColor];
	label.font = self.labelFont;
	label.text = self.labelText;
	[self addSubview:label];
}

- (void)updateIndicators {
	
	BOOL isActivityIndicator = [indicator isKindOfClass:[UIActivityIndicatorView class]];
	
	if (mode == MBProgressHUDModeIndeterminate &&  !isActivityIndicator) {
		// Update to indeterminate indicator
		[indicator removeFromSuperview];
        /*
		self.indicator = MB_AUTORELEASE([[UIActivityIndicatorView alloc]
										 initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite]);
		[(UIActivityIndicatorView *)indicator startAnimating];
         */
        indicator = [self addLauncherActivityIndicatorView];
		[self addSubview:indicator];
	}
    else if (mode == MBProgressHUDModeText) {
		[indicator removeFromSuperview];
		self.indicator = nil;
	}
}

- (id)addLauncherActivityIndicatorView
{
    //UIColor *lanucherColor = [UIColor colorWithRed:50.0/255.0 green:155.0/255.0 blue:255.0/255.0 alpha:1.0];
    UIColor *lanucherColor = [UIColor orangeColor];
    MBSpinningCircle *cycleIndicator = [MBSpinningCircle circleWithSize:NSSpinningCircleSizeDefault color:lanucherColor];
    CGRect circleRect = cycleIndicator.frame;
    circleRect.origin = indicator.frame.origin;
    cycleIndicator.frame = circleRect;
    cycleIndicator.circleSize = NSSpinningCircleSizeDefault;
    cycleIndicator.hasGlow = YES;
    cycleIndicator.isAnimating = YES;
    cycleIndicator.speed = 0.3;
    return cycleIndicator;
}

- (void)cancelNetworkRequest:(id)sender
{
    if (self.delegate && [self.delegate conformsToProtocol:@protocol(HTProgressHUDDelegate)]
        && [self.delegate respondsToSelector:@selector(progressHUD:cancelButtonClicked:)]) {
        [self.delegate progressHUD:self cancelButtonClicked:sender];
    }
}
#pragma mark - KVO
- (void)registerForKVO {
	for (NSString *keyPath in [self observableKeypaths]) {
		[self addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew context:NULL];
	}
}

- (NSArray *)observableKeypaths {
	return [NSArray arrayWithObjects:@"mode", @"labelText", @"labelFont", @"progress", nil];
}

- (void)unregisterFromKVO {
	for (NSString *keyPath in [self observableKeypaths]) {
		[self removeObserver:self forKeyPath:keyPath];
	}
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if (![NSThread isMainThread]) {
		[self performSelectorOnMainThread:@selector(updateUIForKeypath:) withObject:keyPath waitUntilDone:NO];
	} else {
		[self updateUIForKeypath:keyPath];
	}
}

- (void)updateUIForKeypath:(NSString *)keyPath {
	if ([keyPath isEqualToString:@"mode"] || [keyPath isEqualToString:@"customView"]) {
		[self updateIndicators];
	} else if ([keyPath isEqualToString:@"labelText"]) {
		label.text = self.labelText;
        [self updateLabelFont];
	} else if ([keyPath isEqualToString:@"labelFont"]) {
        [self updateLabelFont];
        //label.font = self.labelFont;
	}  else if ([keyPath isEqualToString:@"progress"]) {
		if ([indicator respondsToSelector:@selector(setProgress:)]) {
			//[(id)indicator setProgress:progress];
		}
		return;
	}
	[self setNeedsLayout];
	[self setNeedsDisplay];
}

- (void)updateLabelFont
{
    CGFloat fontSize;
    [self.labelText sizeWithFont:self.labelFont minFontSize:6.0f actualFontSize:&fontSize forWidth:label.bounds.size.width lineBreakMode:NSLineBreakByCharWrapping];
    label.font = [UIFont boldSystemFontOfSize:fontSize];
}

#pragma mark - Notifications

- (void)registerForNotifications {
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc addObserver:self selector:@selector(deviceOrientationDidChange:)
			   name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)unregisterFromNotifications {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)deviceOrientationDidChange:(NSNotification *)notification {
	UIView *superview = self.superview;
	if (!superview) {
		return;
	} else if ([superview isKindOfClass:[UIWindow class]]) {
		[self setTransformForCurrentOrientation:YES];
	} else {
		self.bounds = self.superview.bounds;
		[self setNeedsDisplay];
	}
}

- (void)setTransformForCurrentOrientation:(BOOL)animated {
	// Stay in sync with the superview
	if (self.superview) {
		self.bounds = self.superview.bounds;
		[self setNeedsDisplay];
	}
	
	UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
	float radians = 0;
	if (UIInterfaceOrientationIsLandscape(orientation)) {
		if (orientation == UIInterfaceOrientationLandscapeLeft) { radians = -M_PI_2; }
		else { radians = M_PI_2; }
		// Window coordinates differ!
		self.bounds = CGRectMake(0, 0, self.bounds.size.height, self.bounds.size.width);
	} else {
		if (orientation == UIInterfaceOrientationPortraitUpsideDown) { radians = M_PI; }
		else { radians = 0; }
	}
	rotationTransform = CGAffineTransformMakeRotation(radians);
	
	if (animated) {
		[UIView beginAnimations:nil context:nil];
	}
	[self setTransform:rotationTransform];
	if (animated) {
		[UIView commitAnimations];
	}
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (id)initWithView:(UIView *)view {
	NSAssert(view, @"View must not be nil.");
	id me = [self initWithFrame:view.bounds];
	// We need to take care of rotation ourselfs if we're adding the HUD to a window
	if ([view isKindOfClass:[UIWindow class]]) {
		[self setTransformForCurrentOrientation:NO];
	}
	return me;
}

#pragma mark - Layout

- (void)layoutSubviews {
	
	// Entirely cover the parent view
	UIView *parent = self.superview;
	if (parent) {
		self.frame = parent.bounds;
	}
	CGRect bounds = self.bounds;
	
    
	// Determine the total widt and height needed
    CGFloat maxWidth = bounds.size.width - 5 * margin;;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) maxWidth = bounds.size.width * 0.26f;
	CGSize totalSize = CGSizeZero;
	
	CGRect indicatorF = indicator.bounds;
	indicatorF.size.width = MIN(indicatorF.size.width, maxWidth);
	totalSize.width = MAX(totalSize.width, indicatorF.size.width);
	totalSize.height = indicatorF.size.height;
    
	totalSize.width += 2 * margin;
	totalSize.height += margin*2/3;
	
	// Position elements
	CGFloat yPos = roundf(((bounds.size.height - totalSize.height) / 2)) + yOffset;
	CGFloat xPos = xOffset;
    
    CGRect btnF;
    btnF.origin.y = yPos;
    btnF.origin.x = roundf(((bounds.size.width + maxWidth) / 2)) - totalSize.height - xOffset/2;
    btnF.size.width = totalSize.height;
    btnF.size.height = totalSize.height;
    deleteFrame = btnF;
    
    vLineFrame.origin.y = roundf(((bounds.size.height - totalSize.height) / 2));
    vLineFrame.origin.x = btnF.origin.x - 6;
    vLineFrame.size.width = 0.5f;
    vLineFrame.size.height = totalSize.height;
    
    indicatorF.origin.y = roundf(((bounds.size.height - indicatorF.size.height) / 2)) + yOffset;
	indicatorF.origin.x = roundf(vLineFrame.origin.x-indicatorF.size.width) - xPos;
	indicator.frame = indicatorF;
    
    CGRect labelF;
    CGSize labelSize = [label.text sizeWithFont:label.font];
    labelF.origin.y = roundf(((bounds.size.height - labelSize.height) / 2)) + yOffset;;
	labelF.origin.x = roundf((bounds.size.width - maxWidth) / 2) + xPos;
	labelSize.width = (indicatorF.origin.x - roundf((bounds.size.width - maxWidth) / 2) - xPos);
	
	labelF.size = labelSize;
	label.frame = labelF;
    [self updateLabelFont];
    
	// Enforce minsize and quare rules
	if (square) {
		CGFloat max = MAX(totalSize.width, totalSize.height);
        
		if (max <= bounds.size.width - 2 * margin) {
			totalSize.width = max;
		}
		if (max <= bounds.size.height - 2 * margin) {
			totalSize.height = max;
		}
	}
	if (totalSize.width < minSize.width) {
		totalSize.width = minSize.width;
	}
	if (totalSize.height < minSize.height) {
		totalSize.height = minSize.height;
	}
	
	//self.size = totalSize;
    self.size = CGSizeMake(maxWidth, totalSize.height);
}

#pragma mark BG Drawing

- (void)drawRect:(CGRect)rect {
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	UIGraphicsPushContext(context);
    
	if (self.dimBackground) {
		//Gradient colours
		size_t gradLocationsNum = 2;
		CGFloat gradLocations[2] = {0.0f, 1.0f};
		CGFloat gradColors[8] = {0.0f,0.0f,0.0f,0.0f,0.0f,0.0f,0.0f,0.3f};
		CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
		CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, gradColors, gradLocations, gradLocationsNum);
		CGColorSpaceRelease(colorSpace);
		//Gradient center
		CGPoint gradCenter= CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
		//Gradient radius
		float gradRadius = MIN(self.bounds.size.width , self.bounds.size.height) ;
		//Gradient draw
		CGContextDrawRadialGradient (context, gradient, gradCenter,
									 0, gradCenter, gradRadius,
									 kCGGradientDrawsAfterEndLocation);
		CGGradientRelease(gradient);
	}
    
    // Set background rect color
    if (self.color) {
        CGContextSetFillColorWithColor(context, self.color.CGColor);
    } else {
        CGContextSetGrayFillColor(context, 0.0f, self.opacity);
    }
    
	// Center HUD
	CGRect allRect = self.bounds;
	// Draw rounded HUD backgroud rect
	CGRect boxRect = CGRectMake(roundf((allRect.size.width - size.width) / 2) ,
								roundf((allRect.size.height - size.height) / 2), size.width, size.height);
    CGContextAddRect(context, boxRect);
	CGContextFillPath(context);
    
    // 画圆环
    CGFloat lineWidth = 1.5f;
    UIBezierPath *processBackgroundPath = [UIBezierPath bezierPath];
    processBackgroundPath.lineWidth = lineWidth;
    processBackgroundPath.lineCapStyle = kCGLineCapRound;
    CGPoint center = CGPointMake(CGRectGetMidX(indicator.frame), CGRectGetMidY(indicator.frame));
    CGFloat radius = (indicator.bounds.size.width - 4 - lineWidth)/2;
    CGFloat startAngle = - ((float)M_PI / 2); // 90 degrees
    CGFloat endAngle = (2 * (float)M_PI) + startAngle;
    [processBackgroundPath addArcWithCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    [[UIColor grayColor] set];
    [processBackgroundPath stroke];
    
    // 画白色的竖直分割线
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextAddRect(context, vLineFrame);
	CGContextFillPath(context);
    
    // 画右边的叉叉
    CGPoint pOrigin = deleteFrame.origin;
    CGPoint pTopRight = CGPointMake(CGRectGetMaxX(deleteFrame), deleteFrame.origin.y);
    CGPoint pBottomLeft = CGPointMake(deleteFrame.origin.x, CGRectGetMaxY(deleteFrame));
    CGPoint pBottomRight = CGPointMake(CGRectGetMaxX(deleteFrame), CGRectGetMaxY(deleteFrame));
    CGFloat scaleFactor = 11.0f;
    
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, 0.9);
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    
    // 捺
    CGContextMoveToPoint(context,  pOrigin.x + scaleFactor, pOrigin.y+ scaleFactor);
    CGContextAddLineToPoint(context, pBottomRight.x - scaleFactor, pBottomRight.y - scaleFactor);
    // 撇
    CGContextMoveToPoint(context,  pTopRight.x - scaleFactor, pTopRight.y + scaleFactor);
    CGContextAddLineToPoint(context, pBottomLeft.x + scaleFactor, pBottomLeft.y - scaleFactor);
    //立马画上
    CGContextStrokePath(context);
    
	UIGraphicsPopContext();
}


#pragma mark - Timer callbacks

- (void)handleGraceTimer:(NSTimer *)theTimer {
	// Show the HUD only if the task is still running
	if (taskInProgress) {
		[self setNeedsDisplay];
		[self showUsingAnimation:useAnimation];
	}
}

- (void)handleMinShowTimer:(NSTimer *)theTimer {
	[self hideUsingAnimation:useAnimation];
}

#pragma mark - Show & hide

- (void)show:(BOOL)animated {
	useAnimation = animated;
	// If the grace time is set postpone the HUD display
	if (self.graceTime > 0.0) {
		self.graceTimer = [NSTimer scheduledTimerWithTimeInterval:self.graceTime target:self
                                                         selector:@selector(handleGraceTimer:) userInfo:nil repeats:NO];
	}
	// ... otherwise show the HUD imediately
	else {
		[self setNeedsDisplay];
		[self showUsingAnimation:useAnimation];
	}
}

- (void)hide:(BOOL)animated {
	useAnimation = animated;
	// If the minShow time is set, calculate how long the hud was shown,
	// and pospone the hiding operation if necessary
	if (self.minShowTime > 0.0 && showStarted) {
		NSTimeInterval interv = [[NSDate date] timeIntervalSinceDate:showStarted];
		if (interv < self.minShowTime) {
			self.minShowTimer = [NSTimer scheduledTimerWithTimeInterval:(self.minShowTime - interv) target:self
                                                               selector:@selector(handleMinShowTimer:) userInfo:nil repeats:NO];
			return;
		} 
	}
	// ... otherwise hide the HUD immediately
	[self hideUsingAnimation:useAnimation];
}

#pragma mark - Internal show & hide operations

- (void)showUsingAnimation:(BOOL)animated {
	self.alpha = 0.0f;
	if (animated && animationType == MBProgressHUDAnimationZoom) {
		self.transform = CGAffineTransformConcat(rotationTransform, CGAffineTransformMakeScale(1.5f, 1.5f));
	}
	self.showStarted = [NSDate date];
	// Fade in
	if (animated) {
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.30];
		self.alpha = 1.0f;
		if (animationType == MBProgressHUDAnimationZoom) {
			self.transform = rotationTransform;
		}
		[UIView commitAnimations];
	}
	else {
		self.alpha = 1.0f;
	}
}

- (void)hideUsingAnimation:(BOOL)animated {
	// Fade out
	if (animated && showStarted) {
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.30];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
		// 0.02 prevents the hud from passing through touches during the animation the hud will get completely hidden
		// in the done method
		if (animationType == MBProgressHUDAnimationZoom) {
			self.transform = CGAffineTransformConcat(rotationTransform, CGAffineTransformMakeScale(0.5f, 0.5f));
		}
		self.alpha = 0.02f;
		[UIView commitAnimations];
	}
	else {
		self.alpha = 0.0f;
		[self done];
	}
	self.showStarted = nil;
}

- (void)animationFinished:(NSString *)animationID finished:(BOOL)finished context:(void*)context {
	[self done];
}

- (void)done {
	isFinished = YES;
	self.alpha = 0.0f;
    [self removeFromSuperview];
}

#pragma mark - Memory Manager
- (void)dealloc
{
    [self unregisterFromNotifications];
	[self unregisterFromKVO];
    
    self.delegate = nil;
}

@end
