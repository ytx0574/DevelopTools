//
//  BaseCell.h
//  uBing.C
//
//  Created by Johnson on 10/21/14.
//  Copyright (c) 2014 成都航旅网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseCell : UITableViewCell

/**返回必须带nil, 否则crash*/
@property (nonatomic, copy) void(^callBack)(id firstValue, ...);

- (void)setInfo:(id)info;

@end
