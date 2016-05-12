////
////  HttpRequest.m
////  DevelopTools
////
////  Created by Johnson on 5/12/16.
////  Copyright © 2016 Johnson. All rights reserved.
////
//
//#import "HttpRequest.h"
//#import <objc/runtime.h>
//#import "AFHTTPSessionManager.h"
//#import "NSObject+MJKeyValue.h"
//
//@implementation HttpRequest
//
//
//@end
//
//
//@interface NSURLSessionTask (HttpHandle)
//
//- (void)setTaskIdentifierString:(NSString *)indentifier;
//
//- (NSString *)taskIdentifierString;
//
//@end
//
//@implementation NSURLSessionTask (HttpHandle)
//
//#pragma mark - Associated-NSURLSessionTask
//- (void)setTaskIdentifierString:(NSString *)indentifier
//{
//    objc_setAssociatedObject(self, @selector(taskIdentifierString), indentifier, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}
//
//- (NSString *)taskIdentifierString
//{
//    NSString *_indentifier = objc_getAssociatedObject(self, _cmd);
//    return _indentifier;
//}
//
//@end
//
//
//
//@implementation NSObject (HttpHandle)
//
//- (void)cancelRequesetTaskWithInterFaceName:(NSString *)interfaceName;
//{
//    NSMutableArray *array = [[[self arrayTasks] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"taskIdentifierString == %@", interfaceName]] mutableCopy];
//   [array enumerateObjectsUsingBlock:^(NSURLSessionTask *obj, NSUInteger idx, BOOL * _Nonnull stop) {
//       [obj cancel];
//       [array removeObject:obj];
//   }];
//}
//
//- (void)cancelAllRequesetTask;
//{
//    [[self arrayTasks] enumerateObjectsUsingBlock:^(NSURLSessionTask *obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        [obj cancel];
//    }];
//    [[self arrayTasks] removeAllObjects];
//}
//
//
//
//#pragma mark - Private Methods
//
//- (NSString *)customInterface:(NSString *)interface
//{
//    return [NSString stringWithFormat:@"%@/%@", InterfaceUrl, interface];
//}
//
//- (NSDictionary *)customParameter:(NSDictionary *)parameter
//{
//    return [self customParameter:parameter interface:nil];
//}
//
//- (NSDictionary *)customParameter:(NSDictionary *)parameter interface:(NSString *)interface
//{
//    if (interface) {
//        //  某些请求是把接口名称也放在参数里面的
//    }
//    
//    return parameter;
//}
//
//- (AFHTTPSessionManager *)customHttpSessionManager
//{
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    
//    [[User shareInstance] accessToken] ? [manager.requestSerializer setValue:[[User shareInstance] accessToken] forHTTPHeaderField:@"X-Access-Token"] : nil;
//    return manager;
//}
//
//
//
//- (NSURLSessionTask *)getForInterfaceName:(NSString *)interfaceName Parameter:(NSDictionary *)parameter success:(void (^)(NSURLSessionTask *task, id responseObject))success failure:(void (^)(NSURLSessionTask *task, NSError *error))failure;
//{
//    NSURLSessionTask *task = [[self customHttpSessionManager] GET:[self customInterface:interfaceName] parameters:[self customParameter:parameter] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        success ? success(task, responseObject) : nil;
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        failure ? failure(task, error) : nil;
//    }];
//    
//    
//    [task setTaskIdentifierString:interfaceName];
//    [[self arrayTasks] addObject:task];
//    
//    return task;
//}
//
//- (NSURLSessionTask *)postForInterfaceName:(NSString *)interfaceName Parameter:(NSDictionary *)parameter success:(void (^)(NSURLSessionTask *task, id responseObject))success failure:(void (^)(NSURLSessionTask *task, NSError *error))failure;
//{
//    NSURLSessionTask *task = [[self customHttpSessionManager] POST:[self customInterface:interfaceName] parameters:[self customParameter:parameter] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        success ? success(task, responseObject) : nil;
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        success ? success(task, error) : nil;
//    }];
//    
//    
//    [task setTaskIdentifierString:interfaceName];
//    [[self arrayTasks] addObject:task];
//    
//    return task;
//}
//
//
//- (void)httpRequestSuccess
//{
//    SVDismiss;
//}
//
//- (void)httpRequestFailure
//{
//    SVDismiss;
//}
//
//
//#pragma mark - CurrentProject
//- (NSURLSessionTask *)assistHttpForInterface:(NSString *)interface parameter:(NSDictionary *)parameter httpBefore:(void(^)(void))httpBefore success:(void (^)(NSInteger code, NSString *msg, id responseObject, BOOL status))success failure:(void (^)(NSURLSessionTask *task, NSError *error))failure
//{
//    
//    if (httpBefore) {
//        httpBefore();
//    }else {
//        SVShowStatus(nil);
//    }
//    
//    return [self postForInterfaceName:interface Parameter:parameter success:^(NSURLSessionTask *task, id responseObject) {
//        [self httpRequestSuccess];
//        if ([responseObject isKindOfClass:[NSError class]])
//            return;
//        
//        NSInteger code = [responseObject[@"code"] integerValue];
//        NSString *msg = responseObject[@"msg"];
//        success ? success(code, msg, responseObject, (code == 0) ? YES : NO) : nil;
//        
//    } failure:^(NSURLSessionTask *task, NSError *error) {
//        [self httpRequestFailure];
//        
//        failure ? failure(task, error) : nil;
//    }];
//}
//
//- (NSURLSessionTask *)assistHttpSingleModelForInterface:(NSString *)interface parameter:(NSDictionary *)parameter modelClass:(Class)modelClass httpBefore:(void(^)(void))httpBefore success:(void (^)(NSInteger code, NSString *msg, id responseObject, BOOL status, id model))success failure:(void (^)(NSURLSessionTask *task, NSError *error))failure
//{
//    
//    if (httpBefore) {
//        httpBefore();
//    }else {
//        SVShowStatus(nil);
//    }
//    
//    return [self postForInterfaceName:interface Parameter:parameter success:^(NSURLSessionTask *task, id responseObject) {
//        [self httpRequestSuccess];
//        if ([responseObject isKindOfClass:[NSError class]])
//            return;
//        
//        NSInteger code = [responseObject[@"code"] integerValue];
//        NSString *msg = responseObject[@"msg"];
//        id model = [modelClass mj_objectWithKeyValues:responseObject];
//        success ? success(code, msg, responseObject, (code == 0) ? YES : NO, model) : nil;
//        
//    } failure:^(NSURLSessionTask *task, NSError *error) {
//        [self httpRequestFailure];
//    
//        failure ? failure(task, error) : nil;
//        
//    }];
//}
//
//- (NSURLSessionTask *)assistHttpMultiModelForInterface:(NSString *)interface parameter:(NSDictionary *)parameter modelClass:(Class)modelClass  httpBefore:(void(^)(void))httpBefore success:(void (^)(NSInteger code, NSString *msg, id responseObject, BOOL status, NSArray *models))success failure:(void (^)(NSURLSessionTask *task, NSError *error))failure
//{
//    
//    if (httpBefore) {
//        SVShowStatus(nil);
//        httpBefore();
//    }
//    
//    return [self postForInterfaceName:interface Parameter:parameter success:^(NSURLSessionTask *task, id responseObject) {
//        [self httpRequestSuccess];
//        if ([responseObject isKindOfClass:[NSError class]])
//            return;
//        
//        NSInteger code = [responseObject[@"code"] integerValue];
//        NSString *msg = responseObject[@"msg"];
//        NSMutableArray *ay = [modelClass mj_objectArrayWithKeyValuesArray:nil];
//        success ? success(code, msg, responseObject, (code == 0) ? YES : NO, ay) : nil;
//    } failure:^(NSURLSessionTask *task, NSError *error) {
//        [self httpRequestFailure];
//        
//        failure ? failure(task, error) : nil;
//    }];
//    
//}
//
//#pragma mark - Associated-NSObject
//- (void)setArrayTasks:(NSMutableArray *)array
//{
//    objc_setAssociatedObject(self, @selector(arrayTasks), array, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}
//
//- (NSMutableArray *)arrayTasks
//{
//    NSMutableArray *_arrayTasks = objc_getAssociatedObject(self, _cmd);
//    if (!_arrayTasks) {
//        [self setArrayTasks:[NSMutableArray array]];
//    }
//    _arrayTasks = objc_getAssociatedObject(self, _cmd);
//    return _arrayTasks;
//}
//
//@end
