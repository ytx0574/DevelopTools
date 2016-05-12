//
//  User.h
//  RedLawyerC
//
//  Created by Johnson on 10/7/15.
//  Copyright (c) 2015 成都洪茂科技有限公司. All rights reserved.
//

#import "SuperModel.h"

@interface User : SuperModel

+ (instancetype)shareInstance;

+ (void)checckAccessToken:(void(^)(BOOL haveAccessToken, BOOL accessTokenValid))complete;


- (void)saveLocalWithPwd:(NSString *)pwd;

- (void)mergeFromOtherUser:(User *)user;




/**登录取得的SessionID*/
@property (nonatomic, retain) NSDate *accessTokenDate;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *getuiClientId;


@property (nonatomic, copy) NSString *accessToken;

@property (nonatomic, copy) NSString *attestationStatus;

@property (nonatomic, copy) NSString *birthday;

@property (nonatomic, copy) NSString *companyName;

@property (nonatomic, copy) NSString *createTime;

@property (nonatomic, copy) NSString *diathesis;

@property (nonatomic, copy) NSString *email;

@property (nonatomic, copy) NSString *experience;

@property (nonatomic, copy) NSString *gender;

//@property (nonatomic, copy) NSString *id;

@property (nonatomic, copy) NSString *imToken;

@property (nonatomic, copy) NSString *image;

@property (nonatomic, copy) NSString *informationPercentage;

@property (nonatomic, copy) NSString *likeCount;

@property (nonatomic, copy) NSString *mobile;

@property (nonatomic, copy) NSString *nameCN;

@property (nonatomic, copy) NSString *nameEN;

@property (nonatomic, copy) NSString *orderCount;

@property (nonatomic, copy) NSString *positionCount;

@property (nonatomic, copy) NSString *positionName;

@property (nonatomic, strong) NSArray *userAcademyList;

@property (nonatomic, strong) NSArray *userDomain;

@property (nonatomic, strong) NSArray *userExperienceList;

@property (nonatomic, copy) NSString *userPerfect;

@property (nonatomic, strong) NSArray *userProjectList;

@property (nonatomic, copy) NSString *wechat;
@end



@interface UserAcademyList : SuperModel

@end


@interface UserDomain : SuperModel
@property (nonatomic, copy) NSString *companyAddress;
@property (nonatomic, copy) NSString *companyNumber;
@property (nonatomic, copy) NSString *companyType;
@property (nonatomic, copy) NSString *direction;
@property (nonatomic, copy) NSString *resume;
@end


@interface UserExperienceList : SuperModel
@property (nonatomic, copy) NSString *companyName;
//@property (nonatomic, copy) NSString *description;
@property (nonatomic, copy) NSString *endTime;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *position;
@property (nonatomic, copy) NSString *region;
@property (nonatomic, copy) NSString *regionName;
@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, copy) NSString *title;
@end


@interface UserProjectList : SuperModel
//@property (nonatomic, copy) NSString *description;
@property (nonatomic, copy) NSString *endTime;
@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *region;
@property (nonatomic, copy) NSString *regionName;
@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, copy) NSString *title;
@end