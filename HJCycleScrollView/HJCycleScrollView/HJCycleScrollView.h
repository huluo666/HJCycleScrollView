//
//  HJCycleScrollView.h
//  HJCycleScrollView
//
//  Created by luo.h on 15/7/12.
//  Copyright (c) 2015年 l.h. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "NSTimer+Addition.h"
/**  开启定时器 */
static NSString * const HJCycleScrollViewOpenTimerNotiName   = @"BCycleScrollViewOpenTimer";

/**  关闭定时器*/
static NSString * const HJCycleScrollViewCloseTimerNotiName   = @"SBCycleScrollViewCloseTimer";

@class HJCycleScrollView;
@protocol HJCycleScrollViewDelegate <NSObject>
- (void)HJCycleScrollView:(HJCycleScrollView *)cycleScrollView didSelectIndex:(NSInteger)index;
@end


@interface HJCycleScrollView : UIView

-(id)initWithFrame:(CGRect)frame
          Duration:(NSTimeInterval)duration
  pageControlHeight:(NSInteger)height;

@property (nonatomic,weak) id<HJCycleScrollViewDelegate>delegate;

@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, strong) NSArray *titleArray;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel      *titleLabel;

@end
