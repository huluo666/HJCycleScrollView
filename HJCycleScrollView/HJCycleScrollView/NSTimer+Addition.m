//
//  NSTimer+Ad.m
//  Haole
//
//  Created by l.h on 14-9-16.
//  Copyright (c) 2015年 l.h. All rights reserved.
//

#import "NSTimer+Addition.h"

@implementation NSTimer (Ad)

/**
 *  让定时器失效
 */
- (void)invalidateTimer
{
    if ([self isValid]) {
        [self invalidate];
    }
}

/**
 *  暂停定时器
 */
-(void)pauseTimer
{
    if (![self isValid]) {
        return ;
    }
    [self setFireDate:[NSDate distantFuture]];
}

/**
 *  立即激活定时器
 */
-(void)resumeTimer
{
    if (![self isValid]) {
        return ;
    }
    [self setFireDate:[NSDate date]];
}

/**
 *  固定时间后激活定时器
 *
 *  @param interval 固定时间
 */
- (void)resumeTimerAfterTimeInterval:(NSTimeInterval)interval
{
    if (![self isValid]) {
        return ;
    }
    [self setFireDate:[NSDate dateWithTimeIntervalSinceNow:interval]];
}


@end
