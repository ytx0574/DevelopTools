//
//  BaseNVC.h
//  uBing
//
//  Created by Johnson on 7/3/14.
//  Copyright (c) 2014 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseNVC : UINavigationController

- (void)hiddenTabBar:(BOOL)hidden animation:(BOOL)animation;

- (void)selectItem:(NSInteger)item;
@end
