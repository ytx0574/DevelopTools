//
//  Model.h
//  DevelopTools
//
//  Created by Johnson on 4/25/16.
//  Copyright © 2016 Johnson. All rights reserved.
//

#import "LocalStorageHelper.h"

@interface Model : LocalStorageHelper
+ (instancetype)shareInstance;
@property (nonatomic, copy) NSString *a;
@property (nonatomic, copy) NSString *b;
@end
