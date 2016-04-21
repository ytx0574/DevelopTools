//
//  UbingGuideView.h
//  uBing
//
//  Created by Johnson on 9/10/14.
//  Copyright (c) 2014 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GuideView : UIView 
+ (BOOL)autoShowGuideViewForGuidePictureBundle;
+ (BOOL)autoShowGuideView:(NSArray *)arrayImageName;
+ (BOOL)autoShowGuideView:(NSArray *)arrayImageName showPageControl:(BOOL)showPageControl;
@end
