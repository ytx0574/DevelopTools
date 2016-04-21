//
//  BaseTVC.h
//  EducationGanzi
//
//  Created by Johnson on 8/26/15.
//  Copyright (c) 2015 Johnson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseTVC : UITabBarController

- (instancetype)initWithNormalImageNames:(NSArray *)normalImageNames highlightedImageNames:(NSArray *)highlightedImageNames viewControllers:(NSArray *)viewControllers;

@end
