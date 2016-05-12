//
//  NSObject+AccessibilityTools.m
//  uBing
//
//  Created by Johnson on 6/27/14.
//  Copyright (c) 2014 apple. All rights reserved.
//

#import "NSObject+AccessibilityTools.h"
#import "AFNetworking.h"
#import "Helper.h"
#import <objc/message.h>


static char CallBackKey;
@implementation NSObject (AccessibilityTools)

#pragma mark - CallBack
- (void)setCallBack:(void (^)())callBack
{
    objc_setAssociatedObject(self, &CallBackKey, callBack, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)())callBack
{
    return objc_getAssociatedObject(self, &CallBackKey);
}

#pragma mark - Http
- (void)testInterface:(NSString *)urlString complete:(void (^)(NSURLResponse* response, NSData* data, NSError* connectionError))complete
{
    IF_RETURN(!urlString)
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setValue:[NSString triple3DES:@"www.hongmaofalv.com" desKey:@"hongmaofalvfly4000041200" encryptOrDecrypt:kCCEncrypt] forHTTPHeaderField:@"html"];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue new] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (data) {
            NSLog(@"responseString ->%@  responseObject -> %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding], [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:NULL]);
        }else {
            NSLog(@"response -> %@ error ->%@", response, connectionError);
        }
        complete ? complete(response, data, connectionError) : nil;
    }];
}



