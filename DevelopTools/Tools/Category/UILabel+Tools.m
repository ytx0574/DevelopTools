//
//  ff.m
//  uBing.C
//
//  Created by Johnson on 11/12/14.
//  Copyright (c) 2014 成都航旅网络科技有限公司. All rights reserved.
//

#import "UILabel+Tools.h"

@implementation UILabel(Tools)

- (CGSize)sizeOfText
{
    return [self sizeOfText:self.bounds.size.width];
}

- (CGSize)sizeOfText:(CGFloat)width
{
    CGSize size = [[[UIDevice currentDevice] systemVersion] floatValue] >= 7 ? [self.text boundingRectWithSize:CGSizeMake(width, NSIntegerMax) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName: self.font} context:nil].size : [self.text sizeWithFont:self.font constrainedToSize:CGSizeMake(width, NSIntegerMax)];
    return size;
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
