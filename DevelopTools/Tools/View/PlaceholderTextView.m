//
//  PlaceholderTextView.m
//  SmartEstate
//
//  Created by Johnson on 15/3/17.
//  Copyright (c) 2015年 pretang. All rights reserved.
//

#import "PlaceholderTextView.h"

@interface PlaceholderTextView ()
{
    CGRect _frame;
}
@property (nonatomic, strong) UILabel *labelPlaceholder;
@property (nonatomic, strong) void(^frameChangedComplete)(CGFloat height, CGFloat keyboardAnimationTime);
@end

@implementation PlaceholderTextView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUp];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setUp];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

#pragma mark - Methods
- (void)setUp
{
    _frame = self.frame;
    [self insertSubview:self.labelPlaceholder atIndex:0];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TextViewValueChanged:) name:UITextViewTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)overlapHeight:(void(^)(CGFloat height, CGFloat keyboardAnimationTime))frameChangedComplete;
{
    self.frameChangedComplete = frameChangedComplete;
}

#pragma mark - SetMethods
- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    self.labelPlaceholder.text = self.text.length > 0 ? nil : self.placeholder;
    CGRect rect = self.labelPlaceholder.frame;
    rect.size = STRING_WITH_SIZE_AND_DEFAULT_HEIGHT(self.labelPlaceholder.text, self.labelPlaceholder.font, self.labelPlaceholder.bounds.size.width);
    self.labelPlaceholder.frame = rect;
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    self.labelPlaceholder.font = font;
}

#pragma mark - GetMethods
- (UILabel *)labelPlaceholder
{
    if (!_labelPlaceholder) {
        UIView *view = self.subviews.firstObject;
        _labelPlaceholder = [[UILabel alloc] initWithFrame:CGRectMake(view.frame.origin.x + 3, view.frame.origin.y + 8, self.bounds.size.width, self.bounds.size.height)];
        _labelPlaceholder.numberOfLines = 100;
        _labelPlaceholder.textColor = [UIColor lightGrayColor];
        _labelPlaceholder.text = _placeholder;
    }
    return _labelPlaceholder;
}

#pragma mark - Noti
- (void)TextViewValueChanged:(NSNotification *)noti
{
    self.labelPlaceholder.text = self.text.length > 0 ? nil : self.placeholder;
}

- (void)keyboardFrameChange:(NSNotification *)noti
{
    NSValue *value = noti.userInfo[UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrame = value.CGRectValue;
    CGRect rect = [self.superview convertRect:_frame toView:KEY_WINDOW];

    self.frameChangedComplete ? self.frameChangedComplete((SCREEN_HEIGHT - keyboardFrame.size.height) - (rect.size.height + rect.origin.y), [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue]) : nil;
}
@end
