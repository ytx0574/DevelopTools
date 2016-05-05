//  github: https://github.com/MakeZL/UIView-Category
//  author: @email <120886865@qq.com>
//
//  UIView+MBIBnspectable.h
//  MakeZL
//
//  Created by 张磊 on 15/4/29.
//  Copyright (c) 2015年 www.weibo.com/makezl All rights reserved.
//

#import <UIKit/UIKit.h>
IB_DESIGNABLE

/**使用的时候注意设置顺序 不然会显示不出来*/
@interface UIView (MBIBnspectable)

@property (assign,nonatomic) IBInspectable NSInteger cornerRadius;
@property (assign,nonatomic) IBInspectable NSInteger borderWidth;
@property (assign,nonatomic) IBInspectable BOOL      masksToBounds;
// set border hex color
@property (strong,nonatomic) IBInspectable NSString  *borderHexRgb;
@property (strong,nonatomic) IBInspectable UIColor   *borderColor;
// set background hex color
@property (assign,nonatomic) IBInspectable NSString  *hexRgbColor;
@property (assign,nonatomic) IBInspectable BOOL      onePx;


@property (nonatomic, assign) IBInspectable BOOL showTopLine;
@property (nonatomic, assign) IBInspectable BOOL showBottomLine;

@property (nonatomic, assign) IBInspectable CGFloat lineHeight;
@property (nonatomic, assign) IBInspectable UIColor *lineColor;


/**bottomLine Edge Left*/
@property (nonatomic, assign) IBInspectable CGFloat BL_Edge_Left;

@end