//
//  ModalBackGroundView.h
//  RedLawyerC
//
//  Created by Johnson on 10/21/15.
//  Copyright (c) 2015 成都洪茂科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

/**切记在dealloc做移除操作, 否则造成循环引用*/
@interface ModalBackGroundView : UIView
+ (instancetype)showBottom:(UIView *)view isGrayHidden:(BOOL)hidden;
+ (instancetype)showCenter:(UIView *)view isGrayHidden:(BOOL)hidden;
- (void)dismiss:(void(^)(void))complete;
@end
