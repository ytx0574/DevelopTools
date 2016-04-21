//
//  ShareView.m
//  RedLawyerC
//
//  Created by Johnson on 10/14/15.
//  Copyright (c) 2015 成都洪茂科技有限公司. All rights reserved.
//

#import "ShareView.h"
#import "ShareBottomView.h"

@interface ShareView ()
@property (nonatomic, strong) UIButton *buttonBackGround;
@property (nonatomic, strong) ShareBottomView *viewBottom;

@property (nonatomic, strong) NSMutableArray *arrayButtons;
@end

@implementation ShareView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = RECT_ORIGIN_SIZE(CGPointZero, [[UIScreen mainScreen] bounds].size);
        self.buttonBackGround = [[UIButton alloc] initWithFrame:self.bounds];
        [self.buttonBackGround addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        self.buttonBackGround.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
        [self addSubview:self.buttonBackGround];
        [self addSubview:self.viewBottom];
        [UIView animateWithDuration:0.25 animations:^{
            RESET_FRAME_ORIGIN_Y(self.viewBottom, SCREEN_HEIGHT - SIZE_H(self.viewBottom));
        }];
    }
    return self;
}

- (ShareBottomView *)viewBottom
{
    if (!_viewBottom) {
        self.arrayButtons = [NSMutableArray array];
        _viewBottom = [[ShareBottomView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 183)];
        WEAK_SELF
        [_viewBottom shareComplete:^(ShareType shareType) {
            wself.callBack ? wself.callBack(shareType) : nil;
            [wself removeFromSuperview];
        }];
    }
    return _viewBottom;
}

- (void)dismiss
{
    [self.buttonBackGround removeFromSuperview];
    [UIView animateWithDuration:0.25 animations:^{
        RESET_FRAME_ORIGIN_Y(self.viewBottom, SCREEN_HEIGHT);
    } completion:^(BOOL finished) {
        [self.viewBottom removeFromSuperview];
        [self removeFromSuperview];
    }];
}

+ (void)show:(void(^)(NSInteger index))complete;
{
    ShareView *view = [[[self class] alloc] init];
    view.callBack = complete;
    [APPDELEGATE_WINDOW addSubview:view];
}
@end
