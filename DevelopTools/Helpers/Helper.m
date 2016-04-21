//
//  Helper.m
//  RedLawyerC
//
//  Created by Johnson on 9/9/15.
//  Copyright (c) 2015 成都洪茂科技有限公司. All rights reserved.
//

#import "Helper.h"

//#import "UMSocial.h"
//#import "WXApi.h"
//#import "UMSocialWechatHandler.h"
//#import "UMSocialSinaHandler.h"
//#import "UMSocialQQHandler.h"
//#import "MobClick.h"

//#import "GeTuiSdk.h"
//#import "XMLDictionary.h"

#import "GTMBase64.h"
#import <Security/Security.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCrypto.h>

//#import <BaiduMapAPI_Base/BMKMapManager.h>
//#import <BaiduMapAPI_Search/BMKSearchComponent.h>

#import "UINavigationController+Tools.h"


@import MapKit;
@import CoreTelephony;
@import AddressBook;

@interface Helper () <CLLocationManagerDelegate/**, BMKGeoCodeSearchDelegate*/>
@property (nonatomic, assign) BOOL isLogin;

@property (nonatomic, assign) NSInteger second;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, copy) void(^countDownComplete)(NSInteger s);

@property (nonatomic, assign) BOOL network;
@property (nonatomic, strong) CTCallCenter *callCenter;

@property (nonatomic, strong) CLLocationManager *locationManager;
//@property (nonatomic, copy) void(^positioningLocationComplete)(CLLocationCoordinate2D location, BMKReverseGeoCodeResult *result);
//@property (nonatomic, strong) BMKMapManager *bmkMapManager;
//@property (nonatomic, strong) BMKGeoCodeSearch *bmkGeoCodeSearch;

@property (nonatomic, copy) NSString *cityId;
@property (nonatomic, copy) NSString *cityName;

@property (nonatomic, strong) NSArray *lawTypeEnterprise;
@property (nonatomic, strong) NSArray *lawTypePersonal;
@property (nonatomic, strong) NSArray *lawTypeHatch;
@end

@implementation Helper

+ (void)load
{

}

+ (instancetype)shareInstance;
{
    static dispatch_once_t onceToken;
    static Helper *helper = nil;
    dispatch_once(&onceToken, ^{
        helper = [Helper new];
    });
    return helper;
}

#pragma mark - Public

+ (BOOL)network
{
    return YES;
    return [[Helper shareInstance] network];
}

+ (void)registerRemoteNotificationAndHandleLaunchOptions:(NSDictionary *)launchOptions
{
    if (launchOptions) {
        ALERT_LOG(launchOptions.description);
        id value = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if ([[[UIApplication sharedApplication] delegate] respondsToSelector:@selector(application:didReceiveRemoteNotification:)] && value) {
            [[[UIApplication sharedApplication] delegate] application:[UIApplication sharedApplication] didReceiveRemoteNotification:value];
        }
    }
    
    
    
    if (iOS8_AND_LATER) {
        UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert) categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }else {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
    }
}

+ (void)sendSMSCodeWithPhoneNumber:(NSString *)phoneNumber complete:(void(^)(BOOL status, NSString *code))complete
{
    NSArray *arrayCode = [[NSArray alloc] initWithObjects:@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", nil];
    NSInteger kCharCount = 6;
    NSMutableString *smsCode = [[NSMutableString alloc] initWithCapacity:kCharCount];
    for (int i = 0; i < kCharCount; i++)
    {
        NSInteger index = arc4random() % (arrayCode.count - 1);
        NSString *tempStr = [arrayCode objectAtIndex:index];
        [smsCode appendString:tempStr];
    }
    
#ifdef DEBUG
    AlertMsgOk(smsCode);
    complete ? complete(YES, smsCode) : nil;
#else
    NSString *content = [[NSString stringWithFormat:@"您的动态验证码是【%@】。工作人员不会向您索要，请勿向任何人泄露。", smsCode] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *account = @"cf_hongmao";
    NSString *pwd = @"evxhxdb61juec";
    
    NSString *url = [NSString stringWithFormat:@"http://106.ihuyi.cn/webservice/sms.php?method=Submit&account=%@&password=%@&mobile=%@&content=%@", account, pwd, phoneNumber, content];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue new] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSDictionary *dict = [NSDictionary dictionaryWithXMLData:data];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data && dict) {
                if ([dict[@"code"] integerValue] == 2) {
                    complete ? complete(YES, smsCode) : nil;
                }else {
                    complete ? complete(NO, dict[@"msg"]) : nil;
                }
            }else {
                complete ? complete(NO, @"网络连接失败") : nil;
            }
        });
    }];
#endif
}

