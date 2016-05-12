////
////  HttpRequest.h
////  DevelopTools
////
////  Created by Johnson on 5/12/16.
////  Copyright © 2016 Johnson. All rights reserved.
////
//
//#import <Foundation/Foundation.h>
//
//@interface HttpRequest : NSObject
//
//@end
//
//
//@interface NSObject (HttpHandle)
//
//- (NSURLSessionTask *)assistHttpForInterface:(NSString *)interface parameter:(NSDictionary *)parameter httpBefore:(void(^)(void))httpBefore success:(void (^)(NSInteger code, NSString *msg, id responseObject, BOOL status))success failure:(void (^)(NSURLSessionTask *task, NSError *error))failure;
//
//- (NSURLSessionTask *)assistHttpSingleModelForInterface:(NSString *)interface parameter:(NSDictionary *)parameter modelClass:(Class)modelClass httpBefore:(void(^)(void))httpBefore success:(void (^)(NSInteger code, NSString *msg, id responseObject, BOOL status, id model))success failure:(void (^)(NSURLSessionTask *task, NSError *error))failure;
//
//- (NSURLSessionTask *)assistHttpMultiModelForInterface:(NSString *)interface parameter:(NSDictionary *)parameter modelClass:(Class)modelClass  httpBefore:(void(^)(void))httpBefore success:(void (^)(NSInteger code, NSString *msg, id responseObject, BOOL status, NSArray *models))success failure:(void (^)(NSURLSessionTask *task, NSError *error))failure;
//
//
//- (void)cancelRequesetTaskWithInterFaceName:(NSString *)interfaceName;
//
//- (void)cancelAllRequesetTask;
//
//@end
//
