//
//  ff.h
//  uBing.C
//
//  Created by Johnson on 11/12/14.
//  Copyright (c) 2014 成都航旅网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel(Tools)

- (CGRect)sizeFromWidth:(CGFloat)width;

- (void)sizeFromText:(NSString *)text lineSpacing:(CGFloat)spacing;;

- (CGRect)sizeFromWidth:(CGFloat)width withText:(NSString *)text lineSpacing:(CGFloat)spacing;

- (void)alignTop;

- (void)alignBottom;

@end
