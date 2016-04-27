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
    [request setValue:[Helper triple3DES:@"www.hongmaofalv.com" desKey:@"hongmaofalvfly4000041200" encryptOrDecrypt:kCCEncrypt] forHTTPHeaderField:@"html"];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue new] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (data) {
            NSLog(@"responseString ->%@  responseObject -> %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding], [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:NULL]);
        }else {
            NSLog(@"response -> %@ error ->%@", response, connectionError);
        }
        complete ? complete(response, data, connectionError) : nil;
    }];
}



- (NSDictionary *)customParameter:(NSDictionary *)parameter
{
    return [self customInterface:nil parameter:parameter];
}

- (NSString *)customInterface:(NSString *)interface
{
    return [NSString stringWithFormat:@"%@/%@", InterfaceUrl, interface];
}

- (NSDictionary *)customInterface:(NSString *)interface parameter:(NSDictionary *)parameter
{
    if (interface) {
        
    }
    
    return parameter;
}

- (AFHTTPSessionManager *)customHttpSessionManager
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
//    [[User shareInstance] accessToken] ? [manager.requestSerializer setValue:[[User shareInstance] accessToken] forHTTPHeaderField:@"X-Access-Token"] : nil;
    return manager;
}



+ (NSURLSessionTask *)getForInterfaceName:(NSString *)interfaceName Parameter:(NSDictionary *)parameter success:(void (^)(NSURLSessionTask *task, id responseObject))success failure:(void (^)(NSURLSessionTask *task, NSError *error))failure;
{
    return [[self customHttpSessionManager] GET:[self customInterface:interfaceName] parameters:[self customParameter:parameter] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success ? success(task, responseObject) : nil;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure ? failure(task, error) : nil;
    }];
}

+ (NSURLSessionTask *)postForInterfaceName:(NSString *)interfaceName Parameter:(NSDictionary *)parameter success:(void (^)(NSURLSessionTask *task, id responseObject))success failure:(void (^)(NSURLSessionTask *task, NSError *error))failure;
{
    return [[self customHttpSessionManager] POST:[self customInterface:interfaceName] parameters:[self customParameter:parameter] progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success ? success(task, responseObject) : nil;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        success ? success(task, error) : nil;
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

#pragma mark - Calculate
- (CGFloat)calculateCellHeightWithCellWidth:(CGFloat)cellWidth initCellBlock:(UITableViewCell * (^)())initCellBlock
{
    if (!initCellBlock) return 44;
    UITableViewCell *cell = initCellBlock ? initCellBlock() : nil;
    
    cell.contentView.bounds = CGRectMake(0, 0, cellWidth, 0);
    
    [cell prepareForReuse];
    
    NSLayoutConstraint *tempWidthConstraint =
    [NSLayoutConstraint constraintWithItem:cell.contentView
                                 attribute:NSLayoutAttributeWidth
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:nil
                                 attribute:NSLayoutAttributeNotAnAttribute
                                multiplier:1.0
                                  constant:cellWidth];
    [cell.contentView addConstraint:tempWidthConstraint];
    
    CGSize fittingSize = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    
    [cell.contentView removeConstraint:tempWidthConstraint];
    
    return fittingSize.height + 1;
}

#pragma mark - VirtualMethods
- (id)setInfo:(id)info;
{
    return nil;
}

#pragma mark - CurrentProject
+ (NSURLSessionTask *)assistHttpForInterface:(NSString *)interface parameter:(NSDictionary *)parameter success:(void (^)(NSInteger code, NSString *msg, id responseObject, BOOL status))success failure:(void (^)(NSURLSessionTask *task, NSError *error))failure
{
    return [[self class] postForInterfaceName:interface Parameter:parameter success:^(NSURLSessionTask *task, id responseObject) {
        SVDismiss;
        
        NSInteger code = [responseObject[@"code"] integerValue];
        NSString *msg = responseObject[@"msg"];
        success ? success(code, msg, responseObject, (code == 0) ? YES : NO) : nil;

    } failure:^(NSURLSessionTask *task, NSError *error) {
        SVDismiss;
        
        if (!failure) {ShowAlert(@"网络似乎抽风了");}
        failure ? failure(task, error) : nil;
    }];
}

+ (NSURLSessionTask *)assistHttpModelForInterface:(NSString *)interface parameter:(NSDictionary *)parameter success:(void (^)(NSInteger code, NSString *msg, id responseObject, BOOL status, id model))success failure:(void (^)(NSURLSessionTask *task, NSError *error))failure
{
    return [[self class] postForInterfaceName:interface Parameter:parameter success:^(NSURLSessionTask *task, id responseObject) {
        SVDismiss;
        
        NSInteger code = [responseObject[@"code"] integerValue];
        NSString *msg = responseObject[@"msg"];
        id model = [[self class] initWithDictionary:responseObject[@"data"]];
        success ? success(code, msg, responseObject, (code == 0) ? YES : NO, model) : nil;

    } failure:^(NSURLSessionTask *task, NSError *error) {
        SVDismiss;
        
        if (!failure) {ShowAlert(@"网络似乎抽风了");}
        failure ? failure(task, error) : nil;

    }];
}

+ (NSURLSessionTask *)assistHttpMultiModelForInterface:(NSString *)interface parameter:(NSDictionary *)parameter success:(void (^)(NSInteger code, NSString *msg, id responseObject, BOOL status, NSArray *models))success failure:(void (^)(NSURLSessionTask *task, NSError *error))failure
{
    return [[self class] postForInterfaceName:interface Parameter:parameter success:^(NSURLSessionTask *task, id responseObject) {
        SVDismiss;
        
        NSInteger code = [responseObject[@"code"] integerValue];
        NSString *msg = responseObject[@"msg"];
        NSMutableArray *ay = [NSMutableArray array];
        if (code == 0 && ![responseObject[@"data"] isEqual:[NSNull null]]) {
            [responseObject[@"data"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                [ay addObject:[[self class] initWithDictionary:obj]];
            }];
        }
        success ? success(code, msg, responseObject, (code == 0) ? YES : NO, ay) : nil;
    } failure:^(NSURLSessionTask *task, NSError *error) {
        SVDismiss;
        
        if (!failure) {ShowAlert(@"网络似乎抽风了");}
        failure ? failure(task, error) : nil;
    }];
    
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