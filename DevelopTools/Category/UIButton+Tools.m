//
//  UIButton+Tools.m
//  uBing
//
//  Created by Johnson on 7/5/14.
//  Copyright (c) 2014 apple. All rights reserved.
//

#import "UIButton+Tools.h"

@interface UIButton ()<NSCopying>
@property (nonatomic, strong) NSTimer *timer;
@end
@implementation UIButton (Tools)

- (void)setRadius:(float)radius;
{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerTopLeft|UIRectCornerBottomRight|UIRectCornerTopRight                                                 cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
}

@end
