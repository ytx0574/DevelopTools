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

- (CGRect)sizeFromWidth:(CGFloat)width
{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, self.frame.size.height);
    [self sizeToFit];
    return self.frame;
}

- (void)sizeFromText:(NSString *)text lineSpacing:(CGFloat)spacing;  //defult width
{
    self.text = text;
    [self sizeToFit];
    
    NSInteger row = SIZE_H(self) / self.font.lineHeight;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = row == 1 ? 0 : spacing;
    NSDictionary *attributes = @{NSFontAttributeName: self.font, NSParagraphStyleAttributeName: paragraphStyle};
    self.attributedText = [[NSAttributedString alloc] initWithString:text attributes:attributes];
    [self sizeToFit];
}

- (CGRect)sizeFromWidth:(CGFloat)width withText:(NSString *)text lineSpacing:(CGFloat)spacing;
{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, self.frame.size.height);
    self.text = text;
    [self sizeToFit];
    
    NSInteger row = SIZE_H(self) / self.font.lineHeight;
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = row == 1 ? 0 : spacing;
    NSDictionary *attributes = @{NSFontAttributeName: self.font, NSParagraphStyleAttributeName: paragraphStyle};
    self.attributedText = [[NSAttributedString alloc] initWithString:text attributes:attributes];
    
    [self sizeToFit];
    return self.frame;
}

- (CGSize)sizeOfText:(CGFloat)width
{
    return STRING_WITH_SIZE_AND_DEFAULT_HEIGHT(self.text, self.font, width);
}

- (void)alignTop
{
    self.numberOfLines = NSIntegerMax;
    CGSize fontSize = [self sizeOfText:self.bounds.size.width];
    if (self.bounds.size.height > fontSize.height) {
        NSInteger newLinesToPad = (self.bounds.size.height - fontSize.height) / self.font.lineHeight;
        for(int i = 0; i < newLinesToPad; i++)
            self.text = [self.text stringByAppendingString:@"\n"];
    }
}

- (void)alignBottom
{
    self.numberOfLines = NSIntegerMax;
    CGSize fontSize = [self sizeOfText:self.bounds.size.width];
    if (self.bounds.size.height > fontSize.height) {
        NSInteger newLinesToPad = (self.bounds.size.height - fontSize.height) / self.font.lineHeight;
        for(int i = 0; i < newLinesToPad; i++)
            self.text = [NSString stringWithFormat:@"\n%@",self.text];
    }
}

@end
