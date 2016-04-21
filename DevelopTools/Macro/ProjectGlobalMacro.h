//
//  ProjectGlobalMacro.h
//  RedLawyerC
//
//  Created by Johnson on 9/25/15.
//  Copyright (c) 2015 成都洪茂科技有限公司. All rights reserved.
//

#pragma mark - BaiduMap
#define BaiduMapAK                           @"6ueOKQBTn7dPIAAjozhk685M"

//#import "PPRevealSideViewController.h"
//#define IsMine(uid)                         [uid isEqualToString:[UserInstance localIdentifier]]
//#define ROOTVIEWCONTROLLER                  ((PPRevealSideViewController *)[[[[UIApplication sharedApplication] delegate] window] rootViewController])
#define ROOTNAVIGATIONCONROLLER             ((BaseNVC *)[[[[UIApplication sharedApplication] delegate] window] rootViewController])


#define CoilMainColor                           RGB(83, 155, 244)


/**全局的cell的标志 */
static NSString *cellIdentifier =               @"cellIdentifier";
static NSString *cellIdentifierReusableView =   @"cellIdentifierReusableView";
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
/**测试服*/
//#define InterfaceUrl                        @"http://test.hongmaofalv.com/hmfl3"
/**正式服*/
#define InterfaceUrl                        @"http://114.215.236.27:8080/hmfl3"
/**固定机器*/
//#define InterfaceUrl                        @"http://192.168.1.3:8080/hmfl3"
