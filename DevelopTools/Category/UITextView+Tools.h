//
//  UITextView+Tools.h
//  RedLawyerC
//
//  Created by Johnson on 10/12/15.
//  Copyright (c) 2015 成都洪茂科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (Tools)

@property (nonatomic, assign) BOOL enableClipboard;

/**限制文本输入长度*/
- (void)limitTextLength:(NSInteger)length complete:(void(^)())complete;
@end
