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




#pragma mark - Http

- (void)testInterface:(NSString *)urlString complete:(void (^)(NSURLResponse* response, NSData* data, NSError* connectionError))complete;

+ (NSURLSessionTask *)getForInterfaceName:(NSString *)interfaceName Parameter:(NSDictionary *)parameter success:(void (^)(NSURLSessionTask *task, id responseObject))success failure:(void (^)(NSURLSessionTask *task, NSError *error))failure;

+ (NSURLSessionTask *)postForInterfaceName:(NSString *)interfaceName Parameter:(NSDictionary *)parameter success:(void (^)(NSURLSessionTask *task, id responseObject))success failure:(void (^)(NSURLSessionTask *task, NSError *error))failure;

+ (void)httpRequestLog:(NSURLRequest *)request parameters:(NSDictionary *)parameters;

+ (void)httpResponseLog:(NSURLRequest *)request responseObject:(id)responseObject error:(NSError *)error;

#pragma mark - Calculate
- (CGFloat)calculateCellHeightWithCellWidth:(CGFloat)cellWidth initCellBlock:(UITableViewCell * (^)())initCellBlock;

#pragma mark - VirtualMethods
- (id)setInfo:(id)info;


#pragma mark - CurrentProject
+ (NSURLSessionTask *)assistHttpForInterface:(NSString *)interface parameter:(NSDictionary *)parameter success:(void (^)(NSInteger code, NSString *msg, id responseObject, BOOL status))success failure:(void (^)(NSURLSessionTask *task, NSError *error))failure;

+ (NSURLSessionTask *)assistHttpModelForInterface:(NSString *)interface parameter:(NSDictionary *)parameter success:(void (^)(NSInteger code, NSString *msg, id responseObject, BOOL status, id model))success failure:(void (^)(NSURLSessionTask *task, NSError *error))failure;

+ (NSURLSessionTask *)assistHttpMultiModelForInterface:(NSString *)interface parameter:(NSDictionary *)parameter success:(void (^)(NSInteger code, NSString *msg, id responseObject, BOOL status, NSArray *models))success failure:(void (^)(NSURLSessionTask *task, NSError *error))failure;

#pragma mark - SDWebImage
- (NSURL *)sd_urlWithString:(NSString *)urlString;

@end
