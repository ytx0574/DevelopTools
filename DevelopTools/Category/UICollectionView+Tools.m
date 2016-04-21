//
//  UICollectionView+Tools.m
//  RedLawyerC
//
//  Created by Johnson on 11/6/15.
//  Copyright (c) 2015 成都洪茂科技有限公司. All rights reserved.
//

#import "UICollectionView+Tools.h"
#import <objc/runtime.h>

#define LabelTag 7932
#define ImageViewTag 7934

@interface UICollectionView ()
@property (nonatomic, strong) UIView *nothingView;
@end

@implementation UICollectionView (Tools)

static char NothingViewKey;

- (BOOL)showNothingTips:(NSString *)tips
{
    if (!self.nothingView) {
        self.nothingView = [[UIView alloc] initWithFrame:self.frame];
        [self.superview addSubview:self.nothingView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:self.bounds];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor lightGrayColor];
        
        label.tag = LabelTag;
        [self.nothingView addSubview:label];
    }
    
    UILabel *label = (id)[self.nothingView viewWithTag:LabelTag];
    label.text = tips;
    
    return [self isShowNothingView];
}

- (BOOL)showNothingImage:(UIImage *)image
{
    if (!self.nothingView) {
        self.nothingView = [[UIView alloc] initWithFrame:self.frame];
        [self.superview addSubview:self.nothingView];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        imageView.contentMode = UIViewContentModeCenter;
        
        imageView.tag = ImageViewTag;
        [self.nothingView addSubview:imageView];
    }
    
    UIImageView *imageView = (id)[self.nothingView viewWithTag:ImageViewTag];
    imageView.image = image;
    
    return [self isShowNothingView];
}

- (BOOL)isShowNothingView
{
    BOOL hidden = YES;
    if ([self.dataSource numberOfSectionsInCollectionView:self] == 0 && [self.dataSource collectionView:self numberOfItemsInSection:0] == 0) {
        hidden = NO;
    }else {
        hidden = YES;
    }
    self.nothingView.hidden = hidden;
    
    //返回是否显示tips
    return hidden;
}




- (void)setNothingView:(UIView *)nothingView
{
    objc_setAssociatedObject(self, &NothingViewKey, nothingView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)nothingView
{
    return objc_getAssociatedObject(self, &NothingViewKey);
}

@end
