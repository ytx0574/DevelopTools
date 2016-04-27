//
//  BaseVC.h
//  uBing
//
//  Created by Johnson on 7/3/14.
//  Copyright (c) 2014 apple. All rights reserved.
//

#import <UIKit/UIKit.h>


#define LoadingPlusPlus       [self getDataSourse:self.currentPage += 1 pullState:NO]
#define LoadingBegin          [self getDataSourse:self.currentPage = 1 pullState:YES]
#define LoadingAnimationEnd   state ? [self.tableView.pullToRefreshView stopAnimating] : [self.tableView.infiniteScrollingView stopAnimating]

#define LoadingSuccess      \
pageNo == 1 ? [self.mutableArrayWithDataSourse removeAllObjects] : nil;\
self.toTalCount = [responseObject[@"totalCount"] integerValue];\
[self.mutableArrayWithDataSourse addObjectsFromArray:models];\
self.tableView.separatorColor = [UIColor lightGrayColor];\
[self.tableView reloadData];

#define  LoadingEndReturn \
RESIGN_FIRST_RESPONDER;\
if (self.toTalCount == self.mutableArrayWithDataSourse.count && !state) {\
state ? [self.tableView.pullToRefreshView stopAnimating] : [self.tableView.infiniteScrollingView stopAnimating];\
return;\
}

@interface BaseVC : UIViewController //<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) NSUInteger currentPage;
@property (nonatomic, assign) NSUInteger toTalCount;

@property (nonatomic, strong) NSArray *arrayWithDataSourse;
@property (nonatomic, strong) NSMutableArray *mutableArrayWithDataSourse;

@property (nonatomic, strong) NSDictionary *dicatinaryWithDataSourse;
@property (nonatomic, strong) NSMutableDictionary *mutableDicatinaryWithDataSourse;

@property (nonatomic, strong) UITableViewCell *cell;
@property (nonatomic, strong) UICollectionReusableView *cellHeader;
@property (nonatomic, strong) UICollectionReusableView *cellFooter;


- (void)setSeparatorInsetNone;

- (void)viewDidLoadComplete:(void(^)(UIViewController *viewController))complete;

- (void)getDataSourse:(NSInteger)pageNo pullState:(BOOL)state;

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)setSizeRatios:(UIView *)view, ... NS_REQUIRES_NIL_TERMINATION;

- (void)resetNavigationBackComplete:(void(^)(NSInteger index, id item))complete;
- (void)resetNavigationBackTitle:(NSString *)title;
- (void)resetNavigationBackTitle:(NSString *)title image:(UIImage *)image;
- (void)resetNavigationBackTitle:(NSString *)title image:(UIImage *)image complete:(void(^)(NSInteger index, id item))complete;


- (void)setNavigationLeftItem:(void(^)(NSInteger index, id item))complete images:(UIImage *)image, ... NS_REQUIRES_NIL_TERMINATION;

- (void)setNavigationRightItem:(void(^)(NSInteger index, id item))complete images:(UIImage *)image, ... NS_REQUIRES_NIL_TERMINATION;

- (void)setNavigationRightItem:(void(^)(NSInteger index, id item))complete buttons:(UIButton *)button, ... NS_REQUIRES_NIL_TERMINATION;

- (void)setNavigationRightItem:(void(^)(NSInteger index, id item))complete titles:(NSArray *)titles;

@end
