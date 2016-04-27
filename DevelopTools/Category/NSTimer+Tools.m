
//
//  NSTimer+Addition.m
//  BHGMasterProject2
//
//  Created by Admin on 4/3/14.
//  Copyright (c) 2014 BHG. All rights reserved.
//

#import "NSTimer+Tools.h"

@implementation NSTimer (Tools)

-(void)pauseTimer
{
    if (![self isValid]) {
        return ;
    }
    [self setFireDate:[NSDate distantFuture]];
}


-(void)resumeTimer
{
    if (![self isValid]) {
        return ;
    }
    [self setFireDate:[NSDate date]];
}

- (void)resumeTimerAfterTimeInterval:(NSTimeInterval)interval
{
    if (![self isValid]) {
        return ;
    }
    [self setFireDate:[NSDate dateWithTimeIntervalSinceNow:interval]];
}

@end
