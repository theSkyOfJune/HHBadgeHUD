//
//  HHBadgeHUD.m
//  HHKangarooManager
//
//  Created by HHIOS on 2017/4/17.
//  Copyright © 2017年 LiYang. All rights reserved.
//

#import "HHBadgeHUD.h"


@implementation HHDotBadgeStyle
- (instancetype)init {
    if (self = [super init]) {
        self.badgeDiameter = 15;
        self.bgColor = [UIColor redColor];
    }
    return self;
}
@end


@interface HHCountBadgeStyle ()
@property (nonatomic, assign)CGFloat countMagnitudeAdaptationRatio;
@end

@implementation HHCountBadgeStyle
- (instancetype)init {
    if (self = [super init]) {
        self.badgeDiameter = 30;
        self.countMagnitudeAdaptationRatio = 0.3;
        self.countAlignment = NSTextAlignmentCenter;
        self.countColor = [UIColor whiteColor];
        self.automaticExpansion = YES;
    }
    return self;
}
- (void)setBadgeDiameter:(CGFloat)diameter {
    [super setBadgeDiameter:diameter];
    self.countFont = [UIFont fontWithName:@"HelveticaNeue" size:diameter * 0.5];
}

@end




@interface _HHDotView : UIView
@property (nonatomic, assign, getter=isUserChangingBgColor)BOOL userChangingBgColor;
@end
@implementation _HHDotView
- (void)setBackgroundColor:(UIColor *)backgroundColor {
    if (self.isUserChangingBgColor) {
        super.backgroundColor = backgroundColor;
        self.userChangingBgColor = NO;
    }
}
@end

@interface HHBadge ()
/// 源视图
@property (nonatomic, weak)UIView *sourceView;
/// 源item
@property (nonatomic, weak)UIBarButtonItem *sourceBarButtonItem;
@end
@implementation HHBadge
+ (instancetype)badge {
    return [[[self class] alloc] init];
}
- (void)show {}
- (void)hide {}
@end

@interface HHDotBadge ()

///
@property (nonatomic, strong) _HHDotView *dotView;

/// 样式
@property (nonatomic, strong) HHDotBadgeStyle *style;

///
@property (nonatomic, assign)NSInteger curOrderMagnitude;
/// 初始中心点
@property (nonatomic, assign)CGPoint initialCenter;
///
@property (nonatomic, assign)CGRect baseFrame;
///
@property (nonatomic, assign)CGRect initialFrame;
///
@property (nonatomic, assign)BOOL isIndeterminateMode;

@end

@interface HHCountBadge ()
/// 数字标签
@property (nonatomic, strong)UILabel *countLabel;
@end


@implementation HHDotBadge
- (instancetype)init {
    if (self = [super init]) {
        _curOrderMagnitude = 0;
        _isIndeterminateMode = NO;
        
        _HHDotView *dotView = [[_HHDotView alloc] init];
        dotView.userInteractionEnabled = NO;
        
        _dotView = dotView;
    }
    return self;
}


- (void)setBadgeFrame:(CGRect)frame {
    self.dotView.frame = frame;
    self.initialCenter = self.dotView.center;
    self.baseFrame = frame;
    self.initialFrame = frame;
    self.dotView.layer.cornerRadius = frame.size.height * 0.5;
}

#pragma mark adjustment
- (void)applyStyle:(void (^)(HHDotBadgeStyle *style))maker {
    !maker ?: maker(self.style);
    if (maker) self.style = self.style;
}
- (void)moveByX:(CGFloat)x Y:(CGFloat)y {
    CGRect frame = self.dotView.frame;
    frame.origin.x += x;
    frame.origin.y += y;
    [self setBadgeFrame:frame];
}
- (void)scaleBy:(CGFloat)scale {
    CGRect rect = self.initialFrame;
    CGFloat width = rect.size.width * scale;
    CGFloat height = rect.size.height * scale;
    CGFloat wdiff = (rect.size.width - width) / 2;
    CGFloat hdiff = (rect.size.height - height) / 2;
    
    CGRect frame = CGRectMake(rect.origin.x + wdiff, rect.origin.y + hdiff, width, height);
    [self setBadgeFrame:frame];
}

- (void)show {
    self.dotView.hidden = NO;
}
- (void)hide {
    self.dotView.hidden = YES;
}

#pragma mark animation
- (void)doAnimationWithType:(HHBadgeAnimationType)type {
    switch (type) {
        case HHBadgeAnimationPop:
            [self pop];
            break;
        case HHBadgeAnimationBlink:
            [self blink];
            break;
        case HHBadgeAnimationBump:
            [self bump];
            break;
            
        default:
            break;
    }
}

