//
//  User.m
//  RedLawyerC
//
//  Created by Johnson on 10/7/15.
//  Copyright (c) 2015 成都洪茂科技有限公司. All rights reserved.
//

#import "User.h"


#define UserLocalFilePath                  [NSHomeDirectory() stringByAppendingString:@"/Documents/whojoin"]

@implementation User

#pragma mark - MJ
+ (NSDictionary *)mj_objectClassInArray;
{
    return @{
             @"userAcademyList": [UserAcademyList class],
             @"userDomain": [UserDomain class],
             @"userExperienceList": [UserExperienceList class],
             @"userProjectList": [UserProjectList class]
             };
}

#pragma mark User
+ (instancetype)shareInstance;
{
    static dispatch_once_t onceToken;
    static id user = nil;
    dispatch_once(&onceToken, ^{
        user = [[self class] mj_objectWithKeyValues:[NSKeyedUnarchiver unarchiveObjectWithFile:UserLocalFilePath]];
    });
    
    return user;
}

+ (void)checckAccessToken:(void(^)(BOOL haveAccessToken, BOOL accessTokenValid))complete;
{
    if ([[User shareInstance] accessToken]) {
        
        NSTimeInterval interval = [[User shareInstance] accessTokenDate].timeIntervalSinceNow;
        complete ? complete(YES, (interval < 60 * 60 * 24 * 6) ) : nil;
    }else {
        complete ? complete(NO, NO) : nil;
    }
}


- (void)saveLocalWithPwd:(NSString *)pwd;
{
    self.accessTokenDate = [NSDate date];
    
    [NSKeyedArchiver archiveRootObject:[self mj_keyValues] toFile:UserLocalFilePath];
}

- (void)mergeFromOtherUser:(User *)user;
{
    [[self propertyList:[self class]] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        id value = [user valueForKey:obj];
        if (value) {
            [self setValue:value forKey:obj];
        }
        
    }];
}

@end


@implementation UserAcademyList

@end


@implementation UserDomain


@end


@implementation UserExperienceList


@end


@implementation UserProjectList


@end
