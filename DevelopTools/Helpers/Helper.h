//
//  Helper.h
//  RedLawyerC
//
//  Created by Johnson on 9/9/15.
//  Copyright (c) 2015 成都洪茂科技有限公司. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "AFNetworkReachabilityManager.h"

#if FunctionSwitch_BaiduMap
#import "UMSocialAccountManager.h"
#endif

#if FunctionSwitch_UM
#import <BaiduMapAPI_Search/BMKGeocodeType.h>
#endif

//#import <MapKit/MapKit.h>
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



@interface Helper : NSObject


+ (BOOL)network;

+ (AFNetworkReachabilityStatus)networkStatus;

+ (void)networkStatusChanged:(void(^)(AFNetworkReachabilityStatus status))complete;




+ (void)registerRemoteNotificationAndHandleLaunchOptions:(NSDictionary *)launchOptions handlerComplete:(void(^)(NSDictionary *userInfo))handlerComplete;

+ (BOOL)isOpenRemotePush;

+ (void)ListeningCallStatus:(void(^)(CallStatus status))callStatus;




+ (void)countDown:(NSInteger)second complete:(void(^)(NSInteger s))complete;
+ (void)cancelCountDown;




+ (BOOL)haveContactPermission;

+ (NSDictionary *)allContacts;

+ (NSDictionary *)allContactForMobilePhone;

+ (BOOL)queryContactWithName:(NSString *)name;

+ (void)addContactWithName:(NSString *)name phone:(NSString *)phone;




#if FunctionSwitch_BaiduMap
+ (void)getCurrentLocation:(void(^)(CLLocationCoordinate2D location, BMKReverseGeoCodeResult *result))positioningLocationComplete;
#endif



#if FunctionSwitch_UM
+ (void)registerUM;

+ (void)authLoginWithPaltForm:(NSString *)paltformName completion:(void(^)(BOOL status, UMSocialAccountEntity *snsAccount))completion;

+ (void)shareWithPaltform:(NSArray *)paltforms content:(NSString *)content image:(UIImage *)image location:(CLLocation *)location urlResource:(UMSocialUrlResource *)urlResource presentedController:(UIViewController *)presentedController completion:(void(^)(BOOL status))completion;
#endif


//以下为当前项目使用
+ (BOOL)isLogin;

+ (void)setIsLogin:(BOOL)isLogin;

+ (void)navigationRightBackDisabled:(BOOL)back;


+ (void)sendSMSCodeWithPhoneNumber:(NSString *)phoneNumber complete:(void(^)(BOOL status, NSString *code))complete;

@end
