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

+ (instancetype)shareInstance;
{
    static dispatch_once_t onceToken;
    static Helper *helper = nil;
    dispatch_once(&onceToken, ^{
        helper = [[Helper alloc] init];
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    });
    return helper;
}

#pragma mark - System

+ (BOOL)network
{
    return [AFNetworkReachabilityManager sharedManager].reachableViaWiFi || [AFNetworkReachabilityManager sharedManager].reachableViaWWAN;
}

+ (AFNetworkReachabilityStatus)networkStatus
{
    return [AFNetworkReachabilityManager sharedManager].networkReachabilityStatus;
}

+ (void)networkStatusChanged:(void(^)(AFNetworkReachabilityStatus status))complete;
{
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:complete];
}



+ (void)registerRemoteNotificationAndHandleLaunchOptions:(NSDictionary *)launchOptions handlerComplete:(void(^)(NSDictionary *userInfo))handlerComplete
{
    if (__IPHONE_8_0) {
        UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert) categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }else {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
    }
    
    
    if (launchOptions) {
        
        id value = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        handlerComplete ? handlerComplete(value  ?: nil) : nil;
        
        if ([[[UIApplication sharedApplication] delegate] respondsToSelector:@selector(application:didReceiveRemoteNotification:)] && value)
            [[[UIApplication sharedApplication] delegate] application:[UIApplication sharedApplication] didReceiveRemoteNotification:value];
        
    }
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



#pragma mark - 计数器
+ (void)countDown:(NSInteger)second complete:(void(^)(NSInteger s))complete
{
    [Helper shareInstance].timer = [NSTimer scheduledTimerWithTimeInterval:1 target:[Helper shareInstance] selector:@selector(countDownEvent:) userInfo:nil repeats:YES];
    [[Helper shareInstance] setSecond:second];
    [[Helper shareInstance] setCountDownComplete:complete];
}

+ (void)cancelCountDown
{
    [[Helper shareInstance].timer invalidate];
    [Helper shareInstance].timer = nil;
    
    [[Helper shareInstance] setSecond:0];
    [Helper shareInstance].countDownComplete ? [Helper shareInstance].countDownComplete(0) : nil;
}


#pragma mark - 通讯录
+ (BOOL)haveContactPermission;
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

+ (NSDictionary *)allContacts;
{
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    //获取所有联系人的数组
    CFArrayRef allLinkPeople = ABAddressBookCopyArrayOfAllPeople(addressBookRef);
    //获取联系人总数
    CFIndex number = ABAddressBookGetPersonCount(addressBookRef);
    
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    for (NSInteger i = 0; i < number; i++) {
        ABRecordRef  people = CFArrayGetValueAtIndex(allLinkPeople, i);
        NSString *firstName = (__bridge NSString *)(ABRecordCopyValue(people, kABPersonFirstNameProperty));
        NSString *middleName = (__bridge NSString *)(ABRecordCopyValue(people, kABPersonMiddleNameProperty));
        NSString *lastName = (__bridge NSString *)(ABRecordCopyValue(people, kABPersonLastNameProperty));
        
        
//        NSString *phone = (__bridge NSString *)(ABRecordCopyValue(people, kABPersonPhoneProperty));
        NSString *phone = (__bridge NSString *)(ABMultiValueCopyValueAtIndex(ABRecordCopyValue(people, kABPersonPhoneProperty), 0));
        phone = [phone stringByReplacingOccurrencesOfString:@"-" withString:EMPTY_STRING];
        
        
        NSString *name = [[lastName ?: EMPTY_STRING stringByAppendingString:middleName ?: EMPTY_STRING] stringByAppendingString:firstName ?: EMPTY_STRING];
        phone ? [dictionary setObject:phone forKey:[name isEqualToString:EMPTY_STRING] ? phone : name] : nil;
    }
    
    CFRelease(addressBookRef);
    CFRelease(allLinkPeople);
    return dictionary;
}

+ (NSDictionary *)allContactForMobilePhone;
{
    NSMutableDictionary *dictionary = (id)[Helper allContacts];
    [dictionary enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if (![NSString validateTel:obj]) {
            [dictionary removeObjectForKey:key];
        }
    }];
    return dictionary;
}

+ (BOOL)queryContactWithName:(NSString *)name;
{
    return [[[Helper allContacts] allValues] containsObject:name];
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
    ABMultiValueRef dic = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    // 添加电话号码与其对应的名称内容
    for (int i = 0; i < [phones count]; i ++) {
        ABMultiValueIdentifier obj = ABMultiValueAddValueAndLabel(dic, (__bridge CFStringRef)[phones objectAtIndex:i],  (__bridge CFStringRef)[labels objectAtIndex:i], &obj);
    }
    // 设置phone属性
    ABRecordSetValue(person, kABPersonPhoneProperty, dic, NULL);
    
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    
    // 将新建的联系人添加到通讯录中
    ABAddressBookAddRecord(addressBookRef, person, NULL);
    // 保存通讯录数据
    ABAddressBookSave(addressBookRef, NULL);
    
    
    CFRelease(person);
    CFRelease(dic);
    CFRelease(addressBookRef);
}

