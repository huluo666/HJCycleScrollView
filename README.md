# HJCycleScrollView
自动循环滚动ScrollView

#1.基本使用

```Objective-C
  HJCycleScrollView  * _scrollView=[[HJCycleScrollView alloc]initWithFrame:CGRectMake(0, 20, kScreen_Width,  210*(kScreen_Width/320)) Duration:3 pageControlHeight:20];
  _scrollView.delegate=self;
  [self.view addSubview:_scrollView];


  NSArray *images=@[@"1.jpg",@"2.jpg",@"3.jpg",@"4.jpg",@"5.jpg"];
  _scrollView.imageArray=images;
    
  /*不设置数据源则不显示*/
  _scrollView.titleArray=images;

```

#2.刷新数据
```Objective-C
#pragma mark ----刷新Scrollview,一般首页会有下拉刷新功能---
/*重置数据源*/
-(void)refreshScrollview
{
    NSArray *images=@[@"3.jpg",@"2.jpg",@"5.jpg",@"3.jpg",@"0.jpg"];
    self.scrollView.imageArray=images;
    self.scrollView.titleArray=images;
}
```

###注意在页面切换是开启关闭定时器
```Objective-C
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
```





