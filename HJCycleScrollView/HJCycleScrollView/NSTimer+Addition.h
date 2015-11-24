//
//  NSTimer+Ad.h
//  Haole
//
//  Created by l.h on 14-9-16.
//  Copyright (c) 2015年 l.h. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (Addition)

/**
 *  让定时器失效
 */
- (void)invalidateTimer;

/**
 *  暂停定时器
 */
- (void)pauseTimer;

/**
 *  立即激活定时器
 */
- (void)resumeTimer;

/**
 *  固定时间后激活定时器
 *
 *  @param interval 固定时间
 */
- (void)resumeTimerAfterTimeInterval:(NSTimeInterval)interval;

@end