#if FunctionSwitch_BaiduMap
+ (void)getCurrentLocation:(void(^)(CLLocationCoordinate2D location, BMKReverseGeoCodeResult *result))positioningLocationComplete;
{
    // if location services are restricted do nothing
    [[Helper shareInstance] setPositioningLocationComplete:positioningLocationComplete];
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted ) {
        AlertMsgOk(@"请到 [设置->隐私->定位服务] 开启定位");
        CLLocationCoordinate2D xx;
        [Helper shareInstance].positioningLocationComplete ? [Helper shareInstance].positioningLocationComplete(xx, nil) : nil;
        return;
    }
    
    if ([Helper shareInstance].locationManager == nil) {
        [Helper shareInstance].locationManager = [CLLocationManager new];
        [Helper shareInstance].locationManager.delegate = [Helper shareInstance];
        [Helper shareInstance].locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        [Helper shareInstance].locationManager.distanceFilter = 5.f;
    }
    
    if (__IPHONE_8_0) {
        [[Helper shareInstance].locationManager requestAlwaysAuthorization];
    }
    [[Helper shareInstance].locationManager startMonitoringSignificantLocationChanges];
    [[Helper shareInstance].locationManager startUpdatingLocation];
    
    [Helper shareInstance].bmkMapManager = [[Helper shareInstance] bmkMapManager] ?: [[BMKMapManager alloc] init];
    if (![[Helper shareInstance].bmkMapManager start:BaiduMapAK generalDelegate:nil]) {
        NSLog(@"baidu map manager start failed!");
    }
}
#endif


#if FunctionSwitch_UM
+ (void)registerUM
{
    //设置友盟Appkey
    [UMSocialData setAppKey:UMAppKey];
    //设置微信AppId、appSecret，分享url
    [UMSocialWechatHandler setWXAppId:WeixinAppId appSecret:WeixinSecret url:WeixinUrl];
    //设置手机QQ 的AppId，Appkey，和分享URL，需要#import "UMSocialQQHandler.h"
    [UMSocialQQHandler setQQWithAppId:QQAppId appKey:QQAppKey url:QQUrl];
    //打开新浪微博的SSO开关，设置新浪微博回调地址，这里必须要和你在新浪微博后台设置的回调地址一致。若在新浪后台设置我们的回调地址，“http://sns.whalecloud.com/sina2/callback”，这里可以传nil ,需要 #import "UMSocialSinaHandler.h"
    [UMSocialSinaHandler openSSOWithRedirectURL:SinaSSOCallBack];
    [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToQQ, UMShareToQzone, UMShareToWechatSession,UMShareToWechatTimeline]];
    
    //使用友盟统计
    [MobClick startWithAppkey:UMAppKey];
}

+ (void)authLoginWithPaltForm:(NSString *)paltformName completion:(void(^)(BOOL status, UMSocialAccountEntity *snsAccount))completion
{
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:paltformName];
    snsPlatform.loginClickHandler(nil, [UMSocialControllerService defaultControllerService], YES, ^(UMSocialResponseEntity *response){
        //获取微博用户名、uid、token等
        UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:paltformName];
        completion ? completion((response.responseCode == UMSResponseCodeSuccess), snsAccount) : nil;
    });
}

+ (void)shareWithPaltform:(NSArray *)paltforms content:(NSString *)content image:(UIImage *)image location:(CLLocation *)location urlResource:(UMSocialUrlResource *)urlResource presentedController:(UIViewController *)presentedController completion:(void(^)(BOOL status))completion {
    [[UMSocialDataService defaultDataService] postSNSWithTypes:paltforms content:content image:image location:location urlResource:urlResource presentedController:presentedController completion:^(UMSocialResponseEntity *response) {
        completion ? completion((response.responseCode == UMSResponseCodeSuccess)) : nil;
    }];
}
#endif



#pragma mark - 当前项目
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


#pragma mark - PrivateMethods
- (void)countDownEvent:(NSTimer *)timer
{
    self.second--;
    self.countDownComplete ? self.countDownComplete(self.second) : nil;
    if (self.second == 0) {
        [self.timer invalidate];
        self.timer = nil;
    }
}


#pragma mark - CLLocationManagerDelegate
#if FunctionSwitch_BaiduMap
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation __OSX_AVAILABLE_BUT_DEPRECATED(__MAC_10_6, __MAC_NA, __IPHONE_2_0, __IPHONE_6_0);
{
    [manager stopMonitoringSignificantLocationChanges];
    [manager stopUpdatingLocation];
    
    
    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeocodeSearchOption.reverseGeoPoint = newLocation.coordinate;
    [Helper shareInstance].bmkGeoCodeSearch = [Helper shareInstance].bmkGeoCodeSearch ?: [[BMKGeoCodeSearch alloc] init];
    [Helper shareInstance].bmkGeoCodeSearch.delegate = self;
    
    [[Helper shareInstance].bmkGeoCodeSearch reverseGeoCode:reverseGeocodeSearchOption];
    
//    @weakify(self);
//    [[[CLGeocoder alloc] init] reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
//        @strongify(self);
//        self.positioningLocationComplete ? self.positioningLocationComplete(newLocation.coordinate, placemarks.firstObject) : nil;
//    }];
}

#pragma mark - BMKGeoCodeSearchDelegate
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error;
{
    if (error == BMK_SEARCH_NO_ERROR) {
        self.positioningLocationComplete ? self.positioningLocationComplete(result.location, result) : nil;
    }else {
        NSLog(@"反地理编码失败");
    }
}
#endif

@end
