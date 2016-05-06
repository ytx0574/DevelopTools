//
//  ProjectGlobalMacro.h
//  RedLawyerC
//
//  Created by Johnson on 9/25/15.
//  Copyright (c) 2015 成都洪茂科技有限公司. All rights reserved.
//


#pragma mark - 部分功能开关 不区分debug release

#warning        Whether open part of the third party in the "Helper" class function, lack of support package to import
#define FunctionSwitch_BaiduMap            false
#define FunctionSwitch_UM                  false


#warning        1=ReleaseUrl, 2=TestUrl, 3=Fixed IP, Please configuration The "InterfaceUrl"
#define InterfaceUrlType                   1




#pragma mark - BaiduMap
#define BaiduMapAK                           @"6ueOKQBTn7dPIAAjozhk685M"


#pragma mark - UM


#pragma mark - Global
#define ROOTNAVIGATIONCONROLLER             ((BaseNVC *)[[[[UIApplication sharedApplication] delegate] window] rootViewController])

/**全局的cell的标志 */
static NSString *cellIdentifier =               @"cellIdentifier";
static NSString *cellIdentifierReusableView =   @"cellIdentifierReusbleView";
/**本地替换返回数据key*/
static NSString *localIdentifier =              @"localIdentifier";
static NSString *localDescription =             @"localDescription";
/**默认的idUbing字符串(本地出现) "idUbing"*/
#define plocalIdentifier                        @property (nonatomic, copy) NSString *localIdentifier;
#define plocalDescription                       @property (nonatomic, copy) NSString *localDescription;
/**数据接收时,本地跟服务器不同的字段  默认需要转换的keys  详情见:NSObject+AccessibilityTools-> convertResponseObject:keys:*/
#define CONVERT_RESPONSE_KEYS                   @{\
[NSString stringWithFormat:@"\"%@\"", @"id"]: [NSString stringWithFormat:@"\"%@\"", localIdentifier],\
[NSString stringWithFormat:@"\"%@\"", @"description"]: [NSString stringWithFormat:@"\"%@\"", localDescription]\
}


#pragma mark - Interface


#if InterfaceUrlType == 1

    #define InterfaceUrl                        @"http://whojoin-appserver-test.obaymax.com"

#elif InterfaceUrlType == 2

    #define InterfaceUrl                        @"http://test.hongmaofalv.com/hmfl3"

#else

    #define InterfaceUrl                        @"http://192.168.1.3:8080/hmfl3"

#endif





#define HTTP_ORDER_REFUSE                   @"/orderMassage/refuse"
#define HTTP_REGISTER_CODE                  @"/user/registerCode"
#define HTTP_REGISTER                       @"/user/register"
#define HTTP_LOGIN                          @"/user/login"
#define HTTP_SAVE_FORGET_PASSWORD           @"/user/saveForgetPassword"
#define HTTP_FORGET_PASSWORD_CODE           @"/user/forgetPasswordCode"
#define HTTP_UPDATE_PASSWORD                @"/user/updatPassword"
#define HTTP_LOGOUT                         @"/user/logout"
#define HTTP_USER_UPDATE_INFO               @"/user/updateInfo"  //更新用户姓名之类
#define HTTP_USER_UPDATE                    @"/user/update"      //更新用户邮箱之类
#define HTTP_USER_UPDATE_ICON               @"/user/updateicon"
#define HTTP_USER_DETAIL                    @"/user/detail"

#define HTTP_COMMON_POSITION_ADD            @"/commonPosition/create"
#define HTTP_COMMON_POSITION_QUERY          @"/commonPosition/query"
#define HTTP_COMMON_JOB_INTE_QUERY          @"/commonJobIntension/query"
#define HTTP_COMMON_JOB_INTE_ADD            @"/commonJobIntension/create"

#define HTTP_POSITION_HOMEPAGE              @"/position/homePage"
#define HTTP_POSITION_CREATE                @"/position/create"
#define HTTP_JOB_INTE_HOMEPAGE              @"/jobIntension/homePage"
#define HTTP_JOB_INTE_CREATE                @"/jobIntension/create"

#define HTTP_USER_PROJECT_CREATE            @"/userProject/create"
#define HTTP_USER_PROJECT_DELETE            @"/userProject/delete"              //{id}
#define HTTP_USER_EXPERI_CREATE             @"/userExperience/create"
#define HTTP_USER_EXPERI_DELETE             @"/userExperience/delete"           //{id}
#define HTTP_USER_ACADEMY_CREATE            @"/userAcademy/create"
#define HTTP_USER_ACADEMY_DELETE            @"/userAcademy/delete"              //{id}

#define HTTP_REGION_ALL_PROVINCE            @"/region/allProvince"
#define HTTP_REGION_CHILDREN                @"/region/children"                 //{id}
#define HTTP_INDUSTRY_ALL                   @"/industry/all"


