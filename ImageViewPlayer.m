//
//  ImageViewPlayer.m
//  ImagePlayer
//
//  Created by zhangpei on 14/12/5.
//  Copyright (c) 2014年 zhangpei. All rights reserved.
//

#import "ImageViewPlayer.h"

#define IMAGEVIEW_COUNT 3

@interface ImageViewPlayer ()
<UIScrollViewDelegate>
{
    UIScrollView *_scrollView;
    
    UIImageView *_leftImageView;
    
    UIImageView *_centerImageView;
    
    UIImageView *_rightImageView;
    
    UIPageControl *_pageControl;
    
    NSArray *_imageData;//图片数据
    
    int _imageCount;//图片总数
    
    int _currentImageIndex;//当前图片索引
    
    int timeNum; //计时器

}
@end

@implementation ImageViewPlayer
@synthesize imageViewPlayerDelegate;

- (id)initWithFrame:(CGRect)frame withDataArray:(NSArray *)array
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _imageData = array;
        
        _imageCount = (int)_imageData.count;
        
        [self createImageViewPlayer:frame];
        
        timeNum = 0;
        _currentImageIndex = 0;
        
        [self setCurrentImageAtIndex:_currentImageIndex];
        
        [NSTimer scheduledTimerWithTimeInterval:1 target: self selector: @selector(handleTimer:)  userInfo:nil  repeats: YES];
    }
    return self;
}

#pragma mark 添加控件
- (void)createImageViewPlayer:(CGRect)rect
{
    [self addScrollView:rect];
    
    [self addImageViews];
    
    [self addPageControl];
}


#pragma mark 添加ScrollView
-(void)addScrollView:(CGRect)rect
{
    _scrollView = [[UIScrollView alloc]initWithFrame:rect];
    
    [self addSubview:_scrollView];
    
    //设置代理
    _scrollView.delegate=self;
    //设置contentSize
    _scrollView.contentSize = CGSizeMake(IMAGEVIEW_COUNT*_scrollView.frame.size.width, _scrollView.frame.size.height) ;
    //设置当前显示的位置为中间图片
    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0) animated:NO];
    //设置分页
    _scrollView.pagingEnabled=YES;
    //去掉滚动条
    _scrollView.showsHorizontalScrollIndicator=NO;
}

#pragma mark 添加图片三个控件
-(void)addImageViews
{
    _leftImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _scrollView.frame.size.width, _scrollView.frame.size.height)];
    [_scrollView addSubview:_leftImageView];
    
    _centerImageView=[[UIImageView alloc]initWithFrame:CGRectMake(_scrollView.frame.size.width, 0, _scrollView.frame.size.width, _scrollView.frame.size.height)];
    _centerImageView.userInteractionEnabled = YES;
    [_scrollView addSubview:_centerImageView];
    
    _rightImageView=[[UIImageView alloc]initWithFrame:CGRectMake(2*_scrollView.frame.size.width, 0, _scrollView.frame.size.width, _scrollView.frame.size.height)];
    [_scrollView addSubview:_rightImageView];
    
    
    //在中间的图片添加手势
    // 单击的 Recognizer
    UITapGestureRecognizer* singleTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizerSingleTap)];
    //点击的次数
    singleTapRecognizer.numberOfTapsRequired = 1; // 单击
    singleTapRecognizer.numberOfTouchesRequired = 1;
    [_centerImageView addGestureRecognizer:singleTapRecognizer];
}

- (void)tapGestureRecognizerSingleTap
{
    if (imageViewPlayerDelegate && [imageViewPlayerDelegate respondsToSelector:@selector(imageViewPlayerDidSelectedAtIndex:withImageInfo:)])
    {
        [imageViewPlayerDelegate imageViewPlayerDidSelectedAtIndex:_currentImageIndex withImageInfo:[_imageData objectAtIndex:_currentImageIndex]];
    }
}


#pragma mark 添加分页控件
-(void)addPageControl
{
    _pageControl = [[UIPageControl alloc]init];
    //注意此方法可以根据页数返回UIPageControl合适的大小
    CGSize size= [_pageControl sizeForNumberOfPages:_imageCount];
    _pageControl.bounds=CGRectMake(0, 0, size.width, size.height);
    _pageControl.center=CGPointMake(self.frame.size.width/2, self.frame.size.height-20);
    //设置颜色
    _pageControl.pageIndicatorTintColor=[UIColor colorWithRed:193/255.0 green:219/255.0 blue:249/255.0 alpha:1];
    //设置当前页颜色
    _pageControl.currentPageIndicatorTintColor=[UIColor colorWithRed:0 green:150/255.0 blue:1 alpha:1];
    //设置总页数
    _pageControl.numberOfPages=_imageCount;
    
    [self addSubview:_pageControl];
}


#pragma mark - 5秒换图片
- (void)handleTimer:(NSTimer *)timer
{
    timeNum ++;
    if (timeNum % 5 == 0)
    {
        [UIView animateWithDuration:0.5 //速度0.5秒
                         animations:^{//修改坐标
                             _scrollView.contentOffset = CGPointMake(_scrollView.frame.size.width*2,0);
                         }];
        
        [self scrollViewDidEndDecelerating:_scrollView];
    }
}

#pragma mark 设置显示图片
-(void)setCurrentImageAtIndex:(NSInteger)index
{
    //设置当前页
    _pageControl.currentPage = index;
    
    NSDictionary *item_center = [_imageData objectAtIndex:index];
    _centerImageView.image=[UIImage imageNamed:[item_center objectForKey:@"IMG"]];
    
    int leftIndex = -1;
    
    if (_currentImageIndex == 0)
    {
        leftIndex = _imageCount-1;
    }
    else
    {
        leftIndex = _currentImageIndex - 1;
    }
    
    //加载默认图片
    NSDictionary *item_left = [_imageData objectAtIndex:leftIndex];
    _leftImageView.image=[UIImage imageNamed:[item_left objectForKey:@"IMG"]];
    
    
    int rightIndex = -1;
    
    if (_currentImageIndex == _imageCount-1)
    {
        rightIndex = 0;
    }
    else
    {
        rightIndex = _currentImageIndex + 1;
    }
    
    NSDictionary *item_right = [_imageData objectAtIndex:rightIndex];
    _rightImageView.image=[UIImage imageNamed:[item_right objectForKey:@"IMG"]];
}




#pragma mark 滚动停止事件
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //重新加载图片
    CGPoint offset = [_scrollView contentOffset];
    
    if (offset.x > scrollView.frame.size.width)
    { //向右滑动
        _currentImageIndex=(_currentImageIndex+1)%_imageCount;
    }
    else if(offset.x < scrollView.frame.size.width)
    { //向左滑动
        _currentImageIndex=(_currentImageIndex+_imageCount-1)%_imageCount;
    }
    
    [self setCurrentImageAtIndex:_currentImageIndex];
    
    //移动到中间
    [_scrollView setContentOffset:CGPointMake(scrollView.frame.size.width, 0) animated:NO];
}

@end
