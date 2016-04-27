//
//  viewCategory.h
//  cloud
//
//  Created by jack ray on 11-4-16.
//  Copyright 2011年 oulin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

//#import "SDWebImageManager.h"

@interface UIView(Tools) <UITextFieldDelegate>

@property (nonatomic, copy) NSString *sizeRatio;

+ (instancetype)createLineView:(CGRect)frame color:(UIColor *)color;

- (void)addResignFirstResponderGesture;

- (void)roundCorner;

- (void)rotateViewStart;

- (void)rotateViewStop;

- (void)addSubviews:(UIView *)view,... NS_REQUIRES_NIL_TERMINATION;

- (void)animationAlertSmall;//alertView动画,抖动小

- (void)animationAlert;//alerView动画

- (void)animationDismiss;

- (void)startAnimationWithCurve:(CGPoint)startPoint endPoint:(CGPoint) endPoint;

- (void)makeAPhoneCall:(NSString *)phoneNumber;

- (void)loadImageUrlString:(NSString *)urlString placeholderImage:(UIImage *)image;
@end
