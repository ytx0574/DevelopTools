//
//  ColorManager.h
//  Music_Demo
//
//  Created by Xu on 13-8-29.
//  Copyright (c) 2013年 Xu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor(ColorManager)

/*
 所有方法参数不对,均返回clearColor
 */

/**
 *  16进制颜色  透明度 colorWithHex:0xea4b35 alpha:1.f
 *
 *  @param hexValue   hexValue
 *  @param alphaValue alpha
 *
 *  @return UIColor
 */
+ (UIColor*)colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue;
/**
 *  16进制颜色(html颜色值)字符串转为UIColor
 *
 *  @param color 16进制颜色值
 *
 *  @return UIColor
 */
+ (UIColor *)colorWithHexString: (NSString *)color;
/**
 *  用RGB值来获取颜色
 *
 *  @param red   red
 *  @param green green
 *  @param blue  blue
 *  @param alpha alpha
 *
 *  @return UIColor
 */
+ (UIColor *)colorWithRGB:(float)red Green:(float) green Blue:(float)blue Alpha:(float)alpha;
/**
 *  获取UIImage的颜色  (得到的颜色就是整个图片的背景颜色)
 *
 *  @param img UIImage
 *
 *  @return UIColor
 */
+ (UIColor *)colorWIthImage:(UIImage *)img;
/**
 *  返回一个颜色的red数值
 *
 *  @return red值
 */
- (CGFloat)red;
/**
 *  返回一个颜色的green数值
 *
 *  @return green值
 */
- (CGFloat)green;
/**
 *  返回一个颜色的blue数值
 *
 *  @return blue值
 */
- (CGFloat)blue;
/**
 *  返回一个颜色的alpha值
 *
 *  @return alpha值
 */
- (CGFloat)alpha;
/**
 *  生成darkerColor
 *
 *  @return darkerColor
 */
- (UIColor *)darkerColor;
/**
 *  生成lighterColor
 *
 *  @return lighterColor
 */
- (UIColor *)lighterColor;
/**
 *  返回是否是lighterColor
 *
 *  @return YES/NO
 */
- (BOOL)isLighterColor;
/**
 *  返回是否是clearColor
 *
 *  @return YES/NO
 */
- (BOOL)isClearColor;

@end
