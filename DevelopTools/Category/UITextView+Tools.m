//
//  UITextView+Tools.m
//  RedLawyerC
//
//  Created by Johnson on 10/12/15.
//  Copyright (c) 2015 成都洪茂科技有限公司. All rights reserved.
//

#import "UITextView+Tools.h"
#import <objc/runtime.h>

@implementation UITextView (Tools)

static char EnableClipboard;

- (void)setEnableClipboard:(BOOL)enableClipboard
{
    objc_setAssociatedObject(self, &EnableClipboard, @(enableClipboard), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)enableClipboard
{
    return [objc_getAssociatedObject(self, &EnableClipboard) boolValue];
}

- (void)limitTextLength:(NSInteger)length complete:(void(^)())complete
{
    [self.rac_textSignal subscribeNext:^(NSString *x) {
        if (x.length > length) {
            self.text = [x substringToIndex:length];
            complete ? complete() : nil;
        }
    }];
}

@end
