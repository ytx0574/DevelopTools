//
//  ViewController.m
//  DevelopTools
//
//  Created by Johnson on 6/17/15.
//  Copyright (c) 2015 Johnson. All rights reserved.
//

#import "ViewController.h"
#import "AFHTTPSessionManager.h"
#import "Model.h"
#import <objc/runtime.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *fsd;

@property (nonatomic, copy) NSString *testTitle;
@property (nonatomic, copy) NSString *testTitle1;

@end

@implementation ViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSLog(@"%@", [self class]);
        NSLog(@"%@", [super class]);
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        NSLog(@"%@", [super class]);
        NSLog(@"%@", [self class]);
        NSLog(@"%@", [super class]);
    }
    return self;
}

static void stringCleanUp(__strong NSString **string)
{
    NSLog(@"%@", *string);
}

//- (void)viewDidLoad {
//    [super viewDidLoad];
//    UITextField *s = [UITextField new];
//    s.enableClipboard = YES;
//    
//    
//    [self.fsd setEnableClipboard:YES];
//
//    
//    NSLog(@"%@", [self class]);
//    NSLog(@"%@", [super class]);
//    
//    
//    __strong NSString *string __attribute__((cleanup(stringCleanUp))) = @"yay";
//    
////    [[[NSObject class] alloc] init][self.view.backgroundColor];
////    NSMutableDictionary *dict ;
////    dict[@"xxx"] = @"ccc";
////    id xx = dict[@"xxx"];
//    
//    
////    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
////    manager.requestSerializer = [AFJSONRequestSerializer serializer];
////    
////    [manager POST:@"http://whojoin-appserver-test.obaymax.com/user/login" parameters:@{@"mobile": @"18623689565", @"password": @"111111"} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
////        NSLog(@"%@", responseObject);
////    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
////       NSLog(@"%@\n%@", error, [[NSString alloc] initWithData:error.userInfo[@"com.alamofire.serialization.response.error.data"] encoding:4])
////    }];
////    
////    [manager.requestSerializer setValue:@"YjQ2MTUwNDEtMTFmNS00OTMzLTg4YWUtY2E0ZmMwNTJkYmU3" forHTTPHeaderField:@"X-Access-Token"];
////    [manager POST:@"http://whojoin-appserver-test.obaymax.com/position/homePage" parameters:@{@"pageSize": @(10), @"page": @(0)} progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
////        
////    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
////        
////    }];
//    
////    self.navigationController.enableBackGesture = YES;
//    
////    [[self class] postForInterfaceName:HTTP_LOGIN Parameter:@{@"mobile": @"18623689565", @"password": @"111111"} success:^(NSURLSessionTask *task, id responseObject) {
////        
////    } failure:^(NSURLSessionTask *task, NSError *error) {
////        
////    }];
//    
//    
//    
//    
//    Model *model = [[Model alloc] init];
//    
//    [model setValue:@"AAA" forKey:@"a"];
//    
//    [model setValue:@"AAA" forKey:@"abc"];
//    
//    [model setA:@"xxx"];
//    
//    [model setA:@"xxx"];
//    
//    model.a = @"下";
//    
//    
//    
//    // Do any additional setup after loading the view, typically from a nib.
//}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self hook];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        self.testTitle = @"new value";
//        self.testTitle1 = @"操你妹";
        [self setValue:@"xxxxxx" forKey:@"testTitle"];
    });
    
    
    
    
    NSLog(@"%@  %@", [[User shareInstance] account], [[Model shareInstance] a])
    
    [[User shareInstance] setInfo:@{@"account": @"草泥马"} saveLocal:YES];
    
    
    
    [[Model shareInstance] setInfo:@{@"a": @"25666"} saveLocal:YES];
    
    NSLog(@"%@", APP_LIBRARY_PREFERENCES_PATH)
    
}

- (void)valueChangeNotificationWithPropertyName:(NSString *)propertyName value:(id)value {
    NSLog(@"propertyName:%@,value:%@",propertyName,value);
}

- (void)hook {
    
    unsigned int methodCount;
    
    Method *methodList = class_copyMethodList(self.class, &methodCount);
    
    Method targetMethod = class_getInstanceMethod(self.class, @selector(hookMethod:));
    
    for (int i = 0; i < methodCount; i++) {
        NSString *methodName =  [NSString stringWithCString:sel_getName(method_getName(methodList[i])) encoding:NSUTF8StringEncoding];
        
        NSPredicate *filter = [NSPredicate predicateWithFormat:@"SELF LIKE 'set*:'"];
        
        if ([filter evaluateWithObject:methodName]) {
            
            Method method = methodList[i];
            method_exchangeImplementations(method, targetMethod);
        }
    }
    
    free(methodList);
}

- (void)hookMethod:(id)value {
    
    [self hookMethod:value];
    
    /// 这样子已经能区分了，如果你觉得要跟属性名一样，把首字母小写即可
    NSString *propertyName = [[NSStringFromSelector(_cmd) stringByReplacingOccurrencesOfString:@"set"
                                                                                    withString:@""]
                              stringByReplacingOccurrencesOfString:@":"
                              withString:@""];
    
    [self valueChangeNotificationWithPropertyName:propertyName value:value];
}

@end
