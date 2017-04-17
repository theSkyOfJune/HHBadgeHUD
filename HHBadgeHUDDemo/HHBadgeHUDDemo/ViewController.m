//
//  ViewController.m
//  HHBadgeHUDDemo
//
//  Created by HHIOS on 2017/4/17.
//  Copyright © 2017年 LiYang. All rights reserved.
//

#import "ViewController.h"

#import "HHBadgeHUD.h"

@interface UIViewController (__HHAdd)
/// 从SB中加载指定的控制器
+ (instancetype)loadFromStoryboard;
@end
@implementation UIViewController (__HHAdd)
+ (instancetype)loadFromStoryboard {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    return [sb instantiateViewControllerWithIdentifier:NSStringFromClass([self class])];
}
@end



@interface HHBadgeViewController : UIViewController

/// 动画类型
@property (nonatomic, assign)HHBadgeAnimationType type;

@end

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.tableView.tableFooterView = [[UIView alloc]init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HHBadgeViewController *badge = [HHBadgeViewController loadFromStoryboard];
    badge.type = indexPath.row;
    [self.navigationController pushViewController:badge animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end



@interface HHBadgeViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *add;

@property (weak, nonatomic) IBOutlet UILabel *customCountStyle;
@property (weak, nonatomic) IBOutlet UILabel *defaultCountStyle;

@property (weak, nonatomic) IBOutlet UILabel *customDotStyle;
@property (weak, nonatomic) IBOutlet UILabel *defaultDotStyle;

@end

@implementation HHBadgeViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupBasic];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.add.hh_badge = [HHCountBadge badgeWithCount:9];
}

- (IBAction)increase:(UIButton *)sender {
    [(HHCountBadge *)self.add.hh_badge increaseWithAnimationType:self.type];
    
    [(HHCountBadge *)self.defaultCountStyle.hh_badge increaseWithAnimationType:self.type];
    [(HHCountBadge *)self.customCountStyle.hh_badge increaseWithAnimationType:self.type];
    
    [(HHDotBadge *)self.defaultDotStyle.hh_badge doAnimationWithType:self.type];
    [(HHDotBadge *)self.customDotStyle.hh_badge doAnimationWithType:self.type];
}
- (IBAction)decrease:(UIButton *)sender {
    [(HHCountBadge *)self.add.hh_badge decreaseWithAnimationType:self.type];
    
    [(HHCountBadge *)self.defaultCountStyle.hh_badge decreaseWithAnimationType:self.type];
    [(HHCountBadge *)self.customCountStyle.hh_badge decreaseWithAnimationType:self.type];
    
    [(HHDotBadge *)self.defaultDotStyle.hh_badge doAnimationWithType:self.type];
    [(HHDotBadge *)self.customDotStyle.hh_badge doAnimationWithType:self.type];
}
- (void)setupBasic {
    self.title = @"Badge";
    
    // viewDidLoad中设置item的hh_badge属性是没有效果的，因为此时item的view属性还未加载
    // 如果此控制器为navigationController的跟控制器可以在viewDidLoad中设置
//    self.add.hh_badge = [HHCountBadge badgeWithCount:9];
    
    self.customCountStyle.hh_badge = [HHCountBadge badgeWithCount:99];
    [(HHCountBadge *)self.customCountStyle.hh_badge applyStyle:^(HHCountBadgeStyle *style) {
        style.bgColor = [UIColor cyanColor];
        style.borderColor = [UIColor redColor];
        style.borderWidth = 1;
    }];
    // 向左移5， 向下移5
    [(HHCountBadge *)self.customCountStyle.hh_badge moveByX:-5 Y:5];
    
    self.defaultCountStyle.hh_badge = [HHCountBadge badgeWithCount:9];
    
    self.customDotStyle.hh_badge = [HHDotBadge badge];
    [(HHDotBadge *)self.customDotStyle.hh_badge applyStyle:^(HHDotBadgeStyle *style) {
        style.bgColor = [UIColor cyanColor];
        style.borderColor = [UIColor redColor];
        style.borderWidth = 1;
    }];
    // 向左移5， 向下移5
    [(HHDotBadge *)self.customDotStyle.hh_badge moveByX:-5 Y:5];
    
    self.defaultDotStyle.hh_badge = [HHDotBadge badge];
}

@end

