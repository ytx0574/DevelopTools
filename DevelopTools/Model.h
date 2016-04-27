//
//  Model.h
//  DevelopTools
//
//  Created by Johnson on 4/25/16.
//  Copyright © 2016 Johnson. All rights reserved.
//

#import "LocalStorage.h"

@interface Model : LocalStorage
+ (instancetype)shareInstance;
@property (nonatomic, copy) NSString *a;
@property (nonatomic, copy) NSString *b;
@end
