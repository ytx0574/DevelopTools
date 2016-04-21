//
//  UITableView+Tools.m
//  AdvisoryLawyer
//
//  Created by Johnson on 1/6/16.
//  Copyright © 2016 Johnson. All rights reserved.
//

#import "UITableView+Tools.h"
#import <objc/runtime.h>

#define LabelTag      98765
#define ImageViewTag  LabelTag + 1
#define ButtonTag     LabelTag + 2

@interface UITableView ()
@property (nonatomic, strong) UIView *nothingView;
@property (nonatomic, strong) UIView *reloadView;
@property (nonatomic, copy) void(^reloadComplete)(void);
@end

@implementation UITableView (Tools)

static char NothingViewKey = 'a';
static char ReloadViewKey  = 'b';
static char ReloadCompleteKey = 'c';

- (void)showNothingTips:(NSString *)tips
{
    if (!self.nothingView) {
        self.nothingView = [[UIView alloc] init];
        self.nothingView.userInteractionEnabled = NO;
        self.nothingView.backgroundColor = [UIColor clearColor];
        self.nothingView.hidden = self.hidden;
        [self.superview addSubview:self.nothingView];
        
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor lightGrayColor];
        
        label.tag = LabelTag;
        [self.nothingView addSubview:label];
        
        
        @weakify(self)
        [RACObserve(self, hidden) subscribeNext:^(id x) {
            @strongify(self);
            if ([x boolValue]) {
                self.nothingView.hidden = [x boolValue];
            }else {
                self.nothingView.hidden = @([self.dataSource tableView:self numberOfRowsInSection:0]).boolValue;
            }
        }];
    }
    
    self.nothingView.frame = self.frame;
    UILabel *label = (id)[self.nothingView viewWithTag:LabelTag];
    label.frame = self.bounds;
    label.text = tips;
}

- (void)showNothingImage:(UIImage *)image
{
    if (!self.nothingView) {
        self.nothingView = [[UIView alloc] init];
        self.nothingView.userInteractionEnabled = NO;
        [self.superview addSubview:self.nothingView];
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeCenter;
        
        imageView.tag = ImageViewTag;
        [self.nothingView addSubview:imageView];
    }
    
    self.nothingView.frame = self.frame;
    UIImageView *imageView = (id)[self.nothingView viewWithTag:ImageViewTag];
    imageView.frame = self.bounds;
    imageView.image = image;
}

- (void)showReloadTips:(NSString *)tips complete:(void(^)(void))complete;
{
    if (!self.reloadView) {
        self.reloadView = [[UIView alloc] init];
        self.reloadView.backgroundColor = self.backgroundColor;
        self.reloadView.hidden = self.hidden;
        [self.superview addSubview:self.reloadView];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(reloadClick:) forControlEvents:UIControlEventTouchUpInside];
        
        button.tag = ButtonTag;
        [self.reloadView addSubview:button];
        
        @weakify(self)
        [RACObserve(self, hidden) subscribeNext:^(id x) {
            @strongify(self);
            if ([x boolValue]) {
                self.reloadView.hidden = [x boolValue];
            }else {
                self.reloadView.hidden = @([self.dataSource tableView:self numberOfRowsInSection:0]).boolValue;
            }
        }];
    }else {
        self.reloadView.hidden = NO;
    }
    
    self.reloadView.frame = self.frame;
    UIButton *button = [self.reloadView viewWithTag:ButtonTag];
    [button setTitle:tips forState:UIControlStateNormal];
    button.frame = self.reloadView.bounds;
    
    self.reloadComplete = complete;
}

#pragma mark - Private Methods
- (BOOL)isShowNothingView
{
    BOOL show = YES;
    if ([self.dataSource tableView:self numberOfRowsInSection:0] == 0) {
        show = YES;
    }else {
        show = NO;
    }
    self.nothingView.hidden = !show;
    
    //返回是否显示tips
    return show;
}

- (void)reloadClick:(UIButton *)button
{
    self.reloadView.hidden = YES;
    
    self.reloadComplete ? self.reloadComplete() : nil;
}


#pragma mark - Get/Set Methods
- (void)setNothingView:(UIView *)nothingView
{
    objc_setAssociatedObject(self, &NothingViewKey, nothingView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)nothingView
{
    return objc_getAssociatedObject(self, &NothingViewKey);
}

- (void)setReloadView:(UIView *)reloadView
{
    objc_setAssociatedObject(self, &ReloadViewKey, reloadView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)reloadView
{
    return objc_getAssociatedObject(self, &ReloadViewKey);
}

- (void)setReloadComplete:(void (^)(void))reloadComplete
{
    objc_setAssociatedObject(self, &ReloadCompleteKey, reloadComplete, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(void))reloadComplete
{
    return objc_getAssociatedObject(self, &ReloadCompleteKey);
}

@end