+ (void)ListeningCallStatus:(void(^)(CallStatus status))callStatus
{
    [([Helper shareInstance].callCenter = [Helper shareInstance].callCenter ?: [[CTCallCenter alloc] init]) setCallEventHandler:^(CTCall *call) {
        CallStatus status = CallStutusDisconnected;
        if ([call.callState isEqualToString:CTCallStateDisconnected])
        {
            status = CallStutusDisconnected;
        }
        else if ([call.callState isEqualToString:CTCallStateConnected])
        {
            status = CallStutusConnected;
        }
        else if([call.callState isEqualToString:CTCallStateIncoming])
        {
            status = CallStutusIncoming;
        }
        else if ([call.callState isEqualToString:CTCallStateDialing])
        {
            status = CallStutusDialing;
        }
        callStatus ? callStatus(status) : nil;
    }];
}

//+ (void)getCurrentLocation:(void(^)(CLLocationCoordinate2D location, BMKReverseGeoCodeResult *result))positioningLocationComplete;
//{
//    // if location services are restricted do nothing
//    [[Helper shareInstance] setPositioningLocationComplete:positioningLocationComplete];
//    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted ) {
//        AlertMsgOk(@"请到 [设置->隐私->定位服务] 开启定位");
//        CLLocationCoordinate2D xx;
//        [Helper shareInstance].positioningLocationComplete ? [Helper shareInstance].positioningLocationComplete(xx, nil) : nil;
//        return;
//    }
//    
//    if ([Helper shareInstance].locationManager == nil) {
//        [Helper shareInstance].locationManager = [CLLocationManager new];
//        [Helper shareInstance].locationManager.delegate = [Helper shareInstance];
//        [Helper shareInstance].locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
//        [Helper shareInstance].locationManager.distanceFilter = 5.f;
//    }
//    
//    if (iOS8_AND_LATER) {
//        [[Helper shareInstance].locationManager requestAlwaysAuthorization];
//    }
//    [[Helper shareInstance].locationManager startMonitoringSignificantLocationChanges];
//    [[Helper shareInstance].locationManager startUpdatingLocation];
//    
//    [Helper shareInstance].bmkMapManager = [[Helper shareInstance]bmkMapManager] ?: [[BMKMapManager alloc] init];
//    if (![[Helper shareInstance].bmkMapManager start:BaiduMapAK generalDelegate:nil]) {
//        NSLog(@"baidu map manager start failed!");
//    }
//}

+ (NSString *)triple3DES:(NSString *)plainText desKey:(NSString *)desKey encryptOrDecrypt:(CCOperation)encryptOrDecrypt
{
    
    const void *vplainText;
    size_t plainTextBufferSize;
    
    if (encryptOrDecrypt == kCCDecrypt)//解密
    {
        NSData *EncryptData = [GTMBase64 decodeData:[plainText dataUsingEncoding:NSUTF8StringEncoding]];
        plainTextBufferSize = [EncryptData length];
        vplainText = [EncryptData bytes];
    }
    else //加密
    {
        NSData* data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
        plainTextBufferSize = [data length];
        vplainText = (const void *)[data bytes];
    }
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    // memset((void *) iv, 0x0, (size_t) sizeof(iv));
    
    const void *vkey = (const void *)[desKey UTF8String];
    // NSString *initVec = @"init Vec";
    //const void *vinitVec = (const void *) [initVec UTF8String];
    //  Byte iv[] = {0x12, 0x34, 0x56, 0x78, 0x90, 0xAB, 0xCD, 0xEF};
    ccStatus = CCCrypt(encryptOrDecrypt,
                       kCCAlgorithm3DES,
                       kCCOptionPKCS7Padding | kCCOptionECBMode,
                       vkey,
                       kCCKeySize3DES,
                       nil,
                       vplainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    //if (ccStatus == kCCSuccess) NSLog(@"SUCCESS");
    /*else if (ccStatus == kCC ParamError) return @"PARAM ERROR";
     else if (ccStatus == kCCBufferTooSmall) return @"BUFFER TOO SMALL";
     else if (ccStatus == kCCMemoryFailure) return @"MEMORY FAILURE";
     else if (ccStatus == kCCAlignmentError) return @"ALIGNMENT";
     else if (ccStatus == kCCDecodeError) return @"DECODE ERROR";
     else if (ccStatus == kCCUnimplemented) return @"UNIMPLEMENTED"; */
    
    NSString *result;
    
    if (encryptOrDecrypt == kCCDecrypt)
    {
        result = [[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)bufferPtr
                                                               length:(NSUInteger)movedBytes]
                                       encoding:NSUTF8StringEncoding];
    }
    else
    {
        NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
        result = [GTMBase64 stringByEncodingData:myData];
    }
    
    return result;
}

