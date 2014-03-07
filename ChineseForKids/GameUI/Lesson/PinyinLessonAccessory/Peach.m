//
//  Peach.m
//  PinyinGame
//
//  Created by yang on 13-10-31.
//  Copyright (c) 2013年 yang. All rights reserved.
//

#import "Peach.h"
#import "cocos2d.h"
#import "Constants.h"

@interface Peach ()<CCTouchOneByOneDelegate>

@end

@implementation Peach
{
    CCSprite *spPeach;
    CCSprite *spTone;
    CCSprite *spWorm;
    
    CCSprite *spMvPeach;
}

+ (id)peachWithParentNode:(CCNode *)parentNode phoneme:(NSInteger)phoneme position:(CGPoint)position
{
    return [[self alloc] initWithParentNode:parentNode phoneme:phoneme position:position];
}

- (id)initWithParentNode:(CCNode *)parentNode phoneme:(NSInteger)phoneme position:(CGPoint)position
{
    CCLOG(@"%@; %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    if (self = [super init])
    {
        _phoneme = phoneme;
        
        spPeach = [CCSprite spriteWithSpriteFrameName:@"peach.png"];
        spPeach.position = position;
        [parentNode addChild:spPeach z:kPeach_z tag:kPeachTag+phoneme];
        _boundingBox = spPeach.boundingBox;
        
        NSString *frameName = [NSString stringWithFormat:@"tone%d.png", phoneme];
        spTone = [CCSprite spriteWithSpriteFrameName:frameName];
        spTone.position = spPeach.position;
        [parentNode addChild:spTone z:kPeach_Tone_z tag:kPeachToneTag+phoneme];
        
        spWorm = [CCSprite spriteWithSpriteFrameName:@"worm1.png"];
        spWorm.scale = 0.3f;
        spWorm.position = ccpAdd(spPeach.position, ccp(spPeach.contentSize.width*0.32f, spPeach.contentSize.height*0.5f));
        spWorm.visible = NO;
        [parentNode addChild:spWorm z:kPeach_Worm_z];
    }
    return self;
}

#pragma mark - CCTouch Manager
- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint location = [touch locationInView:[touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    BOOL isTouchHandled = CGRectContainsPoint([spPeach boundingBox], location);
    return isTouchHandled;
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(peach:touchEnd:)])
    {
        [self.delegate peach:self touchEnd:touch];
    }
}

#pragma mark - Set Manager
- (void)setIsRightPhoneme:(BOOL)isRightPhoneme
{
    _isRightPhoneme = isRightPhoneme;
    if (isRightPhoneme)
    {
        // 执行选对的动画
        [self rightSelectedAnimation];
    }
    else
    {
        // 执行选错的动画
        [self wrongSelectedAnimation];
        
        // 将选错的桃子上出现虫子
        [self showWorm];
    }
}

- (void)setIsMoveRightPeach:(BOOL)isMoveRightPeach
{
    _isMoveRightPeach = isMoveRightPeach;
    if (isMoveRightPeach)
    {
        // 将正确的桃子送到悟空的手中
        [self moveRightPeachToMonkey];
    }
}


