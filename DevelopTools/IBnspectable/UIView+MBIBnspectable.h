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

@end


//#import <UIKit/UIKit.h>
///**已经禁用 IB_DESIGNABLE, xib报错, 太尼玛坑了*/
//@interface UIView (MBIBnspectable)
//
//@property (assign,nonatomic) NSInteger cornerRadius;
//@property (assign,nonatomic) NSInteger borderWidth;
//@property (assign,nonatomic) BOOL      masksToBounds;
//// set border hex color
//@property (strong,nonatomic) NSString  *borderHexRgb;
//@property (strong,nonatomic) UIColor   *borderColor;
//// set background hex color
//@property (assign,nonatomic) NSString  *hexRgbColor;
//@property (assign,nonatomic) BOOL      onePx;
//
//@end

