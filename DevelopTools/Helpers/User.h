//
//  User.h
//  RedLawyerC
//
//  Created by Johnson on 10/7/15.
//  Copyright (c) 2015 成都洪茂科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface User : NSObject
+ (instancetype)shareInstance;

@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *headUrl;
@property (nonatomic, copy) NSString *account;
@property (nonatomic, copy) NSString *userType;
@property (nonatomic, copy) NSString *loginType;
@property (nonatomic, copy) NSString *deviceType;

@property (nonatomic, copy) NSString *createDate;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *isDel;
@property (nonatomic, copy) NSString *localIdentifier;

@end
