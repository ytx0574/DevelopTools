//
//  CustomTabBar.h
//  EducationGanzi
//
//  Created by Johnson on 8/29/15.
//  Copyright (c) 2015 Johnson. All rights reserved.
//

#import <UIKit/UIKit.h>

#define BackGroundColor       RGB(243, 243, 243)
#define LineHeight            0.5f
#define NormalTextColor       RGB(120, 127, 133)
#define HighlightTextColor    CoilMainColor
#define TextFont              FONT(11)
#define ImageEdgeInset        UIEdgeInsetsMake(-10, 0, 0, 0)

@interface CustomTabBar : UIView

/**创建TabBar, item内容为BackgroundImage*/
- (instancetype)initWithFrame:(CGRect)frame normalImageNames:(NSArray *)normalImageNames highlightedImageNames:(NSArray *)highlightedImageNames complete:(void(^)(NSInteger index, UIButton *button))complete;

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles normalImageNames:(NSArray *)normalImageNames highlightedImageNames:(NSArray *)highlightedImageNames complete:(void(^)(NSInteger index, UIButton *button))complete;

- (void)selectItem:(NSInteger)item;

@end