- (void)setTouchEnabled:(BOOL)touchEnabled
{
    // 保证不重复添加target
    if (touchEnabled && !_touchEnabled)
    {
        [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:-1 swallowsTouches:YES];
    }
    else
    {
        [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
    }
    _touchEnabled = touchEnabled;
}

#pragma mark - Animation Manager
- (void)rightSelectedAnimation
{
    CCRotateTo *rotateTo = [CCRotateTo actionWithDuration:0.1f angle:10];
    CCRotateTo *rotateNeg = [CCRotateTo actionWithDuration:0.2f angle:-10];
    CCRotateTo *rotateBack = [CCRotateTo actionWithDuration:0.1f angle:0];
    CCScaleTo *scaleTo = [CCScaleTo actionWithDuration:0.3f scale:1.2f];
    CCScaleTo *scaleBack = [CCScaleTo actionWithDuration:0.2f scale:1.0f];
    
    CCSequence *seqRotate = [CCSequence actions:rotateTo, rotateNeg, rotateBack, nil];
    CCSequence *seqScale = [CCSequence actions:scaleTo, scaleBack, nil];
    CCSpawn *spawn = [CCSpawn actions:seqRotate, seqScale, nil];
    
    CCEaseBounceInOut *easeBounce = [CCEaseBounceInOut actionWithAction:spawn];
    
    [spPeach stopAllActions];
    [spPeach runAction:easeBounce];
    [spTone stopAllActions];
    [spTone runAction:[easeBounce copy]];
}

- (void)wrongSelectedAnimation
{
    CCScaleTo *scaleTo = [CCScaleTo actionWithDuration:0.2f scale:0.8f];
    CCScaleTo *scaleBig = [CCScaleTo actionWithDuration:0.3f scale:1.2f];
    CCScaleTo *scaleBack = [CCScaleTo actionWithDuration:0.2f scale:1.0f];
    
    CCSequence *seq = [CCSequence actions:scaleTo, scaleBig, scaleBack, nil];
    CCEaseBounceInOut *easeBounce = [CCEaseBounceInOut actionWithAction:seq];
    
    [spPeach stopAllActions];
    [spPeach runAction:easeBounce];
    [spTone stopAllActions];
    [spTone runAction:[easeBounce copy]];
}

- (void)moveRightPeachToMonkey
{
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    spMvPeach = [CCSprite spriteWithSpriteFrameName:@"peach.png"];
    spMvPeach.position = spPeach.position;
    [spPeach.parent addChild:spMvPeach z:99 tag:kPeachTag];
    
    CGPoint endPoint = ccp(winSize.width*0.6f, winSize.height*0.32f);
    [self moveWithSprite:spMvPeach startP:spMvPeach.position endP:endPoint startA:spMvPeach.rotation endA:spMvPeach.rotation dirTime:0.2f selected:YES];
}

- (void)moveWithSprite:(CCSprite*)mSprite startP:(CGPoint)startPoint endP:(CGPoint)endPoint startA:(float)startAngle endA:(float)endAngle dirTime:(float)time selected:(BOOL)selected
{
    float sx = startPoint.x;
    float sy = startPoint.y;
    float ex =endPoint.x+50;
    float ey =endPoint.y+150;
    //设置精灵的起始角度
    mSprite.rotation = startAngle;
    ccBezierConfig bezier; // 创建贝塞尔曲线
    bezier.controlPoint_1 = ccp(sx, sy); // 起始点
    bezier.controlPoint_2 = ccp(sx+(ex-sx)*0.5, sy+(ey-sy)*0.5+200); //控制点
    //bezier.endPosition = ccp(endPoint.x-30, endPoint.y+h); // 结束位置
    bezier.endPosition = ccp(endPoint.x, endPoint.y); // 结束位置
    CCBezierTo *actionMove = [CCBezierTo actionWithDuration:time bezier:bezier];
    //创建精灵旋转的动作
    CCRotateTo *actionRotate =[CCRotateTo actionWithDuration:time angle:endAngle];
    
    CCScaleTo *scaleTo = [CCScaleTo actionWithDuration:time scale:0.5f];
    
    //将两个动作封装成一个同时播放进行的动作
    CCSpawn *spawnSelect = [CCSpawn actions:actionMove, actionRotate, scaleTo, nil];
    CCSpawn *spawnNormal = [CCSpawn actions:actionMove, actionRotate, nil];
    
    CCCallBlockO *callBackO = [CCCallBlockO actionWithBlock:^(id object){
        
        CCSprite *spObj = (CCSprite *)object;
        [spObj removeFromParentAndCleanup:YES];
        spObj = nil;
    } object:mSprite];
    
    CCSequence *seqSelected = [CCSequence actions:spawnSelect, callBackO, nil];
    CCSequence *seqNormal  = [CCSequence actions:spawnNormal, nil];
    
    [mSprite runAction:(selected ? seqSelected : seqNormal)];
}

- (void)showWorm
{
    NSMutableArray *arrAnimation=[NSMutableArray arrayWithCapacity:6];
    for(int i = 1; i <= 5; i++)
    {
        NSString *frameName = [NSString stringWithFormat:@"worm%d.png", i];
        CCSpriteFrame *frame=[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName];
        [arrAnimation addObject:frame];
    }
    
    CCAnimation *animation = [CCAnimation animationWithSpriteFrames:arrAnimation delay:0.12];
    if (spWorm)
    {
        spWorm.visible = YES;
        CCAnimate *animate  = [CCAnimate actionWithAnimation:animation];
        CCActionInterval *animateR = [animate reverse];
        
        CCCallBlockN *callBack = [CCCallBlockN actionWithBlock:^(CCNode *node){
            CCSprite *sprite = (CCSprite *)node;
            sprite.visible = NO;
        }];
        
        CCSequence *seq = [CCSequence actions:animate, animateR, callBack, nil];
        [spWorm runAction:seq];
    }
}

#pragma mark - Memory Manager
- (void)dealloc
{
    CCLOG(@"%@; %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    
    [spPeach stopAllActions];
    [spPeach removeFromParentAndCleanup:YES];
    spPeach = nil;
    
    [spTone stopAllActions];
    [spTone removeFromParentAndCleanup:YES];
    spTone = nil;
    
    [spWorm stopAllActions];
    [spWorm removeFromParentAndCleanup:YES];
    spWorm = nil;
    
    [spMvPeach stopAllActions];
    [spMvPeach removeFromParentAndCleanup:YES];
    spMvPeach = nil;
    
    _delegate = nil;
}

@end
