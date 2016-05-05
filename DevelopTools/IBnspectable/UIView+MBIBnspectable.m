//  github: https://github.com/MakeZL/UIView-Category
//  author: @email <120886865@qq.com>
//
//  UIView+MBIBnspectable.m
//  MakeZL
//
//  Created by 张磊 on 15/4/29.
//  Copyright (c) 2015年 www.weibo.com/makezl All rights reserved.
//

#import "UIView+MBIBnspectable.h"
#import <objc/runtime.h>

@implementation UIView (MBIBnspectable)

#pragma mark - setCornerRadius/borderWidth/borderColor
- (void)setCornerRadius:(NSInteger)cornerRadius{
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = cornerRadius > 0;
}

- (NSInteger)cornerRadius{
    return self.layer.cornerRadius;
}

- (void)setBorderWidth:(NSInteger)borderWidth{
    self.layer.borderWidth = borderWidth;
}

- (NSInteger)borderWidth{
    return self.layer.borderWidth;
}

- (void)setBorderColor:(UIColor *)borderColor{
    self.layer.borderColor = borderColor.CGColor;
}

- (UIColor *)borderColor{
    return [UIColor colorWithCGColor:self.layer.borderColor];
}

- (void)setBorderHexRgb:(NSString *)borderHexRgb{
    NSScanner *scanner = [NSScanner scannerWithString:borderHexRgb];
    unsigned hexNum;
    if (![scanner scanHexInt:&hexNum]) return;
    self.layer.borderColor = [self colorWithRGBHex:hexNum].CGColor;
}

-(NSString *)borderHexRgb{
    return @"0xffffff";
}

- (void)setMasksToBounds:(BOOL)bounds{
    self.layer.masksToBounds = bounds;
}

- (BOOL)masksToBounds{
    return self.layer.masksToBounds;
}

#pragma mark - hexRgbColor
- (void)setHexRgbColor:(NSString *)hexRgbColor{
    NSScanner *scanner = [NSScanner scannerWithString:hexRgbColor];
    unsigned hexNum;
    if (![scanner scanHexInt:&hexNum]) return;
    self.backgroundColor = [self colorWithRGBHex:hexNum];
}

- (UIColor *)colorWithRGBHex:(UInt32)hex {
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:1.0f];
}


- (NSString *)hexRgbColor{
    return @"0xffffff";
}

#pragma mark - setOnePx
- (void)setOnePx:(BOOL)onePx{
    if (onePx) {
        CGRect rect = self.frame;
        rect.size.height = 1.0 / [UIScreen mainScreen].scale;
        self.frame = rect;
    }
}

- (BOOL)onePx{
    return self.onePx;
}


#pragma mark - TopLineView & BottomLineView
static char TopLineKey;
- (UIView *)topLineView
{
    return objc_getAssociatedObject(self, &TopLineKey);
}

- (void)setTopLineView:(UIView *)view;
{
    objc_setAssociatedObject(self, &TopLineKey, view, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

static char BottomLineKey;
- (UIView *)bottomLineView
{
    return objc_getAssociatedObject(self, &BottomLineKey);
}

- (void)setBottomLineView:(UIView *)view;
{
    objc_setAssociatedObject(self, &BottomLineKey, view, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (BOOL)showTopLine
{
    return ![self topLineView].hidden;
}

- (void)setShowTopLine:(BOOL)showTopLine
{
    if (![self topLineView]) {
        [self setTopLineView:[[UIView alloc] init]];
        [self addSubview:[self topLineView]];
    }
    
    [[self topLineView] setHidden:!showTopLine];
}

- (BOOL)showBottomLine
{
    return ![self bottomLineView].hidden;
}

- (void)setShowBottomLine:(BOOL)showBottomLine
{
    if (![self bottomLineView]) {
        [self setBottomLineView:[[UIView alloc] init]];
        [self addSubview:[self bottomLineView]];
    }
    
    [[self bottomLineView] setHidden:!showBottomLine];
}

- (CGFloat)lineHeight
{
    return SIZE_H([self topLineView]) != 0 ? SIZE_H([self topLineView]) : SIZE_H([self bottomLineView]);
}

- (void)setLineHeight:(CGFloat)lineHeight
{
    @weakify(self)
    [RACObserve(self, frame) subscribeNext:^(id x) {
        @strongify(self);
    
        [self topLineView].frame = RECT_ORIGIN(CGPointZero, SIZE_W(self), lineHeight);
        [self bottomLineView].frame = RECT([self BL_Edge_Left], SIZE_H(self) - lineHeight, SIZE_W(self) - [self BL_Edge_Left], lineHeight);
    }];
}

- (UIColor *)lineColor
{
    return [self topLineView].backgroundColor ?: [self bottomLineView].backgroundColor;
}

- (void)setLineColor:(UIColor *)lineColor
{
    [[self topLineView] setBackgroundColor:lineColor];
    [[self bottomLineView] setBackgroundColor:lineColor];
}


- (CGFloat)BL_Edge_Left
{
    return [self bottomLineView].frame.origin.x;
}

- (void)setBL_Edge_Left:(CGFloat)BL_Edge_Left
{
    @weakify(self)
    [RACObserve(self, frame) subscribeNext:^(id x) {
        @strongify(self);
        
        [self bottomLineView].frame = RECT(BL_Edge_Left, SIZE_H(self) - [self lineHeight], SIZE_W(self), SIZE_W(self) - BL_Edge_Left);
    }];
}
@end
