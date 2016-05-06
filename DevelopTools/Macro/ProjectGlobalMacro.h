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



#pragma mark - InterfaceName
