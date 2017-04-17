//
//  HHBadgeHUD.h
//  HHKangarooManager
//
//  Created by HHIOS on 2017/4/17.
//  Copyright © 2017年 LiYang. All rights reserved.
//

#import <UIKit/UIKit.h>

/// 动画类型
typedef NS_ENUM(NSUInteger, HHBadgeAnimationType) {
    HHBadgeAnimationPop = 0,///< 缩放动画
    HHBadgeAnimationBlink,///< 眨眼动画
    HHBadgeAnimationBump,///< 上下跳动动画
    HHBadgeAnimationNone///< 无
};


@interface HHDotBadgeStyle : NSObject

/// 直径 defalut 15
@property (nonatomic, assign)CGFloat badgeDiameter;
/// 圆圈的背景颜色
@property (nonatomic, strong)UIColor *bgColor;
/// 边框颜色
@property (nonatomic, strong)UIColor *borderColor;
/// 边框宽度
@property (nonatomic, assign)CGFloat borderWidth;

/// 是否支持QQ的粘性拖拽效果 default NO 此功能暂时未实现 后继版本加入
//@property (nonatomic, assign, getter=haveGooEffect)BOOL gooEffect;

@end

@interface HHCountBadgeStyle : HHDotBadgeStyle

/// 是否自适应大小 default YES
@property (nonatomic, assign)BOOL automaticExpansion;
/// 是否强制显示0 default NO
@property (nonatomic, assign, getter=shouldForcedShowZero)BOOL forceShowZero;

/// 数字的颜色
@property (nonatomic, strong)UIColor *countColor;
/// 数字的字体
@property (nonatomic, strong)UIFont *countFont;
/// 数字的对齐方式
@property (nonatomic, assign)NSTextAlignment countAlignment;

@end


@interface HHBadge : NSObject {
    __weak UIView *_sourceView;
    __weak UIBarButtonItem *_sourceItem;
}

#pragma mark - setup
/// 快速创建实例
+ (instancetype)badge;

- (void)show;
- (void)hide;

/// 源视图
@property (nonatomic, weak, readonly)UIView *sourceView;
/// 源item
@property (nonatomic, weak, readonly)UIBarButtonItem *sourceItem;

@end

@interface HHDotBadge : HHBadge

#pragma mark adjustment
/// 配置外观样式
- (void)applyStyle:(void (^)(HHDotBadgeStyle *style))maker;
/// 配置位置属性
- (void)moveByX:(CGFloat)x Y:(CGFloat)y;
- (void)scaleBy:(CGFloat)scale;

#pragma mark animation
- (void)doAnimationWithType:(HHBadgeAnimationType)type;

@end


@interface HHCountBadge : HHDotBadge

#pragma mark setup
/// 快速创建实例
+ (instancetype)badgeWithCount:(NSInteger)count;
- (instancetype)initWithCount:(NSInteger)count NS_DESIGNATED_INITIALIZER;

#pragma mark adjustment
/// 配置外观样式
- (void)applyStyle:(void (^)(HHCountBadgeStyle *style))maker;


#pragma mark changeCount
- (void)increaseWithAnimationType:(HHBadgeAnimationType)type;
- (void)increaseBy:(NSInteger)count animationWithType:(HHBadgeAnimationType)type;
- (void)decreaseWithAnimationType:(HHBadgeAnimationType)type;
- (void)decreaseBy:(NSInteger)count animationWithType:(HHBadgeAnimationType)type;

/// 数量
@property (nonatomic, assign)NSInteger count;

@end


@interface UIView (HHBadgeHUD)
@property (nonatomic, strong) __kindof HHBadge *hh_badge;
@end

@interface UIBarButtonItem (HHBadgeHUD)
/// 设置此值的时候确保Item的View属性已被加载
@property (nonatomic, strong) __kindof HHBadge *hh_badge;
@end

