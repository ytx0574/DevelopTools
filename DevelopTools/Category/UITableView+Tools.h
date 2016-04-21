//
//  UITableView+Tools.h
//  AdvisoryLawyer
//
//  Created by Johnson on 1/6/16.
//  Copyright © 2016 Johnson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (Tools)
/**
 *  无数据显示在表格中间显示文字提示
 *
 *  @param tips <#tips description#>
 *
 */
- (void)showNothingTips:(NSString *)tips;
/**
 *  无数据显示在表格中间显示图片提示
 *
 *  @param image <#image description#>
 *
 */
- (void)showNothingImage:(UIImage *)image;
/**
 *  显示重新加载
 *
 *  @param tips     <#tips description#>
 *  @param complete <#complete description#>
 */
- (void)showReloadTips:(NSString *)tips complete:(void(^)(void))complete;

@end