+ (void)httpRequestLog:(NSURLRequest *)request parameters:(NSDictionary *)parameters;
{
    NSString *httpBodyString = [[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding];
    NSString *linkString = [request.HTTPMethod isEqualToString:@"POST"] ? [NSString stringWithFormat:@"%@?%@", request.URL, httpBodyString] : request.URL.absoluteString;
    NSLog(@"   HTTP-Method-> %@;\n  HTTP-URL-> %@;\n HTTP-Body-> %@;\nLink-> %@", request.HTTPMethod, request.URL, httpBodyString, [linkString urlDecodedString]);
}

+ (void)httpResponseLog:(NSURLRequest *)request responseObject:(id)responseObject error:(NSError *)error;
{
    NSData *data = error.userInfo[@"com.alamofire.serialization.response.error.data"];
    
    NSLog(@"  Link-> %@\n ResponseObject-> %@\nRequest Error Information-> %@",
          [request.HTTPMethod isEqualToString:@"POST"]
          ?
          [NSString stringWithFormat:@"%@?%@", request.URL, [[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding]]
          :
          request.URL,
          
          error ?: responseObject,
          
          [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    
}

#pragma mark - VirtualMethods
- (id)setInfo:(id)info;
{
    return nil;
}


#pragma mark - SDWebImage
- (NSURL *)sd_urlWithString:(NSString *)urlString;
{
    if (!urlString) {
        NSLog(@"图片链接地址为空!!");
    }else if (![NSURL URLWithString:urlString]) {
        NSLog(@"图片链接地址为空!!");
    }
    return [NSURL URLWithString:urlString];
}


@end






#pragma mark - Associated-NSURLSessionTask
@interface NSURLSessionTask (HttpHandle)

- (void)setTaskIdentifierString:(NSString *)indentifier;

- (NSString *)taskIdentifierString;

@end

@implementation NSURLSessionTask (HttpHandle)


- (void)setTaskIdentifierString:(NSString *)indentifier
{
    objc_setAssociatedObject(self, @selector(taskIdentifierString), indentifier, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)taskIdentifierString
{
    NSString *_indentifier = objc_getAssociatedObject(self, _cmd);
    return _indentifier;
}

@end



@implementation NSObject (HttpHandle)

- (void)cancelRequesetTaskWithInterFaceName:(NSString *)interfaceName;
{
    NSMutableArray *array = [[[self arrayTasks] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"taskIdentifierString == %@", interfaceName]] mutableCopy];
    [array enumerateObjectsUsingBlock:^(NSURLSessionTask *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj cancel];
        [array removeObject:obj];
    }];
}

- (void)cancelAllRequesetTask;
{
    [[self arrayTasks] enumerateObjectsUsingBlock:^(NSURLSessionTask *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj cancel];
    }];
    [[self arrayTasks] removeAllObjects];
}


- (NSURLSessionTask *)assistHttpForInterface:(NSString *)interface parameter:(NSDictionary *)parameter httpBefore:(void(^)(void))httpBefore success:(void (^)(NSInteger code, NSString *msg, id responseObject, BOOL status))success failure:(void (^)(NSURLSessionTask *task, NSError *error))failure
{
    
    if (httpBefore) {
        httpBefore();
    }else {
        SVShowStatus(nil);
    }
    
    return [self postForInterfaceName:interface Parameter:parameter success:^(NSURLSessionTask *task, id responseObject) {
        [self httpRequestSuccess];
        if ([responseObject isKindOfClass:[NSError class]])
            return;
        
        NSInteger code = [responseObject[@"code"] integerValue];
        NSString *msg = responseObject[@"msg"];
        success ? success(code, msg, responseObject, (code == 0) ? YES : NO) : nil;
        
    } failure:^(NSURLSessionTask *task, NSError *error) {
        [self httpRequestFailure];
        
        failure ? failure(task, error) : nil;
    }];
}

- (NSURLSessionTask *)assistHttpSingleModelForInterface:(NSString *)interface parameter:(NSDictionary *)parameter modelClass:(Class)modelClass httpBefore:(void(^)(void))httpBefore success:(void (^)(NSInteger code, NSString *msg, id responseObject, BOOL status, id model))success failure:(void (^)(NSURLSessionTask *task, NSError *error))failure
{
    
    if (httpBefore) {
        httpBefore();
    }else {
        SVShowStatus(nil);
    }
    
    return [self postForInterfaceName:interface Parameter:parameter success:^(NSURLSessionTask *task, id responseObject) {
        [self httpRequestSuccess];
        if ([responseObject isKindOfClass:[NSError class]])
            return;
        
        NSInteger code = [responseObject[@"code"] integerValue];
        NSString *msg = responseObject[@"msg"];
        id model = [modelClass mj_objectWithKeyValues:responseObject];
        success ? success(code, msg, responseObject, (code == 0) ? YES : NO, model) : nil;
        
    } failure:^(NSURLSessionTask *task, NSError *error) {
        [self httpRequestFailure];
        
        failure ? failure(task, error) : nil;
        
    }];
}

- (NSURLSessionTask *)assistHttpMultiModelForInterface:(NSString *)interface parameter:(NSDictionary *)parameter modelClass:(Class)modelClass  httpBefore:(void(^)(void))httpBefore success:(void (^)(NSInteger code, NSString *msg, id responseObject, BOOL status, NSArray *models))success failure:(void (^)(NSURLSessionTask *task, NSError *error))failure
{
    
    if (httpBefore) {
        SVShowStatus(nil);
        httpBefore();
    }
    
    return [self postForInterfaceName:interface Parameter:parameter success:^(NSURLSessionTask *task, id responseObject) {
        [self httpRequestSuccess];
        if ([responseObject isKindOfClass:[NSError class]])
            return;
        
        NSInteger code = [responseObject[@"code"] integerValue];
        NSString *msg = responseObject[@"msg"];
        NSMutableArray *ay = [modelClass mj_objectArrayWithKeyValuesArray:nil];
        success ? success(code, msg, responseObject, (code == 0) ? YES : NO, ay) : nil;
    } failure:^(NSURLSessionTask *task, NSError *error) {
        [self httpRequestFailure];
        
        failure ? failure(task, error) : nil;
    }];
    
}


#pragma mark - Private Methods

- (NSString *)customInterface:(NSString *)interface
{
    return [NSString stringWithFormat:@"%@/%@", InterfaceUrl, interface];
}

- (NSDictionary *)customParameter:(NSDictionary *)parameter
{
    return [self customParameter:parameter interface:nil];
}

- (NSDictionary *)customParameter:(NSDictionary *)parameter interface:(NSString *)interface
{
    if (interface) {
        //  某些请求是把接口名称也放在参数里面的
    }
    
    return parameter;
}

- (AFHTTPSessionManager *)customHttpSessionManager
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [[User shareInstance] accessToken] ? [manager.requestSerializer setValue:[[User shareInstance] accessToken] forHTTPHeaderField:@"X-Access-Token"] : nil;
    return manager;
}



- (NSURLSessionTask *)getForInterfaceName:(NSString *)interfaceName Parameter:(NSDictionary *)parameter success:(void (^)(NSURLSessionTask *task, id responseObject))success failure:(void (^)(NSURLSessionTask *task, NSError *error))failure;
{
    NSURLSessionTask *task = [[self customHttpSessionManager] GET:[self customInterface:interfaceName] parameters:[self customParameter:parameter] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success ? success(task, responseObject) : nil;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure ? failure(task, error) : nil;
    }];
    
    
    [task setTaskIdentifierString:interfaceName];
    [[self arrayTasks] addObject:task];
    
    return task;
}

- (NSURLSessionTask *)postForInterfaceName:(NSString *)interfaceName Parameter:(NSDictionary *)parameter success:(void (^)(NSURLSessionTask *task, id responseObject))success failure:(void (^)(NSURLSessionTask *task, NSError *error))failure;
{
    NSURLSessionTask *task = [[self customHttpSessionManager] POST:[self customInterface:interfaceName] parameters:[self customParameter:parameter] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success ? success(task, responseObject) : nil;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        success ? success(task, error) : nil;
    }];
    
    
    [task setTaskIdentifierString:interfaceName];
    [[self arrayTasks] addObject:task];
    
    return task;
}


- (void)httpRequestSuccess
{
    SVDismiss;
}

- (void)httpRequestFailure
{
    SVDismiss;
}



#pragma mark - Associated-NSObject
- (void)setArrayTasks:(NSMutableArray *)array
{
    objc_setAssociatedObject(self, @selector(arrayTasks), array, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableArray *)arrayTasks
{
    NSMutableArray *_arrayTasks = objc_getAssociatedObject(self, _cmd);
    if (!_arrayTasks) {
        [self setArrayTasks:[NSMutableArray array]];
    }
    _arrayTasks = objc_getAssociatedObject(self, _cmd);
    return _arrayTasks;
}

@end