//
//  NSObject+AccessibilityTools.h
//  uBing
//
//  Created by Johnson on 6/27/14.
//  Copyright (c) 2014 apple. All rights reserved.
//

#import "ToolsHeader.h"
@class AFHTTPRequestOperation;

@interface NSObject (AccessibilityTools)

@property (nonatomic, strong, readonly) UIViewController *rootViewController;
@property (nonatomic, strong, readonly) UIViewController *currentViewController;
@property (nonatomic, strong, readonly) UIViewController *navigationViewController;

#pragma mark - Http
- (AFHTTPRequestOperation *)getForInterfaceName:(NSString *)interfaceName Parameter:(NSDictionary *)parameter success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

- (AFHTTPRequestOperation *)postForInterfaceName:(NSString *)interfaceName Parameter:(NSDictionary *)parameter success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
