//
//  Model.m
//  DevelopTools
//
//  Created by Johnson on 4/25/16.
//  Copyright © 2016 Johnson. All rights reserved.
//

#import "Model.h"

@implementation Model
+ (instancetype)shareInstance;
{
    static dispatch_once_t onceToken;
    static id user = nil;
    dispatch_once(&onceToken, ^{
        user = [[[self class] alloc] initWithLocalStore];
    });
    
    return user;
}

- (void)willChangeValueForKey:(NSString *)key
{
    [super willChangeValueForKey:key];
}

- (void)didChangeValueForKey:(NSString *)key
{
    [super didChangeValueForKey:key];
}

- (id)valueForUndefinedKey:(NSString *)key
{
    return [super valueForUndefinedKey:key];
}

@end
