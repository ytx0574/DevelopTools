//
//  UITextField+Shake.m
//  UITextField+Shake
//
//  Created by Andrea Mazzini on 08/02/14.
//  Copyright (c) 2014 Fancy Pixel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface  UITextField (Shake)

@property (nonatomic, assign) BOOL enableClipboard;

/**
 *  文本框抖动
 *
 *  @param times 抖动的次数
 *  @param delta 抖动的偏移量
 */
- (void)shake:(int)times withDelta:(CGFloat)delta;
/**
 *  文本框抖动
 *
 *  @param times    抖动的次数
 *  @param delta    抖动的偏移量
 *  @param interval 整个抖动的执行时间
*/
- (void)shake:(int)times withDelta:(CGFloat)delta andSpeed:(NSTimeInterval)interval;

/**限制文本输入长度*/
- (void)limitTextLength:(NSInteger)length complete:(void(^)())complete;
@end
