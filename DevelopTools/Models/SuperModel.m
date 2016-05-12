//
//  SuperModel.m
//  DevelopTools
//
//  Created by Johnson on 5/12/16.
//  Copyright © 2016 Johnson. All rights reserved.
//

#import "SuperModel.h"

@implementation SuperModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName;
{
    return @{
             localIdentifier: @"id",
             localDescription: @"description"
             };
};
@end
