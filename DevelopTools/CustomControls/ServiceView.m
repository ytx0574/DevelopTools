//
//  CustomView.m
//  RedLawyerC
//
//  Created by Johnson on 10/8/15.
//  Copyright (c) 2015 成都洪茂科技有限公司. All rights reserved.
//

#import "ServiceView.h"

@interface ServiceView ()
@property (nonatomic, strong) UIView *viewBackGround;
@property (nonatomic, strong) UIView *viewCenter;

@property (nonatomic, strong) NSArray *arrayButtons;
@end

@implementation ServiceView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = RECT_ORIGIN_SIZE(CGPointZero, [[UIScreen mainScreen] bounds].size);
        self.viewBackGround = [[UIView alloc] initWithFrame:self.bounds];
        self.viewBackGround.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
        [self addSubview:self.viewBackGround];
        [self addSubview:self.viewCenter];
        [self.viewCenter animationAlert];
    }
    return self;
}

- (UIView *)viewCenter
{
    if (!_viewCenter) {
        CGFloat width = SCREEN_WIDTH - 25 * 2;
        _viewCenter = [[UIView alloc] initWithFrame:RECT(0, 0, width, width)];
        _viewCenter.center = self.center;
        _viewCenter.backgroundColor = RGB(250, 0, 60);
        _viewCenter.layer.cornerRadius = 10;
        _viewCenter.layer.masksToBounds = YES;
        
        UIButton *buttonClose = [UIButton buttonWithType:UIButtonTypeCustom];
        [buttonClose setImage:LOAD_IMAGE_FROM_MAIN_BUNDLE(@"Close") forState:UIControlStateNormal];
        buttonClose.frame = RECT(0, 0, 44, 44);
        [buttonClose addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [_viewCenter addSubview:buttonClose];
        
        UIImage *image = LOAD_IMAGE_FROM_MAIN_BUNDLE(@"Face");
        UIImageView *imageViewFace = [[UIImageView alloc] initWithFrame:RECT_SIZE((SIZE_W(_viewCenter) - image.size.width) / 2, 30, image.size)];
        imageViewFace.image = image;
        [_viewCenter addSubview:imageViewFace];
        
        CGFloat intervalH = iSWidth320 ? 10 : 18;
        
        UILabel *lableTips = [[UILabel alloc] initWithFrame:RECT(0, ORIGIN_Y_ADD_SIZE_H(imageViewFace) + intervalH, SIZE_W(_viewCenter), 30)];
        lableTips.font = FONT(19);
        lableTips.text = @"选择服务方式";
        lableTips.textAlignment = NSTextAlignmentCenter;
        lableTips.backgroundColor = [UIColor clearColor];
        lableTips.textColor = [UIColor whiteColor];
        [_viewCenter addSubview:lableTips];
        
        
        CGFloat buttonHeight = (SIZE_H(_viewCenter) - ORIGIN_Y_ADD_SIZE_H(lableTips) - intervalH) / 2;
        UIButton *buttonCall = [UIButton buttonWithType:UIButtonTypeCustom];
        [buttonCall setImage:LOAD_IMAGE_FROM_MAIN_BUNDLE(@"Call") forState:UIControlStateNormal];
        [buttonCall setTitle:@"电话咨询" forState:UIControlStateNormal];
        buttonCall.titleLabel.font = BOLDFONT(20);
        buttonCall.frame = RECT(0, ORIGIN_Y_ADD_SIZE_H(lableTips) + intervalH, SIZE_W(_viewCenter), buttonHeight);
        [buttonCall setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#e10035"] Size:SIZE(buttonCall)] forState:UIControlStateNormal];
        [buttonCall setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#cf0031"] Size:SIZE(buttonCall)] forState:UIControlStateHighlighted];
        [buttonCall setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [buttonCall setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
        [buttonCall setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -10)];
        [buttonCall addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [_viewCenter addSubview:buttonCall];
        
        UIButton *buttonConsult = [UIButton buttonWithType:UIButtonTypeCustom];
        [buttonConsult setImage:LOAD_IMAGE_FROM_MAIN_BUNDLE(@"Consult") forState:UIControlStateNormal];
        [buttonConsult setTitle:@"在线咨询" forState:UIControlStateNormal];
        buttonConsult.titleLabel.font = BOLDFONT(19);
        buttonConsult.frame = RECT(0, ORIGIN_Y_ADD_SIZE_H(buttonCall), SIZE_W(_viewCenter), buttonHeight);
        [buttonConsult setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#e10035"] Size:SIZE(buttonCall)] forState:UIControlStateNormal];
        [buttonConsult setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"#cf0031"] Size:SIZE(buttonCall)] forState:UIControlStateHighlighted];
        [buttonConsult setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [buttonConsult setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
        [buttonConsult setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -10)];
        [buttonConsult addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [_viewCenter addSubview:buttonConsult];
        
        UIView *viewLine = [[UIView alloc] initWithFrame:RECT(0, 0, SIZE_W(buttonCall), 1)];
        viewLine.backgroundColor = RGB(199, 0, 47);
        [buttonCall addSubview:viewLine];
        
        UIView *viewLine1 = [[UIView alloc] initWithFrame:RECT(0, 0, SIZE_W(buttonCall), 1)];
        viewLine1.backgroundColor = RGB(199, 0, 47);
        [buttonConsult addSubview:viewLine1];
        
        self.arrayButtons = [NSArray arrayWithObjects:buttonClose, buttonCall, buttonConsult, nil];
    }
    return _viewCenter;
}

- (void)click:(UIButton *)button
{
    self.viewBackGround.hidden = YES;
    [UIView animateWithDuration:0.25 animations:^{
        self.viewCenter.alpha = 0.0;
        self.viewCenter.transform = CGAffineTransformMakeScale(0.8, 0.8);
    } completion:^(BOOL finished) {
        self.callBack ? self.callBack([self.arrayButtons indexOfObject:button]) : nil;
        [self removeFromSuperview];
    }];
}

+ (void)show:(void(^)(NSInteger index))complete
{
    ServiceView *view = [[[self class] alloc] init];
    view.callBack = complete;
    [APPDELEGATE_WINDOW addSubview:view];
}

@end
