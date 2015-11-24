//
//  ViewController.m
//  HJCycleScrollView
//
//  Created by luo.h on 15/11/24.
//  Copyright © 2015年 huluo. All rights reserved.
//

#import "ViewController.h"
#import "HJCycleScrollView.h"

#define kScreen_Height   ([UIScreen mainScreen].bounds.size.height)
#define kScreen_Width    ([UIScreen mainScreen].bounds.size.width)

@interface ViewController ()<HJCycleScrollViewDelegate>

@property(nonatomic,strong)  HJCycleScrollView *scrollView;

@end

@implementation ViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //开启定时器 DDCycleScrollView自动滚动
    [[NSNotificationCenter  defaultCenter]  postNotificationName:HJCycleScrollViewOpenTimerNotiName object:nil userInfo:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    
    //关闭定时器  DDCycleScrollView停止自动滚动
    [[NSNotificationCenter  defaultCenter]  postNotificationName:HJCycleScrollViewOpenTimerNotiName object:nil userInfo:nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:self.scrollView];
    
    NSArray *images=@[@"1.jpg",@"2.jpg",@"3.jpg",@"4.jpg",@"5.jpg"];
    self.scrollView.imageArray=images;
    
    /*不设置数据源则不显示*/
    self.scrollView.titleArray=images;

    
    UIButton   *reloadButton=[UIButton buttonWithType:UIButtonTypeCustom];
    reloadButton.frame=CGRectMake(kScreen_Width/2-100/2, 400,100,50);
    reloadButton.backgroundColor=[UIColor redColor];
    [reloadButton setTitle:@"刷新" forState:UIControlStateNormal];
    [reloadButton addTarget:self action:@selector(refreshScrollview) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:reloadButton];
}





#pragma mark ----刷新Scrollview,一般首页会有下拉刷新功能---
/*重置数据源*/
-(void)refreshScrollview
{
    NSArray *images=@[@"1.jpg",@"2.jpg",@"5.jpg",@"3.jpg",@"0.jpg"];
    self.scrollView.imageArray=images;
    self.scrollView.titleArray=images;
}


#pragma ---- banna滚动图片------
-(HJCycleScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView=[[HJCycleScrollView alloc]initWithFrame:CGRectMake(0, 20, kScreen_Width,  210*(kScreen_Width/320)) Duration:3 pageControlHeight:20];
        _scrollView.delegate=self;
    }
    return _scrollView;
}


-(void)HJCycleScrollView:(HJCycleScrollView *)cycleScrollView didSelectIndex:(NSInteger)index
{
    NSLog(@"选择index===%ld",index);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
