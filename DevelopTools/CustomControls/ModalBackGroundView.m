//
//  ModalBackGroundView.m
//  RedLawyerC
//
//  Created by Johnson on 10/21/15.
//  Copyright (c) 2015 成都洪茂科技有限公司. All rights reserved.
//

#import "ModalBackGroundView.h"

@interface ModalBackGroundView ()
@property (nonatomic, strong) UIButton *buttonBackGround;
@property (nonatomic, weak) UIView *viewBottom;
@property (nonatomic, weak) UIView *viewCenter;

@property (nonatomic, assign) BOOL isGrayHidden;
@end

@implementation ModalBackGroundView

- (instancetype)initWithViewCenter:(UIView *)view isGrayHidden:(BOOL)hidden;
{
    self = [super init];
    if (self) {
        self.viewCenter = view;
        self.isGrayHidden = hidden;
        [self setUp:YES];
    }
    return self;
}

- (instancetype)initWithViewBottom:(UIView *)view isGrayHidden:(BOOL)hidden;
{
    self = [super init];
    if (self) {
        self.viewBottom = view;
        self.isGrayHidden = hidden;
        [self setUp:YES];
    }
    return self;
}

- (void)setUp:(BOOL)first;
{
    if (first) {
        self.frame = RECT_ORIGIN_SIZE(CGPointZero, [[UIScreen mainScreen] bounds].size);
        self.buttonBackGround = [[UIButton alloc] initWithFrame:self.bounds];
        self.isGrayHidden ? [self.buttonBackGround addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside] : nil;
        self.buttonBackGround.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
        [self addSubview:self.buttonBackGround];
        
        if (self.viewBottom) {
            RESET_FRAME_ORIGIN_Y(self.viewBottom, SCREEN_HEIGHT);
            [self addSubview:self.viewBottom];
        }else {
            self.viewCenter.center = self.center;
            [self addSubview:self.viewCenter];
        }
    }
    
    if (self.viewBottom) {
        self.hidden = NO;
        [UIView animateWithDuration:0.25 animations:^{
            RESET_FRAME_ORIGIN_Y(self.viewBottom, SCREEN_HEIGHT - SIZE_H(self.viewBottom));
        }];
    }else {
        self.hidden = NO;
        self.viewCenter.alpha = 1.0;
        self.viewCenter.transform = CGAffineTransformMakeScale(1, 1);
        [self.viewCenter animationAlert];
    }
}

- (void)dismiss
{
    if (self.viewCenter) {
        [UIView animateWithDuration:0.25 animations:^{
            self.viewCenter.alpha = 0.0;
            self.viewCenter.transform = CGAffineTransformMakeScale(0.8, 0.8);
        } completion:^(BOOL finished) {
            self.callBack ? self.callBack() : nil;
            self.hidden = YES;
        }];
    }else {
        [UIView animateWithDuration:0.25 animations:^{
            RESET_FRAME_ORIGIN_Y(self.viewBottom, SCREEN_HEIGHT);
        } completion:^(BOOL finished) {
            self.callBack ? self.callBack() : nil;
            self.hidden = YES;
        }];
    }
}

+ (instancetype)showBottom:(UIView *)view isGrayHidden:(BOOL)hidden;
{
    if ([KEY_WINDOW.subviews.lastObject isKindOfClass:[self class]]) {
        [CONVERTION_TYPE(ModalBackGroundView, KEY_WINDOW.subviews.lastObject) setUp:NO];
        return KEY_WINDOW.subviews.lastObject;
    }else {
        ModalBackGroundView *modalView = [[[self class] alloc] initWithViewBottom:view isGrayHidden:hidden];
        [KEY_WINDOW addSubview:modalView];
        return modalView;
    }
}

+ (instancetype)showCenter:(UIView *)view isGrayHidden:(BOOL)hidden;
{
    if ([KEY_WINDOW.subviews.lastObject isKindOfClass:[self class]]) {
        [CONVERTION_TYPE(ModalBackGroundView, KEY_WINDOW.subviews.lastObject) setUp:NO];
        return KEY_WINDOW.subviews.lastObject;
    }else {
        ModalBackGroundView *modalView = [[[self class] alloc] initWithViewCenter:view isGrayHidden:hidden];
        [modalView setValue:@(hidden) forKey:@"isGrayHidden"];
        [KEY_WINDOW addSubview:modalView];
        return modalView;
    }
}

- (void)dismiss:(void(^)(void))complete;
{
    self.callBack = complete;
    [self dismiss];
}
@end
