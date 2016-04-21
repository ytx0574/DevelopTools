//
//  ShareBottomView.h
//  RedLawyerC
//
//  Created by Johnson on 10/22/15.
//  Copyright (c) 2015 成都洪茂科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ShareType)
{
    ShareTypeSina,
    ShareTypeWeChat,
    ShareTypeQQ,
};

@interface ShareBottomView : UIView
- (void)shareComplete:(void(^)(ShareType shareType))complete;
@end
