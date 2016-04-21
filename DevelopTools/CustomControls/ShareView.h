//
//  ShareView.h
//  RedLawyerC
//
//  Created by Johnson on 10/14/15.
//  Copyright (c) 2015 成都洪茂科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareView : UIView
+ (void)show:(void(^)(NSInteger index))complete;
@end
