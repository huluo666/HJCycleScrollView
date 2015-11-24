//
//  SBCycleScrollView.m
//  SBCycleScrollView
//
//  Created by luo.h on 15/7/12.
//  Copyright (c) 2015年 l.h. All rights reserved.
//  参考 http://www.jianshu.com/p/aa73c273baf2

#import "HJCycleScrollView.h"
#import "SDImageCache.h"

#import "UIImageView+WebCache.h"
#import <UIKit/UIKit.h>

#define animationDurations  3  //默认定时器时间间隔

@interface HJCycleScrollView ()<UIScrollViewDelegate>
{
    NSInteger currentPageIndex;             //当前页
    NSInteger totalPageCount;               //总页码
    NSTimeInterval  animationDuration_;     //时间间隔
}

@property (nonatomic,strong) UIPageControl  *pageControl;
@property (nonatomic,strong) NSTimer        *animationTimer;//定时器
@property (nonatomic,strong) NSArray        *displayViews;//需要显示的视图

@end

@implementation HJCycleScrollView

- (void)dealloc
{
    _pageControl=nil;
    _scrollView.delegate=nil;
    _scrollView=nil;
    _animationTimer=nil;
    _displayViews=nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


-(id)initWithFrame:(CGRect)frame Duration:(NSTimeInterval)duration pageControlHeight:(NSInteger)height;
{
    if (self=[super initWithFrame:frame]) {
        self.backgroundColor=[UIColor whiteColor];
        
        //初始化数据，当前图片默认位置是0
         currentPageIndex=0;
         animationDuration_=duration?duration:animationDurations;
        
        [self addSubview:self.scrollView];
        [self  addSubview:self.pageControl];
         self.pageControl.frame=CGRectMake(0, CGRectGetHeight(self.bounds)-25-height,self.bounds.size.width, 25);
       
        [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector (stopMyTimer) name:HJCycleScrollViewCloseTimerNotiName object:nil];
        [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector (openMyTimer) name:HJCycleScrollViewOpenTimerNotiName object:nil];
        
     }
    return self;
}

-(void)stopMyTimer
{
    [self.animationTimer pauseTimer];
}

-(void)openMyTimer{
    [self.animationTimer resumeTimerAfterTimeInterval:animationDuration_];
}


-(UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel=[[UILabel alloc]init];
        _titleLabel.font=[UIFont boldSystemFontOfSize:15];
        _titleLabel.textColor=[UIColor whiteColor];
        _titleLabel.backgroundColor= [[UIColor blackColor] colorWithAlphaComponent:0.7];
       _titleLabel.frame=CGRectMake(0, CGRectGetHeight(self.frame)-25,self.bounds.size.width, 25);
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

-(UIPageControl *)pageControl
{
    if (!_pageControl) {
        //分页控件
        _pageControl = [[UIPageControl alloc]init];
        _pageControl.userInteractionEnabled = NO;
        _pageControl.currentPage=0;
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        _pageControl.pageIndicatorTintColor = [UIColor grayColor];
    }
    return _pageControl;
}

-(UIScrollView *)scrollView
{
    if (!_scrollView) {
        //滚动视图
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width,self.bounds.size.height)];
        _scrollView.contentSize = CGSizeMake(self.bounds.size.width*3, 0);
        _scrollView.contentOffset = CGPointMake(self.bounds.size.width, 0);
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

-(void)setTitleArray:(NSArray *)titleArray
{
    _titleArray=titleArray;
    if (_imageArray) {
        [self formatTitleLabeltext:titleArray[currentPageIndex]];
    }
}

//前面空3格
-(void)formatTitleLabeltext:(NSString *)text
{
    self.titleLabel.text=[NSString stringWithFormat:@"  %@",text];
}

/**
 *  重写图片数组的set方法
 */
-(void)setImageArray:(NSArray *)imageArray
{
    if (!imageArray) {
        return;
    }
    _imageArray=imageArray;
    totalPageCount=imageArray.count;
    currentPageIndex=0;
    _pageControl.numberOfPages=totalPageCount;
    
    //开启定时器
    if (_animationTimer) {
        [_animationTimer invalidate];
        _animationTimer = nil;
    }
    
     NSMutableArray *views = [[NSMutableArray alloc] init];
    for (int i = 0; i < _imageArray.count; i++) {
        UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(self.scrollView.frame.size.width *i, 0,CGRectGetWidth(self.scrollView.frame),CGRectGetHeight(self.scrollView.frame))];
        imageview.contentMode =UIViewContentModeScaleAspectFit;
        imageview.autoresizingMask =UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        NSString  *imageStr=imageArray[i];
        if ([imageStr hasPrefix:@"http"]) {
            [imageview  sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage  imageNamed:@"picture_default"]];
        }else{
            imageview.image=[UIImage  imageNamed:imageStr];
        }
        
        imageview.userInteractionEnabled=YES;
        [views addObject:imageview];
        
        //添加手势
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)];
        singleTap.numberOfTapsRequired=1;
        [imageview addGestureRecognizer:singleTap];
    }
      _displayViews =views;
    //http://www.jianshu.com/p/0f2d127753ba?nomobile=yes
    //判断图片长度是否大于1，如果一张图片不开启定时器 animationTimerScrollImage
    if ([imageArray count] > 1) {
        [[NSRunLoop currentRunLoop] addTimer:self.animationTimer forMode:NSDefaultRunLoopMode];
//        或者[[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        [[NSRunLoop currentRunLoop] runMode:UITrackingRunLoopMode beforeDate:[NSDate date]];
    }
    
    [self refreshScrollView];//刷新显示视图
}

