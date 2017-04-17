简介
==============
一款更Q的通知图标控件。<br/>


演示项目
==============
查看并运行 `HHBadgeHUDDemo/HHBadgeHUDDemo.xcodeproj`

<img src="https://github.com/theSkyOfJune/HHBadgeHUD/blob/master/gif/badge.gif" width="375"><br/>

特性
==============
- **无侵入性**:
- **轻量**:
- **易扩展**:


使用方法
==============

###数字图标样式

    // 1. 给UIView添加通知图标
    self.oneView.hh_badge = [HHCountBadge badgeWithCount:99];
    // 配置外观样式
    [(HHCountBadge *)self.oneView.hh_badge applyStyle:^(HHCountBadgeStyle *style) {
        style.bgColor = [UIColor cyanColor];
        style.borderColor = [UIColor redColor];
        style.borderWidth = 1;
        ...
    }];
    // 向左移5， 向下移5
    [(HHCountBadge *)self.oneView.hh_badge moveByX:-5 Y:5];
    // 角标+1
    [(HHCountBadge *)self.oneView.hh_badge increaseWithAnimationType:HHBadgeAnimationPop];
    // 角标+count
    [(HHCountBadge *)self.oneView.hh_badge increaseBy:(NSInteger)count animationWithType:HHBadgeAnimationPop];
    // 角标-1
    [(HHCountBadge *)self.oneView.hh_badge decreaseWithAnimationType:HHBadgeAnimationPop];
    // 角标-count
    [(HHCountBadge *)self.oneView.hh_badge decreaseBy:(NSInteger)count animationWithType:HHBadgeAnimationPop];

    // 2. 给UIBarButtonItem添加通知图标
    self.item.hh_badge = [HHCountBadge badgeWithCount:99];
    使用方法和上述一样， 有一点需要注意，给item设置此属性时需保证此时item的view属性已被加载，也即不为nil。

###点图标样式

    // 1. 给UIView添加通知图标
    self.oneView.hh_badge = [HHCountBadge badge];
    // 配置外观样式
    [(HHDotBadge *)self.oneView.hh_badge applyStyle:^(HHDotBadgeStyle *style) {
        style.bgColor = [UIColor cyanColor];
        style.borderColor = [UIColor redColor];
        style.borderWidth = 1;
        ...
    }];
    // 动画
    [(HHDotBadge *)self.oneView.hh_badge doAnimationWithType:self.type];

    // 向左移5， 向下移5
    [(HHDotBadge *)self.oneView.hh_badge moveByX:-5 Y:5];
    // 2. 给UIBarButtonItem添加通知图标
    self.item.hh_badge = [HHCountBadge badge];
    使用方法及注意点同上


关键类定义
==============

###支持动画类型

    typedef NS_ENUM(NSUInteger, HHBadgeAnimationType) {
        HHBadgeAnimationPop = 0,///< 缩放动画
        HHBadgeAnimationBlink,///< 眨眼动画
        HHBadgeAnimationBump,///< 上下跳动动画
        HHBadgeAnimationNone///< 无
    };


###点图标样式模型HHDotBadgeStyle

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


###数字图标样式模型HHCountBadgeStyle

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


###通知图标基类HHBadge

    @interface HHBadge : NSObject {
        __weak UIView *_sourceView;
        __weak UIBarButtonItem *_sourceItem;
    }

    /// 快速创建实例
    + (instancetype)badge;

    - (void)show;
    - (void)hide;

    /// 源视图
    @property (nonatomic, weak, readonly)UIView *sourceView;
    /// 源item
    @property (nonatomic, weak, readonly)UIBarButtonItem *sourceItem;

    @end


###点样式通知图标HHDotBadge

    @interface HHDotBadge : HHBadge

    /// 配置外观样式
    - (void)applyStyle:(void (^)(HHDotBadgeStyle *style))maker;
    /// 配置位置属性
    - (void)moveByX:(CGFloat)x Y:(CGFloat)y;
    - (void)scaleBy:(CGFloat)scale;

    - (void)doAnimationWithType:(HHBadgeAnimationType)type;

    @end


###数字样式通知图标HHCountBadge

    @interface HHCountBadge : HHDotBadge

    /// 快速创建实例
    + (instancetype)badgeWithCount:(NSInteger)count;
    - (instancetype)initWithCount:(NSInteger)count NS_DESIGNATED_INITIALIZER;

    /// 配置外观样式
    - (void)applyStyle:(void (^)(HHCountBadgeStyle *style))maker;

    - (void)increaseWithAnimationType:(HHBadgeAnimationType)type;
    - (void)increaseBy:(NSInteger)count animationWithType:(HHBadgeAnimationType)type;
    - (void)decreaseWithAnimationType:(HHBadgeAnimationType)type;
    - (void)decreaseBy:(NSInteger)count animationWithType:(HHBadgeAnimationType)type;

    /// 数量
    @property (nonatomic, assign)NSInteger count;

    @end


###分类

    @interface UIView (HHBadgeHUD)
    @property (nonatomic, strong) __kindof HHBadge *hh_badge;
    @end

    @interface UIBarButtonItem (HHBadgeHUD)
    /// 设置此值的时候确保Item的View属性已被加载
    @property (nonatomic, strong) __kindof HHBadge *hh_badge;
    @end


安装
==============

### CocoaPods

1. 在 Podfile 中添加 `pod 'HHBadgeHUD'`。
2. 执行 `pod install` 或 `pod update`。
3. 导入 \<HHBadgeHUD/HHBadgeHUD.h\>。


### 手动安装

1. 下载 HHBadgeHUD 文件夹内的所有内容。
2. 将 HHBadgeHUD 内的源文件添加(拖放)到你的工程。
3. 导入 `HHBadgeHUD.h`。


系统要求
==============
该项目最低支持 `iOS 6.0` 和 `Xcode 7.0`。


许可证
==============
HHBadgeHUD 使用 MIT 许可证，详情见 LICENSE 文件。
