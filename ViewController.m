//
//  ViewController.m
//  ImagePlayer
//
//  Created by zhangpei on 14/12/4.
//  Copyright (c) 2014年 zhangpei. All rights reserved.
//

#import "ViewController.h"
#import "ImageViewPlayer.h"

@interface ViewController ()
<ImageViewPlayerDelegate>
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    ImageViewPlayer *img = [[ImageViewPlayer alloc] initWithFrame:self.view.bounds withDataArray:@[@{@"IMG":@"0.jpg",@"TXT":@"小萍"},@{@"IMG":@"1.jpg",@"TXT":@"小丽"},@{@"IMG":@"2.jpg",@"TXT":@"小秋"},@{@"IMG":@"3.jpg",@"TXT":@"小莲"},@{@"IMG":@"4.jpg",@"TXT":@"小冬"}]];
    img.imageViewPlayerDelegate = self;
    [self.view addSubview:img];

}

- (void)imageViewPlayerDidSelectedAtIndex:(NSInteger)index withImageInfo:(NSDictionary *)dictionary
{
    NSLog(@"currentIndex = %ld \n dictionary = %@",(long)index, dictionary);
}
@end
