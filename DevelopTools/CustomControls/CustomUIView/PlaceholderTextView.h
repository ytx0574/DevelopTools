//
//  PlaceholderTextView.h
//  SmartEstate
//
//  Created by Johnson on 15/3/17.
//  Copyright (c) 2015年 pretang. All rights reserved.
//

#import "ToolsHeader.h"

@interface PlaceholderTextView : UITextView

@property (nonatomic, copy) NSString *placeholder;

- (void)overlapHeight:(void(^)(CGFloat height, CGFloat keyboardAnimationTime))frameChangedComplete;

@end
