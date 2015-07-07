//
//  BaseVC.m
//  uBing
//
//  Created by Johnson on 7/3/14.
//  Copyright (c) 2014 apple. All rights reserved.
//

#import "BaseVC.h"
#import "BaseNVC.h"

@interface BaseVC ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *viewContent;

@end

@implementation BaseVC

DEALLOC_LOG

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.currentPage = 1;
    
    //防止iOS7之后,scrollview 内容偏移
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {self.automaticallyAdjustsScrollViewInsets = NO;}
    
    
    //有scrrllView时,自动添加view并且设置contentSize
    JUDGE_IF(self.scrollView && self.viewContent && ![self.scrollView.subviews containsObject:self.viewContent],[self.scrollView addSubview:self.viewContent]; self.scrollView.contentSize = SIZE(self.viewContent);)
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - GetMethdos
- (NSMutableArray *)mutableArrayWithDataSourse
{
    if (!_mutableArrayWithDataSourse) {
        _mutableArrayWithDataSourse = [NSMutableArray array];
    }
    return _mutableArrayWithDataSourse;
}

- (NSMutableDictionary *)mutableDicatinaryWithDataSourse
{
    if (!_mutableDicatinaryWithDataSourse) {
        _mutableDicatinaryWithDataSourse = [[NSMutableDictionary alloc] init];
    }
    return _mutableDicatinaryWithDataSourse;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    RESIGN_FIRST_RESPONDER;
}

@end
