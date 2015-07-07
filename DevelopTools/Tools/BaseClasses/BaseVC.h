//
//  BaseVC.h
//  uBing
//
//  Created by Johnson on 7/3/14.
//  Copyright (c) 2014 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseVC : UIViewController

@property (nonatomic, assign) NSUInteger currentPage;

@property (nonatomic, strong) NSArray *arrayWithDataSourse;
@property (nonatomic, strong) NSMutableArray *mutableArrayWithDataSourse;

@property (nonatomic, strong) NSDictionary *dicatinaryWithDataSourse;
@property (nonatomic, strong) NSMutableDictionary *mutableDicatinaryWithDataSourse;

/**返回必须带nil, 否则crash*/
@property (nonatomic, copy) void(^callBack)(id firstValue, ...);

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end
