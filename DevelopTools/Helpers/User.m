//
//  User.m
//  RedLawyerC
//
//  Created by Johnson on 10/7/15.
//  Copyright (c) 2015 成都洪茂科技有限公司. All rights reserved.
//

#import "User.h"

@implementation User

+ (void)load
{
    NSUserDefaults *userDefault = [User shareUserDefaults];
    User *user = [User shareInstance];
    
    [[[User shareInstance] propertyList:[self class]] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [[User shareInstance] setValue:[userDefault objectForKey:obj] forKey:obj];
    }];
    
    
    //这里直接使用rac_valuesForKeyPath 是避免 宏RACObserve 中引用self所带来的警告
    [[RACSignal merge:@[[user rac_valuesForKeyPath:@keypath(user.token) observer:user],
                        [user rac_valuesForKeyPath:@keypath(user.nickname) observer:user],
                        [user rac_valuesForKeyPath:@keypath(user.headUrl) observer:user],
                        [user rac_valuesForKeyPath:@keypath(user.account) observer:user],
                        [user rac_valuesForKeyPath:@keypath(user.userType) observer:user],
                        [user rac_valuesForKeyPath:@keypath(user.loginType) observer:user],
                        [user rac_valuesForKeyPath:@keypath(user.deviceType) observer:user],
                        [user rac_valuesForKeyPath:@keypath(user.createDate) observer:user],
                        [user rac_valuesForKeyPath:@keypath(user.email) observer:user],
                        [user rac_valuesForKeyPath:@keypath(user.isDel) observer:user],
                        [user rac_valuesForKeyPath:@keypath(user.localIdentifier) observer:user],
                        ]] subscribeNext:^(id x) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            
            NSString *propretyName = [user getPropertyNameForValue:x];
            [userDefault setObject:x ?: EMPTY_STRING forKey:[propretyName substringFromIndex:1]];
            [userDefault synchronize];
            
        });
        
    }];
}

+ (instancetype)shareInstance;
{
    static dispatch_once_t onceToken;
    static User *user = nil;
    dispatch_once(&onceToken, ^{
        user = [[User alloc] init];
    });
    
    return user;
}

+ (NSUserDefaults *)shareUserDefaults
{
    static NSUserDefaults *user = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        user = [[NSUserDefaults alloc] initWithSuiteName:@"笑你妹c"];
    });
    return user;
}

- (id)setInfo:(User *)info
{
    [[self propertyList:[self class]] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [self setValue:[info valueForKey:obj] forKey:obj];
        [[User shareUserDefaults] setValue:[info valueForKey:obj] forKey:obj];
    }];
    return nil;
}

@end
