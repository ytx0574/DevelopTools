//
//  BaseTVC.m
//  EducationGanzi
//
//  Created by Johnson on 8/26/15.
//  Copyright (c) 2015 Johnson. All rights reserved.
//

#import "BaseTVC.h"
#import "CustomTabBar.h"

#define Height 55

@interface BaseTVC ()
@property (nonatomic, strong) CustomTabBar *customTabBar;

@property (nonatomic, strong) NSArray *normalImageNames;
@property (nonatomic, strong) NSArray *highlightedImageNames;
@end

@implementation BaseTVC

- (instancetype)initWithNormalImageNames:(NSArray *)normalImageNames highlightedImageNames:(NSArray *)highlightedImageNames viewControllers:(NSArray *)viewControllers;
{
    if (self = [super init]) {
        self.normalImageNames = normalImageNames;
        self.highlightedImageNames = highlightedImageNames;
        self.viewControllers = viewControllers;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tabBar setHidden:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!self.customTabBar) {
        __weak typeof(self) wself = self;
        self.customTabBar = [[CustomTabBar alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - Height, SCREEN_WIDTH, Height)
//                                                          titles:@[@"哈哈", @"嘻嘻", @"呵呵", @"咳咳", @"叉叉"]
                                                normalImageNames:self.normalImageNames highlightedImageNames:self.highlightedImageNames complete:^(NSInteger index, UIButton *button) {
            [wself setSelectedIndex:index];
        }];
        [self.view addSubview:self.customTabBar];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

@end
