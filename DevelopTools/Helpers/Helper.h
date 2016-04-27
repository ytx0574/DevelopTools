//
//  Helper.h
//  RedLawyerC
//
//  Created by Johnson on 9/9/15.
//  Copyright (c) 2015 成都洪茂科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCrypto.h>
//#import "UMSocialAccountManager.h"
//#import <BaiduMapAPI_Search/BMKGeocodeType.h>
#import <MapKit/MapKit.h>
#import "User.h"
@class CLLocation;
@class CLPlacemark;
@class UMSocialUrlResource;


typedef NS_ENUM(NSInteger, CallStatus)
{
    CallStutusDialing,
    CallStutusIncoming,
    CallStutusConnected,
    CallStutusDisconnected,
};

#define Network            [[Helper shareInstance] network]
@interface Helper : NSObject


+ (BOOL)network;

+ (void)registerRemoteNotificationAndHandleLaunchOptions:(NSDictionary *)launchOptions;

+ (void)sendSMSCodeWithPhoneNumber:(NSString *)phoneNumber complete:(void(^)(BOOL status, NSString *code))complete;

+ (void)ListeningCallStatus:(void(^)(CallStatus status))callStatus;

//+ (void)getCurrentLocation:(void(^)(CLLocationCoordinate2D location, BMKReverseGeoCodeResult *result))positioningLocationComplete;

+ (NSString *)triple3DES:(NSString *)plainText desKey:(NSString *)desKey encryptOrDecrypt:(CCOperation)encryptOrDecrypt;

+ (void)countDown:(NSInteger)second complete:(void(^)(NSInteger s))complete;

+ (BOOL)isOpenRemotePush;

+ (BOOL)queryContactWithName:(NSString *)name;

+ (void)addContactWithName:(NSString *)name phone:(NSString *)phone;



+ (BOOL)isLogin;

+ (void)setIsLogin:(BOOL)isLogin;

+ (void)navigationRightBackDisabled:(BOOL)back;



//+ (BOOL)detectionInstallWeChat;

//+ (void)registerUM;

//+ (void)addRedLawyerContact;

//+ (void)authLoginWithPaltForm:(NSString *)paltformName completion:(void(^)(BOOL status, UMSocialAccountEntity *snsAccount))completion;

//+ (void)shareWithPaltform:(NSArray *)paltforms content:(NSString *)content image:(UIImage *)image location:(CLLocation *)location urlResource:(UMSocialUrlResource *)urlResource presentedController:(UIViewController *)presentedController completion:(void(^)(BOOL status))completion;

@end