+ (void)countDown:(NSInteger)second complete:(void(^)(NSInteger s))complete
{
    [Helper shareInstance].timer = [NSTimer scheduledTimerWithTimeInterval:1 target:[Helper shareInstance] selector:@selector(countDownEvent:) userInfo:nil repeats:YES];
    [[Helper shareInstance] setSecond:second];
    [[Helper shareInstance] setCountDownComplete:complete];
}

+ (BOOL)isOpenRemotePush
{
    if (iOS8_AND_LATER)
    {
        UIUserNotificationType types = [[UIApplication sharedApplication] currentUserNotificationSettings].types;
        BOOL isNotifyAlert = (types & UIUserNotificationTypeAlert) == UIUserNotificationTypeAlert;
//        BOOL isNotifySound = (types & UIUserNotificationTypeSound) == UIUserNotificationTypeSound;
//        BOOL isNotifyBadge = (types & UIUserNotificationTypeBadge) == UIUserNotificationTypeBadge;
        return isNotifyAlert;
    }
    else
    {
        UIRemoteNotificationType types = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        return (types != UIRemoteNotificationTypeNone);
    }
}

+ (BOOL)haveContactPermission
{
    //是否开启权限
    __block BOOL havePermission;
    
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    //申请访问权限
    ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool greanted, CFErrorRef error) {
        //greanted为YES是表示用户允许，否则为不允许
        havePermission = greanted;
        //发送一次信号
        dispatch_semaphore_signal(sema);
    });
    
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    
    if (havePermission) {CFRelease(addressBookRef);}
    return havePermission;
}

+ (BOOL)queryContactWithName:(NSString *)name;
{
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    //获取所有联系人的数组
    CFArrayRef allLinkPeople = ABAddressBookCopyArrayOfAllPeople(addressBookRef);
    //获取联系人总数
    CFIndex number = ABAddressBookGetPersonCount(addressBookRef);
    
    BOOL exist = NO;
    for (NSInteger i = 0; i < number; i++) {
        ABRecordRef  people = CFArrayGetValueAtIndex(allLinkPeople, i);
        NSString *firstName = (__bridge NSString *)(ABRecordCopyValue(people, kABPersonFirstNameProperty));
        if ([firstName isEqualToString:name]) {
            exist = YES;
            break;
        }
    }

    CFRelease(addressBookRef);
    CFRelease(allLinkPeople);
    return exist;
}

+ (void)addContactWithName:(NSString *)name phone:(NSString *)phone;
{
    if (name == nil || phone == nil) {
        return;
    }
    ABRecordRef person = ABPersonCreate();
    NSString *firstName = name;
    NSArray *phones = @[phone];
    NSArray *labels = @[@"-红帽法律卫士-"];
    
    ABRecordSetValue(person, kABPersonFirstNameProperty, (__bridge CFStringRef)firstName, NULL);
    
    // 字典引用
    ABMultiValueRef dic =ABMultiValueCreateMutable(kABMultiStringPropertyType);
    // 添加电话号码与其对应的名称内容
    for (int i = 0; i < [phones count]; i ++) {
        ABMultiValueIdentifier obj = ABMultiValueAddValueAndLabel(dic,(__bridge CFStringRef)[phones objectAtIndex:i], (__bridge CFStringRef)[labels objectAtIndex:i], &obj);
    }
    // 设置phone属性
    ABRecordSetValue(person, kABPersonPhoneProperty, dic, NULL);
    
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    
    // 将新建的联系人添加到通讯录中
    ABAddressBookAddRecord(addressBookRef, person, NULL);
    // 保存通讯录数据
    ABAddressBookSave(addressBookRef, NULL);
    
    CFRelease(addressBookRef);
}





+ (BOOL)isLogin
{
    return [[Helper shareInstance] isLogin];
}

+ (void)setIsLogin:(BOOL)isLogin
{
    [[Helper shareInstance] setIsLogin:isLogin];
}

+ (void)navigationRightBackDisabled:(BOOL)back;
{
    //    ROOTNAVIGATIONCONROLLER.interactivePopGestureRecognizer.enabled = !back;
    //    ROOTNAVIGATIONCONROLLER.fd_fullscreenPopGestureRecognizer.enabled = !back;
}



#pragma mark - Ohter
//+ (BOOL)detectionInstallWeChat;
//{
//    return [WXApi isWXAppInstalled];
//}