#define HTTP_APPOINTMENT_INTERVIEW          @"/orderMassage/orderInterview"
#define HTTP_APPOINTMENT_REFUSE             @"/orderMassage/refuse"              //{id}
#define HTTP_APPOINTMENT_ACCEPT             @"/orderMassage/accept"
#define HTTP_APPOINTMENT_UPDATE_ADDRESS     @"/orderMassage/updatDateAddress"
#define HTTP_APPOINTMENT_FEEDBACK           @"/orderMassage/orderFeedback"
#define HTTP_APPOINTMENT_ACCEPT_ADJUST      @"/orderMassage/acceptAdjust"        //{id}
#define HTTP_APPOINTMENT_REFUSE_ADJUST      @"/orderMassage/refuseAdjust"        //{id}

#define HTTP_CHANGE_CARD_LIST               @"/changeCardMessage/query"
#define HTTP_CHANGE_CARD_ACCEPT             @"/changeCardMessage/accept"        //{id}
#define HTTP_CHANGE_CARD_REFUSE             @"/changeCardMessage/refuse"        //{id}
#define HTTP_SYS_MESSAGE                    @"/sysMessage/query"

#define HTTP_MY_ORDER_LIST                  @"/myOrder/list"

#define HTTP_USER_LIKE_LIST                 @"/userLike/list"
#define HTTP_USER_LIKE_ADD                  @"/userLike/add"         //{otherUserId}
#define HTTP_USER_LIKE_CANCEL               @"/userLike/cancel"      //{otherUserId}

#define HTTP_FEEDBACK_CREATE                @"/feedback/create"

#define HTTP_VIEW_OTHERS_DETAIL             @"/viewOther/details"    //{otherUserId}
#define HTTP_VIEW_OTHERS_RELEASE            @"/viewOther/release"

#define HTTP_POSITION_RELEASE               @"/position/myRelease"   //我的发布
#define HTTP_JOB_INTENSION_RELEASE          @"/jobIntension/myRelease"

#define HTTP_CHANGE_CARD_REQUEST            @"/changeCard/request"   //{otherUserId}

#define HTTP_UPLOAD_IMAGE                   @"/upload/image"
#define HTTP_UPLOAD_VOICE                   @"/upload/voice"

#define HTTP_CHECK_CHANGE_CARD              @"/position/checkChangeCard" //{id}


#define HTTP_VERIFY_CREATE_PERSON           @"/attestation/createPersonal"
#define HTTP_VERIFY_UPDATE_PERSON           @"/attestation/updatePersonal"
#define HTTP_VERIFY_PERSONAL_DETAIL         @"/attestation/personalDetail"
#define HTTP_VERIFY_CREATE_COMPANY          @"/attestation/createCompany"
#define HTTP_VERIFY_UPDATE_COMPANY          @"/attestation/updateCompany"
#define HTTP_VERIFY_COMPANY_DETAIL          @"/attestation/companyDetail"
#define HTTP_VERIFY_UPLOAD_IMAGE            @"/attestation/upload"

#define HTTP_SCHEDULE_DETAILS               @"/schedule/details"         //{id}
#define HTTP_SCHEDULE_GET_DATE              @"/schedule/getDate"
#define HTTP_SCHEDULE_GET_DATE_ORDER        @"/schedule/getDateOrder"
#define HTTP_SCHEDULE_CREATE                @"/schedule/create"
#define HTTP_SCHEDULE_POS_DATE_ORDER        @"/schedule/getPositionDateOrder"
#define HTTP_SCHEDULE_POS_DATE              @"/schedule/getPositionDate"

#define HTTP_DATE_CREATE_POSITION           @"/order/createPosition" //招聘
#define HTTP_DATE_CREATE_JOB                @"/order/createJobIntension" //求职

#define HTTP_ORDER_PAY_REFUSE               @"/orderPay/refuse"

#define HTTP_POSITION_QUERY                 @"/position/query"
#define HTTP_JOB_INTENSION_QUERY            @"/jobIntension/query"

#define HTTP_ORDER_PAY_WX                   @"/orderPay/wx"

// 钱包相关
#define HTTP_USER_Amounts                   @"/user/myAmounts"
#define HTTP_WITHDRAW_APPLY                 @"/withdraw/apply"
#define HTTP_WITHDRAW_LIST                  @"/withdraw/list"
#define HTTP_MONEYRECORD_MYMONEYRECORD      @"/moneyRecord/myMoneyRecord"

// 取消订单
#define HTTP_ORDER_CANCEL                  @"/orderMassage/cancle"
// 支付宝支付
#define HTTP_ORDER_PAY_ALI                 @"/orderPay/aliPay"