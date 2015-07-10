//
//  NSObject+AccessibilityTools.m
//  uBing
//
//  Created by Johnson on 6/27/14.
//  Copyright (c) 2014 apple. All rights reserved.
//

#import "NSObject+AccessibilityTools.h"
#import "AFNetworking.h"

@implementation NSObject (AccessibilityTools)

- (NSDictionary *)customParameter:(NSDictionary *)parameter
{
    return parameter;
}

- (NSString *)customInterface:(NSString *)interface
{
    return interface;
}

- (AFHTTPRequestOperation *)getForInterfaceName:(NSString *)interfaceName Parameter:(NSDictionary *)parameter success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
{
    return [[AFHTTPRequestOperationManager manager] GET:[self customInterface:interfaceName] parameters:[self customParameter:parameter] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success ? success(operation, responseObject) : nil;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure ? failure(operation, error) : nil;
    }];
}

- (AFHTTPRequestOperation *)postForInterfaceName:(NSString *)interfaceName Parameter:(NSDictionary *)parameter success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
{
    return [[AFHTTPRequestOperationManager manager] POST:[self customInterface:interfaceName] parameters:[self customParameter:parameter] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        JUDGE_IF(NSOBJECT_TOOLS_DEBUG, NSLog(@"%@",responseObject));
        success ? success(operation, responseObject) : nil;
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure ? failure(operation, error) : nil;
    }];
}

@end