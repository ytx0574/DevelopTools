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

@interface UIView(Tools)<UITextFieldDelegate>

- (void)roundCorner;

- (void)rotateViewStart;

- (void)rotateViewStop;

- (void)addSubviews:(UIView *)view,... NS_REQUIRES_NIL_TERMINATION;

- (void)animationAlertSmall;//alertView动画,抖动小

- (void)animationAlert;//alerView动画

- (void)animationDismiss;

- (void)startAnimationWithCurve:(CGPoint)startPoint endPoint:(CGPoint) endPoint;

- (void)makeAPhoneCall:(NSString *)phoneNumber;

@end

#pragma mark - SDWebImage
@interface UIView (SDWebImage)
///**
// *  UIImageView设置图片
// *
// *  @param urlString 图片链接
// */
//- (void)imageViewWithUrlString:(NSString *)urlString placeholderImage:(UIImage *)placeholder;
///**
// *  UIButton设置Image
// *
// *  @param urlString 图片链接
// *  @param state UIControlState
// */
//- (void)buttonSetImageWithUrlString:(NSString *)urlString  forState:(UIControlState)state placeholderImage:(UIImage *)placeholder;
///**
// *  UIButton设置BackgroundImage
// *
// *  @param urlString 图片链接
// *  @param state     UIControlState
// */
//- (void)buttonSetBackgroundImageWithUrlString:(NSString *)urlString  forState:(UIControlState)state placeholderImage:(UIImage *)placeholder;
///**
// *  下载图片
// *
// *  @param urlString      图片链接
// *  @param progressBlock  下载进度回调
// *  @param completedBlock 下载完成回调
// */
//- (void)downloadImageWithUrlString:(NSString *)urlString progress:(SDWebImageDownloaderProgressBlock)progressBlock completed:(SDWebImageCompletionBlock)completedBlock;

@end