- (void)pop {
    const float height = self.baseFrame.size.height;
    const float width = self.baseFrame.size.width;
    const float pop_start_h = height * 0.85;
    const float pop_start_w = width * 0.85;
    const float time_start = 0.05;
    const float pop_out_h = height * 1.05;
    const float pop_out_w = width * 1.05;
    const float time_out = 0.2;
    const float pop_in_h = height * 0.95;
    const float pop_in_w = width * 0.95;
    const float time_in = 0.05;
    const float pop_end_h = height;
    const float pop_end_w = width;
    const float time_end = 0.05;
    
    CABasicAnimation *startSize = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
    startSize.duration = time_start;
    startSize.beginTime = 0;
    startSize.fromValue = @(pop_end_h / 2);
    startSize.toValue = @(pop_start_h / 2);
    startSize.removedOnCompletion = NO;
    
    CABasicAnimation *outSize = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
    outSize.duration = time_out;
    outSize.beginTime = time_start;
    outSize.fromValue = startSize.toValue;
    outSize.toValue = @(pop_out_h / 2);
    outSize.removedOnCompletion = NO;
    
    CABasicAnimation *inSize = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
    inSize.duration = time_in;
    inSize.beginTime = time_start+time_out;
    inSize.fromValue = outSize.toValue;
    inSize.toValue = @(pop_in_h / 2);
    inSize.removedOnCompletion = NO;
    
    CABasicAnimation *endSize = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
    endSize.duration = time_end;
    endSize.beginTime = time_in+time_out+time_start;
    endSize.fromValue = inSize.toValue;
    endSize.toValue = @(pop_end_h / 2);
    endSize.removedOnCompletion = NO;
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    [group setDuration: time_start+time_out+time_in+time_end];
    [group setAnimations:@[startSize, outSize, inSize, endSize]];
    
    [self.dotView.layer addAnimation:group forKey:nil];
    
    [UIView animateWithDuration:time_start animations:^{
        CGRect frame = self.dotView.frame;
        CGPoint center = self.dotView.center;
        frame.size.height = pop_start_h;
        frame.size.width = pop_start_w;
        self.dotView.frame = frame;
        self.dotView.center = center;
    }completion:^(BOOL complete){
        [UIView animateWithDuration:time_out animations:^{
            CGRect frame = self.dotView.frame;
            CGPoint center = self.dotView.center;
            frame.size.height = pop_out_h;
            frame.size.width = pop_out_w;
            self.dotView.frame = frame;
            self.dotView.center = center;
        }completion:^(BOOL complete){
            [UIView animateWithDuration:time_in animations:^{
                CGRect frame = self.dotView.frame;
                CGPoint center = self.dotView.center;
                frame.size.height = pop_in_h;
                frame.size.width = pop_in_w;
                self.dotView.frame = frame;
                self.dotView.center = center;
            }completion:^(BOOL complete){
                [UIView animateWithDuration:time_end animations:^{
                    CGRect frame = self.dotView.frame;
                    CGPoint center = self.dotView.center;
                    frame.size.height = pop_end_h;
                    frame.size.width = pop_end_w;
                    self.dotView.frame = frame;
                    self.dotView.center = center;
                }];
            }];
        }];
    }];
}
- (void)blink {
    self.alpha = 0.1;
    [UIView animateWithDuration:0.1 animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            self.alpha = 0.1;
        } completion:^(BOOL finished) {
            self.alpha = 1;
        }];
    }];
}

- (void)bump {
    void (^bumpDelta)(CGFloat) = ^(CGFloat y) {
        CGPoint center = self.dotView.center;
        center.y = self.initialCenter.y - y;
        self.dotView.center = center;
        if ([self isKindOfClass:[HHCountBadge class]])
            ((HHCountBadge *)self).countLabel.center = center;
    };
    
    [UIView animateWithDuration:0.13 animations:^{
        bumpDelta(8.0);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.13 animations:^{
            bumpDelta(0.0);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 animations:^{
                bumpDelta(4.0);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.1 animations:^{
                    bumpDelta(0.0);
                }];
            }];
        }];
    }];
}


#pragma mark - Setter
- (void)setStyle:(HHDotBadgeStyle *)style {
    _style = style;
    
    UIView *sv = self.sourceView;
    CGFloat diameter = style.badgeDiameter;
    CGRect rect = CGRectMake(sv.frame.size.width - (diameter*2/3), -diameter/3, diameter, diameter);
    
    self.dotView.userChangingBgColor = YES;
    self.dotView.backgroundColor = style.bgColor;
    self.dotView.layer.borderColor = style.borderColor.CGColor;
    self.dotView.layer.borderWidth = style.borderWidth;
    
    [self setBadgeFrame:rect];
}
- (void)setAlpha:(CGFloat)alpha {
    self.dotView.alpha = alpha;
}

- (void)setSourceView:(UIView *)view {
    [super setSourceView:view];
    [view addSubview:_dotView];
    
    self.style = [[HHDotBadgeStyle alloc]init];
}
- (void)setSourceBarButtonItem:(UIBarButtonItem *)item {
    [super setSourceBarButtonItem:item];
    [self scaleBy:0.7];
    [self moveByX:-5.0 Y:0];
}

@end




