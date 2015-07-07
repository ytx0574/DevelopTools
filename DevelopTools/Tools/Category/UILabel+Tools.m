//
//  ff.m
//  uBing.C
//
//  Created by Johnson on 11/12/14.
//  Copyright (c) 2014 成都航旅网络科技有限公司. All rights reserved.
//

#import "UILabel+Tools.h"
#import "GlobalMacro.h"

@implementation UILabel(Tools)

- (CGSize)sizeOfText
{
    return [self sizeOfText:self.bounds.size.width];
}

- (CGSize)sizeOfText:(CGFloat)width
{
    return STRING_WITH_SIZE_AND_DEFAULT_HEIGHT(self.text, self.font, width);
}

- (void)alignTop
{
    self.numberOfLines = NSIntegerMax;
    CGSize fontSize = [self sizeOfText];
    if (self.bounds.size.height > fontSize.height) {
        NSInteger newLinesToPad = (self.bounds.size.height - fontSize.height) / self.font.lineHeight;
        for(int i = 0; i < newLinesToPad; i++)
            self.text = [self.text stringByAppendingString:@"\n"];
    }
}

- (void)alignBottom
{
    self.numberOfLines = NSIntegerMax;
    CGSize fontSize = [self sizeOfText];
    if (self.bounds.size.height > fontSize.height) {
        NSInteger newLinesToPad = (self.bounds.size.height - fontSize.height) / self.font.lineHeight;
        for(int i = 0; i < newLinesToPad; i++)
            self.text = [NSString stringWithFormat:@"\n%@",self.text];
    }
}

@end
