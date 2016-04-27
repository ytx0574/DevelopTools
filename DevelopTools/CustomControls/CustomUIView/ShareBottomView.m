//
//  ShareBottomView.m
//  RedLawyerC
//
//  Created by Johnson on 10/22/15.
//  Copyright (c) 2015 成都洪茂科技有限公司. All rights reserved.
//

#import "ShareBottomView.h"


@interface ShareBottomView ()
@property (nonatomic, strong) NSMutableArray *arrayIcons;
@property (nonatomic, strong) NSMutableArray *arrayTitles;

@property (nonatomic, strong) NSMutableArray *arrayButtons;
@end

@implementation ShareBottomView

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

- (void)setUp
{
    self.arrayIcons = [NSMutableArray array];
    self.arrayTitles = [NSMutableArray array];
    self.arrayButtons = [NSMutableArray array];
    self.backgroundColor = [UIColor whiteColor];
    
    [self.arrayIcons addObject:@"ShareSina"];
//    [Helper detectionInstallWeChat] ? [self.arrayIcons addObject:@"ShareWechat"] : nil;
    [self.arrayIcons addObject:@"ShareQZone"];
    
    [self.arrayTitles addObject:@"微博"];
//    [Helper detectionInstallWeChat] ? [self.arrayTitles addObject:@"朋友圈"] : nil;
    [self.arrayTitles addObject:@"QQ空间"];
    

    UILabel *label = [[UILabel alloc] init];
    label.text = @"分享红帽";
    label.font = FONT(16);
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = RGB(114, 112, 112);
    label.backgroundColor = [UIColor clearColor];
    [label sizeToFit];
    label.frame = RECT((SCREEN_WIDTH - SIZE_W(label)) / 2, 15, SIZE_W(label), 30);
    [self addSubview:label];
    
    CGFloat leftInterval = 22; //灰线⬅️间距
    CGFloat lineWidth = (SCREEN_WIDTH - SIZE_W(label) - leftInterval * 4) / 2;
    UIView *viewLineLeft = [[UIView alloc] initWithFrame:CGRectMake(leftInterval, ORIGIN_Y(label) + SIZE_H(label) / 2, lineWidth, 1)];
    viewLineLeft.backgroundColor = label.textColor;
    [self addSubview:viewLineLeft];
    
    UIView *viewLineRight = [[UIView alloc] initWithFrame:CGRectMake(ORIGIN_X_ADD_SIZE_W(label) + leftInterval, ORIGIN_Y(viewLineLeft), lineWidth, 1)];
    viewLineRight.backgroundColor = label.textColor;
    [self addSubview:viewLineRight];
    
    
    UIImage *image = LOAD_IMAGE_FROM_MAIN_BUNDLE(self.arrayIcons.firstObject);
    CGFloat interval = (SCREEN_WIDTH - image.size.width * self.arrayIcons.count) / (self.arrayIcons.count + 1);
    
    [self.arrayIcons enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIButton *button= [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:LOAD_IMAGE_FROM_MAIN_BUNDLE(obj) forState:UIControlStateNormal];
        button.frame = RECT_SIZE(idx * (image.size.width + interval) + interval, 68, image.size);
        [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        [self.arrayButtons addObject:button];
        
        UILabel *tLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, image.size.width, 30)];
        tLabel.center = CGPointMake(button.center.x, ORIGIN_Y_ADD_SIZE_H(button) + 12);
        tLabel.textAlignment = label.textAlignment;
        tLabel.backgroundColor = label.backgroundColor;
        tLabel.font = FONT(14);
        tLabel.text = self.arrayTitles[idx];
        [self addSubview:tLabel];
    }];
}

- (void)click:(UIButton *)button
{
    ShareType shareType = ShareTypeSina;
    
    switch ([self.arrayButtons indexOfObject:button]) {
        case 0:
            shareType = ShareTypeSina;
            break;
        case 01:
//            shareType = [Helper detectionInstallWeChat] ? ShareTypeWeChat : ShareTypeQQ;
            break;
        default:
            shareType = ShareTypeQQ;
            break;
    }
    
    self.callBack ? self.callBack(shareType) : nil;
}

- (void)shareComplete:(void(^)(ShareType shareType))complete
{
    self.callBack = complete;
}

@end
