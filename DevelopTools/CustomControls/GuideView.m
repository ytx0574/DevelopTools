//
//  UbingGuideView.m
//  uBing
//
//  Created by Johnson on 9/10/14.
//  Copyright (c) 2014 apple. All rights reserved.
//

#import "GuideView.h"
#import "UIColor+Tools.h"

#define Version               @"_AppVersion_"
#define CurrentPageColor     [UIColor colorWithHexString:@"#497EC5"]
#define PageColor            [UIColor colorWithHexString:@"#B2B2B2"]
#define ButtonSize           CGSizeMake(111, 33)

#define LoadingGuidePicture(num) [NSString stringWithFormat:@"GuidePicture.bundle/%@_GuidePicture%@", @((NSInteger)SCREEN_HEIGHT).stringValue, @(num)]

@interface GuideView () <UIScrollViewDelegate>

@end

@implementation GuideView 
{
    UIScrollView *_scrollView;
    UIPageControl *_pageControl;
}

- (instancetype)init:(NSArray *)arrayImageName showPageControl:(BOOL)showPageControl;
{
    if (self = [super init]) {
        self.frame = [[UIScreen mainScreen] bounds];
        self.backgroundColor = [UIColor yellowColor];
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * arrayImageName.count, SCREEN_HEIGHT);
        [_scrollView setPagingEnabled:YES];
        [_scrollView setShowsHorizontalScrollIndicator:NO];
        [_scrollView setDelegate:self];
        [self addSubview:_scrollView];
        [arrayImageName enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * idx, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
            imageView.image = LOAD_IMAGE_FROM_MAIN_BUNDLE(arrayImageName[idx]);
            imageView.backgroundColor = RGB(255, 253, 239);
            [imageView setUserInteractionEnabled:YES];
            [_scrollView addSubview:imageView];
        }];
        
        NSInteger intervalCenterY = isSizeOf_3_5 ? 80 : isSizeOf_4_0 ? 95 : isSizeOf_4_7 ? 112 : 123;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.bounds = RECT_ORIGIN_SIZE(CGPointZero, ButtonSize);
        
        button.center = CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT - intervalCenterY);
        [button addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView.subviews.lastObject addSubview:button];
        
        if (showPageControl) {
            _pageControl = [[UIPageControl alloc] initWithFrame:RECT(0, 0, 50, 15)];
            _pageControl.center = CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT - SIZE_H(_pageControl) + (isSizeOf_3_5 ? 0 : -10));
            _pageControl.currentPageIndicatorTintColor = [UIColor colorWithHexString:@"#497EC5"];
            _pageControl.pageIndicatorTintColor = [UIColor colorWithHexString:@"#B2B2B2"];
            _pageControl.numberOfPages = [arrayImageName count];
            [self addSubview:_pageControl];
        }
    }
    return self;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _pageControl.currentPage = scrollView.contentOffset.x / SCREEN_WIDTH;
}

- (void)dismiss:(UIButton *)button
{
    [UIView animateWithDuration:0.8f animations:^{
        [self setAlpha:0.0f];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [[NSUserDefaults standardUserDefaults] setObject:[[MAIN_BUNDLE infoDictionary] objectForKey:@"CFBundleShortVersionString"] forKey:Version];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }];
}

+ (BOOL)autoShowGuideViewForGuidePictureBundle
{
    return [GuideView autoShowGuideView:@[LoadingGuidePicture(1), LoadingGuidePicture(2), LoadingGuidePicture(3), LoadingGuidePicture(4), LoadingGuidePicture(5)]];
}

+ (BOOL)autoShowGuideView:(NSArray *)arrayImageName;
{
    return [GuideView autoShowGuideView:arrayImageName showPageControl:NO];
}

+ (BOOL)autoShowGuideView:(NSArray *)arrayImageName showPageControl:(BOOL)showPageControl;
{
    if (!LOAD_IMAGE_FROM_MAIN_BUNDLE(arrayImageName.firstObject)) {
        return NO;
    }else if (![[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:Version]]) {
        [[[[UIApplication sharedApplication] delegate] window] addSubview:[[[self class] alloc] init:arrayImageName showPageControl:showPageControl]];
    }
    return YES;
}

@end
