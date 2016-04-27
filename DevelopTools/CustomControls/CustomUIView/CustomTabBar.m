//
//  CustomTabBar.m
//  EducationGanzi
//
//  Created by Johnson on 8/29/15.
//  Copyright (c) 2015 Johnson. All rights reserved.
//

#import "CustomTabBar.h"

@interface CustomTabBar ()
@property (nonatomic, strong) UIImageView *imageViewBackGround;
@property (nonatomic, strong) UIView *viewLine;

@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *normalImageNames;
@property (nonatomic, strong) NSArray *highlightedImageNames;
@property (nonatomic, strong) void(^clickComplete)(NSInteger index, UIButton *button);

@property (nonatomic, assign) NSInteger index;

@end

@implementation CustomTabBar

- (void)dealloc
{
    [self.imageViewBackGround.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [obj removeObserver:self forKeyPath:@"selected" context:nil];
    }];
}

- (instancetype)initWithFrame:(CGRect)frame normalImageNames:(NSArray *)normalImageNames highlightedImageNames:(NSArray *)highlightedImageNames complete:(void(^)(NSInteger index, UIButton *button))complete;
{
    return [self initWithFrame:frame titles:nil normalImageNames:normalImageNames highlightedImageNames:highlightedImageNames complete:complete];;
}

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles normalImageNames:(NSArray *)normalImageNames highlightedImageNames:(NSArray *)highlightedImageNames complete:(void(^)(NSInteger index, UIButton *button))complete;
{
    if (self = [self initWithFrame:frame]) {
        if (titles) {
            NSAssert((titles.count == normalImageNames.count && normalImageNames.count && highlightedImageNames.count), @"必须保持item标题 图片数量一致");
        }else {
            NSAssert(normalImageNames.count == highlightedImageNames.count, @"必须保持item图片数量一致");
        }
        
        self.titles = titles;
        self.normalImageNames = normalImageNames;
        self.highlightedImageNames = highlightedImageNames;
        self.clickComplete = complete;
        [self setUp];
    }
    return self;
}

#pragma mark - Methods
- (void)setUp
{
    self.imageViewBackGround = [[UIImageView alloc] init];
    self.imageViewBackGround.frame = self.bounds;
    self.imageViewBackGround.backgroundColor = BackGroundColor;
    self.imageViewBackGround.userInteractionEnabled = YES;
    [self addSubview:self.imageViewBackGround];
    
    self.viewLine = [[UIView alloc] init];
    self.viewLine.frame = CGRectMake(0, 0, SIZE_W(self.imageViewBackGround), LineHeight);
    self.viewLine.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:self.viewLine];
    
    [self.normalImageNames enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(SCREEN_WIDTH / self.normalImageNames.count * idx, 0, SCREEN_WIDTH / self.normalImageNames.count, SIZE_H(self));
        //我自己弄这么多，肯定是吃撑了
        [button addTarget:self action:@selector(clickTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [button addTarget:self action:@selector(clickTouchDown:) forControlEvents:UIControlEventTouchDown];
        [button addTarget:self action:@selector(clickTouchDragEnter:) forControlEvents:UIControlEventTouchDragEnter];
        [button addTarget:self action:@selector(clickTouchDragExit:) forControlEvents:UIControlEventTouchDragExit];
        [button addTarget:self action:@selector(clickTouchTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
        
        
        [self.imageViewBackGround addSubview:button];
        
        if (self.titles) {
            [button setImage:[UIImage imageNamed:obj] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:self.highlightedImageNames[idx]] forState:UIControlStateHighlighted];
            [button setImage:[UIImage imageNamed:self.highlightedImageNames[idx]] forState:UIControlStateSelected];
            [button setImageEdgeInsets:ImageEdgeInset];
            [button addObserver:self forKeyPath:@"selected" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, SIZE_H(button) - TextFont.lineHeight, SIZE_W(button), TextFont.lineHeight)];
            label.textAlignment = NSTextAlignmentCenter;
            label.font = TextFont;
            label.text = self.titles[idx];
            label.textColor = [UIColor blackColor];
            [button addSubview:label];
        }else {
            [button setBackgroundImage:[UIImage imageNamed:obj] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:self.highlightedImageNames[idx]] forState:UIControlStateHighlighted];
            [button setBackgroundImage:[UIImage imageNamed:self.highlightedImageNames[idx]] forState:UIControlStateSelected];
        }
    }];
    
    [self clickTouchUpInside:self.imageViewBackGround.subviews.firstObject];
}

- (void)selectItem:(NSInteger)item;
{
    [self clickTouchDown:[self.imageViewBackGround.subviews objectAtIndex:item]];
    [self clickTouchUpInside:[self.imageViewBackGround.subviews objectAtIndex:item]];
}

#pragma mark - KVC
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    UIButton *button = object;
    UILabel *label = [button.subviews.lastObject isKindOfClass:[UILabel class]] ? button.subviews.lastObject : nil;
    label.textColor = [change[NSKeyValueChangeNewKey] boolValue] ? HighlightTextColor : NormalTextColor;
}

#pragma mark - Click
- (void)clickTouchDown:(UIButton *)button
{
    UIButton *last = self.imageViewBackGround.subviews[self.index];
    if ([last isEqual:button]) {button.selected = NO;}
    
    UILabel *label = [button.subviews.lastObject isKindOfClass:[UILabel class]] ? button.subviews.lastObject : nil;
    label.textColor = HighlightTextColor;
}

- (void)clickTouchDragEnter:(UIButton *)button
{
    UILabel *label = [button.subviews.lastObject isKindOfClass:[UILabel class]] ? button.subviews.lastObject : nil;
    label.textColor = HighlightTextColor;
}

- (void)clickTouchDragExit:(UIButton *)button
{
    UILabel *label = [button.subviews.lastObject isKindOfClass:[UILabel class]] ? button.subviews.lastObject : nil;
    label.textColor =  NormalTextColor;
}

- (void)clickTouchTouchUpOutside:(UIButton *)button
{
    button.selected = [button isEqual:self.imageViewBackGround.subviews[self.index]];
}

- (void)clickTouchUpInside:(UIButton *)button
{
    UIButton *last = self.imageViewBackGround.subviews[self.index];
    last.selected = NO;
    
    self.index = [self.imageViewBackGround.subviews indexOfObject:button];
    button.selected = !last.selected;
    
    self.clickComplete ? self.clickComplete(self.index, button) : nil;
}

@end
