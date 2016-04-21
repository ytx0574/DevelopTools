//
//  UITextField+Shake.m
//  UITextField+Shake
//
//  Created by Andrea Mazzini on 08/02/14.
//  Copyright (c) 2014 Fancy Pixel. All rights reserved.
//

#import "UITextField+Tools.h"
#import <objc/runtime.h>

@implementation UITextField (Shake)

static char EnableClipboard;

- (void)shake:(int)times withDelta:(CGFloat)delta
{
	[self _shake:times direction:1 currentTimes:0 withDelta:delta andSpeed:0.03];
}

- (void)shake:(int)times withDelta:(CGFloat)delta andSpeed:(NSTimeInterval)interval
{
	[self _shake:times direction:1 currentTimes:0 withDelta:delta andSpeed:interval];
}

- (void)_shake:(int)times direction:(int)direction currentTimes:(int)current withDelta:(CGFloat)delta andSpeed:(NSTimeInterval)interval
{
	[UIView animateWithDuration:interval animations:^{
		self.transform = CGAffineTransformMakeTranslation(delta * direction, 0);
	} completion:^(BOOL finished) {
		if(current >= times) {
			self.transform = CGAffineTransformIdentity;
			return;
		}
		[self _shake:(times - 1)
		   direction:direction * -1
		currentTimes:current + 1
		   withDelta:delta
			andSpeed:interval];
	}];
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (self.enableClipboard) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [[UIMenuController sharedMenuController] setMenuVisible:NO animated:NO];
        }];
    }
    return [super canPerformAction:action withSender:sender];
}

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
