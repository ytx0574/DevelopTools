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

@property (nonatomic, copy) void(^callBack)();


#pragma mark - Http Test
- (void)testInterface:(NSString *)urlString complete:(void (^)(NSURLResponse* response, NSData* data, NSError* connectionError))complete;


#pragma mark - Http Log
+ (void)httpRequestLog:(NSURLRequest *)request parameters:(NSDictionary *)parameters;

+ (void)httpResponseLog:(NSURLRequest *)request responseObject:(id)responseObject error:(NSError *)error;


#pragma mark - VirtualMethods
- (id)setInfo:(id)info;

#pragma mark - SDWebImage
- (NSURL *)sd_urlWithString:(NSString *)urlString;

@end







@interface NSObject (HttpHandle)

#pragma mark - CurrentProjectHttpRequest
- (NSURLSessionTask *)assistHttpForInterface:(NSString *)interface parameter:(NSDictionary *)parameter httpBefore:(void(^)(void))httpBefore success:(void (^)(NSInteger code, NSString *msg, id responseObject, BOOL status))success failure:(void (^)(NSURLSessionTask *task, NSError *error))failure;

- (NSURLSessionTask *)assistHttpSingleModelForInterface:(NSString *)interface parameter:(NSDictionary *)parameter modelClass:(Class)modelClass httpBefore:(void(^)(void))httpBefore success:(void (^)(NSInteger code, NSString *msg, id responseObject, BOOL status, id model))success failure:(void (^)(NSURLSessionTask *task, NSError *error))failure;

- (NSURLSessionTask *)assistHttpMultiModelForInterface:(NSString *)interface parameter:(NSDictionary *)parameter modelClass:(Class)modelClass  httpBefore:(void(^)(void))httpBefore success:(void (^)(NSInteger code, NSString *msg, id responseObject, BOOL status, NSArray *models))success failure:(void (^)(NSURLSessionTask *task, NSError *error))failure;


- (void)cancelRequesetTaskWithInterFaceName:(NSString *)interfaceName;

- (void)cancelAllRequesetTask;

@end
