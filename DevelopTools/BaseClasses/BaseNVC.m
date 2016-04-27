//
//  BaseNVC.m
//  uBing
//
//  Created by Johnson on 7/3/14.
//  Copyright (c) 2014 apple. All rights reserved.
//

#import "BaseNVC.h"
#import "UINavigationController+Tools.h"
#import "CustomTabBar.h"

//#import "CoilVC.h"
//#import "PrivateChatVC.h"
//#import "ContactVC.h"
//#import "LookAtVC.h"
//#import "MineVC.h"

@interface BaseNVC () <UINavigationControllerDelegate>
@property (nonatomic, strong) CustomTabBar *customTabBar;
@property (nonatomic, assign) NSInteger currentIndex;

//@property (nonatomic, strong) CoilVC *coilVC;
//@property (nonatomic, strong) PrivateChatVC *privateChatVC;
//@property (nonatomic, strong) ContactVC *contactVC;
//@property (nonatomic, strong) LookAtVC *lookAtVC;
//@property (nonatomic, strong) MineVC *mineVC;
@end

@implementation BaseNVC


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName: FONT(18)};
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    NSString *fileName = isSizeOf_5_5 ? @"iPhone6p" : isSizeOf_4_7 ? @"iPhone6,6s顶部背景" : @"iPhone4，4s，5,5s顶部背景";
    [self.navigationBar setBackgroundImage:LOAD_IMAGE_FROM_MAIN_BUNDLE(fileName) forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];
    self.navigationBar.translucent = NO;
    
    [self.navigationBar addResignFirstResponderGesture];
    
    self.delegate = self;
    
    
    self.currentIndex = MAXFLOAT;
    [self.view addSubview:self.customTabBar];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [super pushViewController:viewController animated:animated];
    [self hiddenTabBar:self.viewControllers.count == 1 ? NO : YES animation:YES];
//    JUDGE_IF(self.viewControllers.count > 1, [self hiddenTabBar:YES animation:YES])
}

- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated
{
    NSArray *ay = [super popToRootViewControllerAnimated:YES];
//    [self hiddenTabBar:NO animation:YES];
    return ay;
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    id vc = [super popViewControllerAnimated:animated];
//    JUDGE_IF(self.viewControllers.count == 1, [self hiddenTabBar:NO animation:YES]);
    return vc;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated;
{

}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated;
{
    [self hiddenTabBar:self.viewControllers.count == 1 ? NO : YES animation:YES];
}

#pragma mark - Methods
- (void)hiddenTabBar:(BOOL)hidden animation:(BOOL)animation
{
    if (hidden) {
        [UIView animateWithDuration:animation ? 0.3f : 0 animations:^{
            RESET_FRAME_ORIGIN_Y(self.customTabBar, SCREEN_HEIGHT);
        }];
    }else {
        [UIView animateWithDuration:animation ? 0.3f : 0 animations:^{
            RESET_FRAME_ORIGIN_Y(self.customTabBar, SCREEN_HEIGHT - SIZE_H(self.customTabBar));
        }];
    }
}

- (void)selectItem:(NSInteger)item;
{
    [self.customTabBar selectItem:item];
}

#pragma mark - GetMethods
- (CustomTabBar *)customTabBar
{
    if (!_customTabBar) {
        @weakify(self);
        _customTabBar = [[CustomTabBar alloc] initWithFrame:RECT(0, SCREEN_HEIGHT - TABBAR_HEIGHT, SCREEN_WIDTH, TABBAR_HEIGHT)
                                                     titles:@[@"圈儿", @"私聊", @"通讯录", @"看看", @"我"]
                                           normalImageNames:@[@"圈儿1", @"私聊1", @"通讯录1", @"看看1", @"我1"]
                                      highlightedImageNames:@[@"圈儿2", @"私聊2", @"通讯录2", @"看看2", @"我2"]
                                                   complete:^(NSInteger index, UIButton *button) {
                                                       @strongify(self);
                                                       if (index == self.currentIndex) {
                                                           return;
                                                       }
                                                       
//                                                       id vc = nil;
//                                                       switch (index) {
//                                                           case 0:
//                                                               vc = self.coilVC ?: (self.coilVC = [[CoilVC alloc] init]);
//                                                               [vc setTitle:@"圈儿"];
//                                                               break;
//                                                           case 01:
//                                                               vc = self.privateChatVC ?: (self.privateChatVC = [[PrivateChatVC alloc] init]);
//                                                               [vc setTitle:@"私聊"];
//                                                               break;
//                                                           case 02:
//                                                               vc = self.contactVC ?: (self.contactVC = [[ContactVC alloc] init]);
//                                                               [vc setTitle:@"通讯录"];
//                                                               break;
//                                                           case 03:
//                                                               vc = self.lookAtVC ?: (self.lookAtVC = [[LookAtVC alloc] init]);
//                                                               [vc setTitle:@"看看"];
//                                                               break;
//                                                           default:
//                                                               vc = self.mineVC ?: (self.mineVC = [[MineVC alloc] init]);
//                                                               [vc setTitle:@"我"];
//                                                               break;
//                                                       }
//                                                       [self setViewControllers:@[vc]];
                                                       self.currentIndex = index;
        }];
    }
    return _customTabBar;
}

@end