-(NSTimer *)animationTimer
{
    if (!_animationTimer) {
        _animationTimer = [NSTimer timerWithTimeInterval:animationDuration_ target:self selector:@selector(animationTimerScrollImage:) userInfo:nil repeats:YES];
    }
    return _animationTimer;
}


/**
 *  刷新显示视图
 */
#pragma mark - Refresh Content View
- (void)refreshScrollView {
    //移除所有子视图
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    _pageControl.currentPage= currentPageIndex;//指示点
    
    NSMutableArray *currentViews = [[NSMutableArray alloc] init];
    [currentViews setArray:[self curDisplayViewsWithCurPage:currentPageIndex]];
    
    NSInteger count = currentViews.count;
    for (int i = 0;i < count;i ++) {
        UIView *aView = [currentViews objectAtIndex:i];
        aView.frame = CGRectMake(self.bounds.size.width * i,
                                 0,
                                 self.bounds.size.width,
                                 self.bounds.size.height);
        [self.scrollView addSubview:aView];
    }
    [self.scrollView setContentOffset:CGPointMake(self.bounds.size.width, 0.0f)];
}

/**
 *  前 中 后 三个视图
 *  @param curPage 当前页
 */
- (NSArray *)curDisplayViewsWithCurPage:(NSInteger)curPage {
    NSInteger backPage    = [self pageNumber:curPage - 1];
    NSInteger forwardPage = [self pageNumber:curPage + 1];
    
    NSMutableArray *currentViews = [[NSMutableArray alloc] init];
    
    [currentViews addObject:_displayViews[backPage]];
    [currentViews addObject:_displayViews[curPage]];
    [currentViews addObject:_displayViews[forwardPage]];
    return currentViews;
}

- (NSInteger)pageNumber:(NSInteger)num {
    NSInteger temp = 0;
    if (num == -1) {
        temp = totalPageCount - 1;
    }else if (num == totalPageCount) {
        temp = 0;
    }else {
        temp = num;
    }
    return temp;
}



#pragma mark - UIScrollViewDelegate  -
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_animationTimer pauseTimer];//拖动停止定时器
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_animationTimer resumeTimerAfterTimeInterval:animationDurations];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int x = scrollView.contentOffset.x;
    if(x >= (2 * self.scrollView.bounds.size.width)) {
        currentPageIndex = [self pageNumber:currentPageIndex + 1];
        [self refreshScrollView];
    }
    if(x <= 0) {
        currentPageIndex = [self pageNumber:currentPageIndex - 1];
        [self refreshScrollView];
    }
    if (_titleArray) {
        [self formatTitleLabeltext:self.titleArray[currentPageIndex]];
    }
}

#pragma mark -
#pragma mark - 响应事件
- (void)animationTimerScrollImage:(NSTimer *)timer
{
    [self.scrollView setContentOffset:CGPointMake(self.bounds.size.width*2, 0) animated:YES];
}

/** 图片点击事件 */
-(void)tapImageView:(UIImageView *)imageview
{
    if ([self.delegate respondsToSelector:@selector(HJCycleScrollView:didSelectIndex:)]) {
        [self.delegate HJCycleScrollView:self didSelectIndex:currentPageIndex];
    }
}

@end