//+ (void)registerUM
//{
//    //设置友盟Appkey
//    [UMSocialData setAppKey:UMAppKey];
//    //设置微信AppId、appSecret，分享url
//    [UMSocialWechatHandler setWXAppId:WeixinAppId appSecret:WeixinSecret url:WeixinUrl];
//    //设置手机QQ 的AppId，Appkey，和分享URL，需要#import "UMSocialQQHandler.h"
//    [UMSocialQQHandler setQQWithAppId:QQAppId appKey:QQAppKey url:QQUrl];
//    //打开新浪微博的SSO开关，设置新浪微博回调地址，这里必须要和你在新浪微博后台设置的回调地址一致。若在新浪后台设置我们的回调地址，“http://sns.whalecloud.com/sina2/callback”，这里可以传nil ,需要 #import "UMSocialSinaHandler.h"
//    [UMSocialSinaHandler openSSOWithRedirectURL:SinaSSOCallBack];
//    [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToQQ, UMShareToQzone, UMShareToWechatSession,UMShareToWechatTimeline]];
//    
//    //使用友盟统计
//    [MobClick startWithAppkey:UMAppKey];
//}

//+ (void)addRedLawyerContact
//{
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        if ([Helper haveContactPermission]) {
//            if (![Helper queryContactWithName:RedLawyerName]) {
//                [Helper addContactWithName:RedLawyerName phone:RedlawyerPhoneNumber];
//            }
//        }else {
//            //未开启权限
//        }
//    });
//}

//+ (void)authLoginWithPaltForm:(NSString *)paltformName completion:(void(^)(BOOL status, UMSocialAccountEntity *snsAccount))completion
//{
//    [UMSocialSnsPlatformManager getSocialPlatformWithName:paltformName].loginClickHandler(ROOTNAVIGATIONCONROLLER.viewControllers.lastObject, [UMSocialControllerService defaultControllerService], YES, ^(UMSocialResponseEntity *response){
//        //获取微博用户名、uid、token等
//        UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:paltformName];
//        completion ? completion((response.responseCode == UMSResponseCodeSuccess), snsAccount) : nil;
//    });
//}

//+ (void)shareWithPaltform:(NSArray *)paltforms content:(NSString *)content image:(UIImage *)image location:(CLLocation *)location urlResource:(UMSocialUrlResource *)urlResource presentedController:(UIViewController *)presentedController completion:(void(^)(BOOL status))completion {
//    
//    if ([paltforms.firstObject isEqualToString:UMShareToSina]) {
//
//        [UMSocialData defaultData].extConfig.sinaData.shareText = [[UMSocialData defaultData].extConfig.sinaData.shareText stringByAppendingString:@"   @红帽法律卫士"];
//        [[UMSocialControllerService defaultControllerService] setShareText:content shareImage:image socialUIDelegate:nil];
//        UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:paltforms.firstObject];
//        snsPlatform.snsClickHandler(ROOTNAVIGATIONCONROLLER.viewControllers.lastObject, [UMSocialControllerService defaultControllerService], YES);
//    }else {
//        [[UMSocialDataService defaultDataService] postSNSWithTypes:paltforms content:content image:image location:location urlResource:urlResource presentedController:presentedController completion:^(UMSocialResponseEntity *response) {
//            completion ? completion((response.responseCode == UMSResponseCodeSuccess)) : nil;
//        }];
//    }
//}


#pragma mark - PrivateMethods

- (void)countDownEvent:(NSTimer *)timer
{
    self.second--;
    self.countDownComplete ? self.countDownComplete(self.second) : nil;
    if (self.second == 0) {
        [timer invalidate];
        timer = nil;
    }
}

//#pragma mark - CLLocationManagerDelegate
//- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_6, __MAC_NA, __IPHONE_2_0, __IPHONE_6_0);
//{
//    [manager stopMonitoringSignificantLocationChanges];
//    [manager stopUpdatingLocation];
//    
//    
//    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
//    reverseGeocodeSearchOption.reverseGeoPoint = newLocation.coordinate;
//    [Helper shareInstance].bmkGeoCodeSearch = [Helper shareInstance].bmkGeoCodeSearch ?: [[BMKGeoCodeSearch alloc] init];
//    [Helper shareInstance].bmkGeoCodeSearch.delegate = self;
//    
//    [[Helper shareInstance].bmkGeoCodeSearch reverseGeoCode:reverseGeocodeSearchOption];
//    
////    @weakify(self);
////    [[[CLGeocoder alloc] init] reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
////        @strongify(self);
////        self.positioningLocationComplete ? self.positioningLocationComplete(newLocation.coordinate, placemarks.firstObject) : nil;
////    }];
//}
//
//#pragma mark - BMKGeoCodeSearchDelegate
//- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error;
//{
//    if (error == BMK_SEARCH_NO_ERROR) {
//        self.positioningLocationComplete ? self.positioningLocationComplete(result.location, result) : nil;
//    }else {
//        NSLog(@"反地理编码失败");
//    }
//}

@end