@implementation HHCountBadge
+ (instancetype)badge {
    return [self badgeWithCount:0];
}
+ (instancetype)badgeWithCount:(NSInteger)count {
    return [[self alloc]initWithCount:count];
}
- (instancetype)init {
    return [self initWithCount:0];
}
- (instancetype)initWithCount:(NSInteger)count {
    if (self = [super init]) {
        UILabel *label = [[UILabel alloc]init];
        label.userInteractionEnabled = NO;
        label.backgroundColor = [UIColor clearColor];
        _countLabel = label;
        
        _count = count;
    }
    return self;
}

- (void)applyStyle:(void (^)(HHCountBadgeStyle *style))maker {
    !maker ?: maker((HHCountBadgeStyle *)self.style);
    if (maker) self.style = self.style;
}

#pragma mark changeCount
- (void)increaseWithAnimationType:(HHBadgeAnimationType)type {
    [self increaseBy:1 animationWithType:type];
}
- (void)increaseBy:(NSInteger)count animationWithType:(HHBadgeAnimationType)type {
    self.count += count;
    [self doAnimationWithType:type];
}
- (void)decreaseWithAnimationType:(HHBadgeAnimationType)type {
    [self decreaseBy:1 animationWithType:type];
}
- (void)decreaseBy:(NSInteger)count animationWithType:(HHBadgeAnimationType)type {
    self.count -= count;
    [self doAnimationWithType:type];
}


#pragma mark - Overide
- (void)setSourceView:(UIView *)view {
    _sourceView = view;
    [view addSubview:self.dotView];
    [view addSubview:_countLabel];
    self.style = [[HHCountBadgeStyle alloc]init];
    [self checkZero];
}
- (void)setAlpha:(CGFloat)alpha {
    [super setAlpha:alpha];
    self.countLabel.alpha = alpha;
}
- (void)setBadgeFrame:(CGRect)frame {
    [super setBadgeFrame:frame];
    self.countLabel.frame = frame;
    [self.countLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:frame.size.width/2]];
    HHCountBadgeStyle *style = (HHCountBadgeStyle *)self.style;
    if (style.automaticExpansion) [self expandToFit];
}

- (void)setStyle:(HHCountBadgeStyle *)style {
    [super setStyle:style];
    
    self.countLabel.textAlignment = style.countAlignment;
    self.countLabel.textColor = style.countColor;
    self.count = self.count;
}
- (void)hide {
    self.dotView.hidden = NO;
    self.countLabel.hidden = self.isIndeterminateMode;
}
- (void)show {
    self.dotView.hidden = YES;
    self.countLabel.hidden = YES;
}

#pragma mark - Setter
- (void)setCount:(NSInteger)count {
    _count = count;
    self.countLabel.text = [NSString stringWithFormat:@"%ld", count];
    HHCountBadgeStyle *style = (HHCountBadgeStyle *)self.style;
    if (style.automaticExpansion) [self expandToFit];
}



#pragma mark - Helper
- (void)checkZero {
    if (self.count <= 0) {
        HHCountBadgeStyle *style = (HHCountBadgeStyle *)self.style;
        if (!style.forceShowZero) {
            self.dotView.hidden = YES;
            self.countLabel.hidden = YES;
        }
    } else {
        self.dotView.hidden = NO;
        self.countLabel.hidden = self.isIndeterminateMode;
    }
}
- (void)expandToFit {
    int orderOfMagnitude = log10((double)self.count);
    orderOfMagnitude = (orderOfMagnitude >= 2) ? orderOfMagnitude : 1;
    
    HHCountBadgeStyle *style = (HHCountBadgeStyle *)self.style;
    CGRect frame = self.initialFrame;
    frame.size.width = self.initialFrame.size.width * (1 + style.countMagnitudeAdaptationRatio * (orderOfMagnitude - 1));
    frame.origin.x = self.initialFrame.origin.x - (frame.size.width - self.initialFrame.size.width) * 0.5;
    
    self.dotView.frame = frame;
    self.initialCenter = self.dotView.center;
    self.baseFrame = frame;
    self.countLabel.frame = frame;
    self.curOrderMagnitude = orderOfMagnitude;
}

@end

#import <objc/runtime.h>

@implementation UIView (HHBadgeHUD)

- (void)setHh_badge:(HHBadge *)badge {
    if (self.hh_badge != badge) {
        [self willChangeValueForKey:@"hh_badge"];
        
        objc_setAssociatedObject(self, @selector(hh_badge), badge, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        badge.sourceView = self;
        [self didChangeValueForKey:@"hh_badge"];
    }
}

- (HHBadge *)hh_badge {
    return objc_getAssociatedObject(self, _cmd);
}

@end


@implementation UIBarButtonItem (HHBadgeHUD)

- (void)setHh_badge:(HHBadge *)badge {
    if (self.hh_badge != badge) {
        UIView *view = [self valueForKey:@"view"];
        view.hh_badge = badge;
        
        [self willChangeValueForKey:@"hh_badge"];
        objc_setAssociatedObject(self, @selector(hh_badge), badge, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        badge.sourceBarButtonItem = self;
        [self didChangeValueForKey:@"hh_badge"];
    }
}


- (HHBadge *)hh_badge {
    return objc_getAssociatedObject(self, _cmd);
}

@end

