//
//  NSTimer+Addition.h
//  BHGMasterProject2
//
//  Created by Admin on 4/3/14.
//  Copyright (c) 2014 BHG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (Tools)
/**
 *  暂停timer
 */
- (void)pauseTimer;
/**
 *  开启timer
 */
- (void)resumeTimer;
/**
 *  延迟开始timer
 *
 *  @param interval 延迟的秒
 */
- (void)resumeTimerAfterTimeInterval:(NSTimeInterval)interval;

@end
