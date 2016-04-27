//
//  User.m
//  RedLawyerC
//
//  Created by Johnson on 10/7/15.
//  Copyright (c) 2015 成都洪茂科技有限公司. All rights reserved.
//

#import "User.h"

@implementation User

+ (instancetype)shareInstance;
{
    static dispatch_once_t onceToken;
    static id user = nil;
    dispatch_once(&onceToken, ^{
        user = [[[self class] alloc] initWithLocalStore];
    });
    
    return user;
}

@end
