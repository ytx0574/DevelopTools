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

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *viewContent;

@property (nonatomic, copy) void(^navigationRightBarButtonClickComplete)(NSInteger index, id item);
@property (nonatomic, copy) void(^navigationLeftBarButtonClickComplete)(NSInteger index, id item);
@property (nonatomic, copy) void(^viewDidLoadComplete)(UIViewController *viewController);

@end

@implementation BaseVC
{
    BOOL _separatorInsetNone;
}

- (void)dealloc
{
    DEALLOC_LOG;
}

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
    
    self.viewDidLoadComplete ? self.viewDidLoadComplete(self) : nil;
    
    [self autoSetBackButton];
    
    self.currentPage = 1;
    self.toTalCount = MAXFLOAT;
    
    //防止iOS7之后,scrollview 内容偏移
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {self.automaticallyAdjustsScrollViewInsets = NO;}
    
    //有scrrllView时,自动添加view并且设置contentSize
    JUDGE_IF(self.scrollView && self.viewContent && ![self.scrollView.subviews containsObject:self.viewContent], [self.scrollView addSubview:self.viewContent]; self.scrollView.contentSize = SIZE(self.viewContent);)
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if (_separatorInsetNone) {
        if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        }
        
        if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [self.tableView setLayoutMargins:UIEdgeInsetsZero];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    JUDGE_IF(self.scrollView && self.viewContent && [self.scrollView.subviews containsObject:self.viewContent], self.scrollView.contentSize = SIZE(self.viewContent);)
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    SVDismiss;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Methods
- (void)setSeparatorInsetNone;
{
    _separatorInsetNone = YES;
}

- (void)viewDidLoadComplete:(void(^)(UIViewController *viewController))complete
{
    self.viewDidLoadComplete = complete;
}

- (void)autoSetBackButton
{
    if (self.navigationController.viewControllers.count > 1) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:LOAD_IMAGE_FROM_MAIN_BUNDLE(@"箭头") forState:UIControlStateNormal];
        [button setTitle:@"返回" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        button.frame = CGRectMake(0, 0, 44, 44);
        [button sizeToFit];
        [button setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 0)];
        [button addTarget:self action:@selector(pop:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationItem.leftBarButtonItems = @[item];
    }
}

- (void)pop:(UIButton *)button
{
    RESIGN_FIRST_RESPONDER;
    self.navigationLeftBarButtonClickComplete ? self.navigationLeftBarButtonClickComplete(0, button) : [self.navigationController popViewControllerAnimated:YES];
}

- (void)getDataSourse:(NSInteger)pageNo pullState:(BOOL)state
{
    
}

- (void)setSizeRatios:(UIView *)view, ... NS_REQUIRES_NIL_TERMINATION
{
//    IF_RETURN(isSizeOf_4_7);
    GetVariableParameterWithMutableArray(view, array);
    IF_RETURN(!view || array.count == 0)
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIView *v = obj;
        v.sizeRatio = @(SIZE_W(v) / SIZE_H(v)).stringValue;
    }];
}

- (void)resetNavigationBackComplete:(void(^)(NSInteger index, id item))complete;
{
    self.navigationLeftBarButtonClickComplete = complete;
}

- (void)resetNavigationBackTitle:(NSString *)title;
{
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStyleBordered target:self action:@selector(pop:)];
    
    [left setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]} forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItems = @[left];
}

- (void)resetNavigationBackTitle:(NSString *)title image:(UIImage *)image;
{
    UIBarButtonItem *item = (id)self.navigationItem.leftBarButtonItems.firstObject;
    UIButton *button = item.customView;
    [button setTitle:title forState:UIControlStateNormal];
    [button setImage:image forState:UIControlStateNormal];
}

- (void)resetNavigationBackTitle:(NSString *)title image:(UIImage *)image complete:(void(^)(NSInteger index, id item))complete;
{
    [self resetNavigationBackTitle:title image:image];
    
    self.navigationLeftBarButtonClickComplete = complete;
}

- (void)setNavigationLeftItem:(void(^)(NSInteger index, id item))complete images:(UIImage *)image, ... NS_REQUIRES_NIL_TERMINATION;
{
    GetVariableParameterWithMutableArray(image, arrayImages);
    if (arrayImages.count == 0) {
        return;
    }
    NSMutableArray *arrayItems = [NSMutableArray array];
    [arrayImages enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithImage:[obj imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleBordered target:self action:@selector(navigationLeftBarButtonClick:)];
        [arrayItems addObject:right];
    }];
    self.navigationItem.leftBarButtonItems = arrayItems;
    
    self.navigationLeftBarButtonClickComplete = complete;
}

- (void)setNavigationRightItem:(void(^)(NSInteger index, id item))complete images:(UIImage *)image, ... NS_REQUIRES_NIL_TERMINATION;
{
    GetVariableParameterWithMutableArray(image, arrayImages);
    if (arrayImages.count == 0) {
        return;
    }
    NSMutableArray *arrayItems = [NSMutableArray array];
    [arrayImages enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
       UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithImage:[obj imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleBordered target:self action:@selector(navigationRightBarButtonClick:)];
        [arrayItems addObject:right];
    }];
    self.navigationItem.rightBarButtonItems = arrayItems;
    
    self.navigationRightBarButtonClickComplete = complete;
}

- (void)setNavigationRightItem:(void(^)(NSInteger index, id item))complete buttons:(UIButton *)button, ... NS_REQUIRES_NIL_TERMINATION;
{
    GetVariableParameterWithMutableArray(button, arrayButtons);
    if (arrayButtons.count == 0) {
        return;
    }
    
    NSMutableArray *arrayItems = [NSMutableArray array];
    [arrayButtons enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:obj];
        [obj addTarget:self action:@selector(navigationRightBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [arrayItems addObject:right];
    }];
    self.navigationItem.rightBarButtonItems = arrayItems;
    
    self.navigationRightBarButtonClickComplete = complete;
}

- (void)setNavigationRightItem:(void(^)(NSInteger index, id item))complete titles:(NSArray *)titles;
{
    IF_RETURN_CODE(!titles || [titles count] == 0, nil)
    
    NSMutableArray *arrayItems = [NSMutableArray array];
    [titles enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:obj style:UIBarButtonItemStyleBordered target:self action:@selector(navigationRightBarButtonClick:)];

        [right setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]} forState:UIControlStateNormal];
        [arrayItems addObject:right];
    }];
    self.navigationItem.rightBarButtonItems = arrayItems;
    
    self.navigationRightBarButtonClickComplete = complete;
}


#pragma mark - PrivateMethods
- (void)navigationLeftBarButtonClick:(UIBarButtonItem *)item
{
    self.navigationLeftBarButtonClickComplete ? self.navigationLeftBarButtonClickComplete([self.navigationItem.rightBarButtonItems indexOfObject:item], item) : nil;
}

- (void)navigationRightBarButtonClick:(UIBarButtonItem *)item
{
    self.navigationRightBarButtonClickComplete ? self.navigationRightBarButtonClickComplete([self.navigationItem.rightBarButtonItems indexOfObject:item], item) : nil;
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

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    RESIGN_FIRST_RESPONDER;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_separatorInsetNone) {
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }
        
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
    }
}


